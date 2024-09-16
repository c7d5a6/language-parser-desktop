import 'dart:developer';

import 'package:sqlite3/sqlite3.dart';
import 'package:flutter/services.dart' show AssetManifest, rootBundle;

void main() async {
  print('Using sqlite3 ${sqlite3.version}');
  // printPragma();
  // checkData();
  await checkAssets();
}

Future<void> checkAssets() async {
  final assetManifest = await AssetManifest.loadFromAssetBundle(rootBundle);
  for(String asset in assetManifest.listAssets()){
    print('Asset: $asset');
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
  for(final Row row in pragma) {
    print("$variable ${row[variable]}");
  }
}
