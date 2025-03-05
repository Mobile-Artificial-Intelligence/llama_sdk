part of 'package:lcpp/lcpp.dart';

/// Sampling parameters combining all argument fields.
class SamplingParams {
  /// Enables greedy decoding if set to `true`.
  final bool greedy;

  /// Enables infill sampling if set to `true`.
  final bool infill;

  /// Optional seed for random number generation to ensure reproducibility.
  final int? seed;

  /// Limits the number of top candidates considered during sampling.
  final int? topK;

  /// Top-P sampling
  final double? topP;

  /// Top-P sampling minimum keep
  final int? minKeepTopP;

  /// Minimum Probability sampling
  final double? minP;

  /// Minimum Probability sampling minimum keep
  final int? minKeepMinP;

  /// Typical-P sampling
  final double? typicalP;

  /// Typical-P sampling minimum keep
  final int? minKeepTypicalP;

  /// Temperature-based sampling
  final double? temperature;

  /// Temperature-based sampling delta
  final double? temperatureDelta;

  /// Temperature-based sampling exponent
  final double? temperatureExponent;

  /// XTC sampling probability
  final double? xtcP;

  /// XTC sampling temperature
  final double? xtcT;

  /// XTC sampling minimum keep
  final int? minKeepXtc;

  /// XTC sampling seed
  final int? xtcSeed;

  /// Mirostat sampling vocabulary size
  final int? mirostatNVocab;

  /// Mirostat sampling seed
  final int? mirostatSeed;

  /// Mirostat sampling tau
  final double? mirostatTau;

  /// Mirostat sampling eta
  final double? mirostatEta;

  /// Mirostat sampling M
  final int? mirostatM;

  /// Mirostat v2 sampling seed
  final int? mirostatV2Seed;

  /// Mirostat v2 sampling tau
  final double? mirostatV2Tau;

  /// Mirostat v2 sampling eta
  final double? mirostatV2Eta;

  /// Grammar-based sampling string
  final String? grammarStr;

  /// Grammar-based sampling root
  final String? grammarRoot;

  /// Penalties last N
  final int? penaltiesLastN;

  /// Penalties repeat
  final double? penaltiesRepeat;

  /// Penalties frequency
  final double? penaltiesFrequency;

  /// Penalties present
  final double? penaltiesPresent;

  /// Dry sampler n ctx train
  final int? drySamplerNCtxTrain;

  /// Dry sampler multiplier
  final double? drySamplerMultiplier;

  /// Dry sampler dry base
  final double? drySamplerDryBase;

  /// Dry sampler allowed length
  final int? drySamplerAllowedLength;

  /// Dry sampler penalty last N
  final int? drySamplerPenaltyLastN;

  /// Dry sampler sequence breakers
  final List<String>? drySamplerSequenceBreakers;

  /// Creates a new instance of [SamplingParams].
  const SamplingParams({
    this.greedy = false,
    this.infill = false,
    this.seed,
    this.topK,
    this.topP,
    this.minKeepTopP,
    this.minP,
    this.minKeepMinP,
    this.typicalP,
    this.minKeepTypicalP,
    this.temperature,
    this.temperatureDelta,
    this.temperatureExponent,
    this.xtcP,
    this.xtcT,
    this.minKeepXtc,
    this.xtcSeed,
    this.mirostatNVocab,
    this.mirostatSeed,
    this.mirostatTau,
    this.mirostatEta,
    this.mirostatM,
    this.mirostatV2Seed,
    this.mirostatV2Tau,
    this.mirostatV2Eta,
    this.grammarStr,
    this.grammarRoot,
    this.penaltiesLastN,
    this.penaltiesRepeat,
    this.penaltiesFrequency,
    this.penaltiesPresent,
    this.drySamplerNCtxTrain,
    this.drySamplerMultiplier,
    this.drySamplerDryBase,
    this.drySamplerAllowedLength,
    this.drySamplerPenaltyLastN,
    this.drySamplerSequenceBreakers,
  });

