@JS()
library llama_wasm;

import 'dart:js_interop';

// Wrap the global Module object’s _llama functions:
@JS('Module._llama_default_params')
external JSString llamaDefaultParams();

@JS('Module._llama_llm_init')
external int llamaInit(JSString params);

@JS('Module._llama_prompt_simple')
external JSString llamaPrompt(JSString messages);

@JS('Module._llama_llm_stop')
external void llamaStop();

@JS('Module._llama_llm_free')
external void llamaFree();