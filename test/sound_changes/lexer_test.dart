import 'package:language_parser_desktop/sound_changes/lexer.dart';
import 'package:test/test.dart';

void main() {
  test('String test', () {
    var str = "*méh₂tēr *ph₂tḗr     suHnús \nh₂éngʷʰis gʰreh₁-";
    for (int i = 0; i < str.length; i++) {
      print("${str[i]} [${str.codeUnitAt(i).toRadixString(16)}]");
    }
  });

  test('Tokenizer test', () {
    var str = "*méh₂tēr *ph₂tḗr     suHnús \nh₂éngʷʰis gʰreh₁-";
    var lexer = Lexer(str);
    while (true) {
      var token = lexer.getToken();
      if (token.type == TokenType.End) {
        break;
      }
      print("$token");
    }
  });
}
