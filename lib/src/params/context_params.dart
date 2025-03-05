// ignore_for_file: constant_identifier_names
part of 'package:lcpp/lcpp.dart';

/// A class representing the parameters for context configuration.
class ContextParams extends ChangeNotifier {
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

  /// A class representing the parameters for context configuration.
  ///
  /// The parameters include various settings for context size, batch size,
  /// threading, scaling, pooling, attention, and other advanced configurations.
  ///
  /// - `nCtx`: The context size.
  /// - `nBatch`: The batch size.
  /// - `nUBatch`: The unrolled batch size.
  /// - `nSeqMax`: The maximum sequence length.
  /// - `nThreads`: The number of threads.
  /// - `nThreadsBatch`: The number of threads for batch processing.
  /// - `ropeScalingType`: The type of scaling for ROPE (Rotary Position Embedding).
  /// - `poolingType`: The type of pooling to be used.
  /// - `attentionType`: The type of attention mechanism to be used.
  /// - `ropeFrequencyBase`: The base frequency for ROPE.
  /// - `ropeFrequencyScale`: The scaling factor for ROPE frequency.
  /// - `yarnExtrapolationFactor`: The extrapolation factor for YARN.
  /// - `yarnAttenuationFactor`: The attenuation factor for YARN.
  /// - `yarnBetaFast`: The fast beta parameter for YARN.
  /// - `yarnBetaSlow`: The slow beta parameter for YARN.
  /// - `yarnOriginalContext`: The original context for YARN.
  /// - `defragmentationThreshold`: The threshold for defragmentation.
  /// - `typeK`: The type of key embeddings.
  /// - `typeV`: The type of value embeddings.
  /// - `embeddings`: The embeddings to be used.
  /// - `offloadKqv`: Whether to offload KQV (Key, Query, Value) computations.
  /// - `flashAttention`: Whether to use flash attention.
  /// - `noPerformance`: Whether to disable performance optimizations.
  ContextParams({
    int nCtx = 0,
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
  })  : _nCtx = nCtx,
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
        _noPerformance = noPerformance;

  /// Creates a new instance of [ContextParams] from a map.
  ///
  /// The [map] parameter should contain the following keys:
  /// - `n_ctx`: The context size.
  /// - `n_batch`: The batch size.
  /// - `n_ubatch`: The unrolled batch size.
  /// - `n_seq_max`: The maximum sequence length.
  /// - `n_threads`: The number of threads.
  /// - `n_threads_batch`: The number of threads for batch processing.
  /// - `rope_scaling_type`: The type of scaling for ROPE (Rotary Position Embedding).
  /// - `pooling_type`: The type of pooling to be used.
  /// - `attention_type`: The type of attention mechanism to be used.
  /// - `rope_frequency_base`: The base frequency for ROPE.
  /// - `rope_frequency_scale`: The scaling factor for ROPE frequency.
  /// - `yarn_ext_factor`: The extrapolation factor for YARN.
  /// - `yarn_attn_factor`: The attenuation factor for YARN.
  /// - `yarn_beta_fast`: The fast beta parameter for YARN.
  /// - `yarn_beta_slow`: The slow beta parameter for YARN.
  /// - `yarn_orig_ctx`: The original context for YARN.
  /// - `defrag_thold`: The threshold for defragmentation.
  /// - `type_k`: The type of key embeddings.
  /// - `type_v`: The type of value embeddings.
  /// - `embeddings`: The embeddings to be used.
  /// - `offload_kqv`: Whether to offload KQV (Key, Query, Value) computations.
  /// - `flash_attn`: Whether to use flash attention.
  /// - `no_perf`: Whether to disable performance optimizations.
  factory ContextParams.fromMap(Map<String, dynamic> map) => ContextParams(
        nCtx: map['n_ctx'] ?? 0,
        nBatch: map['n_batch'],
        nUBatch: map['n_ubatch'],
        nSeqMax: map['n_seq_max'],
        nThreads: map['n_threads'],
        nThreadsBatch: map['n_threads_batch'],
        ropeScalingType: map['rope_scaling_type'] != null
            ? RopeScalingType.fromString(map['rope_scaling_type'])
            : null,
        poolingType: map['pooling_type'] != null
            ? PoolingType.fromString(map['pooling_type'])
            : null,
        attentionType: map['attention_type'] != null
            ? AttentionType.fromString(map['attention_type'])
            : null,
        ropeFrequencyBase: map['rope_frequency_base'],
        ropeFrequencyScale: map['rope_frequency_scale'],
        yarnExtrapolationFactor: map['yarn_ext_factor'],
        yarnAttenuationFactor: map['yarn_attn_factor'],
        yarnBetaFast: map['yarn_beta_fast'],
        yarnBetaSlow: map['yarn_beta_slow'],
        yarnOriginalContext: map['yarn_orig_ctx'],
        defragmentationThreshold: map['defrag_thold'],
        typeK:
            map['type_k'] != null ? GgmlType.fromString(map['type_k']) : null,
        typeV:
            map['type_v'] != null ? GgmlType.fromString(map['type_v']) : null,
        embeddings: map['embeddings'],
        offloadKqv: map['offload_kqv'],
        flashAttention: map['flash_attn'],
        noPerformance: map['no_perf'],
      );

