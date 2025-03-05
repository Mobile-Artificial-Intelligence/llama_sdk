part of 'package:lcpp/lcpp.dart';

/// Arguments for Top-P sampling.
class TopPArguments {
  /// The probability threshold for Top-P sampling.
  final double p;

  /// The minimum number of items to keep in the sample.
  final int minKeep;

  /// Creates a new instance of [TopPArguments].
  const TopPArguments({
    required this.p,
    required this.minKeep,
  });

  /// Constructs a [TopPArguments] instance from a [Map].
  factory TopPArguments.fromMap(Map<String, dynamic> map) => TopPArguments(
        p: map['p'],
        minKeep: map['min_keep'],
      );

  /// Converts this instance to a [Map].
  Map<String, dynamic> toMap() => {
        'p': p,
        'min_keep': minKeep,
      };
}

/// Arguments for Minimum Probability sampling.
class MinPArguments {
  /// The probability threshold for Minimum Probability sampling.
  final double p;

  /// The minimum number of items to keep in the sample.
  final int minKeep;

  /// Creates a new instance of [MinPArguments].
  const MinPArguments({
    required this.p,
    required this.minKeep,
  });

  /// Constructs a [MinPArguments] instance from a [Map].
  factory MinPArguments.fromMap(Map<String, dynamic> map) => MinPArguments(
        p: map['p'],
        minKeep: map['min_keep'],
      );

  /// Converts this instance to a [Map].
  Map<String, dynamic> toMap() => {
        'p': p,
        'min_keep': minKeep,
      };
}

/// Arguments for Typical-P sampling.
class TypicalPArguments {
  /// The probability threshold for Typical-P sampling.
  final double p;

  /// The minimum number of items to keep in the sample.
  final int minKeep;

  /// Creates a new instance of [TypicalPArguments].
  const TypicalPArguments({
    required this.p,
    required this.minKeep,
  });

  /// Constructs a [TypicalPArguments] instance from a [Map].
  factory TypicalPArguments.fromMap(Map<String, dynamic> map) =>
      TypicalPArguments(
        p: map['p'],
        minKeep: map['min_keep'],
      );

  /// Converts this instance to a [Map].
  Map<String, dynamic> toMap() => {
        'p': p,
        'min_keep': minKeep,
      };

  /// Adds this configuration to the sampler.
  void add(ffi.Pointer<llama_sampler> sampler) {
    _LlamaBase.lib.llama_sampler_chain_add(
      sampler,
      _LlamaBase.lib.llama_sampler_init_typical(p, minKeep),
    );
  }
}

/// Arguments for temperature-based sampling.
class TemperatureArguments {
  /// The temperature value for sampling.
  final double temperature;

  /// Optional delta parameter for temperature adjustment.
  final double? delta;

  /// Optional exponent parameter for temperature adjustment.
  final double? exponent;

  /// Creates a new instance of [TemperatureArguments].
  const TemperatureArguments({
    required this.temperature,
    this.delta,
    this.exponent,
  });

  /// Constructs a [TemperatureArguments] instance from a [Map].
  factory TemperatureArguments.fromMap(Map<String, dynamic> map) =>
      TemperatureArguments(
        temperature: map['temperature'],
        delta: map['delta'],
        exponent: map['exponent'],
      );

  /// Converts this instance to a [Map].
  Map<String, dynamic> toMap() => {
        'temperature': temperature,
        'delta': delta,
        'exponent': exponent,
      };
}

/// Arguments for XTC sampling.
class XtcArguments {
  /// The probability threshold for XTC sampling.
  final double p;

  /// The temperature value for XTC sampling.
  final double t;

  /// The minimum number of items to keep in the sample.
  final int minKeep;

  /// The random seed value.
  final int seed;

  /// Creates a new instance of [XtcArguments].
  const XtcArguments({
    required this.p,
    required this.t,
    required this.minKeep,
    required this.seed,
  });

  /// Constructs an [XtcArguments] instance from a [Map].
  factory XtcArguments.fromMap(Map<String, dynamic> map) => XtcArguments(
        p: map['p'],
        t: map['t'],
        minKeep: map['min_keep'],
        seed: map['seed'],
      );

  /// Converts this instance to a [Map].
  Map<String, dynamic> toMap() => {
        'p': p,
        't': t,
        'min_keep': minKeep,
        'seed': seed,
      };
}

/// Arguments for Mirostat sampling.
class MirostatArguments {
  /// The number of vocabulary items.
  final int nVocab;

