part of 'package:llama_sdk/llama_sdk.web.dart';

/// A class that isolates the Llama implementation to run in a separate isolate.
///
/// This class implements the [Llama] interface and provides methods to interact
/// with the Llama model in an isolated environment.
///
/// The [Llama] constructor initializes the isolate with the provided
/// model, context, and sampling parameters.
///
/// The [prompt] method sends a list of [LlamaMessage] to the isolate and returns
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
  Llama(this.controller);

  /// Generates a stream of responses based on the provided list of chat messages.
  ///
  /// This method takes a list of [LlamaMessage] objects and returns a [Stream] of
  /// strings, where each string represents a response generated from the chat messages.
  ///
  /// The stream allows for asynchronous processing of the chat messages, enabling
  /// real-time or batched responses.
  ///
  /// - Parameter messages: A list of [LlamaMessage] objects that represent the chat history.
  /// - Returns: A [Stream] of strings, where each string is a generated response.
  Stream<String> prompt(List<LlamaMessage> messages) async* {
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

  /// Reloads the isolate.
  ///
  /// This method stops the current operation and reloads the isolate.
  /// It is useful for refreshing the state or reinitializing the
  /// environment.
  void reload() {
    throw LlamaException('Web not supported');
  }
}
