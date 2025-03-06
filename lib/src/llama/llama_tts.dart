part of 'package:lcpp/lcpp.dart';

class LlamaTTS with _LlamaTTSMixin implements _LlamaBase {
  static const nParallel = 1; // TODO: Expose this as a parameter
  static const nPredict = 4096; // TODO: Expose this as a parameter

  LlamaTTS(LlamaTtsParams ttsParams) 
    : _ttsParams = ttsParams {
    _LlamaBase.lib.ggml_backend_load_all();
    _LlamaBase.lib.llama_backend_init();

    _initModel();
  }

  ffi.Pointer<llama_model> _ttcModel = ffi.nullptr;
  ffi.Pointer<llama_model> _ctsModel = ffi.nullptr;
  ffi.Pointer<llama_context> _ttcContext = ffi.nullptr;
  ffi.Pointer<llama_context> _ctsContext = ffi.nullptr;
  List<ffi.Pointer<llama_sampler>> _samplers = [];

  LlamaTtsParams _ttsParams;

  set ttsParams(LlamaTtsParams value) {
    _ttsParams = value;
    _ttsParams.addListener(_initModel);
    _initModel();
  }

  void _initModel() {
    final nativeModelParams = _ttsParams.getModelParams();
    final nativeTtcModelPath = _ttsParams.ttcModel.path.toNativeUtf8().cast<ffi.Char>();
    final nativeCtsModelPath = _ttsParams.ctsModel.path.toNativeUtf8().cast<ffi.Char>();

    if (_ttcModel != ffi.nullptr) {
      _LlamaBase.lib.llama_free_model(_ttcModel);
    }

    if (_ctsModel != ffi.nullptr) {
      _LlamaBase.lib.llama_free_model(_ctsModel);
    }

    _ttcModel = _LlamaBase.lib
        .llama_load_model_from_file(nativeTtcModelPath, nativeModelParams);
    assert(_ttcModel != ffi.nullptr, LlamaException('Failed to load TTC model'));

    _ctsModel = _LlamaBase.lib
        .llama_load_model_from_file(nativeCtsModelPath, nativeModelParams);
    assert(_ctsModel != ffi.nullptr, LlamaException('Failed to load CTS model'));

    _LlamaBase.modelFinalizer.attach(this, _ttcModel);
    _LlamaBase.modelFinalizer.attach(this, _ctsModel);

    _initContext();
    _initSampler();
  }

  void _initContext() {
    assert(_ttcModel != ffi.nullptr, LlamaException('TTC Model is not loaded'));
    assert(_ctsModel != ffi.nullptr, LlamaException('CTS Model is not loaded'));

    final nativeContextParams = _ttsParams.getContextParams();

    if (_ttcContext != ffi.nullptr) {
      _LlamaBase.lib.llama_free(_ttcContext);
    }

    if (_ctsContext != ffi.nullptr) {
      _LlamaBase.lib.llama_free(_ctsContext);
    }

    _ttcContext = _LlamaBase.lib.llama_init_from_model(_ttcModel, nativeContextParams);
    assert(_ttcContext != ffi.nullptr, LlamaException('Failed to initialize TTC context'));

    _ctsContext = _LlamaBase.lib.llama_init_from_model(_ctsModel, nativeContextParams);
    assert(_ctsContext != ffi.nullptr, LlamaException('Failed to initialize CTS context'));

    _LlamaBase.contextFinalizer.attach(this, _ttcContext);
    _LlamaBase.contextFinalizer.attach(this, _ctsContext);
  }

  void _initSampler() {
    if (_samplers.isNotEmpty) {
      for (final sampler in _samplers) {
        _LlamaBase.lib.llama_sampler_free(sampler);
      }
    }

    final vocab = _LlamaBase.lib.llama_model_get_vocab(_ttcModel);
    
    for (int i = 0; i < nParallel; i++) {
      final sampler = _ttsParams.getSampler(vocab);
      assert(sampler != ffi.nullptr, LlamaException('Failed to initialize sampler'));
      _samplers.add(sampler);
      _LlamaBase.samplerFinalizer.attach(this, sampler);
    }
  }

  @override
  void reload() => _initModel();

