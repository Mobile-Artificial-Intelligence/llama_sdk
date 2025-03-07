// ignore_for_file: constant_identifier_names

part of 'package:llama/llama.dart';

/// A class that represents the parameters for the Llama model.
class LlamaParams extends ChangeNotifier {
  File _modelFile;

  /// The path to the model file.
  File get modelFile => _modelFile;

  set modelFile(File value) {
    _modelFile = value;
    notifyListeners();
  }

  bool? _vocabOnly;

  /// Indicates whether only the vocabulary should be loaded.
  ///
  /// If `true`, only the vocabulary is loaded, which can be useful for
  /// certain operations where the full model is not required. If `false`
  /// or `null`, the full model is loaded.
  bool? get vocabOnly => _vocabOnly;

  set vocabOnly(bool? value) {
    _vocabOnly = value;
    notifyListeners();
  }

  bool? _useMmap;

  /// Indicates whether memory-mapped files should be used.
  ///
  /// If `true`, memory-mapped files will be used, which can improve performance
  /// by allowing the operating system to manage memory more efficiently.
  /// If `false` or `null`, memory-mapped files will not be used.
  bool? get useMmap => _useMmap;

  set useMmap(bool? value) {
    _useMmap = value;
    notifyListeners();
  }

  bool? _useMlock;

  /// Indicates whether memory locking (mlock) should be used.
  ///
  /// When `true`, the memory used by the application will be locked,
  /// preventing it from being swapped out to disk. This can improve
  /// performance by ensuring that the memory remains in RAM.
  ///
  /// When `false` or `null`, memory locking is not used.
  bool? get useMlock => _useMlock;

  set useMlock(bool? value) {
    _useMlock = value;
    notifyListeners();
  }

  bool? _checkTensors;

  /// A flag indicating whether to check tensors.
  ///
  /// If `true`, tensors will be checked. If `false` or `null`, tensors will not be checked.
  bool? get checkTensors => _checkTensors;

  set checkTensors(bool? value) {
    _checkTensors = value;
    notifyListeners();
  }

  int _nCtx;

  /// text context, 0 = from model
  int get nCtx => _nCtx;

  set nCtx(int value) {
    _nCtx = value;
    notifyListeners();
  }

  int? _nBatch;

  /// logical maximum batch size that can be submitted to llama_decode
  int? get nBatch => _nBatch;

  set nBatch(int? value) {
    _nBatch = value;
    notifyListeners();
  }

  int? _nUBatch;

  /// physical maximum batch size
  int? get nUBatch => _nUBatch;

  set nUBatch(int? value) {
    _nUBatch = value;
    notifyListeners();
  }

  int? _nSeqMax;

  /// max number of sequences (i.e. distinct states for recurrent models)
  int? get nSeqMax => _nSeqMax;

  set nSeqMax(int? value) {
    _nSeqMax = value;
    notifyListeners();
  }

  int? _nThreads;

  /// number of threads to use for generation
  int? get nThreads => _nThreads;

  set nThreads(int? value) {
    _nThreads = value;
    notifyListeners();
  }

  int? _nThreadsBatch;

  /// number of threads to use for batch processing
  int? get nThreadsBatch => _nThreadsBatch;

  set nThreadsBatch(int? value) {
    _nThreadsBatch = value;
    notifyListeners();
  }

  RopeScalingType? _ropeScalingType;

  /// RoPE scaling type, from `enum llama_rope_scaling_type`
  RopeScalingType? get ropeScalingType => _ropeScalingType;

  set ropeScalingType(RopeScalingType? value) {
    _ropeScalingType = value;
    notifyListeners();
  }

  PoolingType? _poolingType;

  /// whether to pool (sum) embedding results by sequence id
  PoolingType? get poolingType => _poolingType;

  set poolingType(PoolingType? value) {
    _poolingType = value;
    notifyListeners();
  }

  AttentionType? _attentionType;

  /// attention type to use for embeddings
  AttentionType? get attentionType => _attentionType;

  set attentionType(AttentionType? value) {
    _attentionType = value;
    notifyListeners();
  }

  double? _ropeFrequencyBase;

  /// RoPE base frequency, 0 = from model
  double? get ropeFrequencyBase => _ropeFrequencyBase;

  set ropeFrequencyBase(double? value) {
    _ropeFrequencyBase = value;
    notifyListeners();
  }

  double? _ropeFrequencyScale;

  /// RoPE frequency scaling factor, 0 = from model
  double? get ropeFrequencyScale => _ropeFrequencyScale;

  set ropeFrequencyScale(double? value) {
    _ropeFrequencyScale = value;
    notifyListeners();
  }

  double? _yarnExtrapolationFactor;

  /// YaRN extrapolation mix factor, negative = from model
  double? get yarnExtrapolationFactor => _yarnExtrapolationFactor;

  set yarnExtrapolationFactor(double? value) {
    _yarnExtrapolationFactor = value;
    notifyListeners();
  }

  double? _yarnAttenuationFactor;

  /// YaRN magnitude scaling factor
  double? get yarnAttenuationFactor => _yarnAttenuationFactor;

  set yarnAttenuationFactor(double? value) {
    _yarnAttenuationFactor = value;
    notifyListeners();
  }

  double? _yarnBetaFast;

  /// YaRN low correction dim
  double? get yarnBetaFast => _yarnBetaFast;

  set yarnBetaFast(double? value) {
    _yarnBetaFast = value;
    notifyListeners();
  }

  double? _yarnBetaSlow;

  /// YaRN high correction dim
  double? get yarnBetaSlow => _yarnBetaSlow;

  set yarnBetaSlow(double? value) {
    _yarnBetaSlow = value;
    notifyListeners();
  }

  int? _yarnOriginalContext;

