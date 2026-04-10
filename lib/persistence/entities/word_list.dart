import 'word_entity.dart';

/// List row: full [Word] (IPA, comment) with embedded [Word.language] and [Word.pos] (category).
class WordListItem {
  final Word word;

  WordListItem(this.word);

  /// Surface form; same as [Word.word] until a dedicated written column exists.
  String get writtenForm => word.word;

  String get phonetic => word.word;

  String get categoryLabel {
    final abbr = word.pos.abbreviation?.trim();
    if (abbr != null && abbr.isNotEmpty) {
      return abbr.endsWith('.') ? abbr : '$abbr.';
    }
    return word.pos.name;
  }
}
