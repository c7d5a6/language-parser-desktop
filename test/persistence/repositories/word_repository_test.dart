import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:language_parser_desktop/persistence/entities/word_entity.dart';
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
    db.execute('''
    INSERT INTO language_tbl (id, display_name, native_name, comment) VALUES 
    (1, 'Language 1', 'Native name 1', 'Comment 1'),
    (2, 'Language 2', 'Native name 2', 'Comment 2');
    ''');
    db.execute('''
    INSERT INTO pos_tbl (id, name, abbreviation) VALUES 
    (1001, 'Pos 1', 'pos1'),
    (1002, 'Pos 2', 'pos2'),
    (1003, 'Pos 3', 'pos3');
    ''');
  });

  test('Get all words', () async {
    db.execute('''
    INSERT INTO word_tbl (word, language, pos, source_type, comment) VALUES 
    ('Word 1', 1, 1001, 'NEW', 'Comment word 1'),
    ('Word 2', 2, 1001, 'NEW', 'Comment word 2');
    ''');

    final words = wordRepository.getAllWordByLang(1);

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
    expect(word.sourceType, WordSource.newWord);
  });

  test('Search: short query uses GLOB, long query uses FTS', () {
    db.execute('''
    INSERT INTO word_tbl (word, language, pos, source_type, comment) VALUES
    ('alpha', 1, 1001, 'NEW', null),
    ('alphabet', 1, 1001, 'NEW', null),
    ('beta', 1, 1001, 'NEW', null);
    ''');

    final short = wordRepository.getWords(10, 'al');
    expect(short.length, 2);
    expect(short.map((w) => w.word.word).toSet(), {'alpha', 'alphabet'});

    final long = wordRepository.getWords(10, 'alp');
    expect(long.length, 2);
    expect(long.map((w) => w.word.word).toSet(), {'alpha', 'alphabet'});
  });

  test('Filters by language and pos across search modes', () {
    db.execute('''
    INSERT INTO word_tbl (word, language, pos, source_type, comment) VALUES
    ('alpha', 1, 1001, 'NEW', null),
    ('beta', 1, 1002, 'NEW', null),
    ('gamma', 2, 1001, 'NEW', null);
    ''');

    expect(wordRepository.countWords('', languageId: 1), 2);
    expect(wordRepository.countWords('', languageId: 2), 1);
    expect(wordRepository.countWords('', languageId: 1, posId: 1002), 1);

    final page = wordRepository.getWordsPage(10, 0, '', languageId: 1, posId: 1002);
    expect(page.totalCount, 1);
    expect(page.words.single.word.word, 'beta');

    final glob = wordRepository.getWords(10, 'be', languageId: 1);
    expect(glob.map((w) => w.word.word).toSet(), {'beta'});

    final fts = wordRepository.getWords(10, 'alp', languageId: 2);
    expect(fts, isEmpty);
    expect(wordRepository.getWords(10, 'alp', languageId: 1).single.word.word, 'alpha');
  });

  test('Get all poses', () {
    db.execute('''
    INSERT INTO word_tbl (word, language, pos, source_type, comment) VALUES
    ('Word 1', 1, 1001, 'NEW', 'Comment word 1'),
    ('Word 2', 2, 1001, 'NEW', 'Comment word 2'),
    ('Word 3', 1, 1001, 'NEW', 'Comment word 3'),
    ('Word 4', 1, 1002, 'NEW', 'Comment word 4');
    ''');

    final poses = wordRepository.getAllPosIDsByLang(1);

    expect(poses.length, 2);
    expect(poses.contains(1001), true);
    expect(poses.contains(1002), true);
  });
}
