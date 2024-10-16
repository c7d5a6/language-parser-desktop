import '../entities/pos_entity.dart';

Pos convertNamedEntity(row) {
  return Pos(row['pos_id'] as int, row['pos_name'] as String, row['pos_abbreviation'] as String?);
}
