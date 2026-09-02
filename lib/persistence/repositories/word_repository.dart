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
  static const _ftsOrderBy = 'ORDER BY length(word_tbl.word), rank, word_tbl.word ASC';

  static String _selectWithLangAndPosFts(String matchTail) => '''
SELECT
$_wordListColumns
  FROM fts5_word
  JOIN word_tbl ON word_tbl.id = fts5_word.rowid
  JOIN language_tbl ON word_tbl.language = language_tbl.id
  JOIN pos_tbl ON word_tbl.pos = pos_tbl.id
  WHERE fts5_word MATCH ?$matchTail
  $_ftsOrderBy
  ''';

  /// SQL `AND word_tbl.language = ?` / `AND word_tbl.pos = ?` for FTS `WHERE` (after `MATCH ?`).
  static String _wordTableFilterSuffix(int? languageId, int? posId) {
    final b = StringBuffer();
    if (languageId != null) {
      b.write(' AND ${Word.table_name}.language = ?');
    }
    if (posId != null) {
      b.write(' AND ${Word.table_name}.pos = ?');
    }
    return b.toString();
  }

  /// `word_tbl.language = ?` [AND `word_tbl.pos = ?`] for standalone `WHERE` / `AND` clauses.
  static String _wordTableFilterConditions(int? languageId, int? posId) {
    final parts = <String>[];
    if (languageId != null) {
      parts.add('${Word.table_name}.language = ?');
    }
    if (posId != null) {
      parts.add('${Word.table_name}.pos = ?');
    }
    return parts.join(' AND ');
  }

  static List<Object> _wordTableFilterArgs(int? languageId, int? posId) {
    final a = <Object>[];
    if (languageId != null) {
      a.add(languageId);
    }
    if (posId != null) {
      a.add(posId);
    }
    return a;
  }

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

  /// FTS5 MATCH string literal. Quotes the query so operators are not parsed.
  static String ftsMatchToken(String raw) {
    return '"${raw.replaceAll('"', '""')}"';
  }

  int countWords(String string, {int? languageId, int? posId}) {
    final query = string.trim();
    final filt = _wordTableFilterConditions(languageId, posId);
    final filtArgs = _wordTableFilterArgs(languageId, posId);
    if (query.isEmpty) {
      final r = filt.isEmpty
          ? db.select(_countSelect, [])
          : db.select(
              '$_countSelect WHERE $filt',
              filtArgs,
            );
      return r.first['cnt'] as int;
    }
    if (query.length < _ftsMinQueryLength) {
      final tail = filt.isEmpty ? '' : ' AND $filt';
      final r = db.select(
        '''
$_countSelect
WHERE ${Word.table_name}.word GLOB ?$tail
''',
        [globPattern(query), ...filtArgs],
      );
      return r.first['cnt'] as int;
    }
    final tail = filt.isEmpty ? '' : ' AND $filt';
    final r = db.select(
      '''
$_countSelect
WHERE ${Word.table_name}.id IN (
  SELECT rowid FROM fts5_word WHERE fts5_word MATCH ?
)$tail
''',
      [ftsMatchToken(query), ...filtArgs],
    );
    return r.first['cnt'] as int;
  }

  WordPageResult getWordsPage(int limit, int offset, String string, {int? languageId, int? posId}) {
    final query = string.trim();
    final totalCount = countWords(string, languageId: languageId, posId: posId);
    final filt = _wordTableFilterConditions(languageId, posId);
    final filtArgs = _wordTableFilterArgs(languageId, posId);
    final ftsTail = _wordTableFilterSuffix(languageId, posId);

    final resultSet = query.isEmpty
        ? filt.isEmpty
            ? db.select(
                '''
$selectWithLangAndPos
ORDER BY ${Word.table_name}.word ASC
LIMIT ? OFFSET ?
''',
                [limit, offset],
              )
            : db.select(
                '''
$selectWithLangAndPos
WHERE $filt
ORDER BY ${Word.table_name}.word ASC
LIMIT ? OFFSET ?
''',
                [...filtArgs, limit, offset],
              )
        : query.length < _ftsMinQueryLength
            ? filt.isEmpty
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
$selectWithLangAndPos
WHERE ${Word.table_name}.word GLOB ? AND $filt
ORDER BY ${Word.table_name}.word ASC
LIMIT ? OFFSET ?
''',
                    [globPattern(query), ...filtArgs, limit, offset],
                  )
            : db.select(
                '''
${_selectWithLangAndPosFts(ftsTail)}
LIMIT ? OFFSET ?
''',
                [ftsMatchToken(query), ...filtArgs, limit, offset],
              );

    final words = resultSet.map((row) => WordListItem(convertFullEntity(row))).toList(growable: false);
    return WordPageResult(words, totalCount);
  }

  List<WordListItem> getWords(int size, String string, {int? languageId, int? posId}) {
    final query = string.trim();
    final filt = _wordTableFilterConditions(languageId, posId);
    final filtArgs = _wordTableFilterArgs(languageId, posId);
    final ftsTail = _wordTableFilterSuffix(languageId, posId);

    final resultSet = query.isEmpty
        ? filt.isEmpty
            ? db.select(
                '''
$selectWithLangAndPos
ORDER BY ${Word.table_name}.word ASC
LIMIT ?
''',
                [size],
              )
            : db.select(
                '''
$selectWithLangAndPos
WHERE $filt
ORDER BY ${Word.table_name}.word ASC
LIMIT ?
''',
                [...filtArgs, size],
              )
        : query.length < _ftsMinQueryLength
            ? filt.isEmpty
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
$selectWithLangAndPos
WHERE ${Word.table_name}.word GLOB ? AND $filt
ORDER BY ${Word.table_name}.word ASC
LIMIT ?
''',
                    [globPattern(query), ...filtArgs, size],
                  )
            : db.select(
                '''
${_selectWithLangAndPosFts(ftsTail)}
LIMIT ?
''',
                [ftsMatchToken(query), ...filtArgs, size],
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
