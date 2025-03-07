part of 'package:llama/llama.dart';

/// A class that isolates the Llama implementation to run in a separate isolate.
///
/// This class implements the [Llama] interface and provides methods to interact
/// with the Llama model in an isolated environment.
///
/// The [LlamaIsolated] constructor initializes the isolate with the provided
/// model, context, and sampling parameters.
///
/// The [prompt] method sends a list of [ChatMessage] to the isolate and returns
/// a stream of responses. It waits for the isolate to be initialized before
/// sending the messages.
///
/// The [stop] method sends a signal to the isolate to stop processing. It waits
/// for the isolate to be initialized before sending the signal.
///
/// The [reload] method stops the current operation and reloads the isolate.
class LlamaIsolated implements Llama {
  Completer _initialized = Completer();
  StreamController<String> _responseController = StreamController<String>()
    ..close();
  Isolate? _isolate;
  SendPort? _sendPort;
  ReceivePort? _receivePort;

  LlamaParams _llamaParams;

  /// Gets the current LlamaParams instance.
  ///
  /// The [LlamaParams] instance contains the parameters used by the llama.
  ///
  /// Returns the current [LlamaParams] instance.
  LlamaParams get llamaParams => _llamaParams;

  set llamaParams(LlamaParams value) {
    _llamaParams = value;
    reload();
  }

  /// Indicates whether the resource has been freed.
  ///
  /// This boolean flag is used to track the state of the resource,
  /// where `true` means the resource has been freed and `false` means
  /// it is still in use.
  bool isFreed = false;

  /// Constructs an instance of [LlamaIsolated].
  ///
  /// Initializes the [LlamaIsolated] with the provided parameters and sets up
  /// the listener.
  ///
  /// Parameters:
  /// - [llamaParams]: The parameters required for the Llama model.
  LlamaIsolated(LlamaParams llamaParams)
      : _llamaParams = llamaParams;

  void _listener() async {
    _receivePort = ReceivePort();

    final workerParams = _LlamaWorkerParams(
      sendPort: _receivePort!.sendPort,
      llamaParams: _llamaParams,
    );

    _isolate = await Isolate.spawn(_LlamaWorker.entry, workerParams.toRecord());

    await for (final data in _receivePort!) {
      if (data is SendPort) {
        _sendPort = data;
        _initialized.complete();
      } else if (data is String) {
        _responseController.add(data);
      } else if (data == null) {
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
