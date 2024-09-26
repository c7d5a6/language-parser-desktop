import 'dart:developer';

import 'package:language_parser_desktop/persistence/repository.dart';
import 'package:sqlite3/common.dart';

class wrd {
  String word;
  String written;
  String pos;
  String comment;

  wrd(this.word, this.written, this.pos, this.comment);
}

class WordRepository extends Repository {
  WordRepository(super.db);

  Future<List<wrd>> getWords(int size, String string) async {
    var time = DateTime.now().millisecondsSinceEpoch;
    final ResultSet resultSet = string.length < 3
        ? db.select(
            'SELECT * FROM word_tbl WHERE word glob ? OR written_word glob ? ORDER BY word ASC LIMIT $size ',
            [
                '*$string*',
                '*$string*',
              ])
        : db.select(
            'SELECT rowid,* FROM fts5_word(?) ORDER BY length(word), rank, word ASC LIMIT ? ',
            [string, size]);
    log('Result time: ${DateTime.now().millisecondsSinceEpoch - time}');
    var res = (resultSet)
        .rows
        .map((row) => wrd(
              '${row[1]}',
              '${row[2]}',
              'n.',
              'Language',
            ))
        .toList(growable: false);
    log('Response time: ${DateTime.now().millisecondsSinceEpoch - time}');
    return res;
  }
}
