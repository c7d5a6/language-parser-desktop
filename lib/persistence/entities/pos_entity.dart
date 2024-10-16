class Pos {
  static String get table_name => 'pos_tbl';
  final int id;
  String name;
  String? abbreviation;

  Pos(this.id, this.name, this.abbreviation);
}
