part of 'package:lcpp/lcpp.dart';

typedef _LlamaIsolateRecord = (SendPort, String, String, String);

class _LlamaIsolateParams {
  final SendPort sendPort;
  final ModelParams modelParams;
  final ContextParams contextParams;
  final SamplingParams samplingParams;

  _LlamaIsolateParams({
    required this.sendPort,
    required this.modelParams,
    required this.contextParams,
    required this.samplingParams,
  });

  factory _LlamaIsolateParams.fromRecord(_LlamaIsolateRecord record) {
    return _LlamaIsolateParams(
      sendPort: record.$1,
      modelParams: ModelParams.fromJson(record.$2),
      contextParams: ContextParams.fromJson(record.$3),
      samplingParams: SamplingParams.fromJson(record.$4),
    );
  }

  _LlamaIsolateRecord toRecord() {
    return (sendPort, modelParams.toJson(), contextParams.toJson(), samplingParams.toJson());
  }
}