import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:language_parser_desktop/persistence/repositories/word_repository.dart';
import 'package:language_parser_desktop/util/sqlite.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late Database db;
  late WordRepository wordRepository;

  setUp(() async {
    db = sqlite3.openInMemory();
    await migrate(db);
    wordRepository = WordRepository(db);
  });

  test('Get all words', () async {
    db.execute('''
    INSERT INTO language_tbl (id, display_name, native_name, comment) VALUES 
    (1, 'Language 1', 'Native name 1', 'Comment 1'),
    (2, 'Language 2', 'Native name 2', 'Comment 2');
    ''');
    db.execute('''
    INSERT INTO pos_tbl (id, name, abbreviation) VALUES 
    (1001, 'Pos 1', 'pos1');
    ''');
    db.execute('''
    INSERT INTO word_tbl (word, language, pos, source_type, comment) VALUES 
    ('Word 1', 1, 1001, 'NEW', 'Comment word 1'),
    ('Word 2', 2, 1001, 'NEW', 'Comment word 2');
    ''');

    final words = await wordRepository.getAllWordByLang(1);

    expect(words.length, 1);
    final word = words[0];
    final lang = word.language;
    expect(lang.id, 1);
    expect(lang.displayName, 'Language 1');
    expect(lang.nativeName, 'Native name 1');
    expect(lang.comment, 'Comment 1');
    final pos = word.pos;
    expect(pos.id, 1001);
    expect(pos.name, 'Pos 1');
    expect(pos.abbreviation, 'pos1');

    expect(word.word, 'Word 1');
    expect(word.forgotten, false);
    expect(word.comment, 'Comment word 1');
    expect(word.sourceType, 'NEW');
  });
}
