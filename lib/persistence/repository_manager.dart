import 'package:language_parser_desktop/persistence/repositories/language_phoneme_repository.dart';
import 'package:language_parser_desktop/persistence/repositories/language_repository.dart';
import 'package:language_parser_desktop/persistence/repositories/word_repository.dart';
import 'package:language_parser_desktop/util/sqlite.dart';
import 'package:sqlite3/sqlite3.dart';

class RepositoryManager {
  Database? _database;
  late LanguageRepository _languageRepository;
  late LanguagePhonemeRepository _languagePhonemeRepository;
  late WordRepository _wordRepository;

  void openDatabase(String filePath) {
    dispose();
    var db = sqlite3.open(filePath);
    migrate(db);
    _database = db;
    _languageRepository = LanguageRepository(_database!);
    _languagePhonemeRepository = LanguagePhonemeRepository(_database!);
    _wordRepository = WordRepository(_database!);
  }

  void dispose() {
    if (_database != null) _database!.dispose();
    _database = null;
  }

  LanguageRepository get languageRepository {
    assert(_database != null);
    return _languageRepository;
  }

  LanguagePhonemeRepository get languagePhonemeRepository {
    assert(_database != null);
    return _languagePhonemeRepository;
  }

  WordRepository get wordRepository {
    assert(_database != null);
    return _wordRepository;
  }
}
