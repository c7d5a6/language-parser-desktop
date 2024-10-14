import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:language_parser_desktop/persistence/repositories/language_repository.dart';
import 'package:language_parser_desktop/util/sqlite.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late Database db;
  late LanguageRepository languageRepository;

  setUp(() async {
    db = sqlite3.openInMemory();
    await migrate(db);
    languageRepository = LanguageRepository(db);
  });

  test('Get all languages', () {
    db.execute('''
    INSERT INTO language_tbl (display_name, native_name, comment) VALUES 
    ('Display name 1', 'Native name 1', 'Comment 1'),
    ('Display name 2', 'Native name 2', 'Comment 2'),
    ('Display name 3', null, null);
    ''');

    var languages = languageRepository.getAll();

    expect(3, languages.length);
    var lang1 = languages[0];
    expect(lang1.id, isNot(null));
    expect(lang1.displayName, 'Display name 1');
    expect(lang1.nativeName, 'Native name 1');
    expect(lang1.comment, 'Comment 1');
    var lang3 = languages[2];
    expect(lang3.nativeName, null);
    expect(lang3.comment, null);
  });

  test('Get languages by id', () {
    db.execute('''
    INSERT INTO language_tbl (id, display_name, native_name, comment) VALUES 
    (1, 'Display name 1', 'Native name 1', 'Comment 1'),
    (2, 'Display name 2', 'Native name 2', 'Comment 2');
    ''');

    var lang = languageRepository.getById(2);

    expect(lang.id, 2);
    expect(lang.displayName, 'Display name 2');
    expect(lang.nativeName, 'Native name 2');
    expect(lang.comment, 'Comment 2');
  });

  test('Get languages by id throws if no language', () {
    expect(() => languageRepository.getById(0), throwsA(isA<StateError>()));
  });

  test('Save Language', () {
    var model = LanguageCreatingModel()..displayName = 'Display';

    var lang = languageRepository.save(model);

    expect(lang.id, 1);
    expect(lang.displayName, 'Display');
    expect(lang.nativeName, null);
    expect(lang.comment, null);
  });

  test('Update Language', () {
    db.execute('''
    INSERT INTO language_tbl (id, display_name, native_name, comment) VALUES 
    (1, 'Display name 1', 'Native name 1', 'Comment 1'),
    (2, 'Display name 2', 'Native name 2', 'Comment 2');
    ''');

    languageRepository.update(LanguageUpdatingModel(id: 1, displayName: 'Updated'));
    final lang = languageRepository.getById(1);

    expect(lang.id, 1);
    expect(lang.displayName, 'Updated');
    expect(lang.nativeName, 'Native name 1');
    expect(lang.comment, 'Comment 1');
  });

  test('Delete Language', () {
    db.execute('''
    INSERT INTO language_tbl (id, display_name, native_name, comment) VALUES 
    (1, 'Display name 1', 'Native name 1', 'Comment 1'),
    (2, 'Display name 2', 'Native name 2', 'Comment 2');
    ''');

    languageRepository.delete(2);
    final langs = languageRepository.getAll();

    expect(langs.length, 1);
    expect(langs[0].id, 1);
  });
}
