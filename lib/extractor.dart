import 'dart:io';
import 'package:xml/xml.dart';
import 'package:sqlite3/sqlite3.dart';

void main() async {
  final outputFile = 'data/output/kanji.db';
  final inputFile = 'data/input/kanjidic2.xml';
  final separator = ';';

  // database
  var file = File(outputFile);
  if (file.existsSync()) file.deleteSync();

  final db = sqlite3.open(outputFile);
  db.execute('''
    CREATE TABLE IF NOT EXISTS kanjis  (
      literal TEXT NOT NULL PRIMARY KEY,
      meanings TEXT NOT NULL,
      onReadings TEXT NULL,
      kunReadings TEXT NULL,
      strokes INTEGER NULL,
      frequency INTEGER NULL,
      jlpt INTEGER NULL,
      grade INTEGER NULL,
      heisg6 INTEGER NULL
    );
  ''');
  // will contain the whole sql
  String sql = "INSERT INTO kanjis ";
  sql +=
      "(literal, meanings, onReadings, kunReadings, strokes, frequency, jlpt, grade, heisg6) VALUES ";

  File(inputFile).readAsString().then((String contents) {
    var document = XmlDocument.parse(contents);

    var characters = document.findAllElements('character');
    print("There are ${characters.length} characters");
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
      var strokes = strokes_.isEmpty ? 'null' : strokes_.first.text;

      // grade
      var grade_ = character.findAllElements('grade');
      var grade = grade_.isEmpty ? 'null' : grade_.single.text;

      // frequency
      var freq_ = character.findAllElements('freq');
      var freq = freq_.isEmpty ? 'null' : freq_.single.text;

      // jlpt
      var jlpt_ = character.findAllElements('jlpt');
      var jlpt = jlpt_.isEmpty ? 'null' : jlpt_.single.text;

      // remembering the kanji 6
      var heisig6_ = character
          .findAllElements('dic_ref')
          .where((node) => node.attributes.first.value == "heisig6");
      var heisig6 = heisig6_.isEmpty ? 'null' : heisig6_.single.text;

      // add to sql
      sql +=
          "('$literal', '$meanings', '$onReadings', '$kunReadings', $strokes, $freq, $jlpt, $grade, $heisig6),";

      // test
      if (i > 10) {
        sql = sql.substring(0, sql.length - 1);
        print(sql);
        db.execute(sql);
        // close db
        db.dispose();
        exit(1);
      }
    } //for
  });
}