  /// YaRN original context size
  int? get yarnOriginalContext => _yarnOriginalContext;

  set yarnOriginalContext(int? value) {
    _yarnOriginalContext = value;
    notifyListeners();
  }

  double? _defragmentationThreshold;

  /// defragment the KV cache if holes/size > thold, < 0 disabled (default)
  double? get defragmentationThreshold => _defragmentationThreshold;

  set defragmentationThreshold(double? value) {
    _defragmentationThreshold = value;
    notifyListeners();
  }

  GgmlType? _typeK;

  /// data type for K cache
  GgmlType? get typeK => _typeK;

  set typeK(GgmlType? value) {
    _typeK = value;
    notifyListeners();
  }

  GgmlType? _typeV;

  /// data type for V cache
  GgmlType? get typeV => _typeV;

  set typeV(GgmlType? value) {
    _typeV = value;
    notifyListeners();
  }

  bool? _embeddings;

  /// if true, extract embeddings (together with logits)
  bool? get embeddings => _embeddings;

  set embeddings(bool? value) {
    _embeddings = value;
    notifyListeners();
  }

  bool? _offloadKqv;

  /// whether to offload the KQV ops (including the KV cache) to GPU
  bool? get offloadKqv => _offloadKqv;

  set offloadKqv(bool? value) {
    _offloadKqv = value;
    notifyListeners();
  }

  bool? _flashAttention;

  /// whether to use flash attention
  bool? get flashAttention => _flashAttention;

  set flashAttention(bool? value) {
    _flashAttention = value;
    notifyListeners();
  }

  bool? _noPerformance;

  /// whether to measure performance timings
  bool? get noPerformance => _noPerformance;

  set noPerformance(bool? value) {
    _noPerformance = value;
    notifyListeners();
  }

  bool _greedy = false;

  /// Enables greedy decoding if set to `true`.
  bool get greedy => _greedy;

  set greedy(bool value) {
    _greedy = value;
    notifyListeners();
  }

  bool _infill = false;

  /// Enables infill sampling if set to `true`.
  bool get infill => _infill;

  set infill(bool value) {
    _infill = value;
    notifyListeners();
  }

  int? _seed;

  /// Optional seed for random number generation to ensure reproducibility.
  int? get seed => _seed;

  set seed(int? value) {
    _seed = value;
    notifyListeners();
  }

  int? _topK;

  /// Limits the number of top candidates considered during sampling.
  int? get topK => _topK;

  set topK(int? value) {
    _topK = value;
    notifyListeners();
  }

  double? _topP;

  /// Top-P sampling
  double? get topP => _topP;

  set topP(double? value) {
    _topP = value;
    notifyListeners();
  }

  int? _minKeepTopP;

  /// Top-P sampling minimum keep
  int? get minKeepTopP => _minKeepTopP;

  set minKeepTopP(int? value) {
    _minKeepTopP = value;
    notifyListeners();
  }

  double? _minP;

  /// Minimum Probability sampling
  double? get minP => _minP;

  set minP(double? value) {
    _minP = value;
    notifyListeners();
  }

  int? _minKeepMinP;

  /// Minimum Probability sampling minimum keep
  int? get minKeepMinP => _minKeepMinP;

  set minKeepMinP(int? value) {
    _minKeepMinP = value;
    notifyListeners();
  }

  double? _typicalP;

  /// Typical-P sampling
  double? get typicalP => _typicalP;

  set typicalP(double? value) {
    _typicalP = value;
    notifyListeners();
  }

  int? _minKeepTypicalP;

  /// Typical-P sampling minimum keep
  int? get minKeepTypicalP => _minKeepTypicalP;

  set minKeepTypicalP(int? value) {
    _minKeepTypicalP = value;
    notifyListeners();
  }

  double? _temperature;

  /// Temperature-based sampling
  double? get temperature => _temperature;

  set temperature(double? value) {
    _temperature = value;
    notifyListeners();
  }

  double? _temperatureDelta;

  /// Temperature-based sampling delta
  double? get temperatureDelta => _temperatureDelta;

  set temperatureDelta(double? value) {
    _temperatureDelta = value;
    notifyListeners();
  }

  double? _temperatureExponent;

  /// Temperature-based sampling exponent
  double? get temperatureExponent => _temperatureExponent;

  set temperatureExponent(double? value) {
    _temperatureExponent = value;
    notifyListeners();
  }

  double? _xtcP;

  /// XTC sampling probability
  double? get xtcP => _xtcP;

  set xtcP(double? value) {
    _xtcP = value;
    notifyListeners();
  }

  double? _xtcT;

  /// XTC sampling temperature
  double? get xtcT => _xtcT;

  set xtcT(double? value) {
    _xtcT = value;
    notifyListeners();
  }

  int? _minKeepXtc;

  /// XTC sampling minimum keep
  int? get minKeepXtc => _minKeepXtc;

  set minKeepXtc(int? value) {
    _minKeepXtc = value;
    notifyListeners();
  }

  int? _xtcSeed;

  /// XTC sampling seed
  int? get xtcSeed => _xtcSeed;

  set xtcSeed(int? value) {
    _xtcSeed = value;
    notifyListeners();
  }

  int? _mirostatNVocab;

  /// Mirostat sampling vocabulary size
  int? get mirostatNVocab => _mirostatNVocab;

  set mirostatNVocab(int? value) {
    _mirostatNVocab = value;
    notifyListeners();
  }

  int? _mirostatSeed;

  /// Mirostat sampling seed
  int? get mirostatSeed => _mirostatSeed;

  set mirostatSeed(int? value) {
    _mirostatSeed = value;
    notifyListeners();
  }

  double? _mirostatTau;

  /// Mirostat sampling tau
  double? get mirostatTau => _mirostatTau;

