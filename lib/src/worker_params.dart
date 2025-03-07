part of 'package:llama/llama.dart';

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