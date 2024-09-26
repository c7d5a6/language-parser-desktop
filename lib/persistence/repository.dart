import 'package:sqlite3/sqlite3.dart';

abstract class Repository {
  final Database _db;

  Repository(this._db);

  Database get db => _db;
}
