import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:language_parser_desktop/persistence/repositories/language_phoneme_repository.dart';
import 'package:language_parser_desktop/util/sqlite.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late Database db;
  late LanguagePhonemeRepository languagePhonemeRepository;

  setUp(() async {
    db = sqlite3.openInMemory();
    await migrate(db);
    languagePhonemeRepository = LanguagePhonemeRepository(db);
  });

  test('Save', () async {
    db.execute('''
    INSERT INTO language_tbl (id, display_name, native_name, comment) VALUES 
    (1, 'Language 1', 'Native name 1', 'Comment 1');
    ''');

    final phoneme = await languagePhonemeRepository.save(1, 'p');

    expect(phoneme.id, 1);
    expect(phoneme.phoneme, 'p');
    expect(phoneme.langId, 1);
  });

  test('Delete', () async {
    db.execute('''
    INSERT INTO language_tbl (id, display_name, native_name, comment) VALUES 
    (1, 'Language 1', 'Native name 1', 'Comment 1'),
    (2, 'Language 2', 'Native name 2', 'Comment 2');
    ''');
    db.execute('''
    INSERT INTO language_phoneme_tbl (id, phoneme, language) VALUES 
    (1, 'p', 1),
    (2, 'b', 1);
    ''');

    languagePhonemeRepository.delete(1);
    final phonemes = await languagePhonemeRepository.getAllByLang(1);

    expect(phonemes.length, 1);
    final ph = phonemes[0];
    expect(ph.phoneme, 'b');
    expect(ph.langId, 1);
  });

  test('Get all phonemes by language', () async {
    db.execute('''
    INSERT INTO language_tbl (id, display_name, native_name, comment) VALUES 
    (1, 'Language 1', 'Native name 1', 'Comment 1'),
    (2, 'Language 2', 'Native name 2', 'Comment 2');
    ''');
    db.execute('''
    INSERT INTO language_phoneme_tbl (phoneme, language) VALUES 
    ('p', 1),
    ('b', 1),
    ('p', 2);
    ''');

    final phonemes = await languagePhonemeRepository.getAllByLang(1);

    expect(phonemes.length, 2);
    final ph = phonemes[0];
    expect(ph.phoneme, 'p');
    expect(ph.langId, 1);
  });
}
