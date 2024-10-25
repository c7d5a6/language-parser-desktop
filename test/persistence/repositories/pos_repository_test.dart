import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:language_parser_desktop/persistence/entities/pos_entity.dart';
import 'package:language_parser_desktop/persistence/repositories/pos_repository.dart';
import 'package:language_parser_desktop/util/sqlite.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  late Database db;
  late PosRepository posRepository;
  late List<Pos> initialPoses;

  setUp(() async {
    db = sqlite3.openInMemory();
    await migrate(db);
    posRepository = PosRepository(db);
    initialPoses = posRepository.getAll();
  });

  test('Get all poses', () {
    db.execute('''
    INSERT INTO pos_tbl (id, name, abbreviation) VALUES 
    (1001, 'Pos 1', 'pos1'),
    (1002, 'Pos 2', 'pos2'),
    (1003, 'Pos 3', 'pos3');
    ''');

    var poses = posRepository.getAll();

    expect(3 + initialPoses.length, poses.length);
    var pos = poses[initialPoses.length];
    expect(pos.id, isNot(null));
    expect(pos.name, 'Pos 1');
    expect(pos.abbreviation, 'pos1');
  });

  test('Get poses by id', () {
    db.execute('''
    INSERT INTO pos_tbl (id, name, abbreviation) VALUES 
    (1001, 'Pos 1', 'pos1'),
    (1002, 'Pos 2', 'pos2'),
    (1003, 'Pos 3', 'pos3');
    ''');

    var pos = posRepository.getById(1002);

    expect(pos.id, 1002);
    expect(pos.name, 'Pos 2');
    expect(pos.abbreviation, 'pos2');
  });

  test('Get poses by id throws if no pos', () {
    expect(() => posRepository.getById(0), throwsA(isA<StateError>()));
  });

  test('Save Pos', () {
    var model = PosCreatingModel('Pos new', null);

    var pos = posRepository.save(model);

    expect(pos.id, initialPoses.length + 1);
    expect(pos.name, 'Pos new');
    expect(pos.abbreviation, null);
  });

  test('Update Pos', () {
    db.execute('''
    INSERT INTO pos_tbl (id, name, abbreviation) VALUES 
    (1001, 'Pos 1', 'pos1'),
    (1002, 'Pos 2', 'pos2'),
    (1003, 'Pos 3', 'pos3');
    ''');

    posRepository.update(PosUpdatingModel(1001, 'Updated', null));
    final pos = posRepository.getById(1001);

    expect(pos.id, 1001);
    expect(pos.name, 'Updated');
    expect(pos.abbreviation, null);
  });

  test('Delete Pos', () {
    db.execute('''
    INSERT INTO pos_tbl (id, name, abbreviation) VALUES 
    (1001, 'Pos 1', 'pos1'),
    (1002, 'Pos 2', 'pos2'),
    (1003, 'Pos 3', 'pos3');
    ''');

    posRepository.delete(1002);
    final poses = posRepository.getAll();

    expect(poses.length, 2 + initialPoses.length);
    expect(poses[poses.length - 1].id, 1003);
  });
}
