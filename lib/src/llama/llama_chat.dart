part of 'package:lcpp/lcpp.dart';

class LlamaChat with _LlamaPromptMixin implements _LlamaBase {
  LlamaChat(LlamaChatParams chatParams)
      : _chatParams = chatParams {
    _LlamaBase.lib.ggml_backend_load_all();
    _LlamaBase.lib.llama_backend_init();

    _initModel();
  }

  ffi.Pointer<llama_model> _model = ffi.nullptr;
  ffi.Pointer<llama_context> _context = ffi.nullptr;
  ffi.Pointer<llama_sampler> _sampler = ffi.nullptr;

  int _contextLength = 0;

  LlamaChatParams _chatParams;

  set chatParams(LlamaChatParams value) {
    _chatParams = value;
    _chatParams.addListener(_initModel);
    _initModel();
  }

  void _initModel() {
    final nativeModelParams = _chatParams.getModelParams();
    final nativeModelPath = _chatParams.chatModel.path.toNativeUtf8().cast<ffi.Char>();

    if (_model != ffi.nullptr) {
      _LlamaBase.lib.llama_free_model(_model);
    }

    _model = _LlamaBase.lib
        .llama_load_model_from_file(nativeModelPath, nativeModelParams);
    assert(_model != ffi.nullptr, LlamaException('Failed to load model'));

    _LlamaBase.modelFinalizer.attach(this, _model);

    _initContext();
    _initSampler();
  }

  void _initContext() {
    assert(_model != ffi.nullptr, LlamaException('Model is not loaded'));

    final nativeContextParams = _chatParams.getContextParams();

    if (_context != ffi.nullptr) {
      _LlamaBase.lib.llama_free(_context);
    }

    _context = _LlamaBase.lib.llama_init_from_model(_model, nativeContextParams);
    assert(_context != ffi.nullptr, LlamaException('Failed to initialize context'));

    _LlamaBase.contextFinalizer.attach(this, _context);
  }

  void _initSampler() {
    assert(_model != ffi.nullptr, LlamaException('Model is not loaded'));

    if (_sampler != ffi.nullptr) {
      _LlamaBase.lib.llama_sampler_free(_sampler);
    }

    final vocab = _LlamaBase.lib.llama_model_get_vocab(_model);
    _sampler = _chatParams.getSampler(vocab);
    assert(_sampler != ffi.nullptr, LlamaException('Failed to initialize sampler'));

    _LlamaBase.samplerFinalizer.attach(this, _sampler);
  }

  @override
  void reload() => _initModel();

  @override
  Stream<String> prompt(List<ChatMessage> messages) async* {
    final messagesCopy = messages.copy();

    assert(_model != ffi.nullptr, LlamaException('Model is not loaded'));
    assert(_context != ffi.nullptr, LlamaException('Context is not initialized'));
    assert(_sampler != ffi.nullptr, LlamaException('Sampler is not initialized'));

    final nCtx = _LlamaBase.lib.llama_n_ctx(_context);

    ffi.Pointer<ffi.Char> formatted = calloc<ffi.Char>(nCtx);

    final template = _LlamaBase.lib.llama_model_chat_template(_model, ffi.nullptr);

    ffi.Pointer<llama_chat_message> messagesPtr = messagesCopy.toNative();

    int newContextLength = _LlamaBase.lib.llama_chat_apply_template(
        template, messagesPtr, messagesCopy.length, true, formatted, nCtx);

    if (newContextLength > nCtx) {
      calloc.free(formatted);
      formatted = calloc<ffi.Char>(newContextLength);
      newContextLength = _LlamaBase.lib.llama_chat_apply_template(template,
          messagesPtr, messagesCopy.length, true, formatted, newContextLength);
    }

    messagesPtr.free(messagesCopy.length);

    if (newContextLength < 0) {
      throw Exception('Failed to apply template');
    }

    final prompt =
        formatted.cast<Utf8>().toDartString().substring(_contextLength);
    calloc.free(formatted);

    final vocab = _LlamaBase.lib.llama_model_get_vocab(_model);
    final isFirst = _LlamaBase.lib.llama_get_kv_cache_used_cells(_context) == 0;

    final promptPtr = prompt.toNativeUtf8().cast<ffi.Char>();

    final nPromptTokens = -_LlamaBase.lib.llama_tokenize(
        vocab, promptPtr, prompt.length, ffi.nullptr, 0, isFirst, true);
    ffi.Pointer<llama_token> promptTokens = calloc<llama_token>(nPromptTokens);

    if (_LlamaBase.lib.llama_tokenize(vocab, promptPtr, prompt.length, promptTokens,
            nPromptTokens, isFirst, true) <
        0) {
      throw Exception('Failed to tokenize');
    }

    calloc.free(promptPtr);

    llama_batch batch =
        _LlamaBase.lib.llama_batch_get_one(promptTokens, nPromptTokens);
    ffi.Pointer<llama_token> newTokenId = calloc<llama_token>(1);

    String response = '';

    while (true) {
      final nCtx = _LlamaBase.lib.llama_n_ctx(_context);
      final nCtxUsed = _LlamaBase.lib.llama_get_kv_cache_used_cells(_context);

      if (nCtxUsed + batch.n_tokens > nCtx) {
        throw Exception('Context size exceeded');
      }

      if (_LlamaBase.lib.llama_decode(_context, batch) != 0) {
        throw Exception('Failed to decode');
      }

      newTokenId.value = _LlamaBase.lib.llama_sampler_sample(_sampler, _context, -1);

      // is it an end of generation?
      if (_LlamaBase.lib.llama_vocab_is_eog(vocab, newTokenId.value)) {
        break;
      }

      final buffer = calloc<ffi.Char>(256);
      final n = _LlamaBase.lib
          .llama_token_to_piece(vocab, newTokenId.value, buffer, 256, 0, true);
      if (n < 0) {
        throw Exception('Failed to convert token to piece');
      }

      final piece = buffer.cast<Utf8>().toDartString();
      calloc.free(buffer);
      response += piece;
      yield piece;

      batch = _LlamaBase.lib.llama_batch_get_one(newTokenId, 1);
    }

    messagesCopy.add(AssistantChatMessage(response));

    messagesPtr = messagesCopy.toNative();

    _contextLength = _LlamaBase.lib.llama_chat_apply_template(
        template, messagesPtr, messagesCopy.length, false, ffi.nullptr, 0);

    messagesPtr.free(messagesCopy.length);
    calloc.free(promptTokens);
    _LlamaBase.lib.llama_batch_free(batch);
  }
}
