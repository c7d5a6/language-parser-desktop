import 'package:language_parser_desktop/persistence/entities/grammatical_category_value_entity.dart';
import 'package:language_parser_desktop/persistence/entities/grammatical_category_value_lang_connection.dart';
import 'package:language_parser_desktop/persistence/repositories/repository.dart';

class GCVLangConnectionRepository extends Repository {
  GCVLangConnectionRepository(super.db);

  Set<int> getGCVIdsByLangIdAndGCId(int langId, int gcId) {
    final result = db.select('''
      SELECT gcv_id 
      FROM ${GCVLangConnection.table_name}
      JOIN ${GrammaticalCategoryValue.table_name} 
        ON ${GCVLangConnection.table_name}.gcv_id = ${GrammaticalCategoryValue.table_name}.id 
      WHERE lang_id = $langId AND category_id = $gcId
    ''');
    return (result).map((row) => row['gcv_id'] as int).toSet();
  }

  void save(int langId, int gcvId) {
    db.execute(
        'INSERT INTO ${GCVLangConnection.table_name} (lang_id, gcv_id) VALUES'
        '(?,?);',
        [langId, gcvId]);
    invalidate();
  }

  void delete(int langId, int gcvId) {
    db.execute(
        'PRAGMA foreign_keys = ON; DELETE FROM ${GCVLangConnection.table_name} WHERE gcv_id = $gcvId AND lang_id = $langId;',
        []);
    invalidate();
  }
}
