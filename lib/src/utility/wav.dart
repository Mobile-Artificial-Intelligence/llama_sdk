part of 'package:lcpp/lcpp.dart';

class WAV {
  int chunkSize;
  int fmtChunkSize;
  int audioFormat;
  int numChannels;
  int sampleRate;
  int byteRate;
  int blockAlign;
  int bitsPerSample;
  int dataChunkSize;
  List<double> data;

  WAV({
    this.fmtChunkSize = 16,
    this.audioFormat = 1,
    this.numChannels = 1,
    this.sampleRate = 24000,
    this.bitsPerSample = 16,
    required this.data,
  })  : byteRate = sampleRate * numChannels * (bitsPerSample ~/ 8), 
        blockAlign = numChannels * (bitsPerSample ~/ 8),
        dataChunkSize = data.length * (bitsPerSample ~/ 8),
        chunkSize = 36 + data.length * (bitsPerSample ~/ 8);

  Uint8List toBytes() {
    final bytes = <int>[];

    bytes.addAll(Uint8List.fromList('RIFF'.codeUnits));
    bytes.addAll(Uint8List(4)..buffer.asByteData().setUint32(0, chunkSize, Endian.little));
    bytes.addAll(Uint8List.fromList('WAVE'.codeUnits));

    bytes.addAll(Uint8List.fromList('fmt '.codeUnits));
    bytes.addAll(Uint8List(4)..buffer.asByteData().setUint32(0, fmtChunkSize, Endian.little));
    bytes.addAll(Uint8List(2)..buffer.asByteData().setUint16(0, audioFormat, Endian.little));
    bytes.addAll(Uint8List(2)..buffer.asByteData().setUint16(0, numChannels, Endian.little));
    bytes.addAll(Uint8List(4)..buffer.asByteData().setUint32(0, sampleRate, Endian.little));
    bytes.addAll(Uint8List(4)..buffer.asByteData().setUint32(0, byteRate, Endian.little));
    bytes.addAll(Uint8List(2)..buffer.asByteData().setUint16(0, blockAlign, Endian.little));
    bytes.addAll(Uint8List(2)..buffer.asByteData().setUint16(0, bitsPerSample, Endian.little));

    bytes.addAll(Uint8List.fromList('data'.codeUnits));
    bytes.addAll(Uint8List(4)..buffer.asByteData().setUint32(0, dataChunkSize, Endian.little));
    bytes.addAll(_convertToPCM16(data));

    return Uint8List.fromList(bytes);
  }

  Uint8List _convertToPCM16(List<double> audio) {
    final int length = audio.length;
    final ByteData byteData = ByteData(length * 2); // 2 bytes per sample

    for (int i = 0; i < length; i++) {
      // Clamp values to [-1.0, 1.0]
      double sample = math.max(-1.0, math.min(1.0, audio[i]));

      // Convert to 16-bit PCM
      int intSample = (sample * 32767).round(); // 16-bit range: [-32768, 32767]

      // Store as little-endian
      byteData.setInt16(i * 2, intSample, Endian.little);
    }

    return byteData.buffer.asUint8List();
  }
}