  set mirostatTau(double? value) {
    _mirostatTau = value;
    notifyListeners();
  }

  double? _mirostatEta;

  /// Mirostat sampling eta
  double? get mirostatEta => _mirostatEta;

  set mirostatEta(double? value) {
    _mirostatEta = value;
    notifyListeners();
  }

  int? _mirostatM;

  /// Mirostat sampling M
  int? get mirostatM => _mirostatM;

  set mirostatM(int? value) {
    _mirostatM = value;
    notifyListeners();
  }

  int? _mirostatV2Seed;

  /// Mirostat v2 sampling seed
  int? get mirostatV2Seed => _mirostatV2Seed;

  set mirostatV2Seed(int? value) {
    _mirostatV2Seed = value;
    notifyListeners();
  }

  double? _mirostatV2Tau;

  /// Mirostat v2 sampling tau
  double? get mirostatV2Tau => _mirostatV2Tau;

  set mirostatV2Tau(double? value) {
    _mirostatV2Tau = value;
    notifyListeners();
  }

  double? _mirostatV2Eta;

  /// Mirostat v2 sampling eta
  double? get mirostatV2Eta => _mirostatV2Eta;

  set mirostatV2Eta(double? value) {
    _mirostatV2Eta = value;
    notifyListeners();
  }

  String? _grammarStr;

  /// Grammar-based sampling string
  String? get grammarStr => _grammarStr;

  set grammarStr(String? value) {
    _grammarStr = value;
    notifyListeners();
  }

  String? _grammarRoot;

  /// Grammar-based sampling root
  String? get grammarRoot => _grammarRoot;

  set grammarRoot(String? value) {
    _grammarRoot = value;
    notifyListeners();
  }

  int? _penaltiesLastN;

  /// Penalties last N
  int? get penaltiesLastN => _penaltiesLastN;

  set penaltiesLastN(int? value) {
    _penaltiesLastN = value;
    notifyListeners();
  }

  double? _penaltiesRepeat;

  /// Penalties repeat
  double? get penaltiesRepeat => _penaltiesRepeat;

  set penaltiesRepeat(double? value) {
    _penaltiesRepeat = value;
    notifyListeners();
  }

  double? _penaltiesFrequency;

  /// Penalties frequency
  double? get penaltiesFrequency => _penaltiesFrequency;

  set penaltiesFrequency(double? value) {
    _penaltiesFrequency = value;
    notifyListeners();
  }

  double? _penaltiesPresent;

  /// Penalties present
  double? get penaltiesPresent => _penaltiesPresent;

  set penaltiesPresent(double? value) {
    _penaltiesPresent = value;
    notifyListeners();
  }

  int? _drySamplerNCtxTrain;

  /// Dry sampler n ctx train
  int? get drySamplerNCtxTrain => _drySamplerNCtxTrain;
  
  set drySamplerNCtxTrain(int? value) {
    _drySamplerNCtxTrain = value;
    notifyListeners();
  }

  double? _drySamplerMultiplier;

  /// Dry sampler multiplier
  double? get drySamplerMultiplier => _drySamplerMultiplier;

  set drySamplerMultiplier(double? value) {
    _drySamplerMultiplier = value;
    notifyListeners();
  }

  double? _drySamplerDryBase;

  /// Dry sampler dry base
  double? get drySamplerDryBase => _drySamplerDryBase;

  set drySamplerDryBase(double? value) {
    _drySamplerDryBase = value;
    notifyListeners();
  }

  int? _drySamplerAllowedLength;

  /// Dry sampler allowed length
  int? get drySamplerAllowedLength => _drySamplerAllowedLength;

  set drySamplerAllowedLength(int? value) {
    _drySamplerAllowedLength = value;
    notifyListeners();
  }

  int? _drySamplerPenaltyLastN;

  /// Dry sampler penalty last N
  int? get drySamplerPenaltyLastN => _drySamplerPenaltyLastN;

  set drySamplerPenaltyLastN(int? value) {
    _drySamplerPenaltyLastN = value;
    notifyListeners();
  }

  List<String>? _drySamplerSequenceBreakers;

  /// Dry sampler sequence breakers
  List<String>? get drySamplerSequenceBreakers => _drySamplerSequenceBreakers;

  set drySamplerSequenceBreakers(List<String>? value) {
    _drySamplerSequenceBreakers = value;
    notifyListeners();
  }

