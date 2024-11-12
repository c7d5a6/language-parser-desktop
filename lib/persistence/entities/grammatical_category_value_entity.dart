import 'grammatical_category_entity.dart';

class GrammaticalCategoryValue {
  static String get table_name => 'grammatical_category_value_tbl';
  final int id;
  String name;
  GrammaticalCategory gc;

  GrammaticalCategoryValue(this.id, this.name, this.gc);
}
