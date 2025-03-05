part of 'package:lcpp/lcpp.dart';

class ModelParams extends ChangeNotifier {
  File? _chatModel;

  File? get chatModel => _chatModel;

  set chatModel(File? value) {
    _chatModel = value;
    notifyListeners();
  }

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

  /// Creates a new instance of the [ModelParams] class.
  ///
  /// Parameters:
  /// - `path` (required): The file path to the model.
  /// - `vocabOnly` (optional): A flag indicating whether to load only the vocabulary.
  /// - `useMmap` (optional): A flag indicating whether to use memory-mapped files.
  /// - `useMlock` (optional): A flag indicating whether to lock the model in memory.
  /// - `checkTensors` (optional): A flag indicating whether to check the tensors.
  ModelParams({
    File? chatModel,
    File? ttcModel,
    File? ctsModel,
    bool? vocabOnly,
    bool? useMmap,
    bool? useMlock,
    bool? checkTensors,
  })  : _chatModel = chatModel,
        _ttcModel = ttcModel,
        _ctsModel = ctsModel,
        _vocabOnly = vocabOnly,
        _useMmap = useMmap,
        _useMlock = useMlock,
        _checkTensors = checkTensors;

  factory ModelParams.fromMap(Map<String, dynamic> map) => ModelParams(
      chatModel: map['chat_model'] != null ? File(map['chat_model']) : null,
      ttcModel: map['ttc_model'] != null ? File(map['ttc_model']) : null,
      ctsModel: map['cts_model'] != null ? File(map['cts_model']) : null,
      vocabOnly: map['vocab_only'],
      useMmap: map['use_mmap'],
      useMlock: map['use_mlock'],
      checkTensors: map['check_tensors']);

  /// Creates a new `ModelParams` instance from a JSON string.
  ///
  /// The [source] parameter is a JSON-encoded string representation of the
  /// `ModelParams` object.
  ///
  /// Returns a `ModelParams` instance created from the decoded JSON map.
  factory ModelParams.fromJson(String source) =>
      ModelParams.fromMap(jsonDecode(source));

  /// Converts the current instance of `model_params` to its native representation.
  ///
  /// This method initializes the native `llama_model_params` structure with default values
  /// and then updates it with the values from the current instance if they are not null.
  ///
  /// Returns:
  ///   A `llama_model_params` instance with the updated values.
  llama_model_params toNative() {
    final llama_model_params modelParams =
        _LlamaBase.lib.llama_model_default_params();
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

  /// Converts the model parameters to a map.
  ///
  /// The map contains the following keys:
  /// - 'path': The file path of the model.
  /// - 'vocab_only': Whether to use only the vocabulary.
  /// - 'use_mmap': Whether to use memory mapping.
  /// - 'use_mlock': Whether to use memory locking.
  /// - 'check_tensors': Whether to check tensors.
  ///
  /// Returns a map representation of the model parameters.
  Map<String, dynamic> toMap() => {
        'chat_model': chatModel?.path,
        'ttc_model': ttcModel?.path,
        'cts_model': ctsModel?.path,
        'vocab_only': vocabOnly,
        'use_mmap': useMmap,
        'use_mlock': useMlock,
        'check_tensors': checkTensors,
      };

  /// Converts the model parameters to a JSON string.
  ///
  /// This method uses [toMap] to convert the model parameters to a map,
  /// and then encodes the map to a JSON string using [jsonEncode].
  ///
  /// Returns a JSON string representation of the model parameters.
  String toJson() => jsonEncode(toMap());
}
