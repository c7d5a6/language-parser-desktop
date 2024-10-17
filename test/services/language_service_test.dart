import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:language_parser_desktop/persistence/repositories/language_repository.dart';
import 'package:language_parser_desktop/persistence/repositories/word_repository.dart';
import 'package:language_parser_desktop/services/language_service.dart';
import 'package:language_parser_desktop/util/sqlite.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late Database db;
  late LanguageService languageService;

  setUp(() async {
    db = sqlite3.openInMemory();
    await migrate(db);
    final wordRepository = WordRepository(db);
    final languageRepository = LanguageRepository(db);
    languageService = LanguageService(languageRepository, wordRepository);
  });

  test('Get all words', () async {
    db.execute('''
    INSERT INTO language_tbl (id, display_name, native_name, comment) VALUES 
    (1, 'Language 1', 'Native name 1', 'Comment 1');
    ''');
    db.execute('''
    INSERT INTO pos_tbl (id, name, abbreviation) VALUES 
    (1001, 'Pos 1', 'pos1');
    ''');
    db.execute('''
    INSERT INTO word_tbl (word, language, pos, source_type, comment) VALUES 
    ('asd1', 1, 1001, 'NEW', 'Comment word 1'),
    ('qsd2', 1, 1001, 'NEW', 'Comment word 2');
    ''');

    final phonetics = await languageService.getLanguagePhonemes(1);

    expect(deepEqualUnorderedStringLists(phonetics.usedMainPhonemes, ['a', 's', 'd', 'q']), true);
    expect(deepEqualUnorderedStringLists(phonetics.restUsedPhonemes, ['1', '2']), true);
  });
}

bool deepEqualUnorderedStringLists(List<String> list1, List<String> list2) {
  if (list1.length != list2.length) {
    return false;
  }
  List<String> sortedList1 = List.from(list1)..sort();
  List<String> sortedList2 = List.from(list2)..sort();
  for (int i = 0; i < sortedList1.length; i++) {
    if (sortedList1[i] != sortedList2[i]) {
      return false;
    }
  }
  return true;
}
