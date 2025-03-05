part of 'package:lcpp/lcpp.dart';

/// An abstract interface class representing a Llama library.
///
/// This class provides a factory constructor to create instances of either
/// `LlamaIsolated` or `LlamaNative` based on the `isolate` parameter. It also
/// provides a static getter to load the appropriate dynamic library based on
/// the platform.
///
/// The `Llama` class has the following members:
///
/// - `lib`: A static getter that returns an instance of the `llama` library,
///   loading the appropriate dynamic library based on the platform if it has
///   not been loaded already.
/// - `Llama` factory constructor: Creates an instance of either `LlamaIsolated`
///   or `LlamaNative` based on the `isolate` parameter.
/// - `prompt`: A method that takes a list of `ChatMessage` objects and returns
///   a stream of strings.
/// - `stop`: A method to stop the Llama instance.
/// - `free`: A method to free the resources used by the Llama instance.
///
/// Throws an `LlamaException` if the platform is unsupported.
abstract interface class _LlamaBase {
  static final modelFinalizer =
      Finalizer<ffi.Pointer<llama_model>>(_LlamaBase.lib.llama_free_model);
  static final contextFinalizer =
      Finalizer<ffi.Pointer<llama_context>>(_LlamaBase.lib.llama_free);
  static final samplerFinalizer =
      Finalizer<ffi.Pointer<llama_sampler>>(_LlamaBase.lib.llama_sampler_free);

  static llama? _lib;

  static llama get lib {
    if (_lib == null) {
      if (Platform.isWindows) {
        _lib = llama(ffi.DynamicLibrary.open('llama.dll'));
      } else if (Platform.isLinux || Platform.isAndroid) {
        _lib = llama(ffi.DynamicLibrary.open('libllama.so'));
      } else if (Platform.isMacOS || Platform.isIOS) {
        _lib = llama(ffi.DynamicLibrary.open('lcpp.framework/lcpp'));
      } else {
        throw LlamaException('Unsupported platform');
      }
    }
    return _lib!;
  }

  /// Reloads the current state or configuration.
  ///
  /// This method is used to refresh or reinitialize the state or configuration
  /// of the object. Implementations should define the specific behavior of
  /// what needs to be reloaded.
  void reload();
}
