import 'dart:io';

import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:lcpp/lcpp.dart';

void main() {
  runApp(const LlamaApp());
}

class LlamaApp extends StatefulWidget {
  const LlamaApp({super.key});

  @override
  State<LlamaApp> createState() => LlamaAppState();
}

const String enMale1 = '''
{
  "text": "The overall package from just two people is pretty remarkable. Sure I have some critiques about some of the gameplay aspects, but it's still really enjoyable and it looks lovely.",
  "words": [
    {
      "word": "the",
      "duration": 0.08,
      "codes": [
        257,
        740,
        636,
        913,
        788,
        1703
      ]
    },
    {
      "word": "overall",
      "duration": 0.36,
      "codes": [
        127,
        201,
        191,
        774,
        700,
        532,
        1056,
        557,
        798,
        298,
        1741,
        747,
        1662,
        1617,
        1702,
        1527,
        368,
        1588,
        1049,
        1008,
        1625,
        747,
        1576,
        728,
        1019,
        1696,
        1765
      ]
    },
    {
      "word": "package",
      "duration": 0.56,
      "codes": [
        935,
        584,
        1319,
        627,
        1016,
        1491,
        1344,
        1117,
        1526,
        1040,
        239,
        1435,
        951,
        498,
        723,
        1180,
        535,
        789,
        1649,
        1637,
        78,
        465,
        1668,
        901,
        595,
        1675,
        117,
        1009,
        1667,
        320,
        840,
        79,
        507,
        1762,
        1508,
        1228,
        1768,
        802,
        1450,
        1457,
        232,
        639
      ]
    },
    {
      "word": "from",
      "duration": 0.19,
      "codes": [
        604,
        782,
        1682,
        872,
        1532,
        1600,
        1036,
        1761,
        647,
        1554,
        1371,
        653,
        1595,
        950
      ]
    },
    {
      "word": "just",
      "duration": 0.25,
      "codes": [
        1782,
        1670,
        317,
        786,
        1748,
        631,
        599,
        1155,
        1364,
        1524,
        36,
        1591,
        889,
        1535,
        541,
        440,
        1532,
        50,
        870
      ]
    },
    {
      "word": "two",
      "duration": 0.24,
      "codes": [
        1681,
        1510,
        673,
        799,
        805,
        1342,
        330,
        519,
        62,
        640,
        1138,
        565,
        1552,
        1497,
        1552,
        572,
        1715,
        1732
      ]
    },
    {
      "word": "people",
      "duration": 0.39,
      "codes": [
        593,
        274,
        136,
        740,
        691,
        633,
        1484,
        1061,
        1138,
        1485,
        344,
        428,
        397,
        1562,
        645,
        917,
        1035,
        1449,
        1669,
        487,
        442,
        1484,
        1329,
        1832,
        1704,
        600,
        761,
        653,
        269
      ]
    },
    {
      "word": "is",
      "duration": 0.16,
      "codes": [
        566,
        583,
        1755,
        646,
        1337,
        709,
        802,
        1008,
        485,
        1583,
        652,
        10
      ]
    },
    {
      "word": "pretty",
      "duration": 0.32,
      "codes": [
        1818,
        1747,
        692,
        733,
        1010,
        534,
        406,
        1697,
        1053,
        1521,
        1355,
        1274,
        816,
        1398,
        211,
        1218,
        817,
        1472,
        1703,
        686,
        13,
        822,
        445,
        1068
      ]
    },
    {
      "word": "remarkable",
      "duration": 0.68,
      "codes": [
        230,
        1048,
        1705,
        355,
        706,
        1149,
        1535,
        1787,
        1356,
        1396,
        835,
        1583,
        486,
        1249,
        286,
        937,
        1076,
        1150,
        614,
        42,
        1058,
        705,
        681,
        798,
        934,
        490,
        514,
        1399,
        572,
        1446,
        1703,
        1346,
        1040,
        1426,
        1304,
        664,
        171,
        1530,
        625,
        64,
        1708,
        1830,
        1030,
        443,
        1509,
        1063,
        1605,
        1785,
        721,
        1440,
        923
      ]
    },
    {
      "word": "sure",
      "duration": 0.36,
      "codes": [
        792,
        1780,
        923,
        1640,
        265,
        261,
        1525,
        567,
        1491,
        1250,
        1730,
        362,
        919,
        1766,
        543,
        1,
        333,
        113,
        970,
        252,
        1606,
        133,
        302,
        1810,
        1046,
        1190,
        1675
      ]
    },
    {
      "word": "i",
      "duration": 0.08,
      "codes": [
        123,
        439,
        1074,
        705,
        1799,
        637
      ]
    },
    {
      "word": "have",
      "duration": 0.16,
      "codes": [
        1509,
        599,
        518,
        1170,
        552,
        1029,
        1267,
        864,
        419,
        143,
        1061,
        0
      ]
    },
    {
      "word": "some",
      "duration": 0.16,
      "codes": [
        619,
        400,
        1270,
        62,
        1370,
        1832,
        917,
        1661,
        167,
        269,
        1366,
        1508
      ]
    },
    {
      "word": "critiques",
      "duration": 0.6,
      "codes": [
        559,
        584,
        1163,
        1129,
        1313,
        1728,
        721,
        1146,
        1093,
        577,
        928,
        27,
        630,
        1080,
        1346,
        1337,
        320,
        1382,
        1175,
        1682,
        1556,
        990,
        1683,
        860,
        1721,
        110,
        786,
        376,
        1085,
        756,
        1523,
        234,
        1334,
        1506,
        1578,
        659,
        612,
        1108,
        1466,
        1647,
        308,
        1470,
        746,
        556,
        1061
      ]
    },
    {
      "word": "about",
      "duration": 0.29,
      "codes": [
        26,
        1649,
        545,
        1367,
        1263,
        1728,
        450,
        859,
        1434,
        497,
        1220,
        1285,
        179,
        755,
        1154,
        779,
        179,
        1229,
        1213,
        922,
        1774,
        1408
      ]
    },
    {
      "word": "some",
      "duration": 0.23,
      "codes": [
        986,
        28,
        1649,
        778,
        858,
        1519,
        1,
        18,
        26,
        1042,
        1174,
        1309,
        1499,
        1712,
        1692,
        1516,
        1574
      ]
    },
    {
      "word": "of",
      "duration": 0.07,
      "codes": [
        197,
        716,
        1039,
        1662,
        64
      ]
    },
    {
      "word": "the",
      "duration": 0.08,
      "codes": [
        1811,
        1568,
        569,
        886,
        1025,
        1374
      ]
    },
    {
      "word": "gameplay",
      "duration": 0.48,
      "codes": [
        1269,
        1092,
        933,
        1362,
        1762,
        1700,
        1675,
        215,
        781,
        1086,
        461,
        838,
        1022,
        759,
        649,
        1416,
        1004,
        551,
        909,
        787,
        343,
        830,
        1391,
        1040,
        1622,
        1779,
        1360,
        1231,
        1187,
        1317,
        76,
        997,
        989,
        978,
        737,
        189
      ]
    },
    {
      "word": "aspects",
      "duration": 0.56,
      "codes": [
        1423,
        797,
        1316,
        1222,
        147,
        719,
        1347,
        386,
        1390,
        1558,
        154,
        440,
        634,
        592,
        1097,
        1718,
        712,
        763,
        1118,
        1721,
        1311,
        868,
        580,
        362,
        1435,
        868,
        247,
        221,
        886,
        1145,
        1274,
        1284,
        457,
        1043,
        1459,
        1818,
        62,
        599,
        1035,
        62,
        1649,
        778
      ]
    },
    {
      "word": "but",
      "duration": 0.2,
      "codes": [
        780,
        1825,
        1681,
        1007,
        861,
        710,
        702,
        939,
        1669,
        1491,
        613,
        1739,
        823,
        1469,
        648
      ]
    },
    {
      "word": "its",
      "duration": 0.09,
      "codes": [
        92,
        688,
        1623,
        962,
        1670,
        527,
        599
      ]
    },
    {
      "word": "still",
      "duration": 0.27,
      "codes": [
        636,
        10,
        1217,
        344,
        713,
        957,
        823,
        154,
        1649,
        1286,
        508,
        214,
        1760,
        1250,
        456,
        1352,
        1368,
        921,
        615,
        5
      ]
    },
    {
      "word": "really",
      "duration": 0.36,
      "codes": [
        55,
        420,
        1008,
        1659,
        27,
        644,
        1266,
        617,
        761,
        1712,
        109,
        1465,
        1587,
        503,
        1541,
        619,
        197,
        1019,
        817,
        269,
        377,
        362,
        1381,
        507,
        1488,
        4,
        1695
      ]
    },
    {
      "word": "enjoyable",
      "duration": 0.49,
      "codes": [
        678,
        501,
        864,
        319,
        288,
        1472,
        1341,
        686,
        562,
        1463,
        619,
        1563,
        471,
        911,
        730,
        1811,
        1006,
        520,
        861,
        1274,
        125,
        1431,
        638,
        621,
        153,
        876,
        1770,
        437,
        987,
        1653,
        1109,
        898,
        1285,
        80,
        593,
        1709,
        843
      ]
    },
    {
      "word": "and",
      "duration": 0.15,
      "codes": [
        1285,
        987,
        303,
        1037,
        730,
        1164,
        502,
        120,
        1737,
        1655,
        1318
      ]
    },
    {
      "word": "it",
      "duration": 0.09,
      "codes": [
        848,
        1366,
        395,
        1601,
        1513,
        593,
        1302
      ]
    },
    {
      "word": "looks",
      "duration": 0.27,
      "codes": [
        1281,
        1266,
        1755,
        572,
        248,
        1751,
        1257,
        695,
        1380,
        457,
        659,
        585,
        1315,
        1105,
        1776,
        736,
        24,
        736,
        654,
        1027
      ]
    },
    {
      "word": "lovely",
      "duration": 0.56,
      "codes": [
        634,
        596,
        1766,
        1556,
        1306,
        1285,
        1481,
        1721,
        1123,
        438,
        1246,
        1251,
        795,
        659,
        1381,
        1658,
        217,
        1772,
        562,
        952,
        107,
        1129,
        1112,
        467,
        550,
        1079,
        840,
        1615,
        1469,
        1380,
        168,
        917,
        836,
        1827,
        437,
        583,
        67,
        595,
        1087,
        1646,
        1493,
        1677
      ]
    }
  ],
  "language": "en"
}
''';