  LlamaParams({
    required File modelFile,
    bool? vocabOnly,
    bool? useMmap,
    bool? useMlock,
    bool? checkTensors,
    int? nCtx,
    int? nBatch,
    int? nUBatch,
    int? nSeqMax,
    int? nThreads,
    int? nThreadsBatch,
    RopeScalingType? ropeScalingType,
    PoolingType? poolingType,
    AttentionType? attentionType,
    double? ropeFrequencyBase,
    double? ropeFrequencyScale,
    double? yarnExtrapolationFactor,
    double? yarnAttenuationFactor,
    double? yarnBetaFast,
    double? yarnBetaSlow,
    int? yarnOriginalContext,
    double? defragmentationThreshold,
    GgmlType? typeK,
    GgmlType? typeV,
    bool? embeddings,
    bool? offloadKqv,
    bool? flashAttention,
    bool? noPerformance,
    bool? greedy,
    bool? infill,
    int? seed,
    int? topK,
    double? topP,
    int? minKeepTopP,
    double? minP,
    int? minKeepMinP,
    double? typicalP,
    int? minKeepTypicalP,
    double? temperature,
    double? temperatureDelta,
    double? temperatureExponent,
    double? xtcP,
    double? xtcT,
    int? minKeepXtc,
    int? xtcSeed,
    int? mirostatNVocab,
    int? mirostatSeed,
    double? mirostatTau,
    double? mirostatEta,
    int? mirostatM,
    int? mirostatV2Seed,
    double? mirostatV2Tau,
    double? mirostatV2Eta,
    String? grammarStr,
    String? grammarRoot,
    int? penaltiesLastN,
    double? penaltiesRepeat,
    double? penaltiesFrequency,
    double? penaltiesPresent,
    int? drySamplerNCtxTrain,
    double? drySamplerMultiplier,
    double? drySamplerDryBase,
    int? drySamplerAllowedLength,
  })  : _modelFile = modelFile,
        _vocabOnly = vocabOnly,
        _useMmap = useMmap,
        _useMlock = useMlock,
        _checkTensors = checkTensors,
        _nCtx = nCtx ?? 0,
        _nBatch = nBatch,
        _nUBatch = nUBatch,
        _nSeqMax = nSeqMax,
        _nThreads = nThreads,
        _nThreadsBatch = nThreadsBatch,
        _ropeScalingType = ropeScalingType,
        _poolingType = poolingType,
        _attentionType = attentionType,
        _ropeFrequencyBase = ropeFrequencyBase,
        _ropeFrequencyScale = ropeFrequencyScale,
        _yarnExtrapolationFactor = yarnExtrapolationFactor,
        _yarnAttenuationFactor = yarnAttenuationFactor,
        _yarnBetaFast = yarnBetaFast,
        _yarnBetaSlow = yarnBetaSlow,
        _yarnOriginalContext = yarnOriginalContext,
        _defragmentationThreshold = defragmentationThreshold,
        _typeK = typeK,
        _typeV = typeV,
        _embeddings = embeddings,
        _offloadKqv = offloadKqv,
        _flashAttention = flashAttention,
        _noPerformance = noPerformance,
        _greedy = greedy ?? false,
        _infill = infill ?? false,
        _seed = seed,
        _topK = topK,
        _topP = topP,
        _minKeepTopP = minKeepTopP,
        _minP = minP,
        _minKeepMinP = minKeepMinP,
        _typicalP = typicalP,
        _minKeepTypicalP = minKeepTypicalP,
        _temperature = temperature,
        _temperatureDelta = temperatureDelta,
        _temperatureExponent = temperatureExponent,
        _xtcP = xtcP,
        _xtcT = xtcT,
        _minKeepXtc = minKeepXtc,
        _xtcSeed = xtcSeed,
        _mirostatNVocab = mirostatNVocab,
        _mirostatSeed = mirostatSeed,
        _mirostatTau = mirostatTau,
        _mirostatEta = mirostatEta,
        _mirostatM = mirostatM,
        _mirostatV2Seed = mirostatV2Seed,
        _mirostatV2Tau = mirostatV2Tau,
        _mirostatV2Eta = mirostatV2Eta,
        _grammarStr = grammarStr,
        _grammarRoot = grammarRoot,
        _penaltiesLastN = penaltiesLastN,
        _penaltiesRepeat = penaltiesRepeat,
        _penaltiesFrequency = penaltiesFrequency,
        _penaltiesPresent = penaltiesPresent,
        _drySamplerNCtxTrain = drySamplerNCtxTrain,
        _drySamplerMultiplier = drySamplerMultiplier,
        _drySamplerDryBase = drySamplerDryBase,
        _drySamplerAllowedLength = drySamplerAllowedLength;

