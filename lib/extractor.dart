import 'dart:io';
import 'package:xml/xml.dart';
import 'package:sqlite3/sqlite3.dart';

void main() async {
  final outputFile = 'data/output/kanji.db';
  final inputFile = 'data/input/kanjidic2.xml';
  final separator = ';';

  // database
  final db = sqlite3.open(outputFile);
  db.dispose();

  File(inputFile).readAsString().then((String contents) {
    var document = XmlDocument.parse(contents);

    var characters = document.findAllElements('character');
    int i = 0;
    for (var character in characters) {
      i++;
      // the character
      var literal = character.findElements('literal').single.text;

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

      // strokes
      var strokes_ = character.findAllElements('stroke_count');
      var strokes = strokes_.isEmpty ? '-' : strokes_.single.text;

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

      // CHECK OUTPUT
      // literal
      print('Character: ' + literal);
      // meanings
      print('meanings: ' + meanings);
      // readings
      print('on readings: ' + onReadings);
      print('kun readings: ' + kunReadings);
      // metadata
      print('strokes: ' + strokes);
      print('grade: ' + grade);
      print('frequency: ' + freq);
      print('jlpt: ' + jlpt);
      print('heisig6: ' + heisig6);

      // test
      if (i > 3) exit(1);
    }
  });
}
