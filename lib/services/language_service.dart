import 'dart:core';

import 'package:language_parser_desktop/persistence/entities/language_entity.dart';
import 'package:language_parser_desktop/persistence/repositories/word_repository.dart';
import 'package:language_parser_desktop/services/ipa_service.dart';

import '../persistence/repositories/language_repository.dart';

class LanguageService {
  final LanguageRepository _languageRepository;
  final WordRepository _wordRepository;
  Function()? langsUpdated;

  LanguageService(this._languageRepository, this._wordRepository);

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

  String _getLanguagePhonemes(int langId) {
    return _wordRepository.getAllWordByLang(langId).map((w) => w.word).fold('', (a, b) => '$a $b').trim();
  }

  ListOfLanguagePhonemes getLanguagePhonemes(int languageId) {
    assert(_languageRepository.exists(languageId), 'Language must exist');
    List<String> usedMainPhonemes = [];
    List<String> restUsedPhonemes = [];
    String languagePhonemes = IpaService.cleanIPA(_getLanguagePhonemes(languageId));
    //   List<ELanguagePhoneme> elp = this.languagePhonemeRepository.findByLanguage_Id(languageId);
    List<String> allSoundsWithVariants = IpaService.allSoundsWithVariants;
    List<String> allSoundsWithVariantsAndLanguagePhonemes =
        []; // elp.stream().map(ELanguagePhoneme::getPhoneme).collect(Collectors.toList());
    allSoundsWithVariantsAndLanguagePhonemes.addAll(allSoundsWithVariants);

    List<String> sounds = allSoundsWithVariantsAndLanguagePhonemes..sort((o1, o2) => o2.length - o1.length);
    sounds.forEach((sound) {
      if (languagePhonemes.contains(sound) && sound.length > 0) {
        usedMainPhonemes.add(sound);
        languagePhonemes = languagePhonemes.replaceAll(sound, "");
      }
    });
    restUsedPhonemes = languagePhonemes.split('').where((s) => s.trim().length > 0).toSet().toList()
      ..sort((o1, o2) => o2.length - o1.length);
    //   List<LanguagePhoneme> lpused = elp
    //       .stream()
    //       .filter((lp) -> Arrays.stream(allSoundsWithVariants).anyMatch(lp.getPhoneme()::equals))
    //       .map(this::convertToRestModel)
    //       .collect(Collectors.toList());
    //   resultList.setSelectedMainPhonemes(lpused);
    //   List<LanguagePhoneme> lprest = elp
    //       .stream()
    //       .filter((lp) -> Arrays.stream(allSoundsWithVariants).noneMatch(lp.getPhoneme()::equals))
    //       .map(this::convertToRestModel)
    //       .collect(Collectors.toList());
    //   resultList.setSelectedRestPhonemes(lprest);
    //
    return ListOfLanguagePhonemes(languageId, usedMainPhonemes, restUsedPhonemes);
  }
}

class ListOfLanguagePhonemes {
  final int langId;
  final List<String> usedMainPhonemes;
  final List<String> restUsedPhonemes;

  // final List<LanguagePhoneme> selectedMainPhonemes;
  // final List<LanguagePhoneme> selectedRestPhonemes;

  ListOfLanguagePhonemes(this.langId, this.usedMainPhonemes, this.restUsedPhonemes);
}
