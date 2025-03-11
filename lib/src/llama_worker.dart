part of 'package:lcpp/lcpp.dart';

typedef _LlamaWorkerRecord = (SendPort, String?, String?);

class _LlamaWorkerParams {
  final SendPort sendPort;
  final LlamaParams? llmParams;
  final LlamaParams? ttsParams;

  _LlamaWorkerParams({
    required this.sendPort,
    required this.llmParams,
    required this.ttsParams
  });

  _LlamaWorkerRecord toRecord() {
    return (sendPort, llmParams?.toJson(), ttsParams?.toJson());
  }
}

class _LlamaWorker {
  static final _finalizer = Finalizer(
    (_) => lib.llama_llm_free(),
  );
  static SendPort? _sendPort;

  final Completer<void> completer = Completer<void>();
  final ReceivePort receivePort = ReceivePort();
  final LlamaParams? llmParams;
  final LlamaParams? ttsParams;

  _LlamaWorker({
    required SendPort sendPort,
    required this.llmParams,
    required this.ttsParams
  }) {
    _sendPort = sendPort;
    sendPort.send(receivePort.sendPort);
    receivePort.listen(handleData);
    _init();
    _finalizer.attach(this, null);
  }

  factory _LlamaWorker.fromRecord(_LlamaWorkerRecord record) => _LlamaWorker(
    sendPort: record.$1,
    llmParams: record.$2 != null ? LlamaParams.fromJson(record.$2!) : null,
    ttsParams: record.$3 != null ? LlamaParams.fromJson(record.$3!) : null
  );

  void handleData(dynamic data) async {
    switch (data.runtimeType) {
      case const (List<_ChatMessageRecord>):
        handlePrompt(data.cast<_ChatMessageRecord>());
        break;
      case const ((String, String)):
        handleTTS(data.$1, data.$2);
        break;
      default:
        completer.completeError(LlamaException('Invalid data type'));
        break;
    }
  }

  void handlePrompt(List<_ChatMessageRecord> data) async {
    if (llmParams == null) {
      throw LlamaException('LlamaParams is null');
    }

    final messages = ChatMessages._fromRecords(data);
    final chatMessagesPointer = messages._toPointer();

    lib.llama_prompt(chatMessagesPointer, ffi.Pointer.fromFunction(_output));
  }

  void handleTTS(String text, String outputPath) async {
    if (ttsParams == null) {
      throw LlamaException('LlamaParams is null');
    }

    final textPointer = text.toNativeUtf8().cast<ffi.Char>();
    final outputPathPointer = outputPath.toNativeUtf8().cast<ffi.Char>();

    lib.llama_tts(textPointer, outputPathPointer);

    await Future.delayed(const Duration(milliseconds: 100));

    _sendPort!.send(false);
  }

  static void entry(_LlamaWorkerRecord record) async {
    final worker = _LlamaWorker.fromRecord(record);
    await worker.completer.future;
  }

  void _init() {
    if (llmParams != null) {
      lib.llama_llm_init(llmParams!._toPointer());
    }

    if (ttsParams != null) {
      lib.llama_tts_init(ttsParams!._toPointer());
    }
  }

  static void _output(ffi.Pointer<ffi.Char> buffer) {
    if (buffer == ffi.nullptr) {
      _sendPort!.send(true);
    }
    else {
      _sendPort!.send(buffer.cast<Utf8>().toDartString());
    }
  }
}