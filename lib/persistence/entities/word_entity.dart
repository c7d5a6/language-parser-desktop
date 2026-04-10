import 'language_entity.dart';
import 'pos_entity.dart';

enum WordSource {
  newWord('NEW');

  final String dbValue;

  const WordSource(this.dbValue);

  static WordSource fromDb(String value) {
    return WordSource.values.firstWhere(
      (source) => source.dbValue == value,
      orElse: () => WordSource.newWord,
    );
  }
}

class Word {
  static String get table_name => 'word_tbl';
  final int id;
  String word;
  Language language;
  Pos pos;
  String? comment;
  bool forgotten = false;
  WordSource sourceType;

  Word(this.id, this.word, this.language, this.pos, this.comment, this.forgotten, this.sourceType);
}
