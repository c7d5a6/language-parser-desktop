import 'package:language_parser_desktop/sound_changes/lexer.dart';

import 'lexer_utils.dart';

class PhonemeLexer extends Lexer<PhonemeToken, PhonemeTokenType> {
  PhonemeLexer(super.source);

  @override
  PhonemeToken getToken() {
    goNextChar();
    if (isWhitespace(curChar)) {
      return getWhitespaceToken();
    }
    if (isDiacritics(curChar)) {
      return getTokenByType(PhonemeTokenType.Diacritic);
    }
    if (curChar == '\0') {
      return getTokenByType(PhonemeTokenType.End);
    }
    return getTokenByType(PhonemeTokenType.Phoneme);
  }

  @override
  PhonemeTokenType getWhitespaceType() {
    return PhonemeTokenType.Whitespace;
  }

  @override
  PhonemeToken newToken(PhonemeTokenType type, String text, Object? literal) {
    return PhonemeToken(type, text, literal);
  }
}

class PhonemeToken {
  PhonemeTokenType type;
  String text;
  Object? literal;

  PhonemeToken(this.type, this.text, this.literal);

  @override
  String toString() {
    return 'Token{type: $type, text: $text, literal: $literal}';
  }
}

enum PhonemeTokenType {
  End,
  Phoneme,
  Diacritic,
  Whitespace,
}
