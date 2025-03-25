@JS()
library wasm_fs;

import 'dart:js_interop';

class FS {
  @JS('Module.FS_unlink')
  external static void unlink(JSString path);

  @JS('Module.FS_createDataFile')
  external static void createDataFile(JSString parent, JSString name, JSArrayBuffer data, JSBoolean canRead, JSBoolean canWrite, JSBoolean canOwn);

  @JS('Module.FS.open')
  external static JSObject open(JSString path, JSString flags);

  @JS('Module.FS.read')
  external static void read(JSObject stream, JSArrayBuffer buffer, JSNumber offset, JSNumber length, JSNumber position);

  @JS('Module.FS.write')
  external static void write(JSObject stream, JSArrayBuffer buffer, JSNumber offset, JSNumber length, JSNumber position);

  @JS('Module.FS.close')
  external static void close(JSObject stream);
}