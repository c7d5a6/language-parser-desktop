import 'package:language_parser_desktop/persistence/repositories/declension_category_pos_lang_connection_repository.dart';
import 'package:language_parser_desktop/persistence/repositories/declension_rule_gc_connection_repository.dart';
import 'package:language_parser_desktop/persistence/repositories/declension_rule_repository.dart';
import 'package:language_parser_desktop/persistence/repositories/declension_rule_sound_change_repository.dart';
import 'package:language_parser_desktop/persistence/repositories/declension_repository.dart';
import 'package:language_parser_desktop/persistence/repositories/gc_repository.dart';
import 'package:language_parser_desktop/persistence/repositories/gcv_lang_connection_repository.dart';
import 'package:language_parser_desktop/persistence/repositories/gcv_repository.dart';
import 'package:language_parser_desktop/persistence/repositories/invalidators/invalidator.dart';
import 'package:language_parser_desktop/persistence/repositories/language_phoneme_repository.dart';
import 'package:language_parser_desktop/persistence/repositories/language_repository.dart';
import 'package:language_parser_desktop/persistence/repositories/pos_category_lang_connection_repository.dart';
import 'package:language_parser_desktop/persistence/repositories/pos_lang_connection_repository.dart';
import 'package:language_parser_desktop/persistence/repositories/pos_repository.dart';
import 'package:language_parser_desktop/persistence/repositories/word_repository.dart';
import 'package:language_parser_desktop/util/sqlite.dart';
import 'package:sqlite3/sqlite3.dart';

class RepositoryManager {
  Database? _database;

  T _createRepository<T>(T Function(Database db) factory) {
    return factory(_database!);
  }

  void openDatabase(String filePath) {
    dispose();
    var db = sqlite3.open(filePath);
    migrate(db);
    _database = db;
    db.execute('PRAGMA foreign_keys = ON;');
    _declensionCategoryPosLangConnectionRepository = _createRepository(
      DeclensionCategoryPosLangConnectionRepository.new,
    );
    _declensionRuleRepository = _createRepository(DeclensionRuleRepository.new);
    _declensionRuleGCConnectionRepository = _createRepository(DeclensionRuleGCConnectionRepository.new);
    _declensionRuleSoundChangeRepository = _createRepository(DeclensionRuleSoundChangeRepository.new);
    _declensionRepository = _createRepository(DeclensionRepository.new);
    _grammaticalCategoryRepository = _createRepository(GrammaticalCategoryRepository.new);
    _grammaticalCategoryValueRepository = _createRepository(GrammaticalCategoryValueRepository.new);
    _gcvLangConnectionRepository = _createRepository(GCVLangConnectionRepository.new);
    _languageRepository = _createRepository(LanguageRepository.new);
    _posRepository = _createRepository(PosRepository.new);
    _posLangConnectionRepository = _createRepository(PosLangConnectionRepository.new);
    _posGCLangConnectionRepository = _createRepository(PosGCLangConnectionRepository.new);
    _languagePhonemeRepository = _createRepository(LanguagePhonemeRepository.new);
    _wordRepository = _createRepository(WordRepository.new);
  }

  void dispose() {
    if (_database != null) _database!.close();
    _database = null;
  }

  //
  late DeclensionRepository _declensionRepository;

  void addDeclensionInvalidator(Invalidator invalidator) {
    _declensionRepository.addInvalidator(invalidator);
  }

  void removeDeclensionInvalidator(Invalidator invalidator) {
    _declensionRepository.removeInvalidator(invalidator);
  }

  DeclensionRepository get declensionRepository {
    assert(_database != null);
    return _declensionRepository;
  }

  //
  late DeclensionCategoryPosLangConnectionRepository _declensionCategoryPosLangConnectionRepository;

  void addDeclensionCategoryPosLangConnectionInvalidator(Invalidator invalidator) {
    _declensionCategoryPosLangConnectionRepository.addInvalidator(invalidator);
  }

  void removeDeclensionCategoryPosLangConnectionInvalidator(Invalidator invalidator) {
    _declensionCategoryPosLangConnectionRepository.removeInvalidator(invalidator);
  }

  DeclensionCategoryPosLangConnectionRepository get declensionCategoryPosLangConnectionRepository {
    assert(_database != null);
    return _declensionCategoryPosLangConnectionRepository;
  }

  //
  late DeclensionRuleRepository _declensionRuleRepository;

  void addDeclensionRuleInvalidator(Invalidator invalidator) {
    _declensionRuleRepository.addInvalidator(invalidator);
  }

