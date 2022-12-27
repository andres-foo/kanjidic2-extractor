# KanjiDic extractor

A small script to turn the basic data from KANJIDIC2 (kanjidic2.xml) into a sqlite3 database file with a single table.


## Resulting database
For reference, the resulting database is created with the following sql:
```
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
```
The fields are as follow: 

```
literal: The actual kanji character
meanings: All meanings joined by a ";" symbol
onReadings: All on readings joined by a ";" symbol
kunReadings: All kun readings joined by a ";" symbol
strokes: The number of strokes
frequency: The frequency of the kanji on the newspapers
jlpt: The JLPT value
grade: The grade value
heisg6: The value corresponding to "Remembering the kanji 6th edition"
```

## Installation and use
1.- Get the dependencies:

```dart pub get```

This script depends on the packages xml and sqlite3.

2.- Download and place the kanjidic2.xml file on the data/input/ folder so it looks like this:

```data/input/kanjidic2.xml```

You can obtain the latest version of kanjidic2.xml from the website [KANJIDIC Project](http://www.edrdg.org/wiki/index.php/KANJIDIC_Project). Make sure to download the KANJIDIC2 file.

3.- Run the script with:

```dart lib/extractor.dart```

4.- The generated sqlite database will be located at:

```/data/output/kanjis.db```

