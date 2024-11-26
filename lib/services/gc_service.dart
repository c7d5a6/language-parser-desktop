import 'dart:core';
import 'dart:developer';

import 'package:language_parser_desktop/persistence/entities/grammatical_category_value_entity.dart';
import 'package:language_parser_desktop/persistence/repositories/gc_repository.dart';
import 'package:language_parser_desktop/persistence/repositories/gcv_lang_connection_repository.dart';
import 'package:language_parser_desktop/persistence/repositories/pos_category_lang_connection_repository.dart';

import '../persistence/entities/grammatical_category_entity.dart';
import '../persistence/repositories/gcv_repository.dart';

class GCService {
  final GrammaticalCategoryRepository _gcRepository;
  final GrammaticalCategoryValueRepository _gcvRepository;
  final GCVLangConnectionRepository _gcvLangConnectionRepository;
  final PosGCLangConnectionRepository _posGCLangConnectionRepository;

  GCService(
    this._gcRepository,
    this._gcvRepository,
    this._gcvLangConnectionRepository,
    this._posGCLangConnectionRepository,
  );

  List<GrammaticalCategory> getAllGCs() {
    return _gcRepository.getAll();
  }

  List<GrammaticalCategoryValue> getAllGCVs(int id) {
    return _gcvRepository.getAllByGCId(id);
  }

  GrammaticalCategory saveGC(GrammaticalCategoryCreatingModel model) {
    var res = _gcRepository.save(model);
    return res;
  }

  GrammaticalCategoryValue saveGCV(GrammaticalCategoryValueCreatingModel model) {
    var res = _gcvRepository.save(model);
    return res;
  }

  void persistGC(GrammaticalCategoryUpdatingModel model) {
    _gcRepository.update(model);
  }

  void persistGCV(GrammaticalCategoryValueUpdatingModel model) {
    _gcvRepository.update(model);
  }

  void deleteGC(int id) {
    _gcRepository.delete(id);
  }

  void deleteGCV(int id) {
    _gcvRepository.delete(id);
  }

  Set<int> getGCVIdsByLangIdAndGCId(int langId, int gcId) {
    return _gcvLangConnectionRepository.getGCVIdsByLangIdAndGCId(langId, gcId);
  }

  void saveGCVLangConnection(int langId, int gcvId) {
    log("saveGCVLangConnection lang $langId gcv $gcvId");
    _gcvLangConnectionRepository.save(langId, gcvId);
  }

  void deleteGCVLangConnection(int langId, int gcvId) {
    log("deleteGCVLangConnection lang $langId gcv $gcvId");
    _gcvLangConnectionRepository.delete(langId, gcvId);
  }

  Set<int> getGCsIdsByLangIdAndPosId(int langId, int posId) {
    return _posGCLangConnectionRepository.getGCsIdsByLangIdAndPosId(langId, posId);
  }

  Set<int> getConnectedGCsIdsByLangId(int langId) {
    return _posGCLangConnectionRepository.getConnectedGCsIdsByLangId(langId);
  }

  Set<int> getGCsWithValuesEnabled(int langId) {
    return _gcvLangConnectionRepository.getGCsWithValuesEnabled(langId);
  }

  Set<int> getAllGCsIdWValues() {
    return _gcRepository.getAllGCsIdWValues();
  }
}
