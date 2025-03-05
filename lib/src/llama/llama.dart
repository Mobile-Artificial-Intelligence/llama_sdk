part of 'package:lcpp/lcpp.dart';

/// A class that isolates the Llama implementation to run in a separate isolate.
///
/// This class implements the [Llama] interface and provides methods to interact
/// with the Llama model in an isolated environment.
///
/// The [Llama] constructor initializes the isolate with the provided
/// model, context, and sampling parameters.
///
/// The [prompt] method sends a list of [ChatMessage] to the isolate and returns
/// a stream of responses. It waits for the isolate to be initialized before
/// sending the messages.
///
/// The [stop] method sends a signal to the isolate to stop processing. It waits
/// for the isolate to be initialized before sending the signal.
/// 
/// The [reload] method stops the current operation and reloads the isolate with
/// the updated parameters.
class Llama with _LlamaPromptMixin, _LlamaTTSMixin implements _LlamaBase {
  Completer _initialized = Completer();
  late StreamController _responseController;
  Isolate? _isolate;
  SendPort? _sendPort;
  ReceivePort? _receivePort;

  LlamaTtsParams? _ttsParams;

  LlamaTtsParams? get ttsParams => _ttsParams;

  set ttsParams(LlamaTtsParams? value) {
    _ttsParams = value;
    reload();
  }

  LlamaChatParams? _chatParams;

  LlamaChatParams? get chatParams => _chatParams;

  set chatParams(LlamaChatParams? value) {
    _chatParams = value;
    reload();
  }

  bool isFreed = false;

  Llama({LlamaChatParams? chatParams, LlamaTtsParams? ttsParams})
      : _chatParams = chatParams, _ttsParams = ttsParams;

  void _listener() async {
    _receivePort = ReceivePort();

    final isolateParams = _LlamaWorkerParams(
      ttsParams: _ttsParams,
      chatParams: _chatParams,
      sendPort: _receivePort!.sendPort
    );

    _isolate = await Isolate.spawn(_LlamaWorker.entry, isolateParams.toRecord());

    await for (final data in _receivePort!) {
      if (data is SendPort) {
        _sendPort = data;
        _initialized.complete();
      } 
      else if (data is String) {
        _responseController.add(data);
      } 
      else if (data is Uint8List) {
        _responseController.add(data);
      }
      else if (data == null) {
        _responseController.close();
      }
    }
  }

  @override
  Stream<String> prompt(List<ChatMessage> messages) async* {
    if (isFreed) {
      throw LlamaException('LlamaIsolated has been freed');
    }

    if (!_initialized.isCompleted) {
      _listener();
      await _initialized.future;
    }

    _responseController = StreamController<String>();

    _sendPort!.send(messages._toRecords());

    await for (final response in _responseController.stream) {
      yield response;
    }
  }

  @override
  Future<Uint8List> tts(String text) async {
    if (isFreed) {
      throw LlamaException('LlamaIsolated has been freed');
    }

    if (!_initialized.isCompleted) {
      _listener();
      await _initialized.future;
    }

    _responseController = StreamController<Uint8List>();

    _sendPort!.send(text);

    return await _responseController.stream.first;
  }

  /// Stops the current operation or process.
  ///
  /// This method should be called to terminate any ongoing tasks or
  /// processes that need to be halted. It ensures that resources are
  /// properly released and the system is left in a stable state.
  void stop() {
    _isolate?.kill(priority: Isolate.immediate);
    _receivePort?.close();
    _initialized = Completer();
  }

  @override
  void reload() => stop();
}
