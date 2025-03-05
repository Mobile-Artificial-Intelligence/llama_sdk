part of 'package:lcpp/lcpp.dart';

/// Sampling parameters combining all argument fields.
class SamplingParams extends ChangeNotifier{
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

  /// Creates a new instance of [SamplingParams].
  SamplingParams({
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
  }) : _greedy = greedy ?? false,
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

  String toJson() => jsonEncode(toMap());

  ffi.Pointer<llama_sampler> getSampler([ffi.Pointer<llama_vocab>? vocab]) {
    final sampler = _LlamaBase.lib.llama_sampler_chain_init(
        _LlamaBase.lib.llama_sampler_chain_default_params());

    if (greedy) {
      _LlamaBase.lib.llama_sampler_chain_add(
          sampler, _LlamaBase.lib.llama_sampler_init_greedy());
    }

    if (_infill) {
      assert(vocab != null, LlamaException('Vocabulary is required for infill'));
      _LlamaBase.lib.llama_sampler_chain_add(
          sampler, _LlamaBase.lib.llama_sampler_init_infill(vocab!));
    }

    if (_seed != null) {
      _LlamaBase.lib.llama_sampler_chain_add(
          sampler, _LlamaBase.lib.llama_sampler_init_dist(_seed!));
    }

    if (_topK != null) {
      _LlamaBase.lib.llama_sampler_chain_add(
          sampler, _LlamaBase.lib.llama_sampler_init_top_k(_topK!));
    }

    if (_topP != null && _minKeepTopP != null) {
      _LlamaBase.lib.llama_sampler_chain_add(
          sampler, _LlamaBase.lib.llama_sampler_init_top_p(_topP!, _minKeepTopP!));
    }

    if (_minP != null && _minKeepMinP != null) {
      _LlamaBase.lib.llama_sampler_chain_add(
          sampler, _LlamaBase.lib.llama_sampler_init_min_p(_minP!, _minKeepMinP!));
    }

    if (_typicalP != null && _minKeepTypicalP != null) {
      _LlamaBase.lib.llama_sampler_chain_add(sampler,
          _LlamaBase.lib.llama_sampler_init_typical(_typicalP!, _minKeepTypicalP!));
    }

    if (_temperature != null) {
      if (_temperatureDelta == null || _temperatureExponent == null) {
        _LlamaBase.lib.llama_sampler_chain_add(sampler,
            _LlamaBase.lib.llama_sampler_init_temp(_temperature!));
      } else {
        _LlamaBase.lib.llama_sampler_chain_add(
            sampler,
            _LlamaBase.lib.llama_sampler_init_temp_ext(_temperature!,
                _temperatureDelta!, _temperatureExponent!));
      }
    }

    if (_xtcP != null &&
        _xtcT != null &&
        _minKeepXtc != null &&
        _xtcSeed != null) {
      _LlamaBase.lib.llama_sampler_chain_add(
          sampler,
          _LlamaBase.lib
              .llama_sampler_init_xtc(_xtcP!, _xtcT!, _minKeepXtc!, _xtcSeed!));
    }

    if (_mirostatNVocab != null &&
        _mirostatSeed != null &&
        _mirostatTau != null &&
        _mirostatEta != null &&
        _mirostatM != null) {
      _LlamaBase.lib.llama_sampler_chain_add(
          sampler,
          _LlamaBase.lib.llama_sampler_init_mirostat(_mirostatNVocab!,
              _mirostatSeed!, _mirostatTau!, _mirostatEta!, _mirostatM!));
    }

    if (_mirostatV2Seed != null &&
        _mirostatV2Tau != null &&
        _mirostatV2Eta != null) {
      _LlamaBase.lib.llama_sampler_chain_add(
          sampler,
          _LlamaBase.lib.llama_sampler_init_mirostat_v2(
              _mirostatV2Seed!, _mirostatV2Tau!, _mirostatV2Eta!));
    }

    if (_grammarStr != null && _grammarRoot != null) {
      assert(vocab != null, LlamaException('Vocabulary is required for grammar'));
      _LlamaBase.lib.llama_sampler_chain_add(
          sampler,
          _LlamaBase.lib.llama_sampler_init_grammar(
              vocab!,
              _grammarStr!.toNativeUtf8().cast<ffi.Char>(),
              _grammarRoot!.toNativeUtf8().cast<ffi.Char>()));
    }

    if (_penaltiesLastN != null &&
        _penaltiesRepeat != null &&
        _penaltiesFrequency != null &&
        _penaltiesPresent != null) {
      _LlamaBase.lib.llama_sampler_chain_add(
          sampler,
          _LlamaBase.lib.llama_sampler_init_penalties(_penaltiesLastN!,
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

      _LlamaBase.lib.llama_sampler_chain_add(
          sampler,
          _LlamaBase.lib.llama_sampler_init_dry(
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