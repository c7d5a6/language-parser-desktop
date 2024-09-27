import 'dart:developer';
import 'dart:math' show Random;

import 'package:sqlite3/sqlite3.dart';

class wrd_u {
  String word;
  String written;
  String pos;
  String comment;

  wrd_u(this.word, this.written, this.pos, this.comment);
}

var poses = ['n.', 'v.', 'adj.', 'pn.'];
var languages = [
  'Náirlanska',
  'Náirlanska, Middle',
  'Náirlanska, Old',
  'Ñizoles',
  'Ñizoles, Middle',
  'Ñizoles, Old',
  'Orkish',
  'PIE',
  'Queran',
  'Runic'
];

List<wrd_u> generateWords(int size) {
  List<wrd_u> result = [];
  for (int i = 0; i < size; i++) {
    var pos = poses[Random().nextInt(poses.length)];
    var ln = languages[Random().nextInt(languages.length)];
    var comment = 'from $ln';
    var word = generateWord();
    var written = writtenWord(word);
    result.add(wrd_u(word, '${written[0].toUpperCase()}${written.substring(1)}', pos, comment));
  }
  return result;
}

String generateWord() {
  var starting = ['dr', 'sn', 'ɡr', 'd', 'h', 'j', 'l', 'm', 'n', 'p', 's', 't', 'w', 'ʍ', 'β', 'θ', 'iː', 'a', ''];
  var clust = [
    'jsk',
    'dr',
    'ɡr',
    'jsk',
    'sɡl',
    'dr',
    'lb',
    'lt',
    'nb',
    'nj',
    'nt',
    'pt',
    'rp',
    'rs',
    'rt',
    'sk',
    'sn',
    'st',
    'wh',
    'zb',
    'ŋk',
    'ɡn',
    'ɡr',
    'd',
    'h',
    'j',
    'l',
    'm',
    'n',
    'p',
    'r',
    's',
    't',
    'w',
    'z',
    'ð',
    'ɣ',
    'ʍ',
    'β',
    'θ',
    'ɸ',
    'kʷ',
    'ɡʷ',
    'χ'
  ];
  var cluv = ['aː', 'ia', 'iu', 'iː', 'oː', 'ɛː', 'a', 'i', 'u', 'ɔ', 'ɛ', 'eː', 'uː', 'ɔː'];
  var endingC = ['r', 's', 'z', 'ð'];
  var endingV = ['i'];
  var word = starting[Random().nextInt(starting.length)];
  while (word.length < Random().nextInt(15)) {
    word = word + cluv[Random().nextInt(cluv.length)];
    word = word + clust[Random().nextInt(clust.length)];
  }
  if (Random().nextInt(2) == 0) {
    word = word + cluv[Random().nextInt(cluv.length)];
    word = word + endingC[Random().nextInt(endingC.length)];
  } else {
    word = word + endingV[Random().nextInt(endingV.length)];
  }
  return word;
}

String writtenWord(String word) {
  return word
      .replaceAll('aː', 'ā')
      .replaceAll('ɛː(?=[iyuɛɔaeo])', 'ai')
      .replaceAll('ɛː', 'ái')
      .replaceAll('ɛ', 'aí')
      .replaceAll('ɔː(?=[iyuɛɔaeo])', 'au')
      .replaceAll('ɔː', 'áu')
      .replaceAll('ɔ', 'aú')
      .replaceAll('eː', 'ē')
      .replaceAll('iː', 'ei')
      .replaceAll('oː', 'ō')
      .replaceAll('uː', 'ū')
      .replaceAll('β', 'b')
      .replaceAll('ð', 'd')
      .replaceAll('ɸ', 'f')
      .replaceAll('ɣ', 'ɡ')
      .replaceAll('x', 'ɡ')
      .replaceAll('ŋ', 'ɡ')
      .replaceAll('n(?=[kɡ])', 'ɡ')
      .replaceAll('hʷ', 'ƕ')
      .replaceAll('ʍ', 'ƕ')
      .replaceAll('kʷ', 'q')
      .replaceAll('θ', 'þ')
      .replaceAll('ɡʷ', 'ɡw')
      .replaceAll('ɡ', 'g');
}

// θuntɔːɣi
//
Future<void> generateSQL(Database database) async {
  log('Using sqlite3 ${sqlite3.version}');

  final db = sqlite3.copyIntoMemory(database);
  db.execute('''
    DROP TABLE IF EXISTS word_tbl;
    CREATE TABLE word_tbl (
      id INTEGER NOT NULL PRIMARY KEY,
      word TEXT NOT NULL,
      written_word TEXT NOT NULL
    );
    CREATE INDEX words_idx ON word_tbl (word, written_word);
    CREATE VIRTUAL TABLE fts5_word USING fts5(word, written_word, content='word_tbl', content_rowid='id', tokenize="trigram case_sensitive 0 remove_diacritics 1");
    CREATE TRIGGER tbl_ai AFTER INSERT ON word_tbl BEGIN  
      INSERT INTO fts5_word(rowid, word, written_word) VALUES (new.id, new.word, new.written_word);  
    END;
  ''');
  log('created db');

  // Prepare a statement to run it multiple times:
  final stmt = db.prepare('INSERT INTO word_tbl (word, written_word) VALUES (?,?)');
  for (int i = 0; i < 1000; i++) {
    if (i % 100 == 0) log("Generated $i");
    var word = generateWord();
    stmt.execute([word, writtenWord(word)]);
  }
  log('statements executed');

  // Dispose a statement when you don't need it anymore to clean up resources.
  stmt.dispose();

  // Use the database
  // var backUp = sqlite3.open('temp.sqlt3');
  await db.backup(database, nPage: -1).drain();
  db.dispose();
}
