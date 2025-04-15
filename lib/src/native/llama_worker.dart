part of 'package:llama_sdk/llama_sdk.dart';

typedef _LlamaWorkerRecord = (SendPort, String);

class _LlamaWorkerParams {
  final SendPort sendPort;
  final LlamaController controller;

  _LlamaWorkerParams({required this.sendPort, required this.controller});

  _LlamaWorkerRecord toRecord() {
    return (sendPort, controller.toJson());
  }
}

class _LlamaWorker {
  static SendPort? _sendPort;

  final Completer<void> completer = Completer<void>();
  final ReceivePort receivePort = ReceivePort();
  final LlamaController controller;

  _LlamaWorker({required SendPort sendPort, required this.controller}) {
    _sendPort = sendPort;
    sendPort.send(receivePort.sendPort);
    receivePort.listen(handlePrompt);
    _init();
  }

  factory _LlamaWorker.fromRecord(_LlamaWorkerRecord record) => _LlamaWorker(
        sendPort: record.$1,
        controller: LlamaController.fromJson(record.$2),
      );

  void handlePrompt(dynamic data) async {
    try {
      final messages = _LlamaMessagesExtension.fromRecords(
        data as List<_LlamaMessageRecord>,
      );
      final llamaMessagesPointer = messages.toPointer();

      lib.llama_prompt(llamaMessagesPointer, ffi.Pointer.fromFunction(_output));
    } catch (e) {
      _output(ffi.nullptr);
    }
  }

  static void entry(_LlamaWorkerRecord record) async {
    final worker = _LlamaWorker.fromRecord(record);
    await worker.completer.future;
  }

  void _init() =>
      lib.llama_llm_init(controller.toJson().toNativeUtf8().cast<ffi.Char>());

  static void _output(ffi.Pointer<ffi.Char> buffer) {
    if (buffer == ffi.nullptr) {
      _sendPort!.send(null);
    } else {
      _sendPort!.send(buffer.cast<Utf8>().toDartString());
    }
  }
}
