@JS()
library llama_wasm;

import 'dart:js_interop';

// Wrap the global Module object’s _llama functions:
@JS('Module._llama_default_params')
external JSString llamaDefaultParams();

@JS('Module._llama_llm_init')
external int llamaInit(JSString params);

@JS('Module._llama_prompt')
external void llamaPrompt(JSString messages, int callback);

@JS('Module._llama_llm_stop')
external void llamaStop();

@JS('Module._llama_llm_free')
external void llamaFree();

@JS('Module.addFunction')
external int addFunction(JSFunction fn, JSString signature);

@JS('Module.FS_createDataFile')
external void createDataFile(JSString parent, JSString name, JSArrayBuffer data, JSBoolean canRead, JSBoolean canWrite, JSBoolean canOwn);