import 'dart:collection';

import 'package:language_parser_desktop/persistence/entities/declension_category_pos_lang_connection.dart';
import 'package:language_parser_desktop/persistence/entities/grammatical_category_entity.dart';
import 'package:language_parser_desktop/persistence/repositories/repository.dart';

class DeclensionCategoryPosLangConnectionRepository extends Repository {
  DeclensionCategoryPosLangConnectionRepository(super.db);

  Set<int> getGCsIdsByLangIdAndPosId(int langId, int posId) {
    final result = db.select(
      '''
      SELECT ${DeclensionGCPosLangConnection.table_name}.gc_id AS gc_id
      FROM ${DeclensionGCPosLangConnection.table_name}
      JOIN ${GrammaticalCategory.table_name}
        ON ${GrammaticalCategory.table_name}.id = ${DeclensionGCPosLangConnection.table_name}.gc_id
      WHERE ${DeclensionGCPosLangConnection.table_name}.lang_id = ?
        AND ${DeclensionGCPosLangConnection.table_name}.pos_id = ?
      ORDER BY ${GrammaticalCategory.table_name}.name, ${DeclensionGCPosLangConnection.table_name}.gc_id
      ''',
      [langId, posId],
    );
    return LinkedHashSet<int>.of(result.map((row) => row['gc_id'] as int));
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
