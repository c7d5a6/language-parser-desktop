import 'package:language_parser_desktop/persistence/repositories/repository.dart';

import '../entities/pos_category_lang_connection.dart';

class PosGCLangConnectionRepository extends Repository {
  PosGCLangConnectionRepository(super.db);

  Set<int> getPosIdsByLangIdGCId(int langId, int gcId) {
    final result =
        db.select("SELECT pos_id FROM ${PosGCLangConnection.table_name} WHERE lang_id = $langId AND gc_id = $gcId");
    return (result).map((row) => row['pos_id'] as int).toSet();
  }

  Set<int> getGCsIdsByLangIdAndPosId(int langId, int posId) {
    final result =
        db.select("SELECT gc_id FROM ${PosGCLangConnection.table_name} WHERE lang_id = $langId AND pos_id = $posId");
    return (result).map((row) => row['gc_id'] as int).toSet();
  }

  Set<int> getConnectedGCsIdsByLangId(int langId) {
    final result = db.select("SELECT gc_id FROM ${PosGCLangConnection.table_name} WHERE lang_id = $langId");
    return (result).map((row) => row['gc_id'] as int).toSet();
  }

  void save(int langId, int gcId, int posId) {
    db.execute(
        'INSERT INTO ${PosGCLangConnection.table_name} (lang_id, gc_id, pos_id) VALUES'
        '(?,?,?);',
        [langId, gcId, posId]);
    invalidate();
  }

  void delete(int langId, int gcId, int posId) {
    db.execute(
        'PRAGMA foreign_keys = ON; DELETE FROM ${PosGCLangConnection.table_name} '
        'WHERE pos_id = $posId AND gc_id = $gcId AND lang_id = $langId;',
        []);
    invalidate();
  }
}
