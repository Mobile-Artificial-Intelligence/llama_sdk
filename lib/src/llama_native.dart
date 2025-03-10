part of 'package:lcpp/lcpp.dart';

class LlamaNative {
  static StreamController<String> _controller = StreamController<String>();

  LlamaParams _llamaParams;

  /// The current LlamaParams instance.
  LlamaParams get llamaParams => _llamaParams;

  /// Sets the current LlamaParams instance.
  /// 
  /// The [LlamaParams] instance contains the parameters used by llama.
  set llamaParams(LlamaParams value) {
    _llamaParams = value;
    _llamaParams.addListener(_init);
    _init();
  }

  /// A class that initializes and manages a native Llama model.
  ///
  /// The [LlamaNative] constructor requires [llamaParams] to initialize the
  /// Llama model, context, and sampler.
  ///
  /// Parameters:
  /// - [llamaParams]: The parameters required for the Llama model.
  LlamaNative(LlamaParams llamaParams)
      : _llamaParams = llamaParams {
    _init();
  }

  void _init() => lib.llama_init(_llamaParams.toPointer());

  Stream<String> prompt(List<ChatMessage> messages) async* {
    _asyncPrompt(messages);

    yield* _controller.stream;
  }

  Future<int> _asyncPrompt(List<ChatMessage> messages) async {
    final chatMessagesPointer = messages.toPointer();

    return lib.llama_prompt(chatMessagesPointer, ffi.Pointer.fromFunction(_output));
  }

  static void _output(ffi.Pointer<ffi.Char> buffer) {
    _controller.add(buffer.cast<Utf8>().toDartString());
  }
}