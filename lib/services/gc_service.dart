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

// Pos save(PosCreatingModel model) {
//   var res = _posRepository.save(model);
//   return res;
// }

// bool canDelete(int id) {
//   return true;
// }

// void persist(PosUpdatingModel model) {
//   _posRepository.update(model);
// }
//
// void delete(int id) {
//   _posRepository.delete(id);
// }
}
