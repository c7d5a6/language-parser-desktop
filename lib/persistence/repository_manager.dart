import 'package:language_parser_desktop/persistence/repositories/invalidators/invalidator.dart';
import 'package:language_parser_desktop/persistence/repositories/language_phoneme_repository.dart';
import 'package:language_parser_desktop/persistence/repositories/language_repository.dart';
import 'package:language_parser_desktop/persistence/repositories/word_repository.dart';
import 'package:language_parser_desktop/util/sqlite.dart';
import 'package:sqlite3/sqlite3.dart';

class RepositoryManager {
  Database? _database;

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

  //
  late LanguageRepository _languageRepository;

  void addLanguageInvalidator(Invalidator invalidator) {
    _languageRepository.addInvalidator(invalidator);
  }

  void removeLanguageInvalidator(Invalidator invalidator) {
    _languageRepository.removeInvalidator(invalidator);
  }

  LanguageRepository get languageRepository {
    assert(_database != null);
    return _languageRepository;
  }

  //
  late LanguagePhonemeRepository _languagePhonemeRepository;

  void addLanguagePhonemeInvalidator(Invalidator invalidator) {
    _languagePhonemeRepository.addInvalidator(invalidator);
  }

  void removeLanguagePhonemeInvalidator(Invalidator invalidator) {
    _languagePhonemeRepository.removeInvalidator(invalidator);
  }

  LanguagePhonemeRepository get languagePhonemeRepository {
    assert(_database != null);
    return _languagePhonemeRepository;
  }

  //
  late WordRepository _wordRepository;

  void addWordInvalidator(Invalidator invalidator) {
    _wordRepository.addInvalidator(invalidator);
  }

  void removeWordInvalidator(Invalidator invalidator) {
    _wordRepository.removeInvalidator(invalidator);
  }

  WordRepository get wordRepository {
    assert(_database != null);
    return _wordRepository;
  }
}
