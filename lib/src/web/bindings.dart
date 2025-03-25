// ignore_for_file: public_member_api_docs, non_constant_identifier_names

@JS()
library llama_wasm;

import 'dart:js_interop';

// Wrap the global Module object’s _llama functions:
@JS('Module._llama_default_params')
external JSNumber llamaDefaultParams();

@JS('Module._llama_llm_init')
external JSNumber llamaInit(JSNumber params);

@JS('Module._llama_prompt')
external void llamaPrompt(JSNumber messages, int callback);

@JS('Module._llama_llm_stop')
external void llamaStop();

@JS('Module._llama_llm_free')
external void llamaFree();

@JS('Module.stringToUTF8')
external JSNumber stringToUTF8(JSString str, JSNumber buffer, JSNumber length);

@JS('Module.UTF8ToString')
external JSString UTF8ToString(JSNumber buffer);

@JS('Module.addFunction')
external JSNumber addFunction(JSFunction fn, JSString signature);

@JS('Module.FS_createDataFile')
external void createDataFile(JSString parent, JSString name, JSArrayBuffer data, JSBoolean canRead, JSBoolean canWrite, JSBoolean canOwn);