  void removeDeclensionRuleInvalidator(Invalidator invalidator) {
    _declensionRuleRepository.removeInvalidator(invalidator);
  }

  DeclensionRuleRepository get declensionRuleRepository {
    assert(_database != null);
    return _declensionRuleRepository;
  }

  //
  late DeclensionRuleGCConnectionRepository _declensionRuleGCConnectionRepository;

  void addDeclensionRuleGCConnectionInvalidator(Invalidator invalidator) {
    _declensionRuleGCConnectionRepository.addInvalidator(invalidator);
  }

  void removeDeclensionRuleGCConnectionInvalidator(Invalidator invalidator) {
    _declensionRuleGCConnectionRepository.removeInvalidator(invalidator);
  }

  DeclensionRuleGCConnectionRepository get declensionRuleGCConnectionRepository {
    assert(_database != null);
    return _declensionRuleGCConnectionRepository;
  }

  //
  late DeclensionRuleSoundChangeRepository _declensionRuleSoundChangeRepository;

  void addDeclensionRuleSoundChangeInvalidator(Invalidator invalidator) {
    _declensionRuleSoundChangeRepository.addInvalidator(invalidator);
  }

  void removeDeclensionRuleSoundChangeInvalidator(Invalidator invalidator) {
    _declensionRuleSoundChangeRepository.removeInvalidator(invalidator);
  }

  DeclensionRuleSoundChangeRepository get declensionRuleSoundChangeRepository {
    assert(_database != null);
    return _declensionRuleSoundChangeRepository;
  }

  //
  late GrammaticalCategoryRepository _grammaticalCategoryRepository;

  void addGCValidator(Invalidator invalidator) {
    _grammaticalCategoryRepository.addInvalidator(invalidator);
  }

  void removeGCInvalidator(Invalidator invalidator) {
    _grammaticalCategoryRepository.removeInvalidator(invalidator);
  }

  GrammaticalCategoryRepository get grammaticalCategoryRepository {
    assert(_database != null);
    return _grammaticalCategoryRepository;
  }

  //
  late GCVLangConnectionRepository _gcvLangConnectionRepository;

  void addGCVLangInvalidator(Invalidator invalidator) {
    _gcvLangConnectionRepository.addInvalidator(invalidator);
  }

  void removeGCVLangInvalidator(Invalidator invalidator) {
    _gcvLangConnectionRepository.removeInvalidator(invalidator);
  }

  GCVLangConnectionRepository get gcvLangConnectionRepository {
    assert(_database != null);
    return _gcvLangConnectionRepository;
  }

  //
  late GrammaticalCategoryValueRepository _grammaticalCategoryValueRepository;

  void addGCVValidator(Invalidator invalidator) {
    _grammaticalCategoryValueRepository.addInvalidator(invalidator);
  }

  void removeGCVInvalidator(Invalidator invalidator) {
    _grammaticalCategoryValueRepository.removeInvalidator(invalidator);
  }

  GrammaticalCategoryValueRepository get grammaticalCategoryValueRepository {
    assert(_database != null);
    return _grammaticalCategoryValueRepository;
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
  late PosGCLangConnectionRepository _posGCLangConnectionRepository;

  void addPosGCLangConnectionInvalidator(Invalidator invalidator) {
    _posGCLangConnectionRepository.addInvalidator(invalidator);
  }

  void removePosGCLangConnectionInvalidator(Invalidator invalidator) {
    _posGCLangConnectionRepository.removeInvalidator(invalidator);
  }

  PosGCLangConnectionRepository get posGCLangConnectionRepository {
    assert(_database != null);
    return _posGCLangConnectionRepository;
  }

  //
  late PosRepository _posRepository;

  void addPosInvalidator(Invalidator invalidator) {
    _posRepository.addInvalidator(invalidator);
  }

  void removePosInvalidator(Invalidator invalidator) {
    _posRepository.removeInvalidator(invalidator);
  }

  PosRepository get posRepository {
    assert(_database != null);
    return _posRepository;
  }

  //
  late PosLangConnectionRepository _posLangConnectionRepository;

  void addPosLangConnectionInvalidator(Invalidator invalidator) {
    _posLangConnectionRepository.addInvalidator(invalidator);
  }

  void removePosLangConnectionInvalidator(Invalidator invalidator) {
    _posLangConnectionRepository.removeInvalidator(invalidator);
  }

  PosLangConnectionRepository get posLangConnectionRepository {
    assert(_database != null);
    return _posLangConnectionRepository;
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
