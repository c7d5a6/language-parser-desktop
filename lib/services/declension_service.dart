import 'dart:core';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:language_parser_desktop/persistence/entities/declension_rule_entity.dart';
import 'package:language_parser_desktop/persistence/entities/declension_rule_sound_change_entity.dart';
import 'package:language_parser_desktop/persistence/entities/grammatical_category_value_entity.dart';
import 'package:language_parser_desktop/persistence/repositories/declension_category_pos_lang_connection_repository.dart';
import 'package:language_parser_desktop/persistence/repositories/declension_rule_gc_connection_repository.dart';
import 'package:language_parser_desktop/persistence/repositories/declension_rule_repository.dart';
import 'package:language_parser_desktop/persistence/repositories/declension_rule_sound_change_repository.dart';
import 'package:language_parser_desktop/persistence/repositories/declension_repository.dart';
import 'package:language_parser_desktop/persistence/repositories/gcv_repository.dart';
import 'package:language_parser_desktop/services/phonological_rules.dart';

import '../persistence/entities/declension.dart';

class DeclensionService {
  final DeclensionCategoryPosLangConnectionRepository _declensionCategoryPosLangConnectionRepository;
  final DeclensionRepository _declensionRepository;
  final DeclensionRuleRepository _declensionRuleRepository;
  final DeclensionRuleGCConnectionRepository _declensionRuleGCConnectionRepository;
  final DeclensionRuleSoundChangeRepository _declensionRuleSoundChangeRepository;
  final GrammaticalCategoryValueRepository _grammaticalCategoryValueRepository;
  final PhonologicalRules _phonologicalRules;

  DeclensionService(
    this._declensionCategoryPosLangConnectionRepository,
    this._declensionRepository,
    this._declensionRuleRepository,
    this._declensionRuleGCConnectionRepository,
    this._declensionRuleSoundChangeRepository,
    this._grammaticalCategoryValueRepository,
    this._phonologicalRules,
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

  void setMainDeclension(int langId, int posId, int declensionId) {
    _declensionRepository.setMainByLangPos(langId, posId, declensionId);
  }

  List<DeclensionRule> getRulesByDeclensionId(int declensionId) {
    return _declensionRuleRepository.getByDeclensionId(declensionId);
  }

  DeclensionRule saveRule(int declensionId, String name, String? wordPattern) {
    return _declensionRuleRepository.save(declensionId, name, wordPattern);
  }

  void updateRule(int id, String name, String wordPattern, bool enabled) {
    _declensionRuleRepository.update(id, name, wordPattern, enabled);
  }

  Set<int> getRuleGCVIds(int declensionRuleId) {
    return _declensionRuleGCConnectionRepository.getGCVIdsByDeclensionRuleId(declensionRuleId);
  }

  void saveRuleGCConnection(int declensionRuleId, int gcvId) {
    _declensionRuleGCConnectionRepository.save(declensionRuleId, gcvId);
  }

  void deleteRuleGCConnection(int declensionRuleId, int gcvId) {
    _declensionRuleGCConnectionRepository.delete(declensionRuleId, gcvId);
  }

  List<DeclensionRuleSoundChange> getRuleSoundChanges(int declensionRuleId) {
    return _declensionRuleSoundChangeRepository
        .getByDeclensionRuleId(declensionRuleId)
        .map(
          (soundChange) => DeclensionRuleSoundChange(
            soundChange.id,
            soundChange.declensionRuleId,
            soundChange.change,
            isCorrect: _phonologicalRules.validateRule(soundChange.change),
          ),
        )
        .toList(growable: false);
  }

  DeclensionRuleSoundChange saveRuleSoundChange(int declensionRuleId, String change) {
    return _declensionRuleSoundChangeRepository.save(declensionRuleId, change);
  }

  void updateRuleSoundChange(int id, String change) {
    _declensionRuleSoundChangeRepository.update(id, change);
  }

  void deleteRuleSoundChange(int id) {
    log('DeclensionService.deleteRuleSoundChange: id=$id');
    _declensionRuleSoundChangeRepository.delete(id);
  }

  void replaceRuleSoundChangesFromEditor(int declensionRuleId, String content) {
    final lines = content
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList(growable: false);
    _declensionRuleSoundChangeRepository.replaceAllByDeclensionRuleId(declensionRuleId, lines);
  }

  List<DeclensionRow> getDeclensions(int languageId, int posId) {
    var gcIds = getGCsIdsByLangIdAndPosId(languageId, posId);
    Map<int, List<GrammaticalCategoryValue>> values = { for (var gcId in gcIds) gcId : _grammaticalCategoryValueRepository.getByGCIdAndLangId(gcId, languageId) };
    var result = calculateMatrix(values);
    var declensions = _declensionRepository.getByLangIdAndPosId(languageId, posId);
    for (var d in declensions) {
      bool used = false;
      for (DeclensionRow row in result) {
        if (setEquals(d.values, row.valuesIds)) {
          if (!row.used) {
            row.addDeclension(d);
            used = true;
          }
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
    }
    for (final row in result) {
      final id = row.declensionId;
      if (id != null) {
        row.hasRules = _declensionRuleRepository.getByDeclensionId(id).isNotEmpty;
      }
    }
    return result;
  }

  List<DeclensionRow> calculateMatrix(Map<int, List<GrammaticalCategoryValue>> values) {
    if (values.values.any((list) => list.isEmpty)) {
      return [];
    }
    List<List<GrammaticalCategoryValue>> result = [];
    for (int id in values.keys) {
      List<List<GrammaticalCategoryValue>> newResult = [];
      if (values[id] == null) continue;
      if (result.isEmpty) {
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
  bool hasRules = false;
  List<GrammaticalCategoryValue> values;

  DeclensionRow(this.values);

  bool get used => declensionId != null;

  Set<int> get valuesIds => values.map((v) => v.id).toSet();

  String get name => values.fold("", (prev, decl) => "$prev ${decl.name}").trim();

  void addDeclension(Declension declension) {
    declensionId = declension.id;
    main = declension.main;
  }
}
