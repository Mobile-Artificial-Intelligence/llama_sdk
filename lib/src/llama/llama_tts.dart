part of 'package:lcpp/lcpp.dart';

class LlamaTTS with _LlamaTTSMixin implements _LlamaBase {
  LlamaTTS({
    required LlamaTtsParams ttsParams,
    SamplingParams samplingParams = const SamplingParams(),
  }) : _ttsParams = ttsParams,
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

  LlamaTtsParams _ttsParams;
  SamplingParams _samplingParams;

  set ttsParams(LlamaTtsParams value) {
    _ttsParams = value;
    _ttsParams.addListener(_initModel);
    _initModel();
  }

  set samplingParams(SamplingParams value) {
    _samplingParams = value;

    _initSampler();
  }

  void _initModel() {
    assert(_ttsParams.ttcModel != null, LlamaException('TTC model is required'));
    assert(_ttsParams.ctsModel != null, LlamaException('CTS model is required'));

    final nativeModelParams = _ttsParams.getModelParams();
    final nativeTtcModelPath = _ttsParams.ttcModel!.path.toNativeUtf8().cast<ffi.Char>();
    final nativeCtsModelPath = _ttsParams.ctsModel!.path.toNativeUtf8().cast<ffi.Char>();

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

    final nativeContextParams = _ttsParams.getContextParams();

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

    _sampler = _samplingParams.getSampler();
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