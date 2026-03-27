import 'package:language_parser_desktop/persistence/entities/declension_rule_gc_connection_entity.dart';
import 'package:language_parser_desktop/persistence/repositories/repository.dart';

class DeclensionRuleGCConnectionRepository extends Repository {
  DeclensionRuleGCConnectionRepository(super.db);

  Set<int> getGCIdsByDeclensionRuleId(int declensionRuleId) {
    final result = db.select(
      'SELECT gcv_id FROM ${DeclensionRuleGCVConnection.table_name} WHERE declension_rule_id = $declensionRuleId',
    );
    return (result).map((row) => row['gcv_id'] as int).toSet();
  }

  void save(int declensionRuleId, int gcvId) {
    db.execute(
      'INSERT INTO ${DeclensionRuleGCVConnection.table_name} (declension_rule_id, gcv_id) VALUES (?,?);',
      [declensionRuleId, gcvId],
    );
    invalidate();
  }

  void delete(int declensionRuleId, int gcId) {
    db.execute(
      'PRAGMA foreign_keys = ON; DELETE FROM ${DeclensionRuleGCVConnection.table_name} '
      'WHERE declension_rule_id = $declensionRuleId AND gc_id = $gcId;',
      [],
    );
    invalidate();
  }
}
