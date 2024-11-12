import 'package:language_parser_desktop/persistence/entities/grammatical_category_entity.dart';
import 'package:language_parser_desktop/persistence/repositories/gc_repository.dart' as gc;
import 'package:language_parser_desktop/persistence/repositories/repository.dart';

import '../entities/grammatical_category_value_entity.dart';

class GrammaticalCategoryValueRepository extends Repository {
  GrammaticalCategoryValueRepository(super.db);

  static const select = '''
  SELECT
    grammatical_category_value_tbl.id as gcv_id,
    grammatical_category_value_tbl.name as gcv_name,
    grammatical_category_tbl.id as gc_id,
    grammatical_category_tbl.name as gc_name
  FROM grammatical_category_value_tbl
  JOIN grammatical_category_tbl ON grammatical_category_value_tbl.category_id = grammatical_category_tbl.id
  ''';

  List<GrammaticalCategoryValue> getAllByGCId(int id) {
    final resultSet = db.select('$select WHERE gc_id = $id ORDER BY gcv_id', []);
    return (resultSet).map(convertFullEntity).toList(growable: false);
  }

  GrammaticalCategoryValue getById(int id) {
    final resultSet = db.select('$select WHERE gcv_id = $id', []);
    return convertFullEntity(resultSet.single);
  }

  GrammaticalCategoryValue save(GrammaticalCategoryValueCreatingModel model) {
    db.execute(
        'INSERT INTO ${GrammaticalCategoryValue.table_name} (name, category_id) VALUES'
        '(?,?);',
        [model.name, model.gc.id]);
    final resultSet = db.select('$select WHERE gcv_id = last_insert_rowid();', []);
    invalidate();
    return convertFullEntity(resultSet.single);
  }

  void update(GrammaticalCategoryValueUpdatingModel model) {
    db.execute('UPDATE ${GrammaticalCategoryValue.table_name} SET name = ? WHERE id = ${model.id};',
        [model.name]);
    invalidate();
  }

  void delete(int id) {
    db.execute('PRAGMA foreign_keys = ON; DELETE FROM ${GrammaticalCategoryValue.table_name} WHERE id = ${id};', []);
    invalidate();
  }
}

class GrammaticalCategoryValueCreatingModel {
  final String name;
  final GrammaticalCategory gc;

  GrammaticalCategoryValueCreatingModel(this.name, this.gc);
}

class GrammaticalCategoryValueUpdatingModel {
  final int id;
  final String name;

  GrammaticalCategoryValueUpdatingModel(this.id, this.name);
}

GrammaticalCategoryValue convertFullEntity(row) {
  return GrammaticalCategoryValue(row['gcv_id'] as int, row['gcv_name'] as String, gc.convertNamedEntity(row));
}
