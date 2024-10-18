class LanguagePhoneme {
  static String get table_name => 'language_phoneme_tbl';
  final int id;
  final String phoneme;
  final int langId;

  LanguagePhoneme(this.id, this.phoneme, this.langId);
}
