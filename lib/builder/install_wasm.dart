import 'dart:async';
import 'dart:io';

import 'package:build/build.dart';
import 'package:path/path.dart' as p;

/// A simple builder that copies JS/WASM files from a package into the app's web folder.
class InstallWasmBuilder implements Builder {
  @override
  final buildExtensions = const {
    r'$package$': ['web/llama.js', 'web/llama.wasm'],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final srcDir = Directory('packages/my_package/web');
    final dstDir = Directory('web');

    if (!srcDir.existsSync()) return;

    for (final fileName in ['llama.js', 'llama.wasm']) {
      final srcPath = p.join(srcDir.path, fileName);
      final dstPath = p.join(dstDir.path, fileName);

      final srcFile = File(srcPath);
      if (srcFile.existsSync()) {
        final dstFile = File(dstPath);
        await dstFile.writeAsBytes(await srcFile.readAsBytes());
        log.info('Copied $fileName to web/');
      } else {
        log.warning('Missing $fileName in ${srcDir.path}');
      }
    }
  }
}

Builder installWasmBuilder(BuilderOptions options) => InstallWasmBuilder();