import 'package:language_parser_desktop/persistence/entities/language_entity.dart';

import '../persistence/repositories/language_repository.dart';

class LanguageService {
  final LanguageRepository _languageRepository;
  Function()? langsUpdated;

  LanguageService(this._languageRepository);

  List<Language> getAllLanguages() {
    return _languageRepository.getAll();
  }

  Language getLanguage(int id) {
    return _languageRepository.getById(id);
  }

  Language save(LanguageCreatingModel model) {
    var res = _languageRepository.save(model);
    if (langsUpdated != null) langsUpdated!();
    return res;
  }

  bool canDelete(int id) {
    return true;
  }

  void persist(LanguageUpdatingModel model) {
    _languageRepository.update(model);
    if (langsUpdated != null) langsUpdated!();
  }

  void delete(int id) {
    _languageRepository.delete(id);
    if (langsUpdated != null) langsUpdated!();
  }
}
