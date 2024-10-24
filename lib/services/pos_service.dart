import 'dart:core';

import '../persistence/entities/pos_entity.dart';
import '../persistence/repositories/pos_repository.dart';

class PosService {
  final PosRepository _posRepository;

  PosService(this._posRepository);

  List<Pos> getAll() {
    return _posRepository.getAll();
  }
//
// Language save(LanguageCreatingModel model) {
//   var res = _languageRepository.save(model);
//   return res;
// }
//
// bool canDelete(int id) {
//   return true;
// }
//
// void persist(LanguageUpdatingModel model) {
//   _languageRepository.update(model);
// }
//
// void delete(int id) {
//   _languageRepository.delete(id);
// }
//
// LanguagePhoneme addPhoneme(int langId, String phoneme) {
//   return _languagePhonemeRepository.save(langId, phoneme);
// }
//
// void deletePhoneme(int id) {
//   return _languagePhonemeRepository.delete(id);
// }
//
// String _getLanguagePhonemes(int langId) {
//   return _wordRepository.getAllWordByLang(langId).map((w) => w.word).fold('', (a, b) => '$a $b').trim();
// }
}
