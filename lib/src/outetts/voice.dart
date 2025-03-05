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

  String get formattedText {
    String result = '<|text_start|>';

    for (final word in words) {
      result += '${word.text}<|text_sep|>';
    }

    return result;
  }

  String get formattedData {
    String result = '<|audio_start|>';

    for (final word in words) {
      result += word.formattedText;
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
    codes: List<int>.from(map['codes']),
  );

  String get formattedText {
    String result = '$text<|t_${duration.inSeconds.toStringAsFixed(2)}|><|code_start|>';

    for (final code in codes) {
      result += '<|$code|>';
    }

    return '$result<|code_end|>';
  }
}