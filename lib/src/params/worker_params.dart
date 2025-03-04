part of 'package:lcpp/lcpp.dart';

typedef _LlamaWorkerRecord = (SendPort, String, String, String);

class _LlamaWorkerParams {
  final SendPort sendPort;
  final ModelParams modelParams;
  final ContextParams contextParams;
  final SamplingParams samplingParams;

  _LlamaWorkerParams({
    required this.sendPort,
    required this.modelParams,
    required this.contextParams,
    required this.samplingParams,
  });

  _LlamaWorkerRecord toRecord() {
    return (sendPort, modelParams.toJson(), contextParams.toJson(), samplingParams.toJson());
  }
}