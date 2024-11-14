import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:language_parser_desktop/persistence/entities/pos_lang_connection_entity.dart';
import 'package:language_parser_desktop/persistence/repositories/pos_lang_connection_repository.dart';
import 'package:language_parser_desktop/util/sqlite.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late Database db;
  late PosLangConnectionRepository posLangConnectionRepository;

  setUp(() async {
    db = sqlite3.openInMemory();
    await migrate(db);
    posLangConnectionRepository = PosLangConnectionRepository(db);
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

  test('Get connections by lang', () async {
    db.execute('''
    INSERT INTO pos_lang_connection_tbl (lang_id, pos_id) VALUES 
    (1,1001),
    (2,1001),
    (1,1002),
    (2,1003);
    ''');

    final poses = await posLangConnectionRepository.getPosIdsByLangId(1);

    expect(poses.length, 2);
    expect(poses.contains(1001), true);
    expect(poses.contains(1002), true);
  });

  test('Save connection', () {
    final langId = 1;
    final posId = 1001;

    posLangConnectionRepository.save(langId, posId);

    final result =
        db.select("SELECT count(*) FROM ${PosLangConnection.table_name} WHERE lang_id = $langId AND pos_id = $posId");
    expect(result.length, 1);
    expect(result.rows[0][0], 1);
  });

  test('Delete connection', () {
    final langId = 1;
    final posId = 1001;
    db.execute('INSERT INTO pos_lang_connection_tbl (lang_id, pos_id) VALUES ($langId, $posId);');

    posLangConnectionRepository.delete(langId, posId);

    final result =
        db.select("SELECT count(*) FROM ${PosLangConnection.table_name} WHERE lang_id = $langId AND pos_id = $posId");
    expect(result.length, 1);
    expect(result.rows[0][0], 0);
  });
}
