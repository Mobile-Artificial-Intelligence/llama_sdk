part of 'package:lcpp/lcpp.dart';

extension Uint8listExtension on Uint8List {
  String get toPath {
    throw LlamaException('The toPath can only be used on web');
  }
}