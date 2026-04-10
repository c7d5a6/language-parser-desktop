import 'package:language_parser_desktop/persistence/entities/language_entity.dart';
import 'package:language_parser_desktop/persistence/entities/word_entity.dart';
import 'package:language_parser_desktop/persistence/entities/word_list.dart';
import 'package:language_parser_desktop/persistence/repositories/language_repository.dart' as lang;
import 'package:language_parser_desktop/persistence/repositories/pos_repository.dart' as pos;
import 'package:language_parser_desktop/persistence/repositories/repository.dart';

class WordPageResult {
  final List<WordListItem> words;
  final int totalCount;

  WordPageResult(this.words, this.totalCount);
}

class WordRepository extends Repository {
  /// Shared projection for [Word] + language + pos (same aliases as before).
  static const _wordListColumns = '''
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
''';

  static const selectWithLangAndPos = '''
SELECT
$_wordListColumns
  FROM word_tbl
  JOIN language_tbl ON word_tbl.language = language_tbl.id
  JOIN pos_tbl ON word_tbl.pos = pos_tbl.id
  ''';

  /// FTS5 path: [rank] is FTS5’s hidden relevance column (default = bm25; lower is better).
  /// It only exists when the virtual table is in the FROM clause with MATCH — not inside `IN (SELECT rowid…)`.
  static const _selectWithLangAndPosFts = '''
SELECT
$_wordListColumns
  FROM fts5_word
  JOIN word_tbl ON word_tbl.id = fts5_word.rowid
  JOIN language_tbl ON word_tbl.language = language_tbl.id
  JOIN pos_tbl ON word_tbl.pos = pos_tbl.id
  WHERE fts5_word MATCH ?
  ORDER BY length(word_tbl.word), rank, word_tbl.word ASC
  ''';

  WordRepository(super.db);

  /// Match legacy behavior: short queries use `GLOB` on `word`; longer queries use FTS5.
  static const int _ftsMinQueryLength = 3;

  static const _countSelect = '''
  SELECT COUNT(*) as cnt
  FROM word_tbl
  JOIN language_tbl ON word_tbl.language = language_tbl.id
  JOIN pos_tbl ON word_tbl.pos = pos_tbl.id
  ''';

  /// Glob pattern `*query*` with `*`, `?`, `[` escaped for SQLite GLOB.
  static String globPattern(String raw) {
    final escaped = raw.replaceAll('[', '[[]').replaceAll('*', '[*]').replaceAll('?', '[?]');
    return '*$escaped*';
  }

  /// Basic escaping for double quotes inside FTS5 MATCH string literals.
  static String ftsMatchToken(String raw) {
    return raw.replaceAll('"', '""');
  }

  int countWords(String string) {
    final query = string.trim();
    if (query.isEmpty) {
      final r = db.select(_countSelect, []);
      return r.first['cnt'] as int;
    }
    if (query.length < _ftsMinQueryLength) {
      final r = db.select(
        '''
$_countSelect
WHERE ${Word.table_name}.word GLOB ?
''',
        [globPattern(query)],
      );
      return r.first['cnt'] as int;
    }
    final r = db.select(
      '''
$_countSelect
WHERE ${Word.table_name}.id IN (
  SELECT rowid FROM fts5_word WHERE fts5_word MATCH ?
)
''',
      [ftsMatchToken(query)],
    );
    return r.first['cnt'] as int;
  }

  WordPageResult getWordsPage(int limit, int offset, String string) {
    final query = string.trim();
    final totalCount = countWords(string);
    final resultSet = query.isEmpty
        ? db.select(
            '''
$selectWithLangAndPos
ORDER BY ${Word.table_name}.word ASC
LIMIT ? OFFSET ?
''',
            [limit, offset],
          )
        : query.length < _ftsMinQueryLength
            ? db.select(
                '''
$selectWithLangAndPos
WHERE ${Word.table_name}.word GLOB ?
ORDER BY ${Word.table_name}.word ASC
LIMIT ? OFFSET ?
''',
                [globPattern(query), limit, offset],
              )
            : db.select(
                '''
$_selectWithLangAndPosFts
LIMIT ? OFFSET ?
''',
                [ftsMatchToken(query), limit, offset],
              );

    final words = resultSet.map((row) => WordListItem(convertFullEntity(row))).toList(growable: false);
    return WordPageResult(words, totalCount);
  }

  List<WordListItem> getWords(int size, String string) {
    final query = string.trim();
    final resultSet = query.isEmpty
        ? db.select(
            '''
$selectWithLangAndPos
ORDER BY ${Word.table_name}.word ASC
LIMIT ?
''',
            [size],
          )
        : query.length < _ftsMinQueryLength
            ? db.select(
                '''
$selectWithLangAndPos
WHERE ${Word.table_name}.word GLOB ?
ORDER BY ${Word.table_name}.word ASC
LIMIT ?
''',
                [globPattern(query), size],
              )
            : db.select(
                '''
$_selectWithLangAndPosFts
LIMIT ?
''',
                [ftsMatchToken(query), size],
              );

    return resultSet.map((row) => WordListItem(convertFullEntity(row))).toList(growable: false);
  }

  List<Word> getAllWordByLang(int langId) {
    final resultSet = db.select('''
    $selectWithLangAndPos
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
    db.execute('INSERT INTO ${Word.table_name} (word, language, pos, comment, source_type) VALUES (?,?,?,?,?);', [
      model.word,
      model.languageId,
      model.posId,
      model.comment,
      model.sourceType.dbValue,
    ]);
    final resultSet = db.select('''
    $selectWithLangAndPos
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
    WordSource.fromDb(row['word_source_type'] as String),
  );
}
