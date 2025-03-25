part of 'package:lcpp/lcpp.web.dart';

extension Uint8listExtension on Uint8List {
  String get toPath {
    FS.unlink('/model.gguf'.toJS);

    FS.createDataFile(
      '/'.toJS, 
      'model.gguf'.toJS, 
      buffer.toJS, 
      true.toJS, 
      true.toJS, 
      true.toJS
    );

    return '/model.gguf';
  }
}