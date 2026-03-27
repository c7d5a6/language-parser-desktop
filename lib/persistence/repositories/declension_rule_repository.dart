import 'package:language_parser_desktop/persistence/entities/declension_rule_entity.dart';
import 'package:language_parser_desktop/persistence/repositories/repository.dart';

class DeclensionRuleRepository extends Repository {
  DeclensionRuleRepository(super.db);

  List<DeclensionRule> getByDeclensionId(int declensionId) {
    final resultSet = db.select(
      'SELECT id, declension_id, name, word_pattern, enabled '
      'FROM ${DeclensionRule.table_name} WHERE declension_id = $declensionId ORDER BY name',
      [],
    );
    return (resultSet).map(convertDeclensionRule).toList(growable: false);
  }

  DeclensionRule save(int declensionId, String name, String? wordPattern) {
    db.execute(
      'INSERT INTO ${DeclensionRule.table_name} (declension_id, name, word_pattern) VALUES (?,?,?);',
      [declensionId, name, wordPattern],
    );
    final resultSet = db.select(
      'SELECT id, declension_id, name, word_pattern, enabled FROM ${DeclensionRule.table_name} '
      'WHERE id = last_insert_rowid();',
      [],
    );
    invalidate();
    return convertDeclensionRule(resultSet.single);
  }

  void update(int id, String name, String wordPattern, bool enabled) {
    db.execute(
      'UPDATE ${DeclensionRule.table_name} SET name = ?, word_pattern = ?, enabled = ? WHERE id = ?;',
      [name, wordPattern, enabled ? 1 : 0, id],
    );
    invalidate();
  }

  void delete(int id) {
    db.execute('PRAGMA foreign_keys = ON; DELETE FROM ${DeclensionRule.table_name} WHERE id = $id;', []);
    invalidate();
  }
}

DeclensionRule convertDeclensionRule(row) {
  return DeclensionRule(
    row['id'] as int,
    row['declension_id'] as int,
    row['name'] as String,
    row['word_pattern'] as String?,
    (row['enabled'] as int) != 0,
  );
}
