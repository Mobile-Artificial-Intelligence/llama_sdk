<div align="center" id = "top">
  <img alt="logo" height="200px" src="https://raw.githubusercontent.com/Mobile-Artificial-Intelligence/maid/refs/heads/main/images/logo.png">
</div>

# llama

<div align="center">

[![Build Android](https://github.com/Mobile-Artificial-Intelligence/llama/actions/workflows/build-android.yml/badge.svg)](https://github.com/Mobile-Artificial-Intelligence/llama/actions/workflows/build-android.yml)
[![Build iOS](https://github.com/Mobile-Artificial-Intelligence/llama/actions/workflows/build-ios.yml/badge.svg)](https://github.com/Mobile-Artificial-Intelligence/llama/actions/workflows/build-ios.yml)
[![Build Linux](https://github.com/Mobile-Artificial-Intelligence/llama/actions/workflows/build-linux.yml/badge.svg)](https://github.com/Mobile-Artificial-Intelligence/llama/actions/workflows/build-linux.yml)
[![Build MacOS](https://github.com/Mobile-Artificial-Intelligence/llama/actions/workflows/build-macos.yml/badge.svg)](https://github.com/Mobile-Artificial-Intelligence/llama/actions/workflows/build-macos.yml)
[![Build Windows](https://github.com/Mobile-Artificial-Intelligence/llama/actions/workflows/build-windows.yml/badge.svg)](https://github.com/Mobile-Artificial-Intelligence/llama/actions/workflows/build-windows.yml)

</div>

llama is a dart implementation of llama.cpp used by the mobile artificial intelligence distribution (maid)

## Features

- Optional use of isolations for parallel processing
- Streaming support

## Getting started

To use this package, add `llama` as a [dependency in your pubspec.yaml file](https://flutter.io/platform-plugins/).

```yaml
dependencies:
  llama: ^0.2.0
```

then you can import llama in your Dart code

```dart
import 'package:llama/llama.dart';
```

## Usage

Below is a simple example of how to use llama

```dart
final llama = LlamaIsolated(LlamaParams(
  modelFile: File('path/to/model'),
  nCtx: 2048, 
  nBatch: 2048,
  greedy: true
));

final messages = [
  ChatMessage.withRole(role: 'user', content: 'Hello World'),
];

final stream = llama.prompt(messages);

stream.listen((event) {
  print(event);
});
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details
```
MIT License

Copyright (c) 2023 Dane Madsen

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```