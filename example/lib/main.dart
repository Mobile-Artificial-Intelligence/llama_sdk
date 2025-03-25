import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:lcpp/lcpp.dart'
    if (dart.library.html) 'package:lcpp/lcpp.web.dart';

void main() {
  runApp(const LlamaApp());
}

class LlamaApp extends StatefulWidget {
  const LlamaApp({super.key});

  @override
  State<LlamaApp> createState() => LlamaAppState();
}

class LlamaAppState extends State<LlamaApp> {
  final TextEditingController controller = TextEditingController();
  final List<ChatMessage> messages = [];
  Llama? model;
  String? modelPath;
  bool busy = false;

  void loadModel() async {
    final result = await FilePicker.platform.pickFiles(
        dialogTitle: "Load Model File",
        type: FileType.any,
        allowMultiple: false,
        allowCompression: false,
        withReadStream: kIsWeb,
      );

    if (result == null ||
        result.files.isEmpty
      ) {
      throw Exception('No file selected');
    }

    String path = '';

    if (kIsWeb) {
      final readStream = result.files.single.readStream!;
      final bytesBuilder = BytesBuilder();

      await for (final chunk in readStream) {
        if (chunk.isEmpty) break;

        bytesBuilder.add(chunk);
      }
      
      final bytes = bytesBuilder.toBytes();

      path = bytes.toPath;
    }
    else {
      path = result.files.single.path!;
    }

    if (!kIsWeb && !File(path).existsSync()) {
      throw Exception('File does not exist');
    }

    final llamaCpp = Llama(LlamaController(
        modelPath: path, nCtx: 2048, nBatch: 2048, greedy: true));

    setState(() {
      model = llamaCpp;
      modelPath = path;
    });
  }

  void onSubmitted(String value) async {
    if (model == null) {
      return;
    }

    setState(() {
      busy = true;
      messages.add(UserChatMessage(value));
      controller.clear();
    });

    final stream = model!.prompt(messages.copy());

    messages.add(AssistantChatMessage(''));

    await for (var response in stream) {
      setState(() {
        messages.last.content += response;
      });
    }

    setState(() => busy = false);
  }

  void onStop() {
    model?.stop();
    setState(() => busy = false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: buildHome());
  }

  Widget buildHome() {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  PreferredSizeWidget buildAppBar() {
    return AppBar(
        title: Text(modelPath ?? 'No model loaded'),
        leading: IconButton(
          icon: const Icon(Icons.folder_open),
          onPressed: loadModel,
        ));
  }

  Widget buildBody() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              final message = messages[index];
              return ListTile(
                title: Text(message.role),
                subtitle: Text(message.content),
              );
            },
          ),
        ),
        buildInputField(),
      ],
    );
  }

  Widget buildInputField() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: onSubmitted,
              decoration: const InputDecoration(
                labelText: 'Enter your message',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          busy
              ? IconButton(
                  icon: const Icon(Icons.stop),
                  onPressed: () => onStop(),
                )
              : IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => onSubmitted(controller.text),
                ),
        ],
      ),
    );
  }
}
