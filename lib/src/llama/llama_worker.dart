part of 'package:lcpp/lcpp.dart';

class _LlamaWorker {
  final Completer<void> completer = Completer<void>();
  final ReceivePort receivePort = ReceivePort();
  final SendPort sendPort;
  LlamaChat? chat;
  LlamaTTS? tts;

  _LlamaWorker({
    required this.sendPort,
    LlamaChatParams? chatParams,
    LlamaTtsParams? ttsParams,
  }) {
    if (chatParams != null) {
      chat = LlamaChat(chatParams);
    }

    if (ttsParams != null) {
      tts = LlamaTTS(ttsParams);
    }

    sendPort.send(receivePort.sendPort);
    receivePort.listen(handleData);
  }

  factory _LlamaWorker.fromRecord(_LlamaWorkerRecord record) => _LlamaWorker(
    sendPort: record.$1,
    chatParams: record.$2 != null ? LlamaChatParams.fromJson(record.$2!) : null,
    ttsParams: record.$3 != null ? LlamaTtsParams.fromJson(record.$3!) : null,
  );

  void handleData(dynamic data) async {
    switch (data.runtimeType) {
      case const (List<_ChatMessageRecord>):
        handlePrompt(data.cast<_ChatMessageRecord>());
        break;
      case const (String):
        handleTts(data);
        break;
      default:
        completer.complete();
        break;
    }
  }

  void handlePrompt(List<_ChatMessageRecord> data) async {
    assert(chat != null, LlamaException('Chat is not initialized'));
    
    final messages = ChatMessages._fromRecords(data);
    final stream = chat!.prompt(messages);

    await for (final response in stream) {
      sendPort.send(response);
    }

    await Future.delayed(const Duration(milliseconds: 100));

    sendPort.send(null);
  }

  void handleTts(String text) async {
    assert(tts != null, LlamaException('TTS is not initialized'));

    final response = await tts!.tts(text);
    sendPort.send(response);

    await Future.delayed(const Duration(milliseconds: 100));

    sendPort.send(null);
  }

  static void entry(_LlamaWorkerRecord record) async {
    final worker = _LlamaWorker.fromRecord(record);
    await worker.completer.future;
  }
}