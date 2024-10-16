import 'package:sqlite3/sqlite3.dart';

abstract class Repository {
  final Database _db;

  Repository(this._db);

  Database get db => _db;

  bool existsInTable(int id, String table) {
    final resultSet = db.select('SELECT COUNT(*) as count FROM $table WHERE id = $id', []);
    final int count = resultSet.first['count'] as int;
    return count > 0;
  }
}