  @override
  Future<Uint8List> tts(String text) {
    final version = _OuteTtsVersion.getVersion(_ttcModel);
    final audioText = _ttsParams.voice._getFormattedText(version);
    final audioData = _ttsParams.voice._getFormattedData(version);
    final processedText = _processText(text);
    final prompt = '<|im_start|>\n$processedText$audioText<|text_end|>\n$audioData';
    final guideTokens = _prepareGuideTokens(processedText); // TODO: Make this conditional
    final promptPtr = prompt.toNativeUtf8().cast<ffi.Char>();

    final vocab = _LlamaBase.lib.llama_model_get_vocab(_ttcModel);

    final nPromptTokens = -_LlamaBase.lib.llama_tokenize(
      vocab, 
      promptPtr, 
      prompt.length, 
      ffi.nullptr, 
      0, 
      false, 
      true
    );
    ffi.Pointer<llama_token> promptTokens = calloc<llama_token>(nPromptTokens);

    if (_LlamaBase.lib.llama_tokenize(vocab, promptPtr, prompt.length, promptTokens,
            nPromptTokens, true, true) <
        0) {
      throw LlamaException('Failed to tokenize');
    }

    calloc.free(promptPtr);

    llama_batch batch = _LlamaBase.lib.llama_batch_init(math.max(nPromptTokens, nParallel), 0, nParallel);

    List<int> seqIds = List<int>.generate(nParallel, (i) => i);

    for (int i = 0; i < nPromptTokens; ++i) {
      batch.token[batch.n_tokens] = promptTokens[i];
      batch.pos[batch.n_tokens] = i;
      batch.logits[batch.n_tokens] = 0;
      batch.n_seq_id[batch.n_tokens] = nParallel;

      for (int j = 0; j < nParallel; ++j) {
        batch.seq_id[batch.n_tokens][j] = seqIds[j];
      }

      batch.n_tokens++;
    }

    assert(batch.n_tokens == nPromptTokens, LlamaException('Failed to initialize batch'));

    // llama_decode will output logits only for the last token of the prompt
    batch.logits[batch.n_tokens - 1] = 1;

    assert(_LlamaBase.lib.llama_decode(_ttcContext, batch) == 0, LlamaException('Failed to decode'));

    _LlamaBase.lib.llama_synchronize(_ttcContext);

    List<int> iBatch = List.filled(nParallel, batch.n_tokens - 1);

    int nPast = batch.n_tokens;
    int nDecode = 0;

    bool nextTokenUsesGuideToken = true;

    ffi.Pointer<llama_token> newTokenId = calloc<llama_token>(1);

    while (nDecode <= nPredict) {
      batch.n_tokens = 0;

      for (int i = 0; i < nParallel; ++i) {
        if (iBatch[i] < 0) {
          // The stream is already finished
          continue;
        }

        newTokenId.value = _LlamaBase.lib.llama_sampler_sample(_samplers[i], _ttcContext, iBatch[i]);
        // TODO
      }
    }

    // TODO
    throw UnimplementedError();
  }

  List<llama_token> _prepareGuideTokens(String prompt) {
    final version = _OuteTtsVersion.getVersion(_ttcModel);
    final delimiter = version == _OuteTtsVersion.v3 ? '<|space|>' : '<|text_sep|>';

    final vocab = _LlamaBase.lib.llama_model_get_vocab(_ttcModel);

    List<llama_token> result = [];
    int start = 0;
    int end = prompt.indexOf(delimiter);

    const bufferSize = 256;
    ffi.Pointer<llama_token> buffer = calloc<llama_token>(bufferSize);

    int nTokens =_LlamaBase.lib.llama_tokenize(
      vocab, 
      '\n'.toNativeUtf8().cast<ffi.Char>(), 
      1, 
      buffer, 
      bufferSize, 
      false, 
      true
    );

    assert(nTokens > 0, LlamaException('Failed to tokenize'));

    result.add(buffer.value as llama_token);

    while (end != -1) {
      nTokens =_LlamaBase.lib.llama_tokenize(
        vocab, 
        prompt.substring(start, end).toNativeUtf8().cast<ffi.Char>(), 
        end - start, 
        buffer, 
        bufferSize, 
        false, 
        true
      );

      assert(nTokens > 0, LlamaException('Failed to tokenize'));

      result.add(buffer.value as llama_token);
      start = end + delimiter.length;
      end = prompt.indexOf(delimiter, start);
    }

    nTokens =_LlamaBase.lib.llama_tokenize(
      vocab, 
      prompt.substring(start).toNativeUtf8().cast<ffi.Char>(), 
      prompt.length - start, 
      buffer, 
      bufferSize, 
      false, 
      true
    );

    if (nTokens > 0) {
      result.add(buffer.value as llama_token);
    }

    calloc.free(buffer);

    return result;
  }

