import 'package:language_parser_desktop/persistence/entities/declension_rule_sound_change_entity.dart';
import 'package:language_parser_desktop/persistence/repositories/repository.dart';

class DeclensionRuleSoundChangeRepository extends Repository {
  DeclensionRuleSoundChangeRepository(super.db);

  List<String> getChangesByDeclensionRuleId(int declensionRuleId) {
    final result = db.select(
      'SELECT change FROM ${DeclensionRuleSoundChange.table_name} WHERE declension_rule_id = $declensionRuleId '
      'ORDER BY id',
    );
    return (result).map((row) => row['change'] as String).toList(growable: false);
  }

  void save(int declensionRuleId, String change) {
    db.execute(
      'INSERT INTO ${DeclensionRuleSoundChange.table_name} (declension_rule_id, change) VALUES (?,?);',
      [declensionRuleId, change],
    );
    invalidate();
  }

  void delete(int declensionRuleId, String change) {
    db.execute(
      'PRAGMA foreign_keys = ON; DELETE FROM ${DeclensionRuleSoundChange.table_name} '
      'WHERE declension_rule_id = $declensionRuleId AND change = ?;',
      [change],
    );
    invalidate();
  }
}
