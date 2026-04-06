import 'dart:developer';

import 'package:language_parser_desktop/persistence/entities/declension_rule_sound_change_entity.dart';
import 'package:language_parser_desktop/persistence/repositories/repository.dart';

class DeclensionRuleSoundChangeRepository extends Repository {
  DeclensionRuleSoundChangeRepository(super.db);

  List<DeclensionRuleSoundChange> getByDeclensionRuleId(int declensionRuleId) {
    final result = db.select(
      'SELECT id, declension_rule_id, change FROM ${DeclensionRuleSoundChange.table_name} WHERE declension_rule_id = $declensionRuleId '
      'ORDER BY id',
    );
    return result.map(convertDeclensionRuleSoundChange).toList(growable: false);
  }

  DeclensionRuleSoundChange save(int declensionRuleId, String change) {
    db.execute(
      'INSERT INTO ${DeclensionRuleSoundChange.table_name} (declension_rule_id, change) VALUES (?,?);',
      [declensionRuleId, change],
    );
    final result = db.select(
      'SELECT id, declension_rule_id, change FROM ${DeclensionRuleSoundChange.table_name} '
      'WHERE id = last_insert_rowid();',
    );
    invalidate();
    return convertDeclensionRuleSoundChange(result.single);
  }

  void update(int id, String change) {
    db.execute(
      'UPDATE ${DeclensionRuleSoundChange.table_name} SET change = ? WHERE id = ?;',
      [change, id],
    );
    invalidate();
  }

  void delete(int id) {
    final before = db.select(
      'SELECT COUNT(*) as count FROM ${DeclensionRuleSoundChange.table_name} WHERE id = ?;',
      [id],
    );
    log('DeclensionRuleSoundChangeRepository.delete: id=$id before=${before.first['count']}');
    db.execute('PRAGMA foreign_keys = ON;');
    db.execute(
      'DELETE FROM ${DeclensionRuleSoundChange.table_name} WHERE id = ?;',
      [id],
    );
    final after = db.select(
      'SELECT COUNT(*) as count FROM ${DeclensionRuleSoundChange.table_name} WHERE id = ?;',
      [id],
    );
    log('DeclensionRuleSoundChangeRepository.delete: id=$id after=${after.first['count']}');
    invalidate();
  }

  void replaceAllByDeclensionRuleId(int declensionRuleId, List<String> changes) {
    db.execute('BEGIN TRANSACTION;');
    try {
      db.execute(
        'DELETE FROM ${DeclensionRuleSoundChange.table_name} WHERE declension_rule_id = ?;',
        [declensionRuleId],
      );
      for (final change in changes) {
        db.execute(
          'INSERT INTO ${DeclensionRuleSoundChange.table_name} (declension_rule_id, change) VALUES (?,?);',
          [declensionRuleId, change],
        );
      }
      db.execute('COMMIT;');
    } catch (_) {
      db.execute('ROLLBACK;');
      rethrow;
    }
    invalidate();
  }
}

DeclensionRuleSoundChange convertDeclensionRuleSoundChange(dynamic row) {
  return DeclensionRuleSoundChange(
    row['id'] as int,
    row['declension_rule_id'] as int,
    row['change'] as String,
  );
}
