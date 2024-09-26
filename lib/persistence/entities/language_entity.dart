class Language {
  static String get table_name => 'language_tbl';
  final int id;
  String displayName;
  String? nativeName;
  String? comment;

  Language(this.id, this.displayName, this.nativeName, this.comment);
}
