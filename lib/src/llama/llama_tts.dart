part of 'package:lcpp/lcpp.dart';

class LlamaTTS with _LlamaTTSMixin implements _LlamaBase {
  LlamaTTS({
    required ModelParams modelParams,
    ContextParams? contextParams,
    SamplingParams samplingParams = const SamplingParams(),
  }) : _modelParams = modelParams,
        _contextParams = contextParams ?? ContextParams(),
        _samplingParams = samplingParams {
    _LlamaBase.lib.ggml_backend_load_all();
    _LlamaBase.lib.llama_backend_init();

    _initModel();
  }

  ffi.Pointer<llama_model> _ttcModel = ffi.nullptr;
  ffi.Pointer<llama_model> _ctsModel = ffi.nullptr;
  ffi.Pointer<llama_context> _ttcContext = ffi.nullptr;
  ffi.Pointer<llama_context> _ctsContext = ffi.nullptr;
  ffi.Pointer<llama_sampler> _sampler = ffi.nullptr;

  ModelParams _modelParams;
  ContextParams _contextParams;
  SamplingParams _samplingParams;

  set modelParams(ModelParams modelParams) {
    _modelParams = modelParams;
    _modelParams.addListener(_initModel);
    _initModel();
  }

  set contextParams(ContextParams contextParams) {
    _contextParams = contextParams;
    _contextParams.addListener(_initContext);
    _initContext();
  }

  set samplingParams(SamplingParams samplingParams) {
    _samplingParams = samplingParams;

    _initSampler();
  }

  void _initModel() {
    assert(_modelParams.ttcModel != null, LlamaException('TTC model is required'));
    assert(_modelParams.ctsModel != null, LlamaException('CTS model is required'));

    final nativeModelParams = _modelParams.toNative();
    final nativeTtcModelPath = _modelParams.ttcModel!.path.toNativeUtf8().cast<ffi.Char>();
    final nativeCtsModelPath = _modelParams.ctsModel!.path.toNativeUtf8().cast<ffi.Char>();

    if (_ttcModel != ffi.nullptr) {
      _LlamaBase.lib.llama_free_model(_ttcModel);
    }

    if (_ctsModel != ffi.nullptr) {
      _LlamaBase.lib.llama_free_model(_ctsModel);
    }

    _ttcModel = _LlamaBase.lib
        .llama_load_model_from_file(nativeTtcModelPath, nativeModelParams);
    assert(_ttcModel != ffi.nullptr, LlamaException('Failed to load model'));

    _ctsModel = _LlamaBase.lib
        .llama_load_model_from_file(nativeCtsModelPath, nativeModelParams);
    assert(_ctsModel != ffi.nullptr, LlamaException('Failed to load model'));

    _LlamaBase.modelFinalizer.attach(this, _ttcModel);
    _LlamaBase.modelFinalizer.attach(this, _ctsModel);

    _initContext();
    _initSampler();
  }

  void _initContext() {
    assert(_ttcModel != ffi.nullptr, LlamaException('TTC Model is not loaded'));
    assert(_ctsModel != ffi.nullptr, LlamaException('CTS Model is not loaded'));

    final nativeContextParams = _contextParams.toNative();

    if (_ttcContext != ffi.nullptr) {
      _LlamaBase.lib.llama_free(_ttcContext);
    }

    if (_ctsContext != ffi.nullptr) {
      _LlamaBase.lib.llama_free(_ctsContext);
    }

    _ttcContext = _LlamaBase.lib.llama_init_from_model(_ttcModel, nativeContextParams);
    assert(_ttcContext != ffi.nullptr, LlamaException('Failed to initialize context'));

    _ctsContext = _LlamaBase.lib.llama_init_from_model(_ctsModel, nativeContextParams);
    assert(_ctsContext != ffi.nullptr, LlamaException('Failed to initialize context'));

    _LlamaBase.contextFinalizer.attach(this, _ttcContext);
    _LlamaBase.contextFinalizer.attach(this, _ctsContext);
  }

  void _initSampler() {
    if (_sampler != ffi.nullptr) {
      _LlamaBase.lib.llama_sampler_free(_sampler);
    }

    _sampler = _samplingParams.toNative();
    assert(_sampler != ffi.nullptr, LlamaException('Failed to initialize sampler'));

    _LlamaBase.samplerFinalizer.attach(this, _sampler);
  }

  @override
  void reload() {
    // TODO: implement reload
  }

  @override
  void stop() {
    // TODO: implement stop
  }

  @override
  Future<Uint8List> tts(String text) {
    // TODO: implement tts
    throw UnimplementedError();
  }
  
}