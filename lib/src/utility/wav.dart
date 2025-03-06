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
  Uint8List data;

  WAV({
    required this.chunkSize,
    required this.fmtChunkSize,
    required this.audioFormat,
    required this.numChannels,
    required this.sampleRate,
    required this.byteRate,
    required this.blockAlign,
    required this.bitsPerSample,
    required this.dataChunkSize,
    required this.data,
  });

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
    bytes.addAll(data);

    return Uint8List.fromList(bytes);
  }
}