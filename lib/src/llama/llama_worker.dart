part of 'package:lcpp/lcpp.dart';

class _LlamaWorker {
  final Completer<void> completer = Completer<void>();
  final ReceivePort receivePort = ReceivePort();
  final SendPort sendPort;
  final LlamaNative llamaNative;

  _LlamaWorker({
    required this.sendPort,
    required ModelParams modelParams,
    required ContextParams contextParams,
    required SamplingParams samplingParams,
  }) : llamaNative = LlamaNative(
    modelParams: modelParams,
    contextParams: contextParams,
    samplingParams: samplingParams,
  ) {
    sendPort.send(receivePort.sendPort);
    receivePort.listen(_handleMessage);
  }

  factory _LlamaWorker.fromRecord(_LlamaWorkerRecord record) => _LlamaWorker(
    sendPort: record.$1,
    modelParams: ModelParams.fromJson(record.$2),
    contextParams: ContextParams.fromJson(record.$3),
    samplingParams: SamplingParams.fromJson(record.$4),
  );

  void _handleMessage(dynamic data) async {
    if (data is List<_ChatMessageRecord>) {
      final messages = ChatMessages._fromRecords(data);
      final stream = llamaNative.prompt(messages);

      await for (final response in stream) {
        sendPort.send(response);
      }

      sendPort.send(null);
    }
  }

  static void entry(_LlamaWorkerRecord record) async {
    final worker = _LlamaWorker.fromRecord(record);
    await worker.completer.future;
  }
}