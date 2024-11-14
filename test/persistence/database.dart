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

  test('Test foreign keys index', () {
    var tables = db.select("PRAGMA table_list;");
    tables.map((r) => r['name'] as String).forEach((tableName) {
      var fkeys = db.select("PRAGMA foreign_key_list('$tableName');");
      var idxes = db.select("PRAGMA index_list('$tableName');").map((idx) {
        return db.select("PRAGMA index_xinfo('${idx['name']}');");
      });
      print("IDXS $tableName $idxes");
      fkeys.forEach((fkey) {
        String? onDel = fkey['on_delete'];
        String? key = fkey['from'];
        expect(onDel, 'RESTRICT', reason: 'on table $tableName from $key');
        print('FKEY $tableName on $key');
        var fkIdxCount = idxes.where((rs) {
          print("IDX $tableName on $key $rs");
          return rs.length == 2 && rs.first['name'] == key;
        }).length;
        expect(fkIdxCount, 1, reason: 'Expected index on fkey $key on table $tableName');
      });
    });
  });

  test('Pragma', () {
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
    ('Word 1', 1, 1001, 'NEW', 'Comment word 1');
    ''');

    // db.execute('PRAGMA foreign_keys = ON; DELETE FROM language_tbl;');
    db.execute('PRAGMA foreign_keys = ON;');
    db.execute('DELETE FROM language_tbl;');
  });
}
