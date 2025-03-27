part of 'package:lcpp/lcpp.web.dart';

/// A utility function that returns the path of the WebAssembly file.
Future<String> getWasmPath(Stream<List<int>> stream, String name) async {
  //unlink('/model.gguf'.toJS);
  print('Unlinked /model.gguf');

  final emptyBytes = Uint8List(0);

  createDataFile(
    '/'.toJS, 
    'model.gguf'.toJS, 
    emptyBytes.buffer.toJS, 
    true.toJS, 
    true.toJS, 
    true.toJS
  );
  print('Created /model.gguf');

  final streamJS = open('/model.gguf'.toJS, 'w'.toJS);
  print('Opened /model.gguf');
  await for (final chunk in stream) {
    final bytes = Uint8List.fromList(chunk);
    write(streamJS, bytes.buffer.toJS, 0.toJS, bytes.length.toJS, (-1).toJS);
    print('Wrote ${bytes.length} bytes to /model.gguf');
  }
  close(streamJS);
  print('Closed /model.gguf');

  return '/model.gguf';
}