part of 'package:lcpp/lcpp.dart';

class _Num2Words {
  static List<String> _splitIntoThrees(String str) {
    List<String> parts = [];

    for (int i = str.length; i > 0; i -= 3) {
      if (i < 3) {
        parts.add(str.substring(0, i));
      } else {
        parts.add(str.substring(i - 3, i));
      }
    }

    return parts.reversed.toList();
  }

  static String _numberToWord(int number) {
    const words = [
      "zero", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"
    ];
    return words[number];
  }

  static String _tensToWord(int tens) {
    const words = [
      "", "ten", "twenty", "thirty", "forty", "fifty", "sixty", "seventy", "eighty", "ninety"
    ];
    return words[tens];
  }

  static String _teensToWord(int teens) {
    const words = [
      "", "eleven", "twelve", "thirteen", "fourteen", "fifteen", "sixteen", "seventeen", "eighteen", "nineteen"
    ];
    return words[teens - 10];
  }

  static List<String> _hundredsToWords(int hundreds) {
    int hundredsDigit = hundreds ~/ 100;
    int tensDigit = (hundreds % 100) ~/ 10;
    int onesDigit = hundreds % 10;
    List<String> result = [];

    if (hundredsDigit > 0) {
      result.add(_numberToWord(hundredsDigit));
      result.add("hundred");
      if (tensDigit > 0 || onesDigit > 0) {
        result.add("and");
      }
    }

    if (tensDigit > 1) {
      result.add(_tensToWord(tensDigit));
    } else if (tensDigit == 1 && onesDigit > 0) {
      result.add(_teensToWord(hundreds % 100));
      return result;
    }

    if (onesDigit > 0 && tensDigit != 1) {
      result.add(_numberToWord(onesDigit));
    }

    return result;
  }

  static String process(String text) {
    const suffixes = [
      "thousand", "million", "billion", "trillion", "quadrillion", "quintillion",
      "sextillion", "septillion", "octillion", "nonillion", "decillion"
    ];

    List<String> parts = _splitIntoThrees(text);
    List<String> result = [];

    for (int i = 0; i < parts.length; i++) {
      int number = int.parse(parts[i]);
      List<String> words = _hundredsToWords(number);
      result.addAll(words);

      if (i < suffixes.length && i < parts.length - 1) {
        int suffixIndex = parts.length - i - 2;
        result.add(suffixes[suffixIndex]);
      }
    }

    return result.join(" ");
  }
}