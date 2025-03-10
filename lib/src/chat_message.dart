part of 'package:lcpp/lcpp.dart';

typedef _ChatMessageRecord = (String role, String content);

/// An abstract class representing a chat message.
///
/// This class provides a base for different types of chat messages, each with
/// a specific role and content.
///
/// Properties:
/// - `role`: A string representing the role of the message sender.
/// - `content`: The content of the message.
///
/// Constructors:
/// - `ChatMessage(String content)`: Initializes a chat message with the given content.
/// - `ChatMessage.withRole({required String role, required String content})`: Factory constructor
///   that creates a chat message based on the specified role. Throws an `ArgumentError` if the role is invalid.
/// - `ChatMessage._fromRecord(_ChatMessageRecord record)`: Factory constructor that creates a chat message
///   from a record.
/// - `ChatMessage.fromNative(llama_chat_message message)`: Factory constructor that creates a chat message
///   from a native `llama_chat_message`.
///
/// Methods:
/// - `llama_chat_message toNative()`: Converts the chat message to a native `llama_chat_message`.
/// - `_ChatMessageRecord _toRecord()`: Converts the chat message to a record.
abstract class ChatMessage {
  /// The role of the chat message sender.
  ///
  /// This property represents the role of the entity that sent the chat message,
  /// such as 'user', 'assistant', or any other defined role.
  String get role;

  /// The content of the chat message.
  String content;

  /// Creates a new instance of [ChatMessage] with the given content.
  ///
  /// The [content] parameter represents the message content.
  ChatMessage(this.content);

  /// Factory constructor to create a `ChatMessage` instance based on the provided role.
  ///
  /// The `role` parameter determines the type of `ChatMessage` to create:
  /// - 'user': Creates a `UserChatMessage`.
  /// - 'assistant': Creates an `AssistantChatMessage`.
  /// - 'system': Creates a `SystemChatMessage`.
  ///
  /// Throws an [ArgumentError] if the provided role is not one of the expected values.
  ///
  /// Parameters:
  /// - `role`: The role of the chat message (e.g., 'user', 'assistant', 'system').
  /// - `content`: The content of the chat message.
  factory ChatMessage.withRole({
    required String role,
    required String content,
  }) {
    switch (role) {
      case 'user':
        return UserChatMessage(content);
      case 'assistant':
        return AssistantChatMessage(content);
      case 'system':
        return SystemChatMessage(content);
      default:
        throw ArgumentError('Invalid role: $role');
    }
  }

  /// Creates a [ChatMessage] instance from a map.
  ///
  /// The map should contain a 'role' key with one of the following values:
  /// - 'user': to create a [UserChatMessage]
  /// - 'assistant': to create an [AssistantChatMessage]
  /// - 'system': to create a [SystemChatMessage]
  ///
  /// The map should also contain a 'content' key with the message content.
  ///
  /// Throws an [Exception] if the 'role' value is invalid.
  factory ChatMessage.fromMap(Map<String, dynamic> map) {
    switch (map['role']) {
      case 'user':
        return UserChatMessage(map['content']);
      case 'assistant':
        return AssistantChatMessage(map['content']);
      case 'system':
        return SystemChatMessage(map['content']);
      default:
        throw Exception('Invalid role');
    }
  }

  factory ChatMessage._fromRecord(_ChatMessageRecord record) =>
      ChatMessage.withRole(role: record.$1, content: record.$2);

  /// Converts a [ChatMessage] object to a map representation.
  ///
  /// The returned map contains the following key-value pairs:
  /// - 'role': The role of the message sender.
  /// - 'content': The content of the message.
  ///
  /// Example:
  /// ```dart
  /// ChatMessage message = ChatMessage(role: 'user', content: 'Hello');
  /// Map<String, String> map = messageToMap(message);
  /// // map = {'role': 'user', 'content': 'Hello'}
  /// ```
  ///
  /// [message]: The [ChatMessage] object to be converted.
  static Map<String, String> messageToMap(ChatMessage message) => {
        'role': message.role,
        'content': message.content,
      };

  /// Converts the current `ChatMessage` instance to a map.
  ///
  /// This method uses the `messageToMap` function to transform the
  /// `ChatMessage` object into a `Map<String, String>`, which can be
  /// useful for serialization or other operations that require a map
  /// representation of the message.
  ///
  /// Returns a `Map<String, String>` representation of the `ChatMessage`.
  Map<String, String> toMap() => messageToMap(this);

