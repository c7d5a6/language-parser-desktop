/// Here is the list of trimmed characters according to Unicode version 6.3:
/// ```plaintext
///     0009..000D    ; White_Space # Cc   <control-0009>..<control-000D>
///     0020          ; White_Space # Zs   SPACE
///     0085          ; White_Space # Cc   <control-0085>
///     00A0          ; White_Space # Zs   NO-BREAK SPACE
///     1680          ; White_Space # Zs   OGHAM SPACE MARK
///     2000..200A    ; White_Space # Zs   EN QUAD..HAIR SPACE
///     2028          ; White_Space # Zl   LINE SEPARATOR
///     2029          ; White_Space # Zp   PARAGRAPH SEPARATOR
///     202F          ; White_Space # Zs   NARROW NO-BREAK SPACE
///     205F          ; White_Space # Zs   MEDIUM MATHEMATICAL SPACE
///     3000          ; White_Space # Zs   IDEOGRAPHIC SPACE
///
///     FEFF          ; BOM                ZERO WIDTH NO_BREAK SPACE
/// ```
const whitespaces = [
  0x0009,
  0x000A,
  0x000B,
  0x000C,
  0x000D,
  0x0020,
  0x0085,
  0x00A0,
  0x1680,
  0x2000,
  0x2001,
  0x2002,
  0x2003,
  0x2004,
  0x2005,
  0x2006,
  0x2007,
  0x2008,
  0x2009,
  0x200A,
  0x2028,
  0x2029,
  0x202F,
  0x205F,
  0x3000,
  0xFEFF,
];

class Lexer {
  String _source;
  String _curChar;
  int _curPos;
  int _startPos;

  Lexer(String source)
      : _source = "$source\0",
        _curChar = "",
        _startPos = -1,
        _curPos = -1 {}

  void nextChar() {
    _startPos += 1;
    _curPos = _startPos;
    if (_startPos >= _source.length) {
      _curChar = '\0';
    } else {
      _curChar = _source[_startPos];
    }
  }

  String peekNext() {
    if (_curPos + 1 >= _source.length) return '\0';
    return _source[_curPos + 1];
  }

  void abort(message) {
    throw new Exception(message);
  }

  void skipWhitespace() {}

  bool isWhitespace(String s) {
    return s.codeUnits.fold(true, (prev, code) => prev && whitespaces.contains(code));
  }

  Token getToken() {
    nextChar();
    if (isWhitespace(_curChar)) {
      return _getWhitespaceToken();
    }
    if (_curChar == '\0') {
      return _getToken(TokenType.End);
    }
    return _getToken(TokenType.Phoneme);
  }

  Token _getWhitespaceToken() {
    while (isWhitespace(peekNext())) {
      _curPos++;
    }
    return _getToken(TokenType.Whitespace);
  }

  Token _getToken(TokenType type) {
    return _getTokenWithLiteral(type, null);
  }

  Token _getTokenWithLiteral(TokenType type, Object? literal) {
    String text = _source.substring(_startPos, _curPos + 1);
    _startPos = _curPos;
    return Token(type, text, literal);
  }
}

class Token {
  TokenType type;
  String text;
  Object? literal;

  Token(this.type, this.text, this.literal);

  @override
  String toString() {
    return 'Token{type: $type, text: $text, literal: $literal}';
  }
}

enum TokenType {
  End,
  Phoneme,
  Whitespace,
}
