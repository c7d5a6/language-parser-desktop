import 'package:language_parser_desktop/enums/feature.dart';
import 'package:test/test.dart';

void main() {
  test('Less than 64 features', () {
    var size = Feature.values.length;
    expect(size < 64, true);
  });

  test('Feature has hash', () {
    var feature = Feature.sonorant;
    expect(feature.hash, int.parse("1000", radix: 2));
    expect(feature.index, 3);
  });
}
