import 'dart:core';

import 'package:language_parser_desktop/persistence/entities/grammatical_category_value_entity.dart';
import 'package:language_parser_desktop/persistence/repositories/declension_category_pos_lang_connection_repository.dart';
import 'package:language_parser_desktop/persistence/repositories/gcv_repository.dart';

class DeclensionService {
  final DeclensionCategoryPosLangConnectionRepository _declensionCategoryPosLangConnectionRepository;
  final GrammaticalCategoryValueRepository _grammaticalCategoryValueRepository;

  DeclensionService(this._declensionCategoryPosLangConnectionRepository, this._grammaticalCategoryValueRepository);

  Set<int> getGCsIdsByLangIdAndPosId(int langId, int posId) {
    return _declensionCategoryPosLangConnectionRepository.getGCsIdsByLangIdAndPosId(langId, posId);
  }

  Set<int> getPosIdsByLangId(int langId) {
    return _declensionCategoryPosLangConnectionRepository.getPosIdsByLangId(langId);
  }

  void save(int langId, int gcId, int posId) {
    _declensionCategoryPosLangConnectionRepository.save(langId, gcId, posId);
  }

  void delete(int langId, int gcId, int posId) {
    _declensionCategoryPosLangConnectionRepository.delete(langId, gcId, posId);
  }

  List<List<GrammaticalCategoryValue>> getDeclensions(int languageId, int posId) {
    var gcIds = getGCsIdsByLangIdAndPosId(languageId, posId);
    Map<int, List<GrammaticalCategoryValue>> values = Map.fromIterable(gcIds,
        key: (gcId) => gcId, value: (gcId) => _grammaticalCategoryValueRepository.getByGCIdAndLangId(gcId, languageId));
    return calculateMatrix(values);
  }

  List<List<GrammaticalCategoryValue>> calculateMatrix(Map<int, List<GrammaticalCategoryValue>> values) {
    List<List<GrammaticalCategoryValue>> result = [];
    for (int id in values.keys) {
      List<List<GrammaticalCategoryValue>> newResult = [];
      if (values[id] == null) continue;
      if (result.length == 0) {
        for (GrammaticalCategoryValue value in values[id]!) {
          newResult.add([value]);
        }
      }
      for (List<GrammaticalCategoryValue> line in result) {
        for (GrammaticalCategoryValue value in values[id]!) {
          newResult.add(List.of(line)..add(value));
        }
      }
      result = newResult;
    }
    return result;
  }
}