  /// Creates an instance of [ContextParams] from a JSON string.
  ///
  /// The [source] parameter is a JSON-encoded string representation of the
  /// context parameters.
  ///
  /// Returns an instance of [ContextParams] created from the decoded JSON map.
  factory ContextParams.fromJson(String source) =>
      ContextParams.fromMap(jsonDecode(source));

  /// Creates a [ContextParams] instance from a native [llama_context_params] object.
  ///
  /// The [params] parameter is a native structure containing various context parameters.
  ///
  /// The following fields are mapped from the native structure:
  /// - [nCtx]: Number of contexts.
  /// - [nBatch]: Number of batches.
  /// - [nUBatch]: Number of micro-batches.
  /// - [nSeqMax]: Maximum sequence length.
  /// - [nThreads]: Number of threads.
  /// - [nThreadsBatch]: Number of threads per batch.
  /// - [ropeScalingType]: Type of rope scaling, if applicable.
  /// - [poolingType]: Type of pooling, if applicable.
  /// - [attentionType]: Type of attention, if applicable.
  /// - [ropeFrequencyBase]: Base frequency for rope.
  /// - [ropeFrequencyScale]: Scaling factor for rope frequency.
  /// - [yarnExtrapolationFactor]: Extrapolation factor for yarn.
  /// - [yarnAttenuationFactor]: Attenuation factor for yarn.
  /// - [yarnBetaFast]: Beta fast parameter for yarn.
  /// - [yarnBetaSlow]: Beta slow parameter for yarn.
  /// - [yarnOriginalContext]: Original context for yarn.
  /// - [defragmentationThreshold]: Threshold for defragmentation.
  /// - [typeK]: Type K, if applicable.
  /// - [typeV]: Type V, if applicable.
  /// - [embeddings]: Embeddings.
  /// - [offloadKqv]: Offload KQV flag.
  /// - [flashAttention]: Flash attention flag.
  /// - [noPerformance]: No performance flag.
  factory ContextParams.fromNative(llama_context_params params) {
    return ContextParams(
      nCtx: params.n_ctx,
      nBatch: params.n_batch,
      nUBatch: params.n_ubatch,
      nSeqMax: params.n_seq_max,
      nThreads: params.n_threads,
      nThreadsBatch: params.n_threads_batch,
      ropeScalingType: params.rope_scaling_typeAsInt != -1
          ? RopeScalingType.values[params.rope_scaling_typeAsInt + 1]
          : null,
      poolingType: params.pooling_typeAsInt != -1
          ? PoolingType.values[params.pooling_typeAsInt + 1]
          : null,
      attentionType: params.attention_typeAsInt != -1
          ? AttentionType.values[params.attention_typeAsInt + 1]
          : null,
      ropeFrequencyBase: params.rope_freq_base,
      ropeFrequencyScale: params.rope_freq_scale,
      yarnExtrapolationFactor: params.yarn_ext_factor,
      yarnAttenuationFactor: params.yarn_attn_factor,
      yarnBetaFast: params.yarn_beta_fast,
      yarnBetaSlow: params.yarn_beta_slow,
      yarnOriginalContext: params.yarn_orig_ctx,
      defragmentationThreshold: params.defrag_thold,
      typeK:
          params.type_kAsInt != -1 ? GgmlType.values[params.type_kAsInt] : null,
      typeV:
          params.type_vAsInt != -1 ? GgmlType.values[params.type_vAsInt] : null,
      embeddings: params.embeddings,
      offloadKqv: params.offload_kqv,
      flashAttention: params.flash_attn,
      noPerformance: params.no_perf,
    );
  }

  /// Factory constructor that creates an instance of [ContextParams] with default parameters.
  ///
  /// This constructor uses the `llama_context_default_params` function from the
  /// Llama library to obtain the default context parameters and then converts
  /// them to a [ContextParams] instance using the [ContextParams.fromNative] method.
  factory ContextParams.defaultParams() {
    final llama_context_params contextParams =
        _LlamaBase.lib.llama_context_default_params();

    return ContextParams.fromNative(contextParams);
  }

