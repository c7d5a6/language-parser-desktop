import 'package:integration_test/integration_test.dart';
import 'package:language_parser_desktop/util/sqlite.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:test/test.dart';

const prefixPath = './test/persistence/migration/db';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  test('Migration empty db', () async {
    var fileDb = sqlite3.open('$prefixPath/00-version');

    var db = sqlite3.copyIntoMemory(fileDb);
    await migrate(db);

    final fileVersion = getUserVersion(fileDb);
    final version = getUserVersion(db);
    expect(fileVersion, 0);
    expect(version, 11);
  });
}

int getUserVersion(Database db) {
  return db.select("PRAGMA user_version;").single['user_version'];
}
