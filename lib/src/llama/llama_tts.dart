part of 'package:lcpp/lcpp.dart';

class LlamaTTS with _LlamaTTSMixin implements _LlamaBase {
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
  final List<ffi.Pointer<llama_sampler>> _samplers = [];

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
    
    for (int i = 0; i < _ttsParams.nParallel; i++) {
      final sampler = _ttsParams.getSampler(vocab);
      assert(sampler != ffi.nullptr, LlamaException('Failed to initialize sampler'));
      _samplers.add(sampler);
      _LlamaBase.samplerFinalizer.attach(this, sampler);
    }
  }

  @override
  void reload() => _initModel();

  @override
  Future<Uint8List> tts(String text) async {
    final version = _OuteTtsVersion.getVersion(_ttcModel);
    final audioText = _ttsParams.voice._getFormattedText(version);
    final audioData = _ttsParams.voice._getFormattedData(version);
    final processedText = _processText(text);
    final prompt = '<|im_start|>\n$processedText$audioText<|text_end|>\n$audioData';
    final promptPtr = prompt.toNativeUtf8().cast<ffi.Char>();

    List<llama_token> guideTokens = [];

    if (_ttsParams.useGuideTokens) {
      guideTokens = _prepareGuideTokens(processedText);
    }

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

    llama_batch batch = _LlamaBase.lib.llama_batch_init(math.max(nPromptTokens, _ttsParams.nParallel), 0, _ttsParams.nParallel);

    List<int> seqIds = List<int>.generate(_ttsParams.nParallel, (i) => i);

    for (int i = 0; i < nPromptTokens; ++i) {
      _batchAdd(batch, promptTokens[i] as llama_token, i as llama_pos, seqIds, false);
    }

    assert(batch.n_tokens == nPromptTokens, LlamaException('Failed to initialize batch'));

    // llama_decode will output logits only for the last token of the prompt
    batch.logits[batch.n_tokens - 1] = 1;

    assert(_LlamaBase.lib.llama_decode(_ttcContext, batch) == 0, LlamaException('Failed to decode'));

    _LlamaBase.lib.llama_synchronize(_ttcContext);

    List<int> iBatch = List.filled(_ttsParams.nParallel, batch.n_tokens - 1);

    int nPast = batch.n_tokens;
    int nDecode = 0;

    bool nextTokenUsesGuideToken = true;

    ffi.Pointer<llama_token> newTokenId = calloc<llama_token>(1);

    List<llama_token> codes = [];

    while (nDecode <= _ttsParams.nPredict) {
      batch.n_tokens = 0;

      for (int i = 0; i < _ttsParams.nParallel; ++i) {
        if (iBatch[i] < 0) {
          // The stream is already finished
          continue;
        }

        newTokenId.value = _LlamaBase.lib.llama_sampler_sample(_samplers[i], _ttcContext, iBatch[i]);
        
        if (
          guideTokens.isNotEmpty && 
          nextTokenUsesGuideToken &&
          !_LlamaBase.lib.llama_vocab_is_control(vocab, newTokenId.value) &&
          !_LlamaBase.lib.llama_vocab_is_eog(vocab, newTokenId.value)
        ) {
          final guideToken = guideTokens.removeAt(0);
          newTokenId.value = guideToken as int;
        }

        nextTokenUsesGuideToken = newTokenId.value == 198;

        _LlamaBase.lib.llama_sampler_accept(_samplers[i], newTokenId.value);

        codes.add(newTokenId.value as llama_token);

        if (_LlamaBase.lib.llama_vocab_is_eog(vocab, newTokenId.value) || nDecode == _ttsParams.nPredict) {
          // Mark the stream as finished
          iBatch[i] = -1;
          continue;
        }

        iBatch[i] = batch.n_tokens;

        _batchAdd(batch, newTokenId.value as llama_token, nPast as llama_pos, [i], true);
      }

      if (batch.n_tokens == 0) {
        break;
      }

      nDecode++;
      nPast++;

      assert(_LlamaBase.lib.llama_decode(_ttcContext, batch) == 0, LlamaException('Failed to decode'));
    }

    _LlamaBase.lib.llama_batch_free(batch);

    codes.removeWhere((code) => code as int < 151672 || code as int > 155772);

    for (int i = 0; i < codes.length; i++) {
      codes[i] = ((codes[i] as int) - 151672) as llama_token;
    }

    batch = _LlamaBase.lib.llama_batch_init(codes.length, 0, 1);

    for (int i = 0; i < codes.length; i++) {
      _batchAdd(batch, codes[i], i as llama_pos, [0], true);
    }

    assert(_LlamaBase.lib.llama_decode(_ctsContext, batch) == 0, LlamaException('Failed to decode'));

    _LlamaBase.lib.llama_synchronize(_ctsContext);

    final nEmbd = _LlamaBase.lib.llama_model_n_embd(_ctsModel);
    final embd = _LlamaBase.lib.llama_get_embeddings(_ctsContext);

    final audio = await _embdToAudio(embd, nEmbd, codes.length);

    // zero out first 0.25 seconds
    for (int i = 0; i < 24000/4; ++i) {
      audio[i] = 0.0;
    }

    return WAV(data: audio).toBytes();
  }

  Future<List<double>> _embdToAudio(ffi.Pointer<ffi.Float> embd, int nEmbd, int nCodes) async {
    const nFft = 1280;
    const nHop = 320;
    const nWin = 1280;
    const nPad = (nWin - nHop) ~/ 2;
    final nOut = (nCodes - 1) * nHop + nWin;
    final nThreads = _ttsParams.nThreads ?? 1;

    List<double> hann = [];

    for (int i = 0; i < nFft; i++) {
      final x = i * math.pi / (nFft - 1);
      hann.add(0.5 * (1 - math.cos(x)));
    }

    final nSpec = nEmbd * nCodes;

    final eList = List.filled(nSpec, 0.0);
    final sList = List.filled(nSpec, 0.0);
    final stList = List.filled(nSpec, 0.0);

    for (int l = 0; l < nCodes; ++l) {
      for (int k = 0; k < nEmbd; ++k) {
        eList[k * nCodes + l] = embd[l * nEmbd + k];
      }
    }

    for (int k = 0; k < nEmbd / 2; ++k) {
      for (int l = 0; l < nCodes; ++l) {
        double mag = eList[k * nCodes + l];
        double phi = eList[(k + nEmbd ~/ 2) * nCodes + l];

        mag = math.exp(mag);

        if (mag > 1e2) {
          mag = 1e2;
        }

        sList[k * (nCodes + l) + 0] = mag * math.cos(phi);
        sList[k * (nCodes + l) + 1] = mag * math.sin(phi);
      }
    }

    for (int l = 0; l < nCodes; ++l) {
      for (int k = 0; k < nEmbd /2; ++k) {
        stList[l * nEmbd + 2 * k + 0] = sList[2 * (k * nCodes + l) + 0];
        stList[l * nEmbd + 2 * k + 1] = sList[2 * (k * nCodes + l) + 1];
      }
    }

    final res = List.filled(nCodes * nFft, 0.0);
    final hann2 = List.filled(nCodes * nFft, 0.0);

    List<Future<List<double>>> futures = [];
    for (int i = 0; i < nThreads; i++) {
      futures.add(Future(() async {
        List<double> localRes = List.filled(nCodes * nFft, 0.0);
        for (int l = i; l < nCodes; l += nThreads) {
          final output = await compute(_irfftTask, {
            'nFft': nFft,
            'input': stList.sublist(l * nEmbd, (l + 1) * nEmbd),
            'hann': hann
          });

          for (int j = 0; j < nFft; ++j) {
            localRes[l * nFft + j] = output[j];
            hann2[l * nFft + j] = hann[j] * hann[j];
          }
        }
        return localRes;
      }));
    }

    List<List<double>> results = await Future.wait(futures);

    // Merge results
    for (var part in results) {
      for (int i = 0; i < res.length; i++) {
        res[i] += part[i];
      }
    }

    List<double> audio = List.filled(nOut, 0.0);
    List<double> env = List.filled(nOut, 0.0);

    _fold(res, nOut, nWin, nHop, nPad, audio);
    _fold(hann2, nOut, nWin, nHop, nPad, env);

    for (int i = 0; i < audio.length; i++) {
      audio[i] /= env[i];
    }

    return audio;
  }

  Future<List<double>> _irfftTask(Map<String, dynamic> args) async {
    int nFft = args['nFft'];
    List<double> input = args['input'];
    List<double> hann = args['hann'];

    int n = nFft ~/ 2 + 1;
    List<double> real = List.filled(nFft, 0.0);
    List<double> imag = List.filled(nFft, 0.0);
    List<double> output = List.filled(nFft, 0.0);

    for (int k = 0; k < n; k++) {
      real[k] = input[2 * k];
      imag[k] = input[2 * k + 1];
    }

    for (int i = 0; i < nFft; i++) {
      double sumReal = 0.0;
      for (int k = 0; k < n; k++) {
        double angle = 2 * math.pi * k * i / nFft;
        sumReal += real[k] * math.cos(angle) - imag[k] * math.sin(angle);
      }
      output[i] = sumReal / nFft; // Normalize
      output[i] *= hann[i]; // Apply Hann window
    }

    return output;
  }

  // Overlap-add method for reconstructing audio
  void _fold(List<double> input, int nOut, int nWin, int nHop, int nPad, List<double> output) {
    List<double> sumWeights = List.filled(nOut, 0.0);
    output.fillRange(0, nOut, 0.0);

    for (int i = 0; i < input.length ~/ nWin; i++) {
      int offset = i * nHop;
      for (int j = 0; j < nWin; j++) {
        if (offset + j < nOut) {
          output[offset + j] += input[i * nWin + j];
          sumWeights[offset + j] += 1.0;
        }
      }
    }

    // Normalize by overlap factor
    for (int i = 0; i < nOut; i++) {
      if (sumWeights[i] > 0) {
        output[i] /= sumWeights[i];
      }
    }
  }

  void _batchAdd(llama_batch batch, llama_token id, llama_pos pos, List<int> seqIds, bool logits) {
    batch.token[batch.n_tokens] = id as int;
    batch.pos[batch.n_tokens] = pos as int;
    batch.logits[batch.n_tokens] = logits ? 1 : 0;
    batch.n_seq_id[batch.n_tokens] = seqIds.length;

    for (int j = 0; j < _ttsParams.nParallel; ++j) {
      batch.seq_id[batch.n_tokens][j] = seqIds[j];
    }

    batch.n_tokens++;
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
  
  String _processText(String text) {
    // Replace numbers with words (Assuming you have an equivalent function)
    String processedText = _Num2Words.process(text);

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