  /// The random seed value.
  final int seed;

  /// The tau value for Mirostat sampling.
  final double tau;

  /// The eta value for Mirostat sampling.
  final double eta;

  /// The number of items to keep in the sample.
  final int m;

  /// Creates a new instance of [MirostatArguments].
  const MirostatArguments(
      {required this.nVocab,
      required this.seed,
      required this.tau,
      required this.eta,
      required this.m});

  /// Constructs a [MirostatArguments] instance from a [Map].
  factory MirostatArguments.fromMap(Map<String, dynamic> map) =>
      MirostatArguments(
          nVocab: map['n_vocab'],
          seed: map['seed'],
          tau: map['tau'],
          eta: map['eta'],
          m: map['m']);

  /// Converts this instance to a [Map].
  Map<String, dynamic> toMap() =>
      {'n_vocab': nVocab, 'seed': seed, 'tau': tau, 'eta': eta, 'm': m};
}

/// Arguments for Mirostat version 2 sampling.
class MirostatV2Arguments {
  /// The random seed value.
  final int seed;

  /// The tau value for Mirostat sampling.
  final double tau;

  /// The eta value for Mirostat sampling.
  final double eta;

  /// Creates a new instance of [MirostatV2Arguments].
  const MirostatV2Arguments(
      {required this.seed, required this.tau, required this.eta});

  /// Constructs a [MirostatV2Arguments] instance from a [Map].
  factory MirostatV2Arguments.fromMap(Map<String, dynamic> map) =>
      MirostatV2Arguments(seed: map['seed'], tau: map['tau'], eta: map['eta']);

  /// Converts this instance to a [Map].
  Map<String, dynamic> toMap() => {'seed': seed, 'tau': tau, 'eta': eta};
}

/// Arguments for grammar-based sampling.
class GrammarArguments {
  /// The grammar rules.
  final String str;

  /// The root node for the grammar.
  final String root;

  /// Creates a new instance of [GrammarArguments].
  const GrammarArguments({required this.str, required this.root});

  /// Constructs a [GrammarArguments] instance from a [Map].
  factory GrammarArguments.fromMap(Map<String, dynamic> map) =>
      GrammarArguments(str: map['str'], root: map['root']);

  /// Converts this instance to a [Map].
  Map<String, dynamic> toMap() => {'str': str, 'root': root};
}

/// Arguments for penalties.
class PenaltiesArguments {
  /// The number of items to consider for the penalty.
  final int lastN;

  /// The penalty for repetition.
  final double repeat;

  /// The penalty frequency.
  final double frequency;

  /// The penalty for present items.
  final double present;

  /// Creates a new instance of [PenaltiesArguments].
  const PenaltiesArguments(
      {required this.lastN,
      required this.repeat,
      required this.frequency,
      required this.present});

  /// Constructs a [PenaltiesArguments] instance from a [Map].
  factory PenaltiesArguments.fromMap(Map<String, dynamic> map) =>
      PenaltiesArguments(
          lastN: map['last_n'],
          repeat: map['repeat'],
          frequency: map['frequency'],
          present: map['present']);

  /// Converts this instance to a [Map].
  Map<String, dynamic> toMap() => {
        'last_n': lastN,
        'repeat': repeat,
        'frequency': frequency,
        'present': present
      };
}

/// Arguments for dry sampling.
class DrySamplerArguments {
  /// The number of training contexts.
  final int nCtxTrain;

  /// The multiplier for the penalty.
  final double multiplier;

  /// The base value for the penalty.
  final double dryBase;

  /// The maximum allowed length for the sequence.
  final int allowedLength;

  /// The penalty for the last N items.
  final int penaltyLastN;

  /// The sequence breakers.
  final List<String> sequenceBreakers;

  /// Creates a new instance of [DrySamplerArguments].
  const DrySamplerArguments(
      {required this.nCtxTrain,
      required this.multiplier,
      required this.dryBase,
      required this.allowedLength,
      required this.penaltyLastN,
      required this.sequenceBreakers});

  /// Constructs a [DrySamplerArguments] instance from a [Map].
  factory DrySamplerArguments.fromMap(Map<String, dynamic> map) =>
      DrySamplerArguments(
          nCtxTrain: map['n_ctx_train'],
          multiplier: map['multiplier'],
          dryBase: map['dryBase'],
          allowedLength: map['allowed_length'],
          penaltyLastN: map['penalty_last_n'],
          sequenceBreakers: List<String>.from(map['sequence_breakers']));

