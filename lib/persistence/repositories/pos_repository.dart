import 'package:language_parser_desktop/persistence/repositories/repository.dart';

import '../entities/pos_entity.dart';

class PosRepository extends Repository {
  PosRepository(super.db);

  List<Pos> getAll() {
    final resultSet = db.select('SELECT * FROM ${Pos.table_name} ORDER BY id', []);
    return (resultSet).map(convertFullEntity).toList(growable: false);
  }
//
// bool exists(int id) {
//   return existsInTable(id, Language.table_name);
// }
//
// Language getById(int id) {
//   final resultSet = db.select('SELECT * FROM ${Language.table_name} WHERE id = $id', []);
//   return convertFullEntity(resultSet.single);
// }
//
// Language save(LanguageCreatingModel model) {
//   db.execute(
//       'INSERT INTO ${Language.table_name} (display_name) VALUES'
//           '(?);',
//       [model.displayName]);
//   final resultSet = db.select('SELECT * from ${Language.table_name} WHERE id = last_insert_rowid();', []);
//   invalidate();
//   return convertFullEntity(resultSet.single);
// }
//
// void update(LanguageUpdatingModel model) {
//   db.execute('UPDATE ${Language.table_name} SET display_name = ? WHERE id = ${model.id};', [model.displayName]);
//   invalidate();
// }
//
// void delete(int id) {
//   db.execute('DELETE FROM ${Language.table_name} WHERE id = ${id};', []);
//   invalidate();
// }
}

Pos convertFullEntity(row) {
  return Pos(row['id'] as int, row['name'] as String, row['abbreviation'] as String?);
}

Pos convertNamedEntity(row) {
  return Pos(row['pos_id'] as int, row['pos_name'] as String, row['pos_abbreviation'] as String?);
}
