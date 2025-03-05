part of 'package:lcpp/lcpp.dart';

class VoiceData {
  final String text;
  final List<WordData> words;

  VoiceData({
    required this.text,
    required this.words,
  });

  factory VoiceData.fromMap(Map<String, dynamic> map) => VoiceData(
    text: map['text'],
    words: List<WordData>.from(map['words'].map((x) => WordData.fromMap(x))),
  );

  Map<String, dynamic> toMap() => {
    'text': text,
    'words': List.from(words.map((x) => x.toMap())),
  };

  String _getFormattedText(_OuteTtsVersion version) {
    String result = '<|text_start|>';
    final seperator = version == _OuteTtsVersion.v3 ? "<|space|>" : "<|text_sep|>";

    for (final word in words) {
      result += '${word.text}$seperator';
    }

    return result;
  }

  String _getFormattedData(_OuteTtsVersion version) {
    String result = '<|audio_start|>\n';

    for (final word in words) {
      result += word._getFormattedText(version);
    }

    return result;
  }
}

class WordData {
  final String text;
  final Duration duration;
  final List<int> codes;

  WordData({
    required this.text,
    required this.duration,
    required this.codes,
  });

  factory WordData.fromMap(Map<String, dynamic> map) => WordData(
    text: map['text'],
    duration: Duration(seconds: map['duration']),
    codes: map['codes'],
  );

  Map<String, dynamic> toMap() => {
    'text': text,
    'duration': duration.inSeconds.toStringAsFixed(2),
    'codes': codes,
  };

  String _getFormattedText(_OuteTtsVersion version) {
    final codeStart = version == _OuteTtsVersion.v3 ? "" : "<|code_start|>";
    String result = '$text<|t_${duration.inSeconds.toStringAsFixed(2)}|>$codeStart';

    for (final code in codes) {
      result += '<|$code|>';
    }

    final codeEnd = version == _OuteTtsVersion.v3 ? "<|space|>\n" : "<|code_end|>\n";
    return '$result$codeEnd';
  }
}