import 'package:language_parser_desktop/persistence/repository_manager.dart';
import 'package:language_parser_desktop/services/gc_service.dart';
import 'package:language_parser_desktop/services/language_service.dart';
import 'package:language_parser_desktop/services/pos_service.dart';
import 'package:language_parser_desktop/services/word_service.dart';

class ServiceManager {
  final RepositoryManager repositoryManager;
  late final GCService _gcService;
  late final LanguageService _languageService;
  late final PosService _posService;
  late final WordService _wordService;

  ServiceManager(this.repositoryManager)
      : _gcService = GCService(repositoryManager.grammaticalCategoryRepository,
            repositoryManager.grammaticalCategoryValueRepository, repositoryManager.gcvLangConnectionRepository),
        _languageService = LanguageService(repositoryManager.languageRepository,
            repositoryManager.languagePhonemeRepository, repositoryManager.wordRepository),
        _posService = PosService(repositoryManager.posRepository, repositoryManager.posLangConnectionRepository,
            repositoryManager.posGCLangConnectionRepository),
        _wordService = WordService(repositoryManager.wordRepository);

  GCService get gcService => _gcService;

  LanguageService get languageService => _languageService;

  PosService get posService => _posService;

  WordService get wordService => _wordService;
}
