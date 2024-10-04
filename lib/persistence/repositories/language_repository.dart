import 'package:language_parser_desktop/features/language/language_creating.dart';
import 'package:language_parser_desktop/persistence/entities/language_entity.dart';
import 'package:language_parser_desktop/persistence/repositories/repository.dart';

class LanguageRepository extends Repository {
  LanguageRepository(super.db);

  List<Language> getAll() {
    final resultSet = db.select('SELECT * FROM ${Language.table_name} ORDER BY id', []);
    return (resultSet).map(convertFullEntity).toList(growable: false);
  }

  Language getById(int id) {
    final resultSet = db.select('SELECT * FROM ${Language.table_name} WHERE id = $id', []);
    return convertFullEntity(resultSet.single);
  }

  Language save(LanguageCreatingModel model) {
    db.execute(
        'INSERT INTO ${Language.table_name} (display_name) VALUES'
        '(?);',
        [model.displayName]);
    final resultSet = db.select('SELECT * from ${Language.table_name} WHERE id = last_insert_rowid();', []);
    return convertFullEntity(resultSet.single);
  }

// save
// delete

  Language convertFullEntity(row) {
    return Language(
        row['id'] as int, row['display_name'] as String, row['native_name'] as String?, row['comment'] as String?);
  }
}
