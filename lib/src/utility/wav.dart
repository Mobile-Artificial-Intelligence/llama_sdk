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
    bytes.addAll(data);

    return Uint8List.fromList(bytes);
  }
}