  /// Creates a new instance from a map.
  factory LlamaParams.fromMap(Map<String, dynamic> map) => LlamaParams(
    modelFile: File(map['model_path']),
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

  /// Creates a new instance from a JSON string.
  factory LlamaParams.fromJson(String source) => LlamaParams.fromMap(jsonDecode(source));

  /// Converts the current instance to a map.
  Map<String, dynamic> toMap() => {
    'model_path': modelFile.path,
    'vocab_only': vocabOnly,
    'use_mmap': useMmap,
    'use_mlock': useMlock,
    'check_tensors': checkTensors,
    'n_ctx': nCtx,
    'n_batch': nBatch,
    'n_ubatch': nUBatch,
    'n_seq_max': nSeqMax,
    'n_threads': nThreads,
    'n_threads_batch': nThreadsBatch,
    'rope_scaling_type': ropeScalingType.toString().split('.').last,
    'pooling_type': poolingType.toString().split('.').last,
    'attention_type': attentionType.toString().split('.').last,
    'rope_frequency_base': ropeFrequencyBase,
    'rope_frequency_scale': ropeFrequencyScale,
    'yarn_extrapolation_factor': yarnExtrapolationFactor,
    'yarn_attenuation_factor': yarnAttenuationFactor,
    'yarn_beta_fast': yarnBetaFast,
    'yarn_beta_slow': yarnBetaSlow,
    'yarn_original_context': yarnOriginalContext,
    'defragmentation_threshold': defragmentationThreshold,
    'type_k': typeK.toString().split('.').last,
    'type_v': typeV.toString().split('.').last,
    'embeddings': embeddings,
    'offload_kqv': offloadKqv,
    'flash_attention': flashAttention,
    'no_perf': noPerformance,
    'greedy': _greedy,
    'infill': _infill,
    'seed': _seed,
    'top_k': _topK,
    'top_p': _topP,
    'top_p_min_keep': _minKeepTopP,
    'min_p': _minP,
    'min_p_min_keep': _minKeepMinP,
    'typical_p': _typicalP,
    'typical_p_min_keep': _minKeepTypicalP,
    'temperature': _temperature,
    'temperature_delta': _temperatureDelta,
    'temperature_exponent': _temperatureExponent,
    'xtc_p': _xtcP,
    'xtc_t': _xtcT,
    'xtc_min_keep': _minKeepXtc,
    'xtc_seed': _xtcSeed,
    'mirostat_n_vocab': _mirostatNVocab,
    'mirostat_seed': _mirostatSeed,
    'mirostat_tau': _mirostatTau,
    'mirostat_eta': _mirostatEta,
    'mirostat_m': _mirostatM,
    'mirostat_v2_seed': _mirostatV2Seed,
    'mirostat_v2_tau': _mirostatV2Tau,
    'mirostat_v2_eta': _mirostatV2Eta,
    'grammar_str': _grammarStr,
    'grammar_root': _grammarRoot,
    'penalties_last_n': _penaltiesLastN,
    'penalties_repeat': _penaltiesRepeat,
    'penalties_frequency': _penaltiesFrequency,
    'penalties_present': _penaltiesPresent,
    'dry_sampler_n_ctx_train': _drySamplerNCtxTrain,
    'dry_sampler_multiplier': _drySamplerMultiplier,
    'dry_sampler_dry_base': _drySamplerDryBase,
    'dry_sampler_allowed_length': _drySamplerAllowedLength,
  };

  /// Converts the current instance to a JSON string.
  String toJson() => jsonEncode(toMap());

  /// Retrieves and initializes the model parameters for the llama model.
  ///
  /// This function initializes the model parameters using the default values
  /// provided by the llama library. It then updates the parameters based on
  /// the optional properties `vocabOnly`, `useMmap`, `useMlock`, and `checkTensors`
  /// if they are not null.
  ///
  /// Returns:
  ///   A `llama_model_params` object containing the initialized and updated
  ///   model parameters.
  llama_model_params getModelParams() {
    final llama_model_params modelParams =
        Llama.lib.llama_model_default_params();
    log("Model params initialized");

    if (vocabOnly != null) {
      modelParams.vocab_only = vocabOnly!;
    }

    if (useMmap != null) {
      modelParams.use_mmap = useMmap!;
    }

    if (useMlock != null) {
      modelParams.use_mlock = useMlock!;
    }

    if (checkTensors != null) {
      modelParams.check_tensors = checkTensors!;
    }

    return modelParams;
  }

  /// Returns a configured `llama_context_params` object based on the current instance's properties.
  /// 
  /// This method initializes a `llama_context_params` object with default values and then overrides
  /// those values with the properties of the current instance if they are not null.
  /// 
  /// The following properties are set:
  /// 
  /// - `n_ctx`: The context size.
  /// - `n_batch`: The batch size.
  /// - `n_ubatch`: The unrolled batch size.
  /// - `n_seq_max`: The maximum sequence length.
  /// - `n_threads`: The number of threads.
  /// - `n_threads_batch`: The number of threads for batch processing.
  /// - `rope_scaling_type`: The type of rope scaling, adjusted by subtracting 1 from the enum index.
  /// - `pooling_type`: The type of pooling, adjusted by subtracting 1 from the enum index.
  /// - `attention_type`: The type of attention, adjusted by subtracting 1 from the enum index.
  /// - `rope_freq_base`: The base frequency for rope.
  /// - `rope_freq_scale`: The scaling factor for rope frequency.
  /// - `yarn_ext_factor`: The extrapolation factor for yarn.
  /// - `yarn_attn_factor`: The attenuation factor for yarn.
  /// - `yarn_beta_fast`: The fast beta value for yarn.
  /// - `yarn_beta_slow`: The slow beta value for yarn.
  /// - `yarn_orig_ctx`: The original context for yarn.
  /// - `defrag_thold`: The defragmentation threshold.
  /// - `type_k`: The type K, converted to a C int.
  /// - `type_v`: The type V, converted to a C int.
  /// - `embeddings`: The embeddings.
  /// - `offload_kqv`: The offload KQV flag.
  /// - `flash_attn`: The flash attention flag.
  /// - `no_perf`: The no performance flag.
  /// 
  /// Returns:
  /// - A `llama_context_params` object with the configured properties.
  llama_context_params getContextParams() {
    final llama_context_params contextParams =
        Llama.lib.llama_context_default_params();

    contextParams.n_ctx = nCtx;

    if (nBatch != null) {
      contextParams.n_batch = nBatch!;
    }

    if (nUBatch != null) {
      contextParams.n_ubatch = nUBatch!;
    }

    if (nSeqMax != null) {
      contextParams.n_seq_max = nSeqMax!;
    }

    if (nThreads != null) {
      contextParams.n_threads = nThreads!;
    }

    if (nThreadsBatch != null) {
      contextParams.n_threads_batch = nThreadsBatch!;
    }

    if (ropeScalingType != null) {
      // This enum starts at -1, so we need to subtract 1 from the index
      contextParams.rope_scaling_typeAsInt = ropeScalingType!.index - 1;
    }

    if (poolingType != null) {
      // This enum starts at -1, so we need to subtract 1 from the index
      contextParams.pooling_typeAsInt = poolingType!.index - 1;
    }

    if (attentionType != null) {
      // This enum starts at -1, so we need to subtract 1 from the index
      contextParams.attention_typeAsInt = attentionType!.index - 1;
    }

    if (ropeFrequencyBase != null) {
      contextParams.rope_freq_base = ropeFrequencyBase!;
    }

    if (ropeFrequencyScale != null) {
      contextParams.rope_freq_scale = ropeFrequencyScale!;
    }

    if (yarnExtrapolationFactor != null) {
      contextParams.yarn_ext_factor = yarnExtrapolationFactor!;
    }

    if (yarnAttenuationFactor != null) {
      contextParams.yarn_attn_factor = yarnAttenuationFactor!;
    }

    if (yarnBetaFast != null) {
      contextParams.yarn_beta_fast = yarnBetaFast!;
    }

    if (yarnBetaSlow != null) {
      contextParams.yarn_beta_slow = yarnBetaSlow!;
    }

    if (yarnOriginalContext != null) {
      contextParams.yarn_orig_ctx = yarnOriginalContext!;
    }

    if (defragmentationThreshold != null) {
      contextParams.defrag_thold = defragmentationThreshold!;
    }

    if (typeK != null) {
      // It may seem redundant to multiply by 1, but it's necessary to convert to a C int
      contextParams.type_kAsInt = typeK!.index * 1;
    }

    if (typeV != null) {
      // It may seem redundant to multiply by 1, but it's necessary to convert to a C int
      contextParams.type_vAsInt = typeV!.index * 1;
    }

    if (embeddings != null) {
      contextParams.embeddings = embeddings!;
    }

    if (offloadKqv != null) {
      contextParams.offload_kqv = offloadKqv!;
    }

    if (flashAttention != null) {
      contextParams.flash_attn = flashAttention!;
    }

    if (noPerformance != null) {
      contextParams.no_perf = noPerformance!;
    }

    return contextParams;
  }

  /// Initializes and returns a pointer to a `llama_sampler` with the specified parameters.
  ///
  /// This method creates a sampler chain and adds various samplers to it based on the provided
  /// parameters. The samplers are added in the following order:
  ///
  /// 1. Greedy sampler (if `greedy` is true).
  /// 2. Infill sampler (if `_infill` is true, requires `vocab` to be non-null).
  /// 3. Distribution sampler (if `_seed` is not null).
  /// 4. Top-K sampler (if `_topK` is not null).
  /// 5. Top-P sampler (if both `_topP` and `_minKeepTopP` are not null).
  /// 6. Min-P sampler (if both `_minP` and `_minKeepMinP` are not null).
  /// 7. Typical sampler (if both `_typicalP` and `_minKeepTypicalP` are not null).
  /// 8. Temperature sampler (if `_temperature` is not null, with optional delta and exponent).
  /// 9. XTC sampler (if `_xtcP`, `_xtcT`, `_minKeepXtc`, and `_xtcSeed` are all not null).
  /// 10. Mirostat sampler (if `_mirostatNVocab`, `_mirostatSeed`, `_mirostatTau`, `_mirostatEta`, and `_mirostatM` are all not null).
  /// 11. Mirostat V2 sampler (if `_mirostatV2Seed`, `_mirostatV2Tau`, and `_mirostatV2Eta` are all not null).
  /// 12. Grammar sampler (if `_grammarStr` and `_grammarRoot` are not null, requires `vocab` to be non-null).
  /// 13. Penalties sampler (if `_penaltiesLastN`, `_penaltiesRepeat`, `_penaltiesFrequency`, and `_penaltiesPresent` are all not null).
  /// 14. Dry sampler (if `_drySamplerSequenceBreakers`, `_drySamplerNCtxTrain`, `_drySamplerMultiplier`, `_drySamplerDryBase`, and `_drySamplerAllowedLength` are all not null, requires `vocab` to be non-null).
  ///
  /// Parameters:
  /// - [vocab] (optional): A pointer to a `llama_vocab` required for certain samplers.
  ///
  /// Returns:
  /// - A pointer to the initialized `llama_sampler`.
  ///
  /// Throws:
  /// - `LlamaException` if `vocab` is required but not provided.
  ffi.Pointer<llama_sampler> getSampler([ffi.Pointer<llama_vocab>? vocab]) {
    final sampler = Llama.lib.llama_sampler_chain_init(
        Llama.lib.llama_sampler_chain_default_params());

    if (greedy) {
      Llama.lib.llama_sampler_chain_add(
          sampler, Llama.lib.llama_sampler_init_greedy());
    }

    if (_infill) {
      assert(vocab != null, LlamaException('Vocabulary is required for infill'));
      Llama.lib.llama_sampler_chain_add(
          sampler, Llama.lib.llama_sampler_init_infill(vocab!));
    }

    if (_seed != null) {
      Llama.lib.llama_sampler_chain_add(
          sampler, Llama.lib.llama_sampler_init_dist(_seed!));
    }

    if (_topK != null) {
      Llama.lib.llama_sampler_chain_add(
          sampler, Llama.lib.llama_sampler_init_top_k(_topK!));
    }

    if (_topP != null && _minKeepTopP != null) {
      Llama.lib.llama_sampler_chain_add(
          sampler, Llama.lib.llama_sampler_init_top_p(_topP!, _minKeepTopP!));
    }

    if (_minP != null && _minKeepMinP != null) {
      Llama.lib.llama_sampler_chain_add(
          sampler, Llama.lib.llama_sampler_init_min_p(_minP!, _minKeepMinP!));
    }

    if (_typicalP != null && _minKeepTypicalP != null) {
      Llama.lib.llama_sampler_chain_add(sampler,
          Llama.lib.llama_sampler_init_typical(_typicalP!, _minKeepTypicalP!));
    }

    if (_temperature != null) {
      if (_temperatureDelta == null || _temperatureExponent == null) {
        Llama.lib.llama_sampler_chain_add(sampler,
            Llama.lib.llama_sampler_init_temp(_temperature!));
      } else {
        Llama.lib.llama_sampler_chain_add(
            sampler,
            Llama.lib.llama_sampler_init_temp_ext(_temperature!,
                _temperatureDelta!, _temperatureExponent!));
      }
    }

    if (_xtcP != null &&
        _xtcT != null &&
        _minKeepXtc != null &&
        _xtcSeed != null) {
      Llama.lib.llama_sampler_chain_add(
          sampler,
          Llama.lib
              .llama_sampler_init_xtc(_xtcP!, _xtcT!, _minKeepXtc!, _xtcSeed!));
    }

    if (_mirostatNVocab != null &&
        _mirostatSeed != null &&
        _mirostatTau != null &&
        _mirostatEta != null &&
        _mirostatM != null) {
      Llama.lib.llama_sampler_chain_add(
          sampler,
          Llama.lib.llama_sampler_init_mirostat(_mirostatNVocab!,
              _mirostatSeed!, _mirostatTau!, _mirostatEta!, _mirostatM!));
    }

    if (_mirostatV2Seed != null &&
        _mirostatV2Tau != null &&
        _mirostatV2Eta != null) {
      Llama.lib.llama_sampler_chain_add(
          sampler,
          Llama.lib.llama_sampler_init_mirostat_v2(
              _mirostatV2Seed!, _mirostatV2Tau!, _mirostatV2Eta!));
    }

    if (_grammarStr != null && _grammarRoot != null) {
      assert(vocab != null, LlamaException('Vocabulary is required for grammar'));
      Llama.lib.llama_sampler_chain_add(
          sampler,
          Llama.lib.llama_sampler_init_grammar(
              vocab!,
              _grammarStr!.toNativeUtf8().cast<ffi.Char>(),
              _grammarRoot!.toNativeUtf8().cast<ffi.Char>()));
    }

    if (_penaltiesLastN != null &&
        _penaltiesRepeat != null &&
        _penaltiesFrequency != null &&
        _penaltiesPresent != null) {
      Llama.lib.llama_sampler_chain_add(
          sampler,
          Llama.lib.llama_sampler_init_penalties(_penaltiesLastN!,
              _penaltiesRepeat!, _penaltiesFrequency!, _penaltiesPresent!));
    }

    if (_drySamplerSequenceBreakers != null &&
        _drySamplerNCtxTrain != null &&
        _drySamplerMultiplier != null &&
        _drySamplerDryBase != null &&
        _drySamplerAllowedLength != null) {
      assert(vocab != null, LlamaException('Vocabulary is required for dry sampler'));
      final sequenceBreakers =
          calloc<ffi.Pointer<ffi.Char>>(_drySamplerSequenceBreakers!.length);
      for (var i = 0; i < _drySamplerSequenceBreakers!.length; i++) {
        sequenceBreakers[i] =
            _drySamplerSequenceBreakers![i].toNativeUtf8().cast<ffi.Char>();
      }

      Llama.lib.llama_sampler_chain_add(
          sampler,
          Llama.lib.llama_sampler_init_dry(
              vocab!,
              _drySamplerNCtxTrain!,
              _drySamplerMultiplier!,
              _drySamplerDryBase!,
              _drySamplerAllowedLength!,
              _drySamplerPenaltyLastN!,
              sequenceBreakers,
              _drySamplerSequenceBreakers!.length));
    }

    return sampler;
  }
}

/// Enum representing different types of rope scaling.
///
/// The available types are:
/// - `unspecified`: Default value when the type is not specified.
/// - `none`: No scaling applied.
/// - `linear`: Linear scaling.
/// - `yarn`: Yarn scaling.
/// - `longrope`: Long rope scaling.
///
/// Provides a method to convert a string value to the corresponding
/// `RopeScalingType` enum value.
enum RopeScalingType {
  /// Default value when the type is not specified.
  unspecified,

