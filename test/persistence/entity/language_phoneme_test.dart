import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:language_parser_desktop/util/sqlite.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late Database db;

  setUp(() async {
    db = sqlite3.openInMemory();
    await migrate(db);
  });

  test('Test unique index', () {
    db.execute('''
    INSERT INTO language_tbl (id, display_name, native_name, comment) VALUES 
    (1, 'Language 1', 'Native name 1', 'Comment 1');
    ''');
    var insert = db.prepare('''
    INSERT INTO language_phoneme_tbl (phoneme, language) VALUES 
    ('ph', 1);
   ''', persistent: true);
    insert.execute();
    expect(() => insert.execute(), throwsA(isA<SqliteException>()));
  });
}
