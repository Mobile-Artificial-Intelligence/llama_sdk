part of 'package:lcpp/lcpp.dart';

class LlamaTtsParams extends LlamaParams {
  File _ttcModel;

  File get ttcModel => _ttcModel;

  set ttcModel(File value) {
    _ttcModel = value;
    notifyListeners();
  }

  File _ctsModel;

  File get ctsModel => _ctsModel;

  set ctsModel(File value) {
    _ctsModel = value;
    notifyListeners();
  }

  VoiceData _voice;

  VoiceData get voice => _voice;

  set voice(VoiceData value) {
    _voice = value;
    notifyListeners();
  }

  LlamaTtsParams({
    required File ttcModel,
    required File ctsModel,
    required VoiceData voice,
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
    super.greedy,
    super.infill,
    super.seed,
    super.topK,
    super.topP,
    super.minKeepTopP,
    super.minP,
    super.minKeepMinP,
    super.typicalP,
    super.minKeepTypicalP,
    super.temperature,
    super.temperatureDelta,
    super.temperatureExponent,
    super.xtcP,
    super.xtcT,
    super.minKeepXtc,
    super.xtcSeed,
    super.mirostatNVocab,
    super.mirostatSeed,
    super.mirostatTau,
    super.mirostatEta,
    super.mirostatM,
    super.mirostatV2Seed,
    super.mirostatV2Tau,
    super.mirostatV2Eta,
    super.grammarStr,
    super.grammarRoot,
    super.penaltiesLastN,
    super.penaltiesRepeat,
    super.penaltiesFrequency,
    super.penaltiesPresent,
    super.drySamplerNCtxTrain,
    super.drySamplerMultiplier,
    super.drySamplerDryBase,
    super.drySamplerAllowedLength,
  }) : _ttcModel = ttcModel, _ctsModel = ctsModel, _voice = voice;

  factory LlamaTtsParams.fromMap(Map<String, dynamic> map) => LlamaTtsParams(
      ttcModel: File(map['ttc_model']),
      ctsModel: File(map['cts_model']),
      voice: VoiceData.fromMap(map['voice']),
      vocabOnly: map['vocab_only'],
      useMmap: map['use_mmap'],
      useMlock: map['use_mlock'],
      checkTensors: map['check_tensors'],
      nCtx: map['n_ctx'],
      nBatch: map['n_batch'],
      nUBatch: map['n_ubatch'],
      nSeqMax: map['n_seq_max'],
      nThreads: map['n_threads'],
      nThreadsBatch: map['n_threads_batch'],
      ropeScalingType: map['rope_scaling_type'] != null ? RopeScalingType.fromString(map['rope_scaling_type']) : null,
      poolingType: map['pooling_type'] != null ? PoolingType.fromString(map['pooling_type']) : null,
      attentionType: map['attention_type'] != null ? AttentionType.fromString(map['attention_type']) : null,
      ropeFrequencyBase: map['rope_frequency_base'],
      ropeFrequencyScale: map['rope_frequency_scale'],
      yarnExtrapolationFactor: map['yarn_extrapolation_factor'],
      yarnAttenuationFactor: map['yarn_attenuation_factor'],
      yarnBetaFast: map['yarn_beta_fast'],
      yarnBetaSlow: map['yarn_beta_slow'],
      yarnOriginalContext: map['yarn_original_context'],
      defragmentationThreshold: map['defragmentation_threshold'],
      typeK: map['type_k'] != null ? GgmlType.fromString(map['type_k']) : null,
      typeV: map['type_v'] != null ? GgmlType.fromString(map['type_v']) : null,
      embeddings: map['embeddings'],
      offloadKqv: map['offload_kqv'],
      flashAttention: map['flash_attention'],
      noPerformance: map['no_perf'],
      greedy: map['greedy'],
      infill: map['infill'],
      seed: map['seed'],
      topK: map['top_k'],
      topP: map['top_p'],
      minKeepTopP: map['min_keep_top_p'],
      minP: map['min_p'],
      minKeepMinP: map['min_keep_min_p'],
      typicalP: map['typical_p'],
      minKeepTypicalP: map['min_keep_typical_p'],
      temperature: map['temperature'],
      temperatureDelta: map['temperature_delta'],
      temperatureExponent: map['temperature_exponent'],
      xtcP: map['xtc_p'],
      xtcT: map['xtc_t'],
      minKeepXtc: map['min_keep_xtc'],
      xtcSeed: map['xtc_seed'],
      mirostatNVocab: map['mirostat_n_vocab'],
      mirostatSeed: map['mirostat_seed'],
      mirostatTau: map['mirostat_tau'],
      mirostatEta: map['mirostat_eta'],
      mirostatM: map['mirostat_m'],
      mirostatV2Seed: map['mirostat_v2_seed'],
      mirostatV2Tau: map['mirostat_v2_tau'],
      mirostatV2Eta: map['mirostat_v2_eta'],
      grammarStr: map['grammar_str'],
      grammarRoot: map['grammar_root'],
      penaltiesLastN: map['penalties_last_n'],
      penaltiesRepeat: map['penalties_repeat'],
      penaltiesFrequency: map['penalties_frequency'],
      penaltiesPresent: map['penalties_present'],
      drySamplerNCtxTrain: map['dry_sampler_n_ctx_train'],
      drySamplerMultiplier: map['dry_sampler_multiplier'],
      drySamplerDryBase: map['dry_sampler_dry_base'],
      drySamplerAllowedLength: map['dry_sampler_allowed_length'],
    );

  factory LlamaTtsParams.fromJson(String source) => LlamaTtsParams.fromMap(jsonDecode(source));

  @override
  Map<String, dynamic> toMap() => {
    'ttc_model': ttcModel.path,
    'cts_model': ctsModel.path,
    'voice': voice.toMap(),
    ...super.toMap(),
  };
}