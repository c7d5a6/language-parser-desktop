import 'lexer_utils.dart';

abstract class Lexer<T, TType> {
  String _source;
  String _curChar;
  int _curPos;
  int _startPos;

  get curChar => _curChar;

  Lexer(String source)
      : _source = "$source\0",
        _curChar = "",
        _startPos = -1,
        _curPos = -1 {}

  void goNextChar() {
    _startPos += 1;
    _curPos = _startPos;
    if (_startPos >= _source.length) {
      _curChar = '\0';
    } else {
      _curChar = _source[_startPos];
    }
  }

  String peekNextChar() {
    if (_curPos + 1 >= _source.length) return '\0';
    return _source[_curPos + 1];
  }

  void abort(message) {
    throw new Exception(message);
  }

  T getToken();

  T getWhitespaceToken() {
    while (isWhitespace(peekNextChar())) {
      _curPos++;
    }
    return getTokenByType(getWhitespaceType());
  }

  T getTokenByType(TType type) {
    return getTokenWithLiteral(type, null);
  }

  T getTokenWithLiteral(TType type, Object? literal) {
    String text = _source.substring(_startPos, _curPos + 1);
    _startPos = _curPos;
    return newToken(type, text, literal);
  }

  TType getWhitespaceType();

  T newToken(TType type, String text, Object? literal);
}
