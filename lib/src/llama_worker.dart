part of 'package:llama/llama.dart';

class _LlamaWorker {
  final Completer<void> completer = Completer<void>();
  final ReceivePort receivePort = ReceivePort();
  final SendPort sendPort;
  LlamaNative? native;

  _LlamaWorker({
    required this.sendPort,
    required LlamaParams llamaParams
  }) {
    native = LlamaNative(llamaParams);

    sendPort.send(receivePort.sendPort);
    receivePort.listen(handleData);
  }

  factory _LlamaWorker.fromRecord(_LlamaWorkerRecord record) => _LlamaWorker(
    sendPort: record.$1,
    llamaParams: LlamaParams.fromJson(record.$2)
  );

  void handleData(dynamic data) async {
    switch (data.runtimeType) {
      case const (List<_ChatMessageRecord>):
        handlePrompt(data.cast<_ChatMessageRecord>());
        break;
      default:
        completer.completeError(LlamaException('Invalid data type'));
        break;
    }
  }

  void handlePrompt(List<_ChatMessageRecord> data) async {
    assert(native != null, LlamaException('Llama Native is not initialized'));
    
    final messages = ChatMessages._fromRecords(data);
    final stream = native!.prompt(messages);

    await for (final response in stream) {
      sendPort.send(response);
    }

    await Future.delayed(const Duration(milliseconds: 100));

    sendPort.send(null);
  }

  static void entry(_LlamaWorkerRecord record) async {
    final worker = _LlamaWorker.fromRecord(record);
    await worker.completer.future;
  }
}