  /// Converts this instance to a [Map].
  Map<String, dynamic> toMap() => {
        'n_ctx_train': nCtxTrain,
        'multiplier': multiplier,
        'dryBase': dryBase,
        'allowed_length': allowedLength,
        'penalty_last_n': penaltyLastN,
        'sequence_breakers': sequenceBreakers
      };
}

/// Represents the parameters used for sampling in the model.
class SamplingParams {
  /// Enables greedy decoding if set to `true`.
  final bool greedy;

  /// Enables infill sampling if set to `true`.
  final bool infill;

  /// Optional seed for random number generation to ensure reproducibility.
  final int? seed;

  /// Limits the number of top candidates considered during sampling.
  final int? topK;

  /// Arguments for top-p sampling (nucleus sampling).
  final TopPArguments? topP;

  /// Arguments for minimum-p sampling.
  final MinPArguments? minP;

  /// Arguments for typical-p sampling.
  final TypicalPArguments? typicalP;

  /// Arguments for controlling the temperature during sampling.
  final TemperatureArguments? temperature;

  /// Arguments for Xtc sampling.
  final XtcArguments? xtc;

  /// Arguments for Mirostat sampling.
  final MirostatArguments? mirostat;

  /// Arguments for Mirostat version 2 sampling.
  final MirostatV2Arguments? mirostatV2;

  /// Grammar rules and root node for constrained sampling.
  final GrammarArguments? grammar;

  /// Penalty configurations for preventing repetition.
  final PenaltiesArguments? penalties;

  /// Arguments for dry sampling (specific training context).
  final DrySamplerArguments? drySampler;

  /// Creates a new instance of [SamplingParams].
  const SamplingParams(
      {this.greedy = false,
      this.infill = false,
      this.seed,
      this.topK,
      this.topP,
      this.minP,
      this.typicalP,
      this.temperature,
      this.xtc,
      this.mirostat,
      this.mirostatV2,
      this.grammar,
      this.penalties,
      this.drySampler});

  /// Constructs a [SamplingParams] instance from a [Map].
  factory SamplingParams.fromMap(Map<String, dynamic> map) => SamplingParams(
      greedy: map['greedy'] ?? false,
      infill: map['infill'] ?? false,
      seed: map['seed'],
      topK: map['top_k'],
      topP: map['top_p'] != null ? TopPArguments.fromMap(map['top_p']) : null,
      minP: map['min_p'] != null ? MinPArguments.fromMap(map['min_p']) : null,
      typicalP: map['typical_p'] != null
          ? TypicalPArguments.fromMap(map['typical_p'])
          : null,
      temperature: map['temperature'] != null
          ? TemperatureArguments.fromMap(map['temperature'])
          : null,
      xtc: map['xtc'] != null ? XtcArguments.fromMap(map['xtc']) : null,
      mirostat: map['mirostat'] != null
          ? MirostatArguments.fromMap(map['mirostat'])
          : null,
      mirostatV2: map['mirostat_v2'] != null
          ? MirostatV2Arguments.fromMap(map['mirostat_v2'])
          : null,
      grammar: map['grammar'] != null
          ? GrammarArguments.fromMap(map['grammar'])
          : null,
      penalties: map['penalties'] != null
          ? PenaltiesArguments.fromMap(map['penalties'])
          : null,
      drySampler: map['dry_sampler'] != null
          ? DrySamplerArguments.fromMap(map['dry_sampler'])
          : null);

  /// Constructs a [SamplingParams] instance from a JSON string.
  factory SamplingParams.fromJson(String source) =>
      SamplingParams.fromMap(jsonDecode(source));

