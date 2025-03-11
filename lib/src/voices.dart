part of 'package:lcpp/lcpp.dart';

enum Voices {
  enFemale1('en_female_1'),
  enFemale2('en_female_2'),
  enMale1('en_male_1'),
  enMale2('en_male_2'),
  enMale3('en_male_3'),
  enMale4('en_male_4'),
  jaFemale1('ja_female_1'),
  jaFemale2('ja_female_2'),
  jaFemale3('ja_female_3'),
  jaMale1('js_male_1'),
  koFemale1('ko_female_1'),
  koFemale2('ko_female_2'),
  koMale1('ko_male_1'),
  koMale2('ko_male_2'),
  zhFemale1('zh_female_1'),
  zhMale1('zh_male_1');

  final String name;

  const Voices(this.name);

  Future<File> get file async {
    final json = await rootBundle.loadString('packages/lcpp/voices/$name.json');

    final tempDir = await getTemporaryDirectory();
    final outputPath = '${tempDir.path}/$name.json';

    final file = File(outputPath);
    await file.writeAsString(json);

    return file;
  }

  static List<Voices> localeVoices(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return [
          enFemale1,
          enFemale2,
          enMale1,
          enMale2,
          enMale3,
          enMale4,
        ];
      case 'ja':
        return [
          jaFemale1,
          jaFemale2,
          jaFemale3,
          jaMale1,
        ];
      case 'ko':
        return [
          koFemale1,
          koFemale2,
          koMale1,
          koMale2,
        ];
      case 'zh':
        return [
          zhFemale1,
          zhMale1,
        ];
      default:
        return [];
    }
  }
}