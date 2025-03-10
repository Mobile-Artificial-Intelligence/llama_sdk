import 'dart:ffi' as ffi;
import 'dart:io';

import 'package:flutter/services.dart';

import 'bindings.dart';

llama? _lib;

llama get lib {
  if (_lib == null) {
    if (Platform.isWindows) {
      _lib = llama(ffi.DynamicLibrary.open('llama.dll'));
    } else if (Platform.isLinux || Platform.isAndroid) {
      _lib = llama(ffi.DynamicLibrary.open('libllama.so'));
    } else if (Platform.isMacOS || Platform.isIOS) {
      _lib = llama(ffi.DynamicLibrary.open('lcpp.framework/lcpp'));
    } else {
      throw PlatformException(code: 'LlamaCPP Unsupported Platform');
    }
  }
  return _lib!;
}