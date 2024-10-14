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

  void update(LanguageUpdatingModel model) {
    db.execute('UPDATE ${Language.table_name} SET display_name = ? WHERE id = ${model.id};', [model.displayName]);
  }

  void delete(int id) {
    db.execute('DELETE FROM ${Language.table_name} WHERE id = ${id};', []);
  }

  Language convertFullEntity(row) {
    return Language(
        row['id'] as int, row['display_name'] as String, row['native_name'] as String?, row['comment'] as String?);
  }
}
