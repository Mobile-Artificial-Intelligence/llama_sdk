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

  LlamaParams _llamaParams;

  /// Gets the model parameters.
  ///
  /// This property returns the [modelParams] which contains the parameters
  /// for the model.
  LlamaParams get modelParams => _llamaParams;

  set modelParams(LlamaParams modelParams) {
    _llamaParams = modelParams;
    reload();
  }

  SamplingParams _samplingParams;

  /// Gets the current sampling parameters.
  ///
  /// This property returns the [_samplingParams] which contains the
  /// parameters used for sampling in the llama isolated context.
  SamplingParams get samplingParams => _samplingParams;

  set samplingParams(SamplingParams samplingParams) {
    _samplingParams = samplingParams;
    reload();
  }

  /// Indicates whether the resource has been freed.
  ///
  /// This boolean flag is used to track the state of the resource,
  /// where `true` means the resource has been freed and `false` means
  /// it is still in use.
  bool isFreed = false;

  /// Constructs an instance of [Llama].
  ///
  /// Initializes the [Llama] with the provided parameters and sets up
  /// the listener.
  ///
  /// Parameters:
  /// - [llamaParams]: The parameters required for the model. This parameter is required.
  /// - [samplingParams]: The parameters for sampling. This parameter is optional and defaults to an instance of [SamplingParams] with `greedy` set to `true`.
  Llama(
      {required LlamaParams llamaParams,
      SamplingParams? samplingParams})
      : _llamaParams = llamaParams,
        _samplingParams = samplingParams ?? SamplingParams(greedy: true);

  void _listener() async {
    _receivePort = ReceivePort();

    final isolateParams = _LlamaWorkerParams(
      llamaParams: _llamaParams,
      samplingParams: _samplingParams,
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

  @override
  void stop() {
    _isolate?.kill(priority: Isolate.immediate);
    _receivePort?.close();
    _initialized = Completer();
  }

  @override
  void reload() => stop();
}
