import 'package:language_parser_desktop/persistence/repository_manager.dart';
import 'package:language_parser_desktop/services/ipa_service.dart';
import 'package:language_parser_desktop/services/language_service.dart';
import 'package:language_parser_desktop/services/word_service.dart';

class ServiceManager {
  late final LanguageService _languageService;
  late final WordService _wordService;
  late final IpaService _ipaService;

  ServiceManager(RepositoryManager repositoryManager)
      : _languageService = LanguageService(repositoryManager.languageRepository),
        _wordService = WordService(repositoryManager.wordRepository),
        _ipaService = IpaService();

  LanguageService get languageService => _languageService;

  WordService get wordService => _wordService;

  IpaService get ipaService => _ipaService;
}