  /// Converts the current instance to a native `llama_context_params` object.
  ///
  /// This method initializes a `llama_context_params` object with default values
  /// and then updates its fields based on the current instance's properties if they are not null.
  ///
  /// The following fields are set if they are not null:
  /// - `nCtx`: Sets the `n_ctx` field.
  /// - `nBatch`: Sets the `n_batch` field.
  /// - `nUBatch`: Sets the `n_ubatch` field.
  /// - `nSeqMax`: Sets the `n_seq_max` field.
  /// - `nThreads`: Sets the `n_threads` field.
  /// - `nThreadsBatch`: Sets the `n_threads_batch` field.
  /// - `ropeScalingType`: Sets the `rope_scaling_typeAsInt` field (enum index - 1).
  /// - `poolingType`: Sets the `pooling_typeAsInt` field (enum index - 1).
  /// - `attentionType`: Sets the `attention_typeAsInt` field (enum index - 1).
  /// - `ropeFrequencyBase`: Sets the `rope_freq_base` field.
  /// - `ropeFrequencyScale`: Sets the `rope_freq_scale` field.
  /// - `yarnExtrapolationFactor`: Sets the `yarn_ext_factor` field.
  /// - `yarnAttenuationFactor`: Sets the `yarn_attn_factor` field.
  /// - `yarnBetaFast`: Sets the `yarn_beta_fast` field.
  /// - `yarnBetaSlow`: Sets the `yarn_beta_slow` field.
  /// - `yarnOriginalContext`: Sets the `yarn_orig_ctx` field.
  /// - `defragmentationThreshold`: Sets the `defrag_thold` field.
  /// - `typeK`: Sets the `type_kAsInt` field (enum index * 1).
  /// - `typeV`: Sets the `type_vAsInt` field (enum index * 1).
  /// - `embeddings`: Sets the `embeddings` field.
  /// - `offloadKqv`: Sets the `offload_kqv` field.
  /// - `flashAttention`: Sets the `flash_attn` field.
  /// - `noPerformance`: Sets the `no_perf` field.
  ///
  /// Returns:
  /// - A `llama_context_params` object with the updated fields.
  llama_context_params toNative() {
    final llama_context_params contextParams =
        _LlamaBase.lib.llama_context_default_params();

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

  /// Converts the context parameters to a map.
  ///
  /// The map contains the following key-value pairs:
  /// - `n_ctx`: The context size.
  /// - `n_batch`: The batch size.
  /// - `n_ubatch`: The unrolled batch size.
  /// - `n_seq_max`: The maximum sequence length.
  /// - `n_threads`: The number of threads.
  /// - `n_threads_batch`: The number of threads for batch processing.
  /// - `rope_scaling_type`: The type of scaling for ROPE (Rotary Position Embedding).
  /// - `pooling_type`: The type of pooling to be used.
  /// - `attention_type`: The type of attention mechanism to be used.
  /// - `rope_frequency_base`: The base frequency for ROPE.
  /// - `rope_frequency_scale`: The scaling factor for ROPE frequency.
  /// - `yarn_ext_factor`: The extrapolation factor for YARN.
  /// - `yarn_attn_factor`: The attenuation factor for YARN.
  /// - `yarn_beta_fast`: The fast beta parameter for YARN.
  /// - `yarn_beta_slow`: The slow beta parameter for YARN.
  /// - `yarn_orig_ctx`: The original context for YARN.
  /// - `defrag_thold`: The threshold for defragmentation.
  /// - `type_k`: The type of key embeddings.
  /// - `type_v`: The type of value embeddings.
  /// - `embeddings`: The embeddings to be used.
  /// - `offload_kqv`: Whether to offload KQV (Key, Query, Value) computations.
  /// - `flash_attn`: Whether to use flash attention.
  /// - `no_perf`: Whether to disable performance optimizations.
  Map<String, dynamic> toMap() => {
        'n_ctx': nCtx,
        'n_batch': nBatch,
        'n_ubatch': nUBatch,
        'n_seq_max': nSeqMax,
        'n_threads': nThreads,
        'n_threads_batch': nThreadsBatch,
        'rope_scaling_type': ropeScalingType?.toString().split('.').last,
        'pooling_type': poolingType?.toString().split('.').last,
        'attention_type': attentionType?.toString().split('.').last,
        'rope_frequency_base': ropeFrequencyBase,
        'rope_frequency_scale': ropeFrequencyScale,
        'yarn_ext_factor': yarnExtrapolationFactor,
        'yarn_attn_factor': yarnAttenuationFactor,
        'yarn_beta_fast': yarnBetaFast,
        'yarn_beta_slow': yarnBetaSlow,
        'yarn_orig_ctx': yarnOriginalContext,
        'defrag_thold': defragmentationThreshold,
        'type_k': typeK?.toString().split('.').last,
        'type_v': typeV?.toString().split('.').last,
        'embeddings': embeddings,
        'offload_kqv': offloadKqv,
        'flash_attn': flashAttention,
        'no_perf': noPerformance,
      };

  /// Converts the current object to a JSON string representation.
  ///
  /// This method uses the `toMap` method to first convert the object to a
  /// map, and then encodes the map to a JSON string using `jsonEncode`.
  ///
  /// Returns:
  ///   A JSON string representation of the current object.
  String toJson() => jsonEncode(toMap());
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