  /// Converts this instance to a [Pointer<llama_sampler>].
  ffi.Pointer<llama_sampler> toNative(ffi.Pointer<llama_vocab> vocab) {
    final sampler = _LlamaBase.lib.llama_sampler_chain_init(
        _LlamaBase.lib.llama_sampler_chain_default_params());

    if (greedy) {
      _LlamaBase.lib.llama_sampler_chain_add(
          sampler, _LlamaBase.lib.llama_sampler_init_greedy());
    }

    if (infill) {
      _LlamaBase.lib.llama_sampler_chain_add(
          sampler, _LlamaBase.lib.llama_sampler_init_infill(vocab));
    }

    if (seed != null) {
      _LlamaBase.lib.llama_sampler_chain_add(
          sampler, _LlamaBase.lib.llama_sampler_init_dist(seed!));
    }

    if (topK != null) {
      _LlamaBase.lib.llama_sampler_chain_add(
          sampler, _LlamaBase.lib.llama_sampler_init_top_k(topK!));
    }

    if (topP != null) {
      _LlamaBase.lib.llama_sampler_chain_add(
          sampler, _LlamaBase.lib.llama_sampler_init_top_p(topP!.p, topP!.minKeep));
    }

    if (minP != null) {
      _LlamaBase.lib.llama_sampler_chain_add(
          sampler, _LlamaBase.lib.llama_sampler_init_min_p(minP!.p, minP!.minKeep));
    }

    if (typicalP != null) {
      _LlamaBase.lib.llama_sampler_chain_add(sampler,
          _LlamaBase.lib.llama_sampler_init_typical(typicalP!.p, typicalP!.minKeep));
    }

    if (temperature != null) {
      if (temperature!.delta == null || temperature!.exponent == null) {
        _LlamaBase.lib.llama_sampler_chain_add(sampler,
            _LlamaBase.lib.llama_sampler_init_temp(temperature!.temperature));
      } else {
        _LlamaBase.lib.llama_sampler_chain_add(
            sampler,
            _LlamaBase.lib.llama_sampler_init_temp_ext(temperature!.temperature,
                temperature!.delta!, temperature!.exponent!));
      }
    }

    if (xtc != null) {
      _LlamaBase.lib.llama_sampler_chain_add(
          sampler,
          _LlamaBase.lib
              .llama_sampler_init_xtc(xtc!.p, xtc!.t, xtc!.minKeep, xtc!.seed));
    }

    if (mirostat != null) {
      _LlamaBase.lib.llama_sampler_chain_add(
          sampler,
          _LlamaBase.lib.llama_sampler_init_mirostat(mirostat!.nVocab,
              mirostat!.seed, mirostat!.tau, mirostat!.eta, mirostat!.m));
    }

    if (mirostatV2 != null) {
      _LlamaBase.lib.llama_sampler_chain_add(
          sampler,
          _LlamaBase.lib.llama_sampler_init_mirostat_v2(
              mirostatV2!.seed, mirostatV2!.tau, mirostatV2!.eta));
    }

    if (grammar != null) {
      _LlamaBase.lib.llama_sampler_chain_add(
          sampler,
          _LlamaBase.lib.llama_sampler_init_grammar(
              vocab,
              grammar!.str.toNativeUtf8().cast<ffi.Char>(),
              grammar!.root.toNativeUtf8().cast<ffi.Char>()));
    }

    if (penalties != null) {
      _LlamaBase.lib.llama_sampler_chain_add(
          sampler,
          _LlamaBase.lib.llama_sampler_init_penalties(penalties!.lastN,
              penalties!.repeat, penalties!.frequency, penalties!.present));
    }

    if (drySampler != null) {
      final sequenceBreakers =
          calloc<ffi.Pointer<ffi.Char>>(drySampler!.sequenceBreakers.length);
      for (var i = 0; i < drySampler!.sequenceBreakers.length; i++) {
        sequenceBreakers[i] =
            drySampler!.sequenceBreakers[i].toNativeUtf8().cast<ffi.Char>();
      }

      _LlamaBase.lib.llama_sampler_chain_add(
          sampler,
          _LlamaBase.lib.llama_sampler_init_dry(
              vocab,
              drySampler!.nCtxTrain,
              drySampler!.multiplier,
              drySampler!.dryBase,
              drySampler!.allowedLength,
              drySampler!.penaltyLastN,
              sequenceBreakers,
              drySampler!.sequenceBreakers.length));
    }

    return sampler;
  }

  /// Converts this instance to a [Map].
  Map<String, dynamic> toMap() => {
        'greedy': greedy,
        'infill': infill,
        'seed': seed,
        'top_k': topK,
        'top_p': topP?.toMap(),
        'min_p': minP?.toMap(),
        'typical_p': typicalP?.toMap(),
        'temperature': temperature?.toMap(),
        'xtc': xtc?.toMap(),
        'mirostat': mirostat?.toMap(),
        'mirostat_v2': mirostatV2?.toMap(),
        'grammar': grammar?.toMap(),
        'penalties': penalties?.toMap(),
        'dry_sampler': drySampler?.toMap()
      };

  /// Converts this instance to a JSON-encoded string.
  String toJson() => jsonEncode(toMap());
}
