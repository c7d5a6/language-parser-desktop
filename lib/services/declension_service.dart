import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:language_parser_desktop/persistence/entities/grammatical_category_value_entity.dart';
import 'package:language_parser_desktop/persistence/repositories/declension_category_pos_lang_connection_repository.dart';
import 'package:language_parser_desktop/persistence/repositories/declension_repository.dart';
import 'package:language_parser_desktop/persistence/repositories/gcv_repository.dart';

import '../persistence/entities/declension.dart';

class DeclensionService {
  final DeclensionCategoryPosLangConnectionRepository _declensionCategoryPosLangConnectionRepository;
  final DeclensionRepository _declensionRepository;
  final GrammaticalCategoryValueRepository _grammaticalCategoryValueRepository;

  DeclensionService(
    this._declensionCategoryPosLangConnectionRepository,
    this._declensionRepository,
    this._grammaticalCategoryValueRepository,
  );

  Set<int> getGCsIdsByLangIdAndPosId(int langId, int posId) {
    return _declensionCategoryPosLangConnectionRepository.getGCsIdsByLangIdAndPosId(langId, posId);
  }

  Set<int> getPosIdsByLangId(int langId) {
    return _declensionCategoryPosLangConnectionRepository.getPosIdsByLangId(langId);
  }

  void saveConnection(int langId, int gcId, int posId) {
    _declensionCategoryPosLangConnectionRepository.save(langId, gcId, posId);
  }

  void deleteConnection(int langId, int gcId, int posId) {
    _declensionCategoryPosLangConnectionRepository.delete(langId, gcId, posId);
  }

  void save(int langId, int posId, Set<int> gcvIds) {
    _declensionRepository.save(langId, posId, gcvIds);
  }

  void delete(int id) {
    _declensionRepository.delete(id);
  }

  List<DeclensionRow> getDeclensions(int languageId, int posId) {
    var gcIds = getGCsIdsByLangIdAndPosId(languageId, posId);
    Map<int, List<GrammaticalCategoryValue>> values = Map.fromIterable(gcIds,
        key: (gcId) => gcId, value: (gcId) => _grammaticalCategoryValueRepository.getByGCIdAndLangId(gcId, languageId));
    var result = calculateMatrix(values);
    var declensions = _declensionRepository.getByLangIdAndPosId(languageId, posId);
    declensions.forEach((d) {
      bool used = false;
      for (DeclensionRow row in result) {
        if (setEquals(d.values, row.valuesIds)) {
          row.addDeclension(d);
          used = true;
          break;
        }
      }
      if (!used) {
        //TODO: optimize sql requests
        var row = DeclensionRow(
            d.values.map((id) => _grammaticalCategoryValueRepository.getById(id)).toList(growable: false));
        row.addDeclension(d);
        row.deprecated = true;
        result.add(row);
      }
    });
    return result;
  }

  List<DeclensionRow> calculateMatrix(Map<int, List<GrammaticalCategoryValue>> values) {
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
    return result.map((list) => DeclensionRow(list)).toList();
  }
}

class DeclensionRow {
  int? declensionId;
  bool main = false;
  bool deprecated = false;
  List<GrammaticalCategoryValue> values;

  DeclensionRow(this.values);

  bool get used => declensionId != null;

  Set<int> get valuesIds => values.map((v) => v.id).toSet();

  String get name => values.fold("", (prev, decl) => "$prev ${decl.name}").trim();

  void addDeclension(Declension declension) {
    this.declensionId = declension.id;
    this.main = declension.main;
  }
}
