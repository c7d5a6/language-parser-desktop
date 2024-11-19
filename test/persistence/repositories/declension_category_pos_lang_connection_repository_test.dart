import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:language_parser_desktop/persistence/repositories/declension_category_pos_lang_connection_repository.dart';
import 'package:language_parser_desktop/util/sqlite.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late Database db;
  late DeclensionCategoryPosLangConnectionRepository declensionCategoryPosLangConnectionRepository;

  setUp(() async {
    db = sqlite3.openInMemory();
    await migrate(db);
    declensionCategoryPosLangConnectionRepository = DeclensionCategoryPosLangConnectionRepository(db);
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
    INSERT INTO pos_tbl (id, name, abbreviation) VALUES 
    (1001, 'Pos 1', 'pos1'),
    (1002, 'Pos 2', 'pos2'),
    (1003, 'Pos 3', 'pos3');
    ''');
  });

  test('Get pos ids', () {
    db.execute('''
    INSERT INTO declension_category_pos_lang_connection_tbl (lang_id,pos_id,gc_id) VALUES 
    (1, 1001, 1001),                                          
    (1, 1002, 1001),                                          
    (1, 1001, 1002),                                          
    (2, 1001, 1001);                                          
    ''');

    var poses = declensionCategoryPosLangConnectionRepository.getPosIdsByLangId(1);

    expect(poses.length, 2);
    expect(poses.contains(1001), true);
    expect(poses.contains(1002), true);
  });

  test('Get pos ids', () {
    db.execute('''
    INSERT INTO declension_category_pos_lang_connection_tbl (lang_id,pos_id,gc_id) VALUES 
    (1, 1001, 1001),                                          
    (1, 1002, 1001),                                          
    (1, 1001, 1002),                                          
    (2, 1001, 1001);                                          
    ''');

    var poses = declensionCategoryPosLangConnectionRepository.getGCsIdsByLangIdAndPosId(1, 1001);

    expect(poses.length, 2);
    expect(poses.contains(1001), true);
    expect(poses.contains(1002), true);
  });

  test('Save GC', () {
    declensionCategoryPosLangConnectionRepository.save(1, 1001, 1001);

    var rows = db.select("SELECT * from declension_category_pos_lang_connection_tbl");
    expect(rows.length, 1);
  });

  test('Delete GC', () {
    db.execute('''
    INSERT INTO declension_category_pos_lang_connection_tbl (lang_id,pos_id,gc_id) VALUES 
    (1, 1001, 1001),                                          
    (1, 1002, 1001),                                          
    (1, 1001, 1002),                                          
    (2, 1001, 1001);                                          
    ''');

    declensionCategoryPosLangConnectionRepository.delete(1, 1001, 1001);

    var rows = db.select("SELECT * from declension_category_pos_lang_connection_tbl");
    expect(rows.length, 3);
  });
}
