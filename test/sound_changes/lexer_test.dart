import 'package:language_parser_desktop/sound_changes/phoneme_lexer.dart';
import 'package:test/test.dart';

void main() {
  test('String test', () {
    var str = "C̥*méh₂tēr *ph₂tḗr     suHnús \nh₂éngʷʰis gʰreh₁-";
    for (int i = 0; i < str.length; i++) {
      print("${str[i]} [${str.codeUnitAt(i).toRadixString(16)}]");
    }
  });

  test('Tokenizer test', () {
    // var str = "C̥*méh₂tēr *ph₂tḗr     suHnús \nh₂éngʷʰis gʰreh₁-";
    var str = "   \naʷʰC̥";
    var lexer = PhonemeLexer(str);
    expect(lexer.getToken().type, PhonemeTokenType.Whitespace);
    expect(lexer.getToken().type, PhonemeTokenType.Phoneme);
    expect(lexer.getToken().type, PhonemeTokenType.Diacritic);
    expect(lexer.getToken().type, PhonemeTokenType.Diacritic);
    expect(lexer.getToken().type, PhonemeTokenType.Phoneme);
    expect(lexer.getToken().type, PhonemeTokenType.Diacritic);
    expect(lexer.getToken().type, PhonemeTokenType.End);
  });

  // test('check set', () {
  //   var totalIndexes = 1000000;
  //   for (var total_numbers = 1; total_numbers < 1000; total_numbers = total_numbers * 10) {
  //     List<int> array = List.filled(total_numbers, 0);
  //     Set<int> set = {};
  //     var time = () => DateTime.now().microsecondsSinceEpoch;
  //     var crArrStr = time();
  //     for (var i = 0; i < total_numbers; i++) {
  //       array[i] = i;
  //     }
  //     print("Creating Array[$total_numbers] in: ${time() - crArrStr}");
  //     var crSetSrt = time();
  //     for (var i = 0; i < total_numbers; i++) {
  //       set.add(i);
  //     }
  //     print("Creating Set[$total_numbers] in: ${time() - crSetSrt}");
  //     var rng = Random();
  //     var indxOfSt = time();
  //     int found = 0;
  //     for (var i = 0; i < totalIndexes; i++) {
  //       found += array.contains(rng.nextInt(total_numbers)) ? 1 : 0;
  //     }
  //     print("Find $found in Array[$total_numbers] in: ${time() - indxOfSt}");
  //     var indxSetOfSt = time();
  //     found = 0;
  //     for (var i = 0; i < totalIndexes; i++) {
  //       found += set.contains(rng.nextInt(total_numbers)) ? 1 : 0;
  //     }
  //     print("Find $found in Set[$total_numbers] in: ${time() - indxSetOfSt}");
  //   }
  // });
}
