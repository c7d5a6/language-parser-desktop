import 'language_entity.dart';
import 'pos_entity.dart';

class Word {
  static String get table_name => 'word_tbl';
  final int id;
  String word;
  Language language;
  Pos pos;
  String? comment;
  bool forgotten = false;
  String sourceType;

  Word(this.id, this.word, this.language, this.pos, this.comment, this.forgotten, this.sourceType);
}
