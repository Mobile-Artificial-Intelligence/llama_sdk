@JS('Module')
library wasm_fs;

import 'dart:js_interop';

@JS('FS_unlink')
external void unlink(JSString path);

@JS('FS_createDataFile')
external void createDataFile(
  JSString parent,
  JSString name,
  JSArrayBuffer data,
  JSBoolean canRead,
  JSBoolean canWrite,
  JSBoolean canOwn,
);

@JS('FS.open')
external JSObject open(JSString path, JSString flags);

@JS('FS.read')
external void read(JSObject stream, JSArrayBuffer buffer, JSNumber offset, JSNumber length, JSNumber position);

@JS('FS.write')
external void write(JSObject stream, JSArrayBuffer buffer, JSNumber offset, JSNumber length, JSNumber position);

@JS('FS.close')
external void close(JSObject stream);