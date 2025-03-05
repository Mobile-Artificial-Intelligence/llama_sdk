part of 'package:lcpp/lcpp.dart';

class LlamaChatParams extends LlamaParams {
  File? _chatModel;

  File? get chatModel => _chatModel;

  set chatModel(File? value) {
    _chatModel = value;
    notifyListeners();
  }

  LlamaChatParams({
    File? chatModel,
    super.vocabOnly,
    super.useMmap,
    super.useMlock,
    super.checkTensors,
    super.nCtx,
    super.nBatch,
    super.nUBatch,
    super.nSeqMax,
    super.nThreads,
    super.nThreadsBatch,
    super.ropeScalingType,
    super.poolingType,
    super.attentionType,
    super.ropeFrequencyBase,
    super.ropeFrequencyScale,
    super.yarnExtrapolationFactor,
    super.yarnAttenuationFactor,
    super.yarnBetaFast,
    super.yarnBetaSlow,
    super.yarnOriginalContext,
    super.defragmentationThreshold,
    super.typeK,
    super.typeV,
    super.embeddings,
    super.offloadKqv,
    super.flashAttention,
    super.noPerformance,
  }) : _chatModel = chatModel;

  factory LlamaChatParams.fromMap(Map<String, dynamic> map) => LlamaChatParams(
      chatModel: File(map['chatModel']),
      vocabOnly: map['vocabOnly'],
      useMmap: map['useMmap'],
      useMlock: map['useMlock'],
      checkTensors: map['checkTensors'],
      nCtx: map['nCtx'],
      nBatch: map['nBatch'],
      nUBatch: map['nUBatch'],
      nSeqMax: map['nSeqMax'],
      nThreads: map['nThreads'],
      nThreadsBatch: map['nThreadsBatch'],
      ropeScalingType: RopeScalingType.fromString(map['ropeScalingType']),
      poolingType: PoolingType.fromString(map['poolingType']),
      attentionType: AttentionType.fromString(map['attentionType']),
      ropeFrequencyBase: map['ropeFrequencyBase'],
      ropeFrequencyScale: map['ropeFrequencyScale'],
      yarnExtrapolationFactor: map['yarnExtrapolationFactor'],
      yarnAttenuationFactor: map['yarnAttenuationFactor'],
      yarnBetaFast: map['yarnBetaFast'],
      yarnBetaSlow: map['yarnBetaSlow'],
      yarnOriginalContext: map['yarnOriginalContext'],
      defragmentationThreshold: map['defragmentationThreshold'],
      typeK: GgmlType.fromString(map['typeK']),
      typeV: GgmlType.fromString(map['typeV']),
      embeddings: map['embeddings'],
      offloadKqv: map['offloadKqv'],
      flashAttention: map['flashAttention'],
      noPerformance: map['noPerformance'],
    );

  factory LlamaChatParams.fromJson(String source) => LlamaChatParams.fromMap(jsonDecode(source));
}