import 'package:language_parser_desktop/persistence/entities/grammatical_category_entity.dart';
import 'package:language_parser_desktop/persistence/entities/grammatical_category_value_entity.dart';
import 'package:language_parser_desktop/persistence/repositories/repository.dart';

class GrammaticalCategoryRepository extends Repository {
  GrammaticalCategoryRepository(super.db);

  List<GrammaticalCategory> getAll() {
    final resultSet = db.select('SELECT * FROM ${GrammaticalCategory.table_name} ORDER BY id', []);
    return (resultSet).map(convertFullEntity).toList(growable: false);
  }

  GrammaticalCategory getById(int id) {
    final resultSet = db.select('SELECT * FROM ${GrammaticalCategory.table_name} WHERE id = $id', []);
    return convertFullEntity(resultSet.single);
  }

  GrammaticalCategory save(GrammaticalCategoryCreatingModel model) {
    db.execute(
        'INSERT INTO ${GrammaticalCategory.table_name} (name) VALUES'
        '(?);',
        [model.name]);
    final resultSet = db.select('SELECT * from ${GrammaticalCategory.table_name} WHERE id = last_insert_rowid();', []);
    invalidate();
    return convertFullEntity(resultSet.single);
  }

  void update(GrammaticalCategoryUpdatingModel model) {
    db.execute('UPDATE ${GrammaticalCategory.table_name} SET name = ? WHERE id = ${model.id};', [model.name]);
    invalidate();
  }

  void delete(int id) {
    db.execute('PRAGMA foreign_keys = ON; DELETE FROM ${GrammaticalCategory.table_name} WHERE id = ${id};', []);
    invalidate();
  }

  Set<int> getAllGCsIdWValues() {
    final resultSet = db.select('''
    SELECT ${GrammaticalCategory.table_name}.id AS gc_id
    FROM ${GrammaticalCategory.table_name}
    INNER JOIN ${GrammaticalCategoryValue.table_name} 
      ON ${GrammaticalCategory.table_name}.id = ${GrammaticalCategoryValue.table_name}.category_id
    GROUP BY ${GrammaticalCategory.table_name}.id 
    ''', []);
    return (resultSet).map((row) => row['gc_id'] as int).toSet();
  }
}

class GrammaticalCategoryCreatingModel {
  final String name;

  GrammaticalCategoryCreatingModel(this.name);
}

class GrammaticalCategoryUpdatingModel {
  final int id;
  final String name;

  GrammaticalCategoryUpdatingModel(this.id, this.name);
}

GrammaticalCategory convertFullEntity(row) {
  return GrammaticalCategory(row['id'] as int, row['name'] as String);
}

GrammaticalCategory convertNamedEntity(row) {
  return GrammaticalCategory(row['gc_id'] as int, row['gc_name'] as String);
}
