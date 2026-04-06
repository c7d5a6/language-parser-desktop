class DeclensionRuleSoundChange {
  static String get table_name => 'declension_rule_sound_change_tbl';

  final int id;
  final int declensionRuleId;
  final String change;
  final bool isCorrect;

  DeclensionRuleSoundChange(this.id, this.declensionRuleId, this.change, {this.isCorrect = true});
}
