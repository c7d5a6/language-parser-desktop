import 'package:language_parser_desktop/persistence/entities/declension_category_pos_lang_connection.dart';
import 'package:language_parser_desktop/persistence/repositories/repository.dart';

class DeclensionCategoryPosLangConnectionRepository extends Repository {
  DeclensionCategoryPosLangConnectionRepository(super.db);

  Set<int> getGCsIdsByLangIdAndPosId(int langId, int posId) {
    final result = db.select(
        "SELECT gc_id FROM ${DeclensionGCPosLangConnection.table_name} WHERE lang_id = $langId AND pos_id = $posId");
    return (result).map((row) => row['gc_id'] as int).toSet();
  }

  Set<int> getPosIdsByLangId(int langId) {
    final result = db.select(
        "SELECT pos_id FROM ${DeclensionGCPosLangConnection.table_name} WHERE lang_id = $langId GROUP BY pos_id");
    return (result).map((row) => row['pos_id'] as int).toSet();
  }

  void save(int langId, int gcId, int posId) {
    db.execute(
        'INSERT INTO ${DeclensionGCPosLangConnection.table_name} (lang_id, gc_id, pos_id) VALUES'
        '(?,?,?);',
        [langId, gcId, posId]);
    invalidate();
  }

  void delete(int langId, int gcId, int posId) {
    db.execute(
        'PRAGMA foreign_keys = ON; DELETE FROM ${DeclensionGCPosLangConnection.table_name} '
        'WHERE pos_id = $posId AND gc_id = $gcId AND lang_id = $langId;',
        []);
    invalidate();
  }
}
