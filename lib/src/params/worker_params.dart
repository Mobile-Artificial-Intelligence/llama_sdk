part of 'package:lcpp/lcpp.dart';

typedef _LlamaWorkerRecord = (SendPort, String?, String?);

class _LlamaWorkerParams {
  final SendPort sendPort;
  final LlamaChatParams? chatParams;
  final LlamaTtsParams? ttsParams;

  _LlamaWorkerParams({
    required this.sendPort,
    required this.chatParams,
    required this.ttsParams,
  });

  _LlamaWorkerRecord toRecord() {
    return (sendPort, chatParams?.toJson(), ttsParams?.toJson());
  }
}