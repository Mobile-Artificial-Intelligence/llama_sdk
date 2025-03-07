part of 'package:llama/llama.dart';

/// A class that implements the Llama interface and provides functionality
/// for loading and interacting with a Llama model, context, and sampler.
///
/// The class initializes the model, context, and sampler based on the provided
/// parameters and allows for prompting the model with chat messages.
///
/// The class also provides methods to stop the current operation and free
/// the allocated resources.
///
class LlamaNative implements Llama {
  static final _modelFinalizer =
      Finalizer<ffi.Pointer<llama_model>>(Llama.lib.llama_free_model);
  static final _contextFinalizer =
      Finalizer<ffi.Pointer<llama_context>>(Llama.lib.llama_free);
  static final _samplerFinalizer =
      Finalizer<ffi.Pointer<llama_sampler>>(Llama.lib.llama_sampler_free);

  ffi.Pointer<llama_model> _model = ffi.nullptr;
  ffi.Pointer<llama_context> _context = ffi.nullptr;
  ffi.Pointer<llama_sampler> _sampler = ffi.nullptr;

  LlamaParams _llamaParams;

  int _contextLength = 0;

  /// Sets the current LlamaParams instance.
  /// 
  /// The [LlamaParams] instance contains the parameters used by llama.
  set llamaParams(LlamaParams value) {
    _llamaParams = value;
    _llamaParams.addListener(_init);
    _init();
  }

  /// A class that initializes and manages a native Llama model.
  ///
  /// The [LlamaNative] constructor requires [llamaParams] to initialize the
  /// Llama model, context, and sampler.
  ///
  /// Parameters:
  /// - [llamaParams]: The parameters required for the Llama model.
  LlamaNative(LlamaParams llamaParams)
      : _llamaParams = llamaParams {
    Llama.lib.ggml_backend_load_all();
    Llama.lib.llama_backend_init();

    _init();
  }

  void _init() {
    final nativeModelParams = _llamaParams.getModelParams();
    final nativeModelPath = _llamaParams.modelFile.path.toNativeUtf8().cast<ffi.Char>();

    if (_model != ffi.nullptr) {
      Llama.lib.llama_free_model(_model);
    }

    _model = Llama.lib
        .llama_load_model_from_file(nativeModelPath, nativeModelParams);
    assert(_model != ffi.nullptr, LlamaException('Failed to load model'));

    _modelFinalizer.attach(this, _model);

    assert(_model != ffi.nullptr, LlamaException('Model is not loaded'));

    final nativeContextParams = _llamaParams.getContextParams();

    if (_context != ffi.nullptr) {
      Llama.lib.llama_free(_context);
    }

    _context = Llama.lib.llama_init_from_model(_model, nativeContextParams);
    assert(_context != ffi.nullptr, LlamaException('Failed to initialize context'));

    _contextFinalizer.attach(this, _context);

    if (_sampler != ffi.nullptr) {
      Llama.lib.llama_sampler_free(_sampler);
    }

    final vocab = Llama.lib.llama_model_get_vocab(_model);
    _sampler = _llamaParams.getSampler(vocab);
    assert(_sampler != ffi.nullptr, LlamaException('Failed to initialize sampler'));

    _samplerFinalizer.attach(this, _sampler);
  }

  @override
  Stream<String> prompt(List<ChatMessage> messages) async* {
    final messagesCopy = messages.copy();

    assert(_model != ffi.nullptr, LlamaException('Model is not loaded'));
    assert(_context != ffi.nullptr, LlamaException('Context is not initialized'));
    assert(_sampler != ffi.nullptr, LlamaException('Sampler is not initialized'));

    final nCtx = Llama.lib.llama_n_ctx(_context);

    ffi.Pointer<ffi.Char> formatted = calloc<ffi.Char>(nCtx);

    final template = Llama.lib.llama_model_chat_template(_model, ffi.nullptr);

    ffi.Pointer<llama_chat_message> messagesPtr = messagesCopy.toNative();

    int newContextLength = Llama.lib.llama_chat_apply_template(
        template, messagesPtr, messagesCopy.length, true, formatted, nCtx);

    if (newContextLength > nCtx) {
      calloc.free(formatted);
      formatted = calloc<ffi.Char>(newContextLength);
      newContextLength = Llama.lib.llama_chat_apply_template(template,
          messagesPtr, messagesCopy.length, true, formatted, newContextLength);
    }

    messagesPtr.free(messagesCopy.length);

    if (newContextLength < 0) {
      throw Exception('Failed to apply template');
    }

    final prompt =
        formatted.cast<Utf8>().toDartString().substring(_contextLength);
    calloc.free(formatted);

    final vocab = Llama.lib.llama_model_get_vocab(_model);
    final isFirst = Llama.lib.llama_get_kv_cache_used_cells(_context) == 0;

    final promptPtr = prompt.toNativeUtf8().cast<ffi.Char>();

    final nPromptTokens = -Llama.lib.llama_tokenize(
        vocab, promptPtr, prompt.length, ffi.nullptr, 0, isFirst, true);
    ffi.Pointer<llama_token> promptTokens = calloc<llama_token>(nPromptTokens);

    if (Llama.lib.llama_tokenize(vocab, promptPtr, prompt.length, promptTokens,
            nPromptTokens, isFirst, true) <
        0) {
      throw Exception('Failed to tokenize');
    }

    calloc.free(promptPtr);

    llama_batch batch =
        Llama.lib.llama_batch_get_one(promptTokens, nPromptTokens);
    ffi.Pointer<llama_token> newTokenId = calloc<llama_token>(1);

    String response = '';

    while (true) {
      final nCtx = Llama.lib.llama_n_ctx(_context);
      final nCtxUsed = Llama.lib.llama_get_kv_cache_used_cells(_context);

      if (nCtxUsed + batch.n_tokens > nCtx) {
        throw Exception('Context size exceeded');
      }

      if (Llama.lib.llama_decode(_context, batch) != 0) {
        throw Exception('Failed to decode');
      }

      newTokenId.value = Llama.lib.llama_sampler_sample(_sampler, _context, -1);

      // is it an end of generation?
      if (Llama.lib.llama_vocab_is_eog(vocab, newTokenId.value)) {
        break;
      }

      final buffer = calloc<ffi.Char>(256);
      final n = Llama.lib
          .llama_token_to_piece(vocab, newTokenId.value, buffer, 256, 0, true);
      if (n < 0) {
        throw Exception('Failed to convert token to piece');
      }

      final piece = buffer.cast<Utf8>().toDartString();
      calloc.free(buffer);
      response += piece;
      yield piece;

      batch = Llama.lib.llama_batch_get_one(newTokenId, 1);
    }

    messagesCopy.add(AssistantChatMessage(response));

    messagesPtr = messagesCopy.toNative();

    _contextLength = Llama.lib.llama_chat_apply_template(
        template, messagesPtr, messagesCopy.length, false, ffi.nullptr, 0);

    messagesPtr.free(messagesCopy.length);
    calloc.free(promptTokens);
    Llama.lib.llama_batch_free(batch);
  }

  @override
  void reload() => _init();
}
