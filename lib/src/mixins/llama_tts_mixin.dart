part of 'package:lcpp/lcpp.dart';

mixin _LlamaTTSMixin implements Llama {
  /// Converts the given text to speech and returns the audio data as a [Uint8List].
  ///
  /// The [text] parameter is the input string that needs to be converted to speech.
  ///
  /// Returns a [Future<Uint8List>] containing the audio data of the synthesized speech.
  Future<Uint8List> tts(String text);
}