import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:language_parser_desktop/persistence/entities/grammatical_category_entity.dart';
import 'package:language_parser_desktop/persistence/repositories/gc_repository.dart';
import 'package:language_parser_desktop/persistence/repositories/gcv_repository.dart';
import 'package:language_parser_desktop/util/sqlite.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late Database db;
  late GrammaticalCategoryValueRepository gcvRepository;
  late GrammaticalCategoryRepository gcRepository;
  late GrammaticalCategory gc;

  setUp(() async {
    db = sqlite3.openInMemory();
    await migrate(db);
    gcvRepository = GrammaticalCategoryValueRepository(db);
    gcRepository = GrammaticalCategoryRepository(db);
    db.execute('''
    INSERT INTO grammatical_category_tbl (id, name) VALUES 
    (1000, 'GC 0'),
    (1001, 'GC 1');
    ''');
    gc = gcRepository.getById(1001);
  });

  test('Get all gcvs', () {
    db.execute('''
    INSERT INTO grammatical_category_value_tbl (id, name, category_id) VALUES 
    (1, 'GCV 1', 1001),
    (2, 'GCV 2', 1001),
    (3, 'GCV 3', 1001),
    (4, 'GCV 4', 1000);
    ''');

    var gcvs = gcvRepository.getAllByGCId(1001);

    expect(gcvs.length, 3);
    var gcv = gcvs[0];
    expect(gcv.id, isNot(null));
    expect(gcv.name, 'GCV 1');
    expect(gcv.gc.id, gc.id);
  });

  test('Get gcv by id', () {
    db.execute('''
    INSERT INTO grammatical_category_value_tbl (id, name, category_id) VALUES 
    (1, 'GCV 1', 1001),
    (2, 'GCV 2', 1001),
    (3, 'GCV 3', 1001);
    ''');

    var gcv = gcvRepository.getById(2);

    expect(gcv.id, 2);
    expect(gcv.name, 'GCV 2');
    expect(gcv.gc.id, gc.id);
  });

  test('Get gcvs by id throws if no gc', () {
    expect(() => gcvRepository.getById(0), throwsA(isA<StateError>()));
  });

  test('Save GCV', () {
    var model = GrammaticalCategoryValueCreatingModel('GC new', gc);

    var gcv = gcvRepository.save(model);

    expect(gcv.id, 1);
    expect(gcv.name, 'GC new');
    expect(gcv.gc.id, gc.id);
  });

  test('Update GCV', () {
    db.execute('''
    INSERT INTO grammatical_category_value_tbl (id, name, category_id) VALUES 
    (1, 'GCV 1', 1001),
    (2, 'GCV 2', 1001),
    (3, 'GCV 3', 1001);
    ''');

    gcvRepository.update(GrammaticalCategoryValueUpdatingModel(1, 'Updated'));
    final gcv = gcvRepository.getById(1);

    expect(gcv.id, 1);
    expect(gcv.name, 'Updated');
    expect(gcv.gc.id, 1001);
  });

  test('Delete GCV', () {
    db.execute('''
    INSERT INTO grammatical_category_value_tbl (id, name, category_id) VALUES 
    (1, 'GCV 1', 1001),
    (2, 'GCV 2', 1001),
    (3, 'GCV 3', 1001);
    ''');

    gcvRepository.delete(2);
    final gcvs = gcvRepository.getAllByGCId(1001);

    expect(gcvs.length, 2);
    expect(gcvs[gcvs.length - 1].id, 3);
  });
}