  /// No scaling applied.
  none,

  /// Linear scaling.
  linear,

  /// Yarn scaling.
  yarn,

  /// Long rope scaling.
  longrope;

  /// Converts a string value to the corresponding `RopeScalingType` enum value.
  static RopeScalingType fromString(String value) {
    switch (value) {
      case 'none':
        return RopeScalingType.none;
      case 'linear':
        return RopeScalingType.linear;
      case 'yarn':
        return RopeScalingType.yarn;
      case 'longrope':
        return RopeScalingType.longrope;
      default:
        return RopeScalingType.unspecified;
    }
  }
}

/// Enum representing different types of pooling operations.
///
/// The available pooling types are:
/// - `unspecified`: Default value when no pooling type is specified.
/// - `none`: No pooling operation.
/// - `mean`: Mean pooling operation.
/// - `cls`: CLS token pooling operation.
/// - `last`: Last token pooling operation.
/// - `rank`: Rank pooling operation.
///
/// The `fromString` method converts a string value to the corresponding
/// `PoolingType` enum value. If the string does not match any known pooling
/// type, it returns `PoolingType.unspecified`.
enum PoolingType {
  /// Default value when no pooling type is specified.
  unspecified,

  /// No pooling operation.
  none,

  /// Mean pooling operation.
  mean,

