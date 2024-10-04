import 'package:language_parser_desktop/features/language/language_creating.dart';
import 'package:language_parser_desktop/persistence/entities/language_entity.dart';

import '../persistence/repositories/language_repository.dart';

class LanguageService {
  final LanguageRepository _languageRepository;

  LanguageService(this._languageRepository);

  List<Language> getAllLanguages() {
    return _languageRepository.getAll();
  }

  Language getLanguage(int id) {
    return _languageRepository.getById(id);
  }

  Language save(LanguageCreatingModel model) {
    return _languageRepository.save(model);
  }
}
