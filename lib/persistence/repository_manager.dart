import 'package:language_parser_desktop/persistence/language_repository.dart';
import 'package:language_parser_desktop/persistence/word_repository.dart';
import 'package:language_parser_desktop/util/sqlite.dart';
import 'package:sqlite3/sqlite3.dart';

class RepositoryManager {
  Database? _database;
  late LanguageRepository _languageRepository;
  late WordRepository _wordRepository;

  void openDatabase(String filePath) {
    dispose();
    var db = sqlite3.open(filePath);
    migrate(db);
    _database = db;
    _languageRepository = LanguageRepository(_database!);
    _wordRepository = WordRepository(_database!);
  }

  void dispose() {
    if (_database != null) _database!.dispose();
    _database = null;
  }

  //TODO add assert
  LanguageRepository get languageRepository => _languageRepository;

  WordRepository get wordRepository => _wordRepository;
}
