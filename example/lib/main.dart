import 'dart:io';

import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:lcpp/lcpp.dart';

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
        allowCompression: false);

    if (result == null ||
        result.files.isEmpty ||
        result.files.single.path == null) {
      throw Exception('No file selected');
    }

    File resultFile = File(result.files.single.path!);

    final exists = await resultFile.exists();
    if (!exists) {
      throw Exception('File does not exist');
    }

    final llamaCpp = Llama(
        llamaParams: LlamaParams(chatModel: resultFile),
        contextParams: ContextParams(nCtx: 2048, nBatch: 2048),
        samplingParams: const SamplingParams(greedy: true));

    setState(() {
      model = llamaCpp;
      modelPath = result.files.single.path;
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
