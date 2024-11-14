import 'package:language_parser_desktop/persistence/entities/pos_lang_connection_entity.dart';
import 'package:language_parser_desktop/persistence/repositories/repository.dart';

class PosLangConnectionRepository extends Repository {
  PosLangConnectionRepository(super.db);

  Set<int> getPosIdsByLangId(int langId) {
    final result = db.select("SELECT pos_id FROM ${PosLangConnection.table_name} WHERE lang_id = $langId");
    return (result).map((row) => row['pos_id'] as int).toSet();
  }

  void save(int langId, int posId) {
    db.execute(
        'INSERT INTO ${PosLangConnection.table_name} (lang_id, pos_id) VALUES'
        '(?,?);',
        [langId, posId]);
    invalidate();
  }

  void delete(int langId, int posId) {
    db.execute(
        'PRAGMA foreign_keys = ON; DELETE FROM ${PosLangConnection.table_name} WHERE pos_id = $posId AND lang_id = $langId;',
        []);
    invalidate();
  }
}