  List<String> _splitIntoThrees(String str) {
    List<String> parts = [];

    for (int i = str.length; i > 0; i -= 3) {
      if (i < 3) {
        parts.add(str.substring(0, i));
      } else {
        parts.add(str.substring(i - 3, i));
      }
    }

    return parts.reversed.toList();
  }

  String _numberToWord(int number) {
    const words = [
      "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"
    ];
    return words[number];
  }

  String _tensToWord(int tens) {
    const words = [
      "", "ten", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"
    ];
    return words[tens];
  }

  String _teensToWord(int teens) {
    const words = [
      "", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"
    ];
    return words[teens - 10];
  }

  List<String> _hundredsToWords(int hundreds) {
    int hundredsDigit = hundreds ~/ 100;
    int tensDigit = (hundreds % 100) ~/ 10;
    int onesDigit = hundreds % 10;
    List<String> result = [];

    if (hundredsDigit > 0) {
      result.add(_numberToWord(hundredsDigit));
      result.add("hundred");
      if (tensDigit > 0 || onesDigit > 0) {
        result.add("and");
      }
    }

    if (tensDigit > 1) {
      result.add(_tensToWord(tensDigit));
    } else if (tensDigit == 1 && onesDigit > 0) {
      result.add(_teensToWord(hundreds % 100));
      return result;
    }

    if (onesDigit > 0 && tensDigit != 1) {
      result.add(_numberToWord(onesDigit));
    }

    return result;
  }

  String _numbersToWords(String text) {
    const suffixes = [
      "thousand", "million", "billion", "trillion", "quadrillion", "quintillion",
      "sextillion", "septillion", "octillion", "nonillion", "decillion"
    ];

    List<String> parts = _splitIntoThrees(text);
    List<String> result = [];

    for (int i = 0; i < parts.length; i++) {
      int number = int.parse(parts[i]);
      List<String> words = _hundredsToWords(number);
      result.addAll(words);

      if (i < suffixes.length && i < parts.length - 1) {
        int suffixIndex = parts.length - i - 2;
        result.add(suffixes[suffixIndex]);
      }
    }

    return result.join(" ");
  }
  
  String _processText(String text) {
    // Replace numbers with words (Assuming you have an equivalent function)
    String processedText = _numbersToWords(text);

    // Convert to lowercase
    processedText = processedText.toLowerCase();

    // Replace special characters with spaces
    processedText = processedText.replaceAll(RegExp(r'[-_/,\.\\]'), ' ');

    // Remove non-alphabetic characters
    processedText = processedText.replaceAll(RegExp(r'[^a-z\s]'), '');

    // Replace multiple spaces with a single space
    processedText = processedText.replaceAll(RegExp(r'\s+'), ' ').trim();

    final version = _OuteTtsVersion.getVersion(_ttcModel);

    // Choose the separator based on TTS version
    String separator = version == _OuteTtsVersion.v3 ? '<|space|>' : '<|text_sep|>';

    // Replace spaces with the separator
    processedText = processedText.replaceAll(RegExp(r'\s'), separator);

    return processedText;
  }
}

enum _OuteTtsVersion {
  v2,
  v3;

  static _OuteTtsVersion getVersion(ffi.Pointer<llama_model> model) {
    final version = _LlamaBase.lib.llama_model_chat_template(model, ffi.nullptr).cast<Utf8>().toDartString();
    if (version.contains('0.3')) {
      return _OuteTtsVersion.v3;
    }

    return _OuteTtsVersion.v2;
  }
}