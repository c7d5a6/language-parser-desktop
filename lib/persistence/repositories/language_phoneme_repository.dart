import 'package:language_parser_desktop/persistence/entities/language_phoneme_entity.dart';
import 'package:language_parser_desktop/persistence/repositories/repository.dart';

class LanguagePhonemeRepository extends Repository {
  LanguagePhonemeRepository(super.db);

  List<LanguagePhoneme> getAllByLang(int langId) {
    final resultSet = db.select('SELECT * FROM ${LanguagePhoneme.table_name} WHERE language = $langId ORDER BY id', []);
    return (resultSet).map(convertFullEntity).toList(growable: false);
  }

  LanguagePhoneme save(int langId, String phoneme) {
    db.execute(
        'INSERT INTO ${LanguagePhoneme.table_name} (phoneme, language) VALUES'
        '(?, ?);',
        [phoneme, langId]);
    final resultSet = db.select('SELECT * from ${LanguagePhoneme.table_name} WHERE id = last_insert_rowid();', []);
    invalidate();
    return convertFullEntity(resultSet.single);
  }

  void delete(int id) {
    db.execute('DELETE FROM ${LanguagePhoneme.table_name} WHERE id = ${id};', []);
    invalidate();
  }
}

LanguagePhoneme convertFullEntity(row) {
  return LanguagePhoneme(row['id'] as int, row['phoneme'] as String, row['language'] as int);
}
