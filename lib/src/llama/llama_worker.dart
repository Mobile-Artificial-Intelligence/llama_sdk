part of 'package:lcpp/lcpp.dart';

class _LlamaWorker {
  final Completer<void> completer = Completer<void>();
  final ReceivePort receivePort = ReceivePort();
  final SendPort sendPort;
  LlamaChat? chat;

  _LlamaWorker({
    required this.sendPort,
    LlamaChatParams? chatParams,
    required SamplingParams samplingParams,
  }) {
    if (chatParams != null) {
      chat = LlamaChat(chatParams: chatParams, samplingParams: samplingParams);
    }

    sendPort.send(receivePort.sendPort);
    receivePort.listen(handleData);
  }

  factory _LlamaWorker.fromRecord(_LlamaWorkerRecord record) => _LlamaWorker(
    sendPort: record.$1,
    chatParams: LlamaChatParams.fromJson(record.$2),
    samplingParams: SamplingParams.fromJson(record.$3),
  );

  void handleData(dynamic data) async {
    switch (data.runtimeType) {
      case const (List<_ChatMessageRecord>):
        handlePrompt(data.cast<_ChatMessageRecord>());
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

    sendPort.send(null);
  }

  static void entry(_LlamaWorkerRecord record) async {
    final worker = _LlamaWorker.fromRecord(record);
    await worker.completer.future;
  }
}