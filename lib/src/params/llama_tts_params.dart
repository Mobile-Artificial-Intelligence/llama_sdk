part of 'package:lcpp/lcpp.dart';

class LlamaTtsParams extends LlamaParams {
  File? _ttcModel;

  File? get ttcModel => _ttcModel;

  set ttcModel(File? value) {
    _ttcModel = value;
    notifyListeners();
  }

  File? _ctsModel;

  File? get ctsModel => _ctsModel;

  set ctsModel(File? value) {
    _ctsModel = value;
    notifyListeners();
  }

  LlamaTtsParams({
    File? ttcModel,
    File? ctsModel,
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
  }) : _ttcModel = ttcModel, _ctsModel = ctsModel;

  factory LlamaTtsParams.fromMap(Map<String, dynamic> map) => LlamaTtsParams(
      ttcModel: File(map['ttcModel']),
      ctsModel: File(map['ctsModel']),
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

  factory LlamaTtsParams.fromJson(String source) => LlamaTtsParams.fromMap(jsonDecode(source));
}