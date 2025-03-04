part of 'package:lcpp/lcpp.dart';

/// A class that isolates the Llama implementation to run in a separate isolate.
///
/// This class implements the [Llama] interface and provides methods to interact
/// with the Llama model in an isolated environment.
///
/// The [LlamaIsolated] constructor initializes the isolate with the provided
/// model, context, and sampling parameters.
///
/// The [_listener] method listens for messages from the isolate and handles
/// them accordingly. It adds responses to the [_responseController] stream,
/// sets the [_sendPort] when received, and completes the [_initialized] completer.
///
/// The [prompt] method sends a list of [ChatMessage] to the isolate and returns
/// a stream of responses. It waits for the isolate to be initialized before
/// sending the messages.
///
/// The [stop] method sends a signal to the isolate to stop processing. It waits
/// for the isolate to be initialized before sending the signal.
///
/// The [free] method sends a signal to the isolate to free resources. It waits
/// for the isolate to be initialized before sending the signal.
class LlamaIsolated implements Llama {
  Completer _initialized = Completer();
  StreamController<String> _responseController = StreamController<String>()
    ..close();
  Isolate? _isolate;
  SendPort? _sendPort;
  ReceivePort? _receivePort;

  ModelParams _modelParams;

  /// Gets the model parameters.
  ///
  /// This property returns the [_modelParams] which contains the parameters
  /// for the model.
  ModelParams get modelParams => _modelParams;

  set modelParams(ModelParams modelParams) {
    _modelParams = modelParams;
    reload();
  }

  ContextParams _contextParams;

  /// Gets the context parameters.
  ///
  /// This property returns the `_contextParams` which contains the parameters
  /// for the current context.
  ContextParams get contextParams => _contextParams;

  set contextParams(ContextParams contextParams) {
    _contextParams = contextParams;
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

  /// Constructs an instance of [LlamaIsolated].
  ///
  /// Initializes the [LlamaIsolated] with the provided parameters and sets up
  /// the listener.
  ///
  /// Parameters:
  /// - [modelParams]: The parameters required for the model. This parameter is required.
  /// - [contextParams]: The parameters for the context. This parameter is optional and defaults to an instance of [ContextParams].
  /// - [samplingParams]: The parameters for sampling. This parameter is optional and defaults to an instance of [SamplingParams] with `greedy` set to `true`.
  LlamaIsolated(
      {required ModelParams modelParams,
      ContextParams? contextParams,
      SamplingParams samplingParams = const SamplingParams(greedy: true)})
      : _modelParams = modelParams,
        _contextParams = contextParams ?? ContextParams(),
        _samplingParams = samplingParams;

  void _listener() async {
    _receivePort = ReceivePort();

    final isolateParams = _LlamaWorkerParams(
      modelParams: _modelParams,
      contextParams: _contextParams,
      samplingParams: _samplingParams,
      sendPort: _receivePort!.sendPort
    );

    _isolate = await Isolate.spawn(_LlamaWorker.entry, isolateParams.toRecord());

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

  @override
  void stop() {
    _isolate?.kill(priority: Isolate.immediate);
    _receivePort?.close();
    _initialized = Completer();
  }

  @override
  void reload() => stop();
}
