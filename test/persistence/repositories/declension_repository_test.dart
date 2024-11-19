import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:language_parser_desktop/persistence/repositories/declension_repository.dart';
import 'package:language_parser_desktop/util/sqlite.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late Database db;
  late DeclensionRepository declensionRepository;

  setUp(() async {
    db = sqlite3.openInMemory();
    await migrate(db);
    declensionRepository = DeclensionRepository(db);
    db.execute('''
    INSERT INTO language_tbl (id, display_name, native_name, comment) VALUES 
    (1, 'Language 1', 'Native name 1', 'Comment 1'),
    (2, 'Language 2', 'Native name 2', 'Comment 2'),
    (3, 'Language 3', 'Native name 3', 'Comment 3');
    ''');
    db.execute('''
    INSERT INTO grammatical_category_tbl (id, name) VALUES 
    (1001, 'GC 1'),
    (1002, 'GC 2'),
    (1003, 'GC 3');
    ''');
    db.execute('''
    INSERT INTO grammatical_category_value_tbl (id, category_id, name) VALUES 
    (1001, 1001, 'GCV 1'),
    (1002, 1002, 'GCV 2'),
    (1003, 1003, 'GCV 3');
    ''');
    db.execute('''
    INSERT INTO pos_tbl (id, name, abbreviation) VALUES 
    (1001, 'Pos 1', 'pos1'),
    (1002, 'Pos 2', 'pos2'),
    (1003, 'Pos 3', 'pos3');
    ''');
  });

  test('Get declensions', () {
    declensionRepository.save(1, 1001, {1001, 1002});
    declensionRepository.save(1, 1001, {1003});

    var declensions = declensionRepository.getByLangIdAndPosId(1, 1001);

    expect(declensions.length, 2);
    expect(declensions[0].id, 1);
    expect(declensions[0].main, false);
    expect(declensions[0].values.length, 2);
    expect(declensions[0].values.contains(1001), true);
    expect(declensions[0].values.contains(1002), true);
    expect(declensions[1].values.length, 1);
    expect(declensions[1].values.contains(1003), true);
  });

  test('Save declension', () {
    declensionRepository.save(1, 1001, {1001, 1002, 1003});

    var rows = db.select("SELECT * from declension_tbl");
    expect(rows.length, 1);
    var rowsValues = db.select("SELECT * from declension_value_connection_tbl");
    expect(rowsValues.length, 3);
  });

  test('Delete declension', () {
    declensionRepository.save(1, 1001, {1001, 1002, 1003});

    var id = db.select("SELECT id from declension_tbl").first['id'];

    declensionRepository.delete(id);

    var rows = db.select("SELECT * from declension_tbl");
    expect(rows.length, 0);
    var rowsValues = db.select("SELECT * from declension_value_connection_tbl");
    expect(rowsValues.length, 0);
  });
}
