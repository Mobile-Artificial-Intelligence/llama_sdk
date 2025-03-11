part of 'package:lcpp/lcpp.dart';

typedef _LlamaWorkerRecord = (SendPort, String);

class _LlamaWorkerParams {
  final SendPort sendPort;
  final LlamaParams llamaParams;

  _LlamaWorkerParams({
    required this.sendPort,
    required this.llamaParams
  });

  _LlamaWorkerRecord toRecord() {
    return (sendPort, llamaParams.toJson());
  }
}

class _LlamaWorker {
  static final _finalizer = Finalizer(
    (_) => lib.llama_llm_free(),
  );
  static SendPort? _sendPort;

  final Completer<void> completer = Completer<void>();
  final ReceivePort receivePort = ReceivePort();
  final LlamaParams llamaParams;

  _LlamaWorker({
    required SendPort sendPort,
    required this.llamaParams
  }) {
    _sendPort = sendPort;
    sendPort.send(receivePort.sendPort);
    receivePort.listen(handleData);
    _init();
    _finalizer.attach(this, null);
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
    final messages = ChatMessages._fromRecords(data);
    final chatMessagesPointer = messages._toPointer();

    lib.llama_prompt(chatMessagesPointer, ffi.Pointer.fromFunction(_output));
  }

  static void entry(_LlamaWorkerRecord record) async {
    final worker = _LlamaWorker.fromRecord(record);
    await worker.completer.future;
  }

  void _init() => lib.llama_llm_init(llamaParams._toPointer());

  static void _output(ffi.Pointer<ffi.Char> buffer) {
    if (buffer == ffi.nullptr) {
      _sendPort!.send(null);
    }
    else {
      _sendPort!.send(buffer.cast<Utf8>().toDartString());
    }
  }
}