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
  /// Factory constructor for creating a [Llama] instance.
  ///
  /// Depending on the value of [isolate], this constructor will either create
  /// an instance of [LlamaIsolated] or [LlamaNative].
  ///
  /// - [llamaParams]: The parameters required for the Llama model.
  /// - [isolate]: If true, creates an instance of [LlamaIsolated], otherwise
  ///   creates an instance of [LlamaNative].
  factory Llama({
    required LlamaParams llamaParams,
    bool isolate = false,
  }) =>
      isolate
          ? LlamaIsolated(llamaParams)
          : LlamaNative(llamaParams);

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
  Stream<String> prompt(List<ChatMessage> messages);

  /// Reloads the current state or configuration.
  ///
  /// This method is used to refresh or reinitialize the state or configuration
  /// of the object. Implementations should define the specific behavior of
  /// what needs to be reloaded.
  void reload();
}