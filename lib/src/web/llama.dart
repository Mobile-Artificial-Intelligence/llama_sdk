part of 'package:lcpp/lcpp.web.dart';

/// A class that isolates the Llama implementation to run in a separate isolate.
///
/// This class implements the [Llama] interface and provides methods to interact
/// with the Llama model in an isolated environment.
///
/// The [Llama] constructor initializes the isolate with the provided
/// model, context, and sampling parameters.
///
/// The [prompt] method sends a list of [ChatMessage] to the isolate and returns
/// a stream of responses. It waits for the isolate to be initialized before
/// sending the messages.
///
/// The [stop] method sends a signal to the isolate to stop processing. It waits
/// for the isolate to be initialized before sending the signal.
///
/// The [reload] method stops the current operation and reloads the isolate.
class Llama {
  /// A completer that indicates when the isolate has been initialized.
  LlamaController controller;

  /// Constructs an instance of [Llama].
  ///
  /// Initializes the [Llama] with the provided parameters and sets up
  /// the listener.
  ///
  /// Parameters:
  /// - [controller]: The parameters required for the Llama model.
  Llama(this.controller) {
    _init();
  }

  void _init() {
    final paramsDartString = controller.toJson();
    final paramsJsString = paramsDartString.toJS;
    final paramsLength = (paramsDartString.length + 1).toJS;
    JSNumber paramsPtr = malloc(paramsLength);
    stringToUTF8(paramsJsString, paramsPtr, paramsLength);

    final result = UTF8ToString(paramsPtr);
    print(result.toDart);
    free(paramsPtr);
  }

  /// Generates a stream of responses based on the provided list of chat messages.
  ///
  /// This method takes a list of [ChatMessage] objects and returns a [Stream] of
  /// strings, where each string represents a response generated from the chat messages.
  ///
  /// The stream allows for asynchronous processing of the chat messages, enabling
  /// real-time or batched responses.
  ///
  /// - Parameter messages: A list of [ChatMessage] objects that represent the chat history.
  /// - Returns: A [Stream] of strings, where each string is a generated response.
  Stream<String> prompt(List<ChatMessage> messages) async* {
    throw LlamaException('Web not supported');
  }

  /// Stops the current operation or process.
  ///
  /// This method should be called to terminate any ongoing tasks or
  /// processes that need to be halted. It ensures that resources are
  /// properly released and the system is left in a stable state.
  void stop() {
    throw LlamaException('Web not supported');
  }
}
