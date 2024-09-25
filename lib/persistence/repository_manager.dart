import 'package:language_parser_desktop/util/sqlite.dart';
import 'package:sqlite3/sqlite3.dart';

class RepositoryManager {
  Database? _database;

  void openDatabase(String filePath) {
    dispose();
    var db = sqlite3.open(filePath);
    migrate(db);
    database = db;
  }

  void dispose() {
    if (_database != null) _database!.dispose();
    _database = null;
  }
}
