import 'package:language_parser_desktop/persistence/entities/language_entity.dart';
import 'package:language_parser_desktop/persistence/entities/word_entity.dart';
import 'package:language_parser_desktop/persistence/repositories/language_repository.dart' as lang;
import 'package:language_parser_desktop/persistence/repositories/pos_repository.dart' as pos;
import 'package:language_parser_desktop/persistence/repositories/repository.dart';

class wrd {
  String word;
  String written;
  String pos;
  String comment;

  wrd(this.word, this.written, this.pos, this.comment);
}

class WordRepository extends Repository {
  static const select = '''
  SELECT
    language_tbl.id as language_id,
    language_tbl.display_name as language_display_name,
    language_tbl.native_name as language_native_name,
    language_tbl.comment as language_comment,
    pos_tbl.id as pos_id,
    pos_tbl.name as pos_name,
    pos_tbl.abbreviation as pos_abbreviation,
    word_tbl.id as word_id,
    word_tbl.word as word_word,
    word_tbl.comment as word_comment,
    word_tbl.forgotten_yn as word_forgotten_yn,
    word_tbl.source_type as word_source_type
  FROM word_tbl
  JOIN language_tbl ON word_tbl.language = language_tbl.id
  JOIN pos_tbl ON word_tbl.pos = pos_tbl.id
  ''';

  WordRepository(super.db);

  // Future<List<wrd>> getWords(int size, String string) async {
  //   var time = DateTime.now().millisecondsSinceEpoch;
  //   final ResultSet resultSet = string.length < 3
  //       ? db.select('SELECT * FROM word_tbl WHERE word glob ? OR written_word glob ? ORDER BY word ASC LIMIT $size ', [
  //           '*$string*',
  //           '*$string*',
  //         ])
  //       : db.select('SELECT rowid,* FROM fts5_word(?) ORDER BY length(word), rank, word ASC LIMIT ? ', [string, size]);
  //   log('Result time: ${DateTime.now().millisecondsSinceEpoch - time}');
  //   var res = (resultSet)
  //       .rows
  //       .map((row) => wrd(
  //             '${row[1]}',
  //             '${row[2]}',
  //             'n.',
  //             'Language',
  //           ))
  //       .toList(growable: false);
  //   log('Response time: ${DateTime.now().millisecondsSinceEpoch - time}');
  //   return res;
  // }
  List<Word> getAllWordByLang(int langId) {
    final resultSet = db.select('''
    $select
    WHERE ${Language.table_name}.id = $langId
    ORDER BY ${Word.table_name}.id
    ''', []);
    return (resultSet).map(convertFullEntity).toList(growable: false);
  }
}

Word convertFullEntity(row) {
  return Word(
      row['word_id'] as int,
      row['word_word'] as String,
      lang.convertNamedEntity(row),
      pos.convertNamedEntity(row),
      row['word_comment'] as String?,
      row['word_forgotten_yn'] == 0 ? false : true,
      row['word_source_type'] as String);
}