class LlamaAppState extends State<LlamaApp> {
  final TextEditingController controller = TextEditingController();
  final List<ChatMessage> messages = [];
  Llama? model;
  String? modelPath;
  bool busy = false;

  void loadModel() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
        dialogTitle: "Load Chat Model File",
        type: FileType.any,
        allowMultiple: false,
        allowCompression: false);

    if (result == null ||
        result.files.isEmpty ||
        result.files.single.path == null) {
      throw Exception('No file selected');
    }

    final chatModel = File(result.files.single.path!);

    final chatModelExists = await chatModel.exists();
    if (!chatModelExists) {
      throw Exception('File does not exist');
    }

    result = await FilePicker.platform.pickFiles(
        dialogTitle: "Load TTC Model File",
        type: FileType.any,
        allowMultiple: false,
        allowCompression: false);

    if (result == null ||
        result.files.isEmpty ||
        result.files.single.path == null) {
      throw Exception('No file selected');
    }

    final ttcModel = File(result.files.single.path!);

    final ttcModelExists = await ttcModel.exists();
    if (!ttcModelExists) {
      throw Exception('File does not exist');
    }

    result = await FilePicker.platform.pickFiles(
        dialogTitle: "Load CTS Model File",
        type: FileType.any,
        allowMultiple: false,
        allowCompression: false);

    if (result == null ||
        result.files.isEmpty ||
        result.files.single.path == null) {
      throw Exception('No file selected');
    }

    final ctsModel = File(result.files.single.path!);

    final ctsModelExists = await ctsModel.exists();
    if (!ctsModelExists) {
      throw Exception('File does not exist');
    }

    final llamaCpp = Llama(
      chatParams: LlamaChatParams(
        chatModel: chatModel,
        greedy: true,
      ),
      ttsParams: LlamaTtsParams(
        ttcModel: ttcModel,
        ctsModel: ctsModel,
        voice: VoiceData.fromJson(enMale1),
      )
    );

    setState(() {
      model = llamaCpp;
      modelPath = 'ChatModel: $chatModelExists, TtcModel: $ttcModelExists, CtsModel: $ctsModelExists';
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

    final wavBytes = await model!.tts(messages.last.content);

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
