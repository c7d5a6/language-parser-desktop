class Declension {
  static String get table_name => 'declension_tbl';

  int id;
  bool main;
  Set<int> values = {};

  Declension(this.id, this.main);
}

class DeclensionValueConnection {
  static String get table_name => 'declension_value_connection_tbl';
}