  _ChatMessageRecord _toRecord() => (role, content);
}

/// A class representing a chat message from a user.
///
/// This class extends the [ChatMessage] class and overrides the [role] getter
/// to return 'user', indicating that the message is from a user.
///
/// Example usage:
/// ```dart
/// var message = UserChatMessage('Hello, world!');
/// print(message.role); // Output: user
/// print(message.content); // Output: Hello, world!
/// ```
///
/// The [UserChatMessage] constructor takes the content of the message as a parameter.
class UserChatMessage extends ChatMessage {
  @override
  String get role => 'user';

  /// A class representing a user chat message.
  ///
  /// This class extends a base class and takes the content of the message as a parameter.
  ///
  /// Example usage:
  /// ```dart
  /// var message = UserChatMessage('Hello, world!');
  /// print(message.content); // Outputs: Hello, world!
  /// ```
  ///
  /// Parameters:
  /// - `content`: The content of the chat message.
  UserChatMessage(super.content);
}

/// A class representing a chat message from an assistant.
///
/// This class extends the [ChatMessage] class and overrides the [role] getter
/// to return 'assistant', indicating that the message is from an assistant.
///
/// Example usage:
/// ```dart
/// var message = AssistantChatMessage('Hello, how can I assist you?');
/// print(message.role); // Outputs: assistant
/// print(message.content); // Outputs: Hello, how can I assist you?
/// ```
///
/// See also:
/// - [ChatMessage], the base class for chat messages.
class AssistantChatMessage extends ChatMessage {
  @override
  String get role => 'assistant';

  /// Represents a chat message from the assistant.
  ///
  /// The [AssistantChatMessage] class extends a base class with the provided
  /// content of the message.
  ///
  /// Example usage:
  /// ```dart
  /// var message = AssistantChatMessage('Hello, how can I assist you?');
  /// print(message.content); // Output: Hello, how can I assist you?
  /// ```
  ///
  /// Parameters:
  /// - `content`: The content of the chat message.
  AssistantChatMessage(super.content);
}

/// A class representing a system-generated chat message.
///
/// This class extends the [ChatMessage] class and overrides the `role`
/// property to return 'system', indicating that the message is generated
/// by the system.
///
/// Example usage:
/// ```dart
/// var systemMessage = SystemChatMessage('System maintenance scheduled.');
/// print(systemMessage.role); // Outputs: system
/// print(systemMessage.content); // Outputs: System maintenance scheduled.
/// ```
///
/// The [SystemChatMessage] constructor takes a single parameter, `content`,
/// which represents the content of the chat message.
class SystemChatMessage extends ChatMessage {
  @override
  String get role => 'system';

  /// Represents a system-generated chat message.
  ///
  /// This class extends the base class and takes the content of the message as a parameter.
  ///
  /// Example usage:
  /// ```dart
  /// var message = SystemChatMessage('System maintenance scheduled.');
  /// print(message.content); // Outputs: System maintenance scheduled.
  /// ```
  ///
  /// Parameters:
  /// - `content`: The content of the chat message.
  SystemChatMessage(super.content);
}

/// An extension on the `List<ChatMessage>` class to provide additional functionality.
extension ChatMessages on List<ChatMessage> {
  /// Creates a copy of the list of `ChatMessage` objects.
  ///
  /// This method iterates over the current list of `ChatMessage` instances,
  /// creates a new `ChatMessage` for each one with the same role and content,
  /// and returns a new list containing these copied messages.
  ///
  /// Returns:
  ///   A new list of `ChatMessage` objects with the same role and content as the original list.
  List<ChatMessage> copy() {
    final List<ChatMessage> messages = [];

    for (var message in this) {
      messages.add(
          ChatMessage.withRole(role: message.role, content: message.content));
    }

    return messages;
  }

  List<Map<String, String>> toMapList() => map((message) => message.toMap()).toList();

  String toJson() => jsonEncode(toMapList());

  ffi.Pointer<ffi.Char> _toPointer() => toJson().toNativeUtf8().cast<ffi.Char>();

  List<_ChatMessageRecord> _toRecords() {
    final List<_ChatMessageRecord> records = [];

    for (var i = 0; i < length; i++) {
      records.add(this[i]._toRecord());
    }

    return records;
  }

  static List<ChatMessage> _fromRecords(List<_ChatMessageRecord> records) {
    final List<ChatMessage> messages = [];

    for (var record in records) {
      messages.add(ChatMessage._fromRecord(record));
    }

    return messages;
  }
}