  /// CLS token pooling operation.
  cls,

  /// Last token pooling operation.
  last,

  /// Rank pooling operation.
  rank;

  /// Converts a string value to the corresponding `PoolingType` enum value.
  static PoolingType fromString(String value) {
    switch (value) {
      case 'none':
        return PoolingType.none;
      case 'mean':
        return PoolingType.mean;
      case 'cls':
        return PoolingType.cls;
      case 'last':
        return PoolingType.last;
      case 'rank':
        return PoolingType.rank;
      default:
        return PoolingType.unspecified;
    }
  }
}

/// Enum representing different types of attention mechanisms.
///
/// - `unspecified`: Default value when the attention type is not specified.
/// - `causal`: Represents causal attention.
/// - `nonCausal`: Represents non-causal attention.
///
/// Provides a method to convert a string representation to an `AttentionType` enum value.
enum AttentionType {
  /// Default value when the attention type is not specified.
  unspecified,

  /// Causal attention.
  causal,

  /// Non-causal attention.
  nonCausal;

  /// Converts a string value to the corresponding `AttentionType` enum value.
  static AttentionType fromString(String value) {
    switch (value) {
      case 'causal':
        return AttentionType.causal;
      case 'non-causal':
        return AttentionType.nonCausal;
      default:
        return AttentionType.unspecified;
    }
  }
}

/// Enum representing different GGML (General Graphical Modeling Language) types.
///
/// Each type corresponds to a specific data format or quantization level used in GGML.
///
/// The available types are:
/// - `f32`: 32-bit floating point
/// - `f16`: 16-bit floating point
/// - `q4_0`, `q4_1`, `q4_2`, `q4_3`: 4-bit quantization levels
/// - `q5_0`, `q5_1`: 5-bit quantization levels
/// - `q8_0`, `q8_1`: 8-bit quantization levels
/// - `q2_k`, `q3_k`, `q4_k`, `q5_k`, `q6_k`, `q8_k`: Various quantization levels with different bit depths
/// - `iq2_xxs`, `iq2_xs`, `iq3_xxs`, `iq1_s`, `iq4_nl`, `iq3_s`, `iq2_s`, `iq4_xs`: Integer quantization levels with different bit depths and suffixes
/// - `i8`, `i16`, `i32`, `i64`: Integer types with different bit depths
/// - `f64`: 64-bit floating point
/// - `iq1_m`: Integer quantization with a specific suffix
/// - `bf16`: Brain floating point 16-bit
/// - `q4_0_4_4`, `q4_0_4_8`, `q4_0_8_8`: Mixed quantization levels
/// - `tq1_0`, `tq2_0`: Tensor quantization levels
///
/// The `fromString` method allows converting a string representation of a GGML type to its corresponding enum value.
enum GgmlType {
  /// 32-bit floating point
  f32,

