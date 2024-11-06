import 'package:language_parser_desktop/persistence/entities/language_entity.dart';
import 'package:language_parser_desktop/persistence/repositories/repository.dart';

class LanguageCreatingModel {
  String displayName = '';

  @override
  String toString() {
    return 'Model{$displayName}';
  }
}

class LanguageUpdatingModel {
  final int id;
  final String displayName;

  LanguageUpdatingModel({required this.id, required this.displayName});
}

class LanguageRepository extends Repository {
  LanguageRepository(super.db);

  List<Language> getAll() {
    final resultSet = db.select('SELECT * FROM ${Language.table_name} ORDER BY id', []);
    return (resultSet).map(convertFullEntity).toList(growable: false);
  }

  bool exists(int id) {
    return existsInTable(id, Language.table_name);
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
    invalidate();
    return convertFullEntity(resultSet.single);
  }

  void update(LanguageUpdatingModel model) {
    db.execute('UPDATE ${Language.table_name} SET display_name = ? WHERE id = ${model.id};', [model.displayName]);
    invalidate();
  }

  void delete(int id) {
    db.execute('PRAGMA foreign_keys = ON; DELETE FROM ${Language.table_name} WHERE id = ${id};', []);
    invalidate();
  }
}

Language convertFullEntity(row) {
  return Language(
      row['id'] as int, row['display_name'] as String, row['native_name'] as String?, row['comment'] as String?);
}

Language convertNamedEntity(row) {
  return Language(row['language_id'] as int, row['language_display_name'] as String,
      row['language_native_name'] as String?, row['language_comment'] as String?);
}
