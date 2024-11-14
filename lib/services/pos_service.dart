import 'dart:core';

import 'package:language_parser_desktop/persistence/repositories/pos_lang_connection_repository.dart';

import '../persistence/entities/pos_entity.dart';
import '../persistence/repositories/pos_repository.dart';

class PosService {
  final PosRepository _posRepository;
  final PosLangConnectionRepository _posLangConnectionRepository;

  PosService(this._posRepository, this._posLangConnectionRepository);

  List<Pos> getAll() {
    return _posRepository.getAll();
  }

  Pos save(PosCreatingModel model) {
    var res = _posRepository.save(model);
    return res;
  }

// bool canDelete(int id) {
//   return true;
// }

  void persist(PosUpdatingModel model) {
    _posRepository.update(model);
  }

  void delete(int id) {
    _posRepository.delete(id);
  }

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
  Set<int> getPosIdsByLangId(int langId) {
    return _posLangConnectionRepository.getPosIdsByLangId(langId);
  }

  void savePosLangConnection(int langId, int posId) {
    _posLangConnectionRepository.save(langId, posId);
  }

  void deletePosLangConnection(int langId, int posId) {
    _posLangConnectionRepository.delete(langId, posId);
  }
}
