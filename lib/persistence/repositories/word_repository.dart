import 'package:language_parser_desktop/persistence/entities/language_entity.dart';
import 'package:language_parser_desktop/persistence/entities/word_entity.dart';
import 'package:language_parser_desktop/persistence/entities/word_list.dart';
import 'package:language_parser_desktop/persistence/repositories/language_repository.dart' as lang;
import 'package:language_parser_desktop/persistence/repositories/pos_repository.dart' as pos;
import 'package:language_parser_desktop/persistence/repositories/repository.dart';

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

  List<WordList> getWords(int size, String string) {
    final query = string.trim();
    final resultSet = query.isEmpty
        ? db.select('''
    $select
    ORDER BY ${Word.table_name}.word ASC
    LIMIT ?
    ''', [size])
        : db.select('''
    $select
    WHERE ${Word.table_name}.word LIKE ?
       OR pos_tbl.name LIKE ?
       OR ifnull(${Word.table_name}.comment, '') LIKE ?
       OR language_tbl.display_name LIKE ?
    ORDER BY ${Word.table_name}.word ASC
    LIMIT ?
    ''', ['%$query%', '%$query%', '%$query%', '%$query%', size]);

    return resultSet.map((row) => WordList(convertFullEntity(row))).toList(growable: false);
  }

  List<Word> getAllWordByLang(int langId) {
    final resultSet = db.select('''
    $select
    WHERE ${Language.table_name}.id = $langId
    ORDER BY ${Word.table_name}.id
    ''', []);
    return (resultSet).map(convertFullEntity).toList(growable: false);
  }

  Set<int> getAllPosIDsByLang(int langId) {
    final result = db.select("SELECT pos FROM ${Word.table_name} WHERE language = $langId GROUP BY pos");
    return (result).map((row) => row['pos'] as int).toSet();
  }

  Word save(WordCreatingModel model) {
    db.execute(
      'INSERT INTO ${Word.table_name} (word, language, pos, comment, source_type) VALUES (?,?,?,?,?);',
      [model.word, model.languageId, model.posId, model.comment, model.sourceType.dbValue],
    );
    final resultSet = db.select('''
    $select
    WHERE ${Word.table_name}.id = last_insert_rowid()
    ''', []);
    invalidate();
    return convertFullEntity(resultSet.single);
  }
}

class WordCreatingModel {
  final String word;
  final int languageId;
  final int posId;
  final String? comment;
  final WordSource sourceType;

  WordCreatingModel(this.word, this.languageId, this.posId, this.comment, this.sourceType);
}

Word convertFullEntity(row) {
  return Word(
      row['word_id'] as int,
      row['word_word'] as String,
      lang.convertNamedEntity(row),
      pos.convertNamedEntity(row),
      row['word_comment'] as String?,
      row['word_forgotten_yn'] == 0 ? false : true,
      WordSource.fromDb(row['word_source_type'] as String));
}
