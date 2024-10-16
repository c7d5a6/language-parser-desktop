import 'dart:developer';

import 'package:flutter/services.dart' show AssetManifest, rootBundle;
import 'package:language_parser_desktop/util/word_generator.dart';
import 'package:sqlite3/sqlite3.dart';

const assetsPath = 'assets/db/';
const migrationsPath = '${assetsPath}migrations/';

Database? database;

void newDb(String path) {
  log('New db in path: $path');
  var tmp = sqlite3.openInMemory();
  database = sqlite3.open(path);
  tmp.backup(database!, nPage: -1);
  tmp.dispose();
  migrate(database!);
}

void setDb(String path) {
  log('Set db in path: $path');
  database = sqlite3.open(path);
  migrate(database!);
}

void generateWords() {
  if (database != null) {
    generateSQL(database!);
  }
}

void main() async {
  print('Using sqlite3 ${sqlite3.version}');
  // printPragma();
  // checkData();
  await checkAssets();
  var db = sqlite3.openInMemory();
  pragmaSelect(db, 'user_version');
  await migrate(db);
  pragmaSelect(db, 'user_version');
}

Future<void> checkAssets() async {
  final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
  for (String asset in assetManifest.listAssets()) {
    print('Asset: $asset');
  }
}

Future<void> migrate(Database db) async {
  final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
  final migrations = assetManifest.listAssets().where((p) => p.startsWith(migrationsPath));
  final versions = migrations
      .map((m) => int.parse(m.substring(migrationsPath.length, m.indexOf('_', migrationsPath.length))))
      .toList(growable: false)
    ..sort();
  var uversion = db.select("PRAGMA user_version;").single['user_version'];
  for (int version in versions) {
    if (version <= uversion) continue;
    var migrationPath = migrations.firstWhere((p) => p.startsWith('$migrationsPath${version}_'));
    var migration = await rootBundle.loadString(migrationPath);
    db.execute('BEGIN TRANSACTION;');
    try {
      db.execute(migration);
      db.execute('''
      PRAGMA user_version = $version;
      ''');
      db.execute('COMMIT;');
      print('Migration $version successful');
    } catch (e) {
      if (e.runtimeType == SqliteException) {
        final se = e as SqliteException;
        if (se.message == 'error in tokenizer constructor') {
          db.execute('''
          PRAGMA user_version = $version;
          ''');
          db.execute('COMMIT;');
          print('Migration $version successful, with warning about tokenizer');
        } else {
          db.execute('ROLLBACK;');
          print('Migration $version failed with sqlite exception: ${se.message}\n$e');
        }
      } else {
        db.execute('ROLLBACK;');
        print('Migration $version failed: $e');
      }
    }
  }
}

void checkData() {
  var db = sqlite3.open('./temp.sqlt3');
  pragmaSelect(db, 'data_version');
  var dm = sqlite3.copyIntoMemory(db);
  pragmaSelect(db, 'data_version');
  db.dispose();

  pragmaSelect(dm, 'data_version');
  dm.execute('''
    DROP TABLE IF EXISTS word_tbl;
    CREATE TABLE word_tbl (
      id INTEGER NOT NULL PRIMARY KEY,
      word TEXT NOT NULL,
      written_word TEXT NOT NULL
    );
  ''');
  final stmt = dm.prepare('INSERT INTO word_tbl (word, written_word) VALUES (?,?)');
  stmt.execute(['abc2', 'abc']);
  stmt.execute(['abc3', 'abc']);
  stmt.dispose();
  pragmaSelect(dm, 'data_version');
  var db2 = sqlite3.open('./temp.sqlt3');
  dm.backup(db2, nPage: -1).drain();
  pragmaSelect(dm, 'data_version');
  pragmaSelect(db2, 'data_version');
  dm.dispose();
  db2.dispose();
}

void printPragma() {
  var db = sqlite3.open('./temp.sqlt3');
  pragmaSelect(db, 'application_id');
  pragmaSelect(db, 'cell_size_check');
  // pragmaSelect(db, 'compile_options');
  pragmaSelect(db, 'data_version');
  // pragmaSelect(db, 'optimize');
  pragmaSelect(db, 'user_version');
  db.dispose();
}

void pragmaSelect(Database db, String variable) {
  var pragma = db.select("PRAGMA $variable;");
  for (final Row row in pragma) {
    print("$variable ${row[variable]}");
  }
}
