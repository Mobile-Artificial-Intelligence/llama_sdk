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
  ffi.Pointer<llama_sampler> _sampler = ffi.nullptr;

  LlamaTtsParams _ttsParams;

  set ttsParams(LlamaTtsParams value) {
    _ttsParams = value;
    _ttsParams.addListener(_initModel);
    _initModel();
  }

  void _initModel() {
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

    _sampler = _ttsParams.getSampler();
    assert(_sampler != ffi.nullptr, LlamaException('Failed to initialize sampler'));

    _LlamaBase.samplerFinalizer.attach(this, _sampler);
  }

  @override
  void reload() => _initModel();

  @override
  Future<Uint8List> tts(String text) {
    // TODO: implement tts
    throw UnimplementedError();
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