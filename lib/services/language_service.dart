import 'dart:core';

import 'package:language_parser_desktop/persistence/entities/language_entity.dart';
import 'package:language_parser_desktop/persistence/entities/language_phoneme_entity.dart';
import 'package:language_parser_desktop/persistence/repositories/language_phoneme_repository.dart';
import 'package:language_parser_desktop/persistence/repositories/word_repository.dart';
import 'package:language_parser_desktop/util/ipa_utils.dart';

import '../persistence/repositories/language_repository.dart';

class LanguageService {
  final LanguageRepository _languageRepository;
  final LanguagePhonemeRepository _languagePhonemeRepository;
  final WordRepository _wordRepository;

  LanguageService(this._languageRepository, this._languagePhonemeRepository, this._wordRepository);

  List<Language> getAllLanguages() {
    return _languageRepository.getAll();
  }

  Language getLanguage(int id) {
    return _languageRepository.getById(id);
  }

  Language save(LanguageCreatingModel model) {
    var res = _languageRepository.save(model);
    return res;
  }

  bool canDelete(int id) {
    return true;
  }

  void persist(LanguageUpdatingModel model) {
    _languageRepository.update(model);
  }

  void delete(int id) {
    _languageRepository.delete(id);
  }

  LanguagePhoneme addPhoneme(int langId, String phoneme) {
    return _languagePhonemeRepository.save(langId, phoneme);
  }

  void deletePhoneme(int id) {
    return _languagePhonemeRepository.delete(id);
  }

  String _getLanguagePhonemes(int langId) {
    return _wordRepository.getAllWordByLang(langId).map((w) => w.word).fold('', (a, b) => '$a $b').trim();
  }

  ListOfLanguagePhonemes getLanguagePhonemes(int languageId) {
    assert(_languageRepository.exists(languageId), 'Language must exist');
    List<String> usedMainPhonemes = [];
    List<String> restUsedPhonemes = [];
    String languagePhonemes = IpaUtils.cleanIPA(_getLanguagePhonemes(languageId));
    List<LanguagePhoneme> lps = _languagePhonemeRepository.getAllByLang(languageId);
    List<String> allSoundsWithVariants = IpaUtils.allSoundsWithVariants;
    List<String> allSoundsWithVariantsAndLanguagePhonemes = List.empty(growable: true)
      ..addAll(allSoundsWithVariants)
      ..addAll(lps.map((lp) => lp.phoneme));
    allSoundsWithVariantsAndLanguagePhonemes.addAll(allSoundsWithVariants);

    List<String> sounds = allSoundsWithVariantsAndLanguagePhonemes..sort((o1, o2) => o2.length - o1.length);
    sounds.forEach((sound) {
      if (languagePhonemes.contains(sound) && sound.length > 0) {
        usedMainPhonemes.add(sound);
        languagePhonemes = languagePhonemes.replaceAll(sound, "");
      }
    });
    restUsedPhonemes = languagePhonemes
        .split('')
        .where((s) {
          return s.trim().length > 0;
        })
        .toSet()
        .toList()
      ..sort((o1, o2) => o2.length - o1.length);
    List<LanguagePhoneme> lpused = lps.where((lp) => allSoundsWithVariants.any((s) => s == lp.phoneme)).toList();
    List<LanguagePhoneme> lprest = lps.where((lp) => !lpused.any((lu) => lu.id == lp.id)).toList();

    return ListOfLanguagePhonemes(languageId, usedMainPhonemes, restUsedPhonemes, lpused, lprest);
  }
}

class ListOfLanguagePhonemes {
  final int? langId;
  final List<String> usedMainPhonemes;
  final List<String> restUsedPhonemes;
  final List<LanguagePhoneme> selectedMainPhonemes;
  final List<LanguagePhoneme> selectedRestPhonemes;

  ListOfLanguagePhonemes(
      this.langId, this.usedMainPhonemes, this.restUsedPhonemes, this.selectedMainPhonemes, this.selectedRestPhonemes);
}
