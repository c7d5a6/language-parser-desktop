import 'package:language_parser_desktop/persistence/repositories/repository.dart';

import '../entities/pos_entity.dart';

class PosRepository extends Repository {
  PosRepository(super.db);

  List<Pos> getAll() {
    final resultSet = db.select('SELECT * FROM ${Pos.table_name} ORDER BY id', []);
    return (resultSet).map(convertFullEntity).toList(growable: false);
  }

  Pos getById(int id) {
    final resultSet = db.select('SELECT * FROM ${Pos.table_name} WHERE id = $id', []);
    return convertFullEntity(resultSet.single);
  }

  Pos save(PosCreatingModel model) {
    db.execute(
        'INSERT INTO ${Pos.table_name} (name, abbreviation) VALUES'
        '(?,?);',
        [model.name, model.abbreviation]);
    final resultSet = db.select('SELECT * from ${Pos.table_name} WHERE id = last_insert_rowid();', []);
    invalidate();
    return convertFullEntity(resultSet.single);
  }

  void update(PosUpdatingModel model) {
    db.execute('UPDATE ${Pos.table_name} SET name = ?, abbreviation = ? WHERE id = ${model.id};',
        [model.name, model.abbreviation]);
    invalidate();
  }

  void delete(int id) {
    db.execute('PRAGMA foreign_keys = ON; DELETE FROM ${Pos.table_name} WHERE id = ${id};', []);
    invalidate();
  }
}

class PosCreatingModel {
  final String name;
  final String? abbreviation;

  PosCreatingModel(this.name, this.abbreviation);
}

class PosUpdatingModel {
  final int id;
  final String name;
  final String? abbreviation;

  PosUpdatingModel(this.id, this.name, this.abbreviation);
}

Pos convertFullEntity(row) {
  return Pos(row['id'] as int, row['name'] as String, row['abbreviation'] as String?);
}

Pos convertNamedEntity(row) {
  return Pos(row['pos_id'] as int, row['pos_name'] as String, row['pos_abbreviation'] as String?);
}
