import 'dart:core';

import 'package:language_parser_desktop/persistence/entities/grammatical_category_value_entity.dart';
import 'package:language_parser_desktop/persistence/repositories/gc_repository.dart';

import '../persistence/entities/grammatical_category_entity.dart';
import '../persistence/repositories/gcv_repository.dart';

class GCService {
  final GrammaticalCategoryRepository _gcRepository;
  final GrammaticalCategoryValueRepository _gcvRepository;

  GCService(this._gcRepository, this._gcvRepository);

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

// bool canDelete(int id) {
//   return true;
// }
}