  /// 16-bit floating point
  f16,

  /// 4-bit quantization level 0
  q4_0,

  /// 4-bit quantization level 1
  q4_1,

  /// 4-bit quantization level 2
  q4_2,

  /// 4-bit quantization level 3
  q4_3,

  /// 5-bit quantization level 0
  q5_0,

  /// 5-bit quantization level 1
  q5_1,

  /// 8-bit quantization level 0
  q8_0,

  /// 8-bit quantization level 1
  q8_1,

  /// 2-bit quantization level for keys
  q2_k,

  /// 3-bit quantization level for keys
  q3_k,

  /// 4-bit quantization level for keys
  q4_k,

  /// 5-bit quantization level for keys
  q5_k,

  /// 6-bit quantization level for keys
  q6_k,

  /// 8-bit quantization level for keys
  q8_k,

  /// Integer quantization level 2 xxs
  iq2_xxs,

  /// Integer quantization level 2 xs
  iq2_xs,

  /// Integer quantization level 3 xxs
  iq3_xxs,

  /// Integer quantization level 1 s
  iq1_s,

  /// Integer quantization level 4 nl
  iq4_nl,

  /// Integer quantization level 3 s
  iq3_s,

  /// Integer quantization level 2 s
  iq2_s,

  /// Integer quantization level 4 xs
  iq4_xs,

  /// 8-bit integer
  i8,

  /// 16-bit integer
  i16,

  /// 32-bit integer
  i32,

  /// 64-bit integer
  i64,

  /// 64-bit floating point
  f64,

  /// Integer quantization level 1 m
  iq1_m,

  /// Brain floating point 16-bit
  bf16,

  /// Mixed quantization level 4-4
  q4_0_4_4,

  /// Mixed quantization level 4-8
  q4_0_4_8,

  /// Mixed quantization level 8-8
  q4_0_8_8,

  /// Tensor quantization level 1
  tq1_0,

  /// Tensor quantization level 2
  tq2_0;

  /// Converts a string value to the corresponding `GgmlType` enum value.
  static GgmlType fromString(String value) {
    switch (value) {
      case 'f32':
        return GgmlType.f32;
      case 'f16':
        return GgmlType.f16;
      case 'q4_0':
        return GgmlType.q4_0;
      case 'q4_1':
        return GgmlType.q4_1;
      case 'q4_2':
        return GgmlType.q4_2;
      case 'q4_3':
        return GgmlType.q4_3;
      case 'q5_0':
        return GgmlType.q5_0;
      case 'q5_1':
        return GgmlType.q5_1;
      case 'q8_0':
        return GgmlType.q8_0;
      case 'q8_1':
        return GgmlType.q8_1;
      case 'q2_k':
        return GgmlType.q2_k;
      case 'q3_k':
        return GgmlType.q3_k;
      case 'q4_k':
        return GgmlType.q4_k;
      case 'q5_k':
        return GgmlType.q5_k;
      case 'q6_k':
        return GgmlType.q6_k;
      case 'q8_k':
        return GgmlType.q8_k;
      case 'iq2_xxs':
        return GgmlType.iq2_xxs;
      case 'iq2_xs':
        return GgmlType.iq2_xs;
      case 'iq3_xxs':
        return GgmlType.iq3_xxs;
      case 'iq1_s':
        return GgmlType.iq1_s;
      case 'iq4_nl':
        return GgmlType.iq4_nl;
      case 'iq3_s':
        return GgmlType.iq3_s;
      case 'iq2_s':
        return GgmlType.iq2_s;
      case 'iq4_xs':
        return GgmlType.iq4_xs;
      case 'i8':
        return GgmlType.i8;
      case 'i16':
        return GgmlType.i16;
      case 'i32':
        return GgmlType.i32;
      case 'i64':
        return GgmlType.i64;
      case 'f64':
        return GgmlType.f64;
      case 'iq1_m':
        return GgmlType.iq1_m;
      case 'bf16':
        return GgmlType.bf16;
      case 'q4_0_4_4':
        return GgmlType.q4_0_4_4;
      case 'q4_0_4_8':
        return GgmlType.q4_0_4_8;
      case 'q4_0_8_8':
        return GgmlType.q4_0_8_8;
      case 'tq1_0':
        return GgmlType.tq1_0;
      case 'tq2_0':
        return GgmlType.tq2_0;
      default:
        return GgmlType.f32;
    }
  }
}