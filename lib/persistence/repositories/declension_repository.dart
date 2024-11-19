import 'package:language_parser_desktop/persistence/entities/declension.dart';
import 'package:language_parser_desktop/persistence/repositories/repository.dart';
import 'package:sqlite3/sqlite3.dart';

class DeclensionRepository extends Repository {
  DeclensionRepository(super.db);

  List<Declension> getByLangIdAndPosId(int langId, int posId) {
    final resultSet = db.select('''
    SELECT 
        ${Declension.table_name}.id as id,
        ${Declension.table_name}.lang_id as lang_id,
        ${Declension.table_name}.pos_id as pos_id,
        ${Declension.table_name}.main as main,
        ${DeclensionValueConnection.table_name}.value_id as value_id
    FROM ${Declension.table_name} 
    JOIN ${DeclensionValueConnection.table_name} 
        ON ${Declension.table_name}.id = ${DeclensionValueConnection.table_name}.declension_id
    WHERE ${Declension.table_name}.lang_id = $langId
        AND ${Declension.table_name}.pos_id = $posId
    ORDER BY id
    ''', []);
    Map<int, Declension> result = {};
    for (Row row in resultSet) {
      int id = row['id'];
      bool main = row['main'] == 0 ? false : true;
      int value = row['value_id'];
      var declension = result.putIfAbsent(id, () => Declension(id, main));
      declension.values.add(value);
    }
    return result.values.toList(growable: false);
  }

  void save(int langId, int posId, Set<int> gcvIds) {
    db.execute('BEGIN TRANSACTION;');
    try {
      db.execute(
          'INSERT INTO ${Declension.table_name} (lang_id,pos_id) VALUES'
          '(?,?);',
          [langId, posId]);
      final resultSet = db.select('SELECT id from ${Declension.table_name} WHERE id = last_insert_rowid();', []);
      final declId = resultSet.first['id'];
      final sql = StringBuffer();
      sql.write('INSERT INTO ${DeclensionValueConnection.table_name} (declension_id,value_id) VALUES');
      var list = gcvIds.toList(growable: false);
      for (int i = 0; i < list.length; i++) {
        sql.write('\n($declId,${list[i]})${i == gcvIds.length - 1 ? ';' : ','}');
      }
      db.execute(sql.toString());
      db.execute('COMMIT;');
    } catch (e) {
      db.execute('ROLLBACK;');
      throw e;
    }
    invalidate();
  }

  void delete(int id) {
    db.execute('PRAGMA foreign_keys = ON; DELETE FROM ${Declension.table_name} WHERE id = ${id};', []);
    invalidate();
  }
}
