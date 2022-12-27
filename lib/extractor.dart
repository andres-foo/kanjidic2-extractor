import 'dart:io';
import 'package:xml/xml.dart';

void main() async {
  final outputFile = 'data/output/kanji.sql';
  final inputFile = 'data/input/kanjidic2.xml';
  final separator = ',';

  File(inputFile).readAsString().then((String contents) {
    var document = XmlDocument.parse(contents);

    var characters = document.findAllElements('character');
    int i = 0;
    for (var character in characters) {
      i++;
      // the character
      var literal = character.findElements('literal').single.text;
      print(literal);

      // meanings
      var meanings = character
          .findAllElements('meaning')
          .where((node) => node.attributes.isEmpty)
          .map((node) => node.text)
          .join(separator);

      // on readings
      var onReadings = character
          .findAllElements('reading')
          .where((node) => node.attributes.first.value == "ja_on")
          .map((node) => node.text)
          .join(separator);

      // kun readings
      var kunReadings = character
          .findAllElements('reading')
          .where((node) => node.attributes.first.value == "ja_kun")
          .map((node) => node.text)
          .join(separator);

      // grade
      var grade_ = character.findAllElements('grade');
      var grade = grade_.isEmpty ? '-' : grade_.single.text;

      // frequency
      var freq_ = character.findAllElements('freq');
      var freq = freq_.isEmpty ? '-' : freq_.single.text;

      // jlpt
      var jlpt_ = character.findAllElements('jlpt');
      var jlpt = jlpt_.isEmpty ? '-' : jlpt_.single.text;

      // remembering the kanji 6
      var heisig6_ = character
          .findAllElements('dic_ref')
          .where((node) => node.attributes.first.value == "heisig6");
      var heisig6 = heisig6_.isEmpty ? '-' : heisig6_.single.text;
      print(heisig6);

      // test
      if (i > 3) exit(1);
    }
  });
}
