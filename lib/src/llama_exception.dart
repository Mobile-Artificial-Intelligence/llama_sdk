part of 'package:llama/llama.dart';

/// A custom exception class for handling errors specific to the Llama application.
///
/// The [LlamaException] class implements the [Exception] interface and provides
/// a way to create exceptions with a custom error message.
///
/// Example usage:
/// ```dart
/// throw LlamaException('An error occurred in the Llama application');
/// ```
///
/// The [message] property contains the error message that can be accessed
/// and displayed when the exception is caught.
///
/// The [toString] method is overridden to return the error message.
class LlamaException implements Exception {
  /// A message describing the exception.
  final String message;

  /// Creates a new instance of [LlamaException] with the provided error [message].
  ///
  /// The [message] parameter contains the details of the exception.
  LlamaException(this.message);

  @override
  String toString() => message;
}