  /// Constructs a [SamplingParams] instance from a [Map].
  factory SamplingParams.fromMap(Map<String, dynamic> map) => SamplingParams(
        greedy: map['greedy'] ?? false,
        infill: map['infill'] ?? false,
        seed: map['seed'],
        topK: map['top_k'],
        topP: map['top_p'],
        minKeepTopP: map['top_p_min_keep'],
        minP: map['min_p'],
        minKeepMinP: map['min_p_min_keep'],
        typicalP: map['typical_p'],
        minKeepTypicalP: map['typical_p_min_keep'],
        temperature: map['temperature'],
        temperatureDelta: map['temperature_delta'],
        temperatureExponent: map['temperature_exponent'],
        xtcP: map['xtc_p'],
        xtcT: map['xtc_t'],
        minKeepXtc: map['xtc_min_keep'],
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

  factory SamplingParams.fromJson(String json) =>
      SamplingParams.fromMap(jsonDecode(json));

  /// Converts this instance to a [Map].
  Map<String, dynamic> toMap() => {
        'greedy': greedy,
        'infill': infill,
        'seed': seed,
        'top_k': topK,
        'top_p': topP,
        'top_p_min_keep': minKeepTopP,
        'min_p': minP,
        'min_p_min_keep': minKeepMinP,
        'typical_p': typicalP,
        'typical_p_min_keep': minKeepTypicalP,
        'temperature': temperature,
        'temperature_delta': temperatureDelta,
        'temperature_exponent': temperatureExponent,
        'xtc_p': xtcP,
        'xtc_t': xtcT,
        'xtc_min_keep': minKeepXtc,
        'xtc_seed': xtcSeed,
        'mirostat_n_vocab': mirostatNVocab,
        'mirostat_seed': mirostatSeed,
        'mirostat_tau': mirostatTau,
        'mirostat_eta': mirostatEta,
        'mirostat_m': mirostatM,
        'mirostat_v2_seed': mirostatV2Seed,
        'mirostat_v2_tau': mirostatV2Tau,
        'mirostat_v2_eta': mirostatV2Eta,
        'grammar_str': grammarStr,
        'grammar_root': grammarRoot,
        'penalties_last_n': penaltiesLastN,
        'penalties_repeat': penaltiesRepeat,
        'penalties_frequency': penaltiesFrequency,
        'penalties_present': penaltiesPresent,
        'dry_sampler_n_ctx_train': drySamplerNCtxTrain,
        'dry_sampler_multiplier': drySamplerMultiplier,
        'dry_sampler_dry_base': drySamplerDryBase,
        'dry_sampler_allowed_length': drySamplerAllowedLength,
      };

  String toJson() => jsonEncode(toMap());

  ffi.Pointer<llama_sampler> getSampler([ffi.Pointer<llama_vocab>? vocab]) {
    final sampler = _LlamaBase.lib.llama_sampler_chain_init(
        _LlamaBase.lib.llama_sampler_chain_default_params());

    if (greedy) {
      _LlamaBase.lib.llama_sampler_chain_add(
          sampler, _LlamaBase.lib.llama_sampler_init_greedy());
    }

    if (infill) {
      assert(vocab != null, LlamaException('Vocabulary is required for infill'));
      _LlamaBase.lib.llama_sampler_chain_add(
          sampler, _LlamaBase.lib.llama_sampler_init_infill(vocab!));
    }

    if (seed != null) {
      _LlamaBase.lib.llama_sampler_chain_add(
          sampler, _LlamaBase.lib.llama_sampler_init_dist(seed!));
    }

    if (topK != null) {
      _LlamaBase.lib.llama_sampler_chain_add(
          sampler, _LlamaBase.lib.llama_sampler_init_top_k(topK!));
    }

    if (topP != null && minKeepTopP != null) {
      _LlamaBase.lib.llama_sampler_chain_add(
          sampler, _LlamaBase.lib.llama_sampler_init_top_p(topP!, minKeepTopP!));
    }

    if (minP != null && minKeepMinP != null) {
      _LlamaBase.lib.llama_sampler_chain_add(
          sampler, _LlamaBase.lib.llama_sampler_init_min_p(minP!, minKeepMinP!));
    }

    if (typicalP != null && minKeepTypicalP != null) {
      _LlamaBase.lib.llama_sampler_chain_add(sampler,
          _LlamaBase.lib.llama_sampler_init_typical(typicalP!, minKeepTypicalP!));
    }

    if (temperature != null) {
      if (temperatureDelta == null || temperatureExponent == null) {
        _LlamaBase.lib.llama_sampler_chain_add(sampler,
            _LlamaBase.lib.llama_sampler_init_temp(temperature!));
      } else {
        _LlamaBase.lib.llama_sampler_chain_add(
            sampler,
            _LlamaBase.lib.llama_sampler_init_temp_ext(temperature!,
                temperatureDelta!, temperatureExponent!));
      }
    }

    if (xtcP != null &&
        xtcT != null &&
        minKeepXtc != null &&
        xtcSeed != null) {
      _LlamaBase.lib.llama_sampler_chain_add(
          sampler,
          _LlamaBase.lib
              .llama_sampler_init_xtc(xtcP!, xtcT!, minKeepXtc!, xtcSeed!));
    }

    if (mirostatNVocab != null &&
        mirostatSeed != null &&
        mirostatTau != null &&
        mirostatEta != null &&
        mirostatM != null) {
      _LlamaBase.lib.llama_sampler_chain_add(
          sampler,
          _LlamaBase.lib.llama_sampler_init_mirostat(mirostatNVocab!,
              mirostatSeed!, mirostatTau!, mirostatEta!, mirostatM!));
    }

    if (mirostatV2Seed != null &&
        mirostatV2Tau != null &&
        mirostatV2Eta != null) {
      _LlamaBase.lib.llama_sampler_chain_add(
          sampler,
          _LlamaBase.lib.llama_sampler_init_mirostat_v2(
              mirostatV2Seed!, mirostatV2Tau!, mirostatV2Eta!));
    }

    if (grammarStr != null && grammarRoot != null) {
      assert(vocab != null, LlamaException('Vocabulary is required for grammar'));
      _LlamaBase.lib.llama_sampler_chain_add(
          sampler,
          _LlamaBase.lib.llama_sampler_init_grammar(
              vocab!,
              grammarStr!.toNativeUtf8().cast<ffi.Char>(),
              grammarRoot!.toNativeUtf8().cast<ffi.Char>()));
    }

    if (penaltiesLastN != null &&
        penaltiesRepeat != null &&
        penaltiesFrequency != null &&
        penaltiesPresent != null) {
      _LlamaBase.lib.llama_sampler_chain_add(
          sampler,
          _LlamaBase.lib.llama_sampler_init_penalties(penaltiesLastN!,
              penaltiesRepeat!, penaltiesFrequency!, penaltiesPresent!));
    }

    if (drySamplerSequenceBreakers != null &&
        drySamplerNCtxTrain != null &&
        drySamplerMultiplier != null &&
        drySamplerDryBase != null &&
        drySamplerAllowedLength != null) {
      assert(vocab != null, LlamaException('Vocabulary is required for dry sampler'));
      final sequenceBreakers =
          calloc<ffi.Pointer<ffi.Char>>(drySamplerSequenceBreakers!.length);
      for (var i = 0; i < drySamplerSequenceBreakers!.length; i++) {
        sequenceBreakers[i] =
            drySamplerSequenceBreakers![i].toNativeUtf8().cast<ffi.Char>();
      }

      _LlamaBase.lib.llama_sampler_chain_add(
          sampler,
          _LlamaBase.lib.llama_sampler_init_dry(
              vocab!,
              drySamplerNCtxTrain!,
              drySamplerMultiplier!,
              drySamplerDryBase!,
              drySamplerAllowedLength!,
              drySamplerPenaltyLastN!,
              sequenceBreakers,
              drySamplerSequenceBreakers!.length));
    }

    return sampler;
  }
}