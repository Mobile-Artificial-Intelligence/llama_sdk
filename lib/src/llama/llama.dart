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
abstract interface class Llama {
  static llama? _lib;

  /// Returns an instance of the `llama` library.
  ///
  /// This getter initializes the `_lib` field if it is `null` by loading the
  /// appropriate dynamic library based on the current platform:
  ///
  /// - On Windows, it loads `llama.dll`.
  /// - On Linux or Android, it loads `libllama.so`.
  /// - On macOS or iOS, it loads `llama.framework/llama`.
  ///
  /// Throws a [LlamaException] if the platform is unsupported.
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

  /// Factory constructor for creating a [Llama] instance.
  ///
  /// - [modelParams]: Required parameters for the model.
  /// - [contextParams]: Optional parameters for the context, defaults to an
  ///   instance of [ContextParams].
  /// - [samplingParams]: Optional parameters for sampling, defaults to an
  ///   instance of [SamplingParams].
  factory Llama({
    required ModelParams modelParams,
    ContextParams? contextParams,
    SamplingParams samplingParams = const SamplingParams(greedy: true)
  }) => LlamaIsolated(
    modelParams: modelParams,
    contextParams: contextParams,
    samplingParams: samplingParams,
  );

  /// Stops the current operation or process.
  ///
  /// This method should be called to terminate any ongoing tasks or
  /// processes that need to be halted. It ensures that resources are
  /// properly released and the system is left in a stable state.
  void stop();

  /// Reloads the current state or configuration.
  ///
  /// This method is used to refresh or reinitialize the state or configuration
  /// of the object. Implementations should define the specific behavior of
  /// what needs to be reloaded.
  void reload();
}
