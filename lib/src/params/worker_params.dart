part of 'package:lcpp/lcpp.dart';

typedef _LlamaWorkerRecord = (SendPort, String, String);

class _LlamaWorkerParams {
  final SendPort sendPort;
  final LlamaParams llamaParams;
  final SamplingParams samplingParams;

  _LlamaWorkerParams({
    required this.sendPort,
    required this.llamaParams,
    required this.samplingParams,
  });

  _LlamaWorkerRecord toRecord() {
    return (sendPort, llamaParams.toJson(),  samplingParams.toJson());
  }
}