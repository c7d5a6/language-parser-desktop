class DeclensionRule {
  static String get table_name => 'declension_rule_tbl';

  final int id;
  final int declensionId;
  final String name;
  final String? wordPattern;
  final bool enabled;

  DeclensionRule(this.id, this.declensionId, this.name, this.wordPattern, this.enabled);
}
