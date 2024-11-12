import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:language_parser_desktop/persistence/entities/grammatical_category_entity.dart';
import 'package:language_parser_desktop/persistence/repositories/gc_repository.dart';
import 'package:language_parser_desktop/util/sqlite.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late Database db;
  late GrammaticalCategoryRepository gcRepository;
  late List<GrammaticalCategory> initialGCs;

  setUp(() async {
    db = sqlite3.openInMemory();
    await migrate(db);
    gcRepository = GrammaticalCategoryRepository(db);
    initialGCs = gcRepository.getAll();
  });

  test('Get all gcs', () {
    db.execute('''
    INSERT INTO grammatical_category_tbl (id, name) VALUES 
    (1001, 'GC 1'),
    (1002, 'GC 2'),
    (1003, 'GC 3');
    ''');

    var poses = gcRepository.getAll();

    expect(3 + initialGCs.length, poses.length);
    var gc = poses[initialGCs.length];
    expect(gc.id, isNot(null));
    expect(gc.name, 'GC 1');
  });

  test('Get gc by id', () {
    db.execute('''
    INSERT INTO grammatical_category_tbl (id, name) VALUES 
    (1001, 'GC 1'),
    (1002, 'GC 2'),
    (1003, 'GC 3');
    ''');

    var gc = gcRepository.getById(1002);

    expect(gc.id, 1002);
    expect(gc.name, 'GC 2');
  });

  test('Get gcs by id throws if no gc', () {
    expect(() => gcRepository.getById(0), throwsA(isA<StateError>()));
  });

  test('Save GC', () {
    var model = GrammaticalCategoryCreatingModel('GC new');

    var gc = gcRepository.save(model);

    expect(gc.id, initialGCs.length + 1);
    expect(gc.name, 'GC new');
  });

  test('Update GC', () {
    db.execute('''
    INSERT INTO grammatical_category_tbl (id, name) VALUES 
    (1001, 'GC 1'),
    (1002, 'GC 2'),
    (1003, 'GC 3');
    ''');

    gcRepository.update(GrammaticalCategoryUpdatingModel(1001, 'Updated'));
    final gc = gcRepository.getById(1001);

    expect(gc.id, 1001);
    expect(gc.name, 'Updated');
  });

  test('Delete GC', () {
    db.execute('''
    INSERT INTO grammatical_category_tbl (id, name) VALUES 
    (1001, 'GC 1'),
    (1002, 'GC 2'),
    (1003, 'GC 3');
    ''');

    gcRepository.delete(1002);
    final poses = gcRepository.getAll();

    expect(poses.length, 2 + initialGCs.length);
    expect(poses[poses.length - 1].id, 1003);
  });
}
