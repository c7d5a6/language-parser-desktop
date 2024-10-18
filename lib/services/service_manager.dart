import 'package:language_parser_desktop/persistence/repository_manager.dart';
import 'package:language_parser_desktop/services/language_service.dart';
import 'package:language_parser_desktop/services/word_service.dart';

class ServiceManager {
  late final LanguageService _languageService;
  late final WordService _wordService;

  ServiceManager(RepositoryManager repositoryManager)
      : _languageService = LanguageService(repositoryManager.languageRepository,
            repositoryManager.languagePhonemeRepository, repositoryManager.wordRepository),
        _wordService = WordService(repositoryManager.wordRepository);

  LanguageService get languageService => _languageService;

  WordService get wordService => _wordService;
}
