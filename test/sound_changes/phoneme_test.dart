import 'package:language_parser_desktop/enums/feature.dart';
import 'package:language_parser_desktop/sound_changes/phoneme.dart';
import 'package:test/test.dart';

void main() {
  test('', () {
    var pf = PhonemicFeatures();
    print(pf);
    pf.addFeature(Feature.voice);
    print(pf);
    pf.addFeature(Feature.dorsal);
    print(pf);
    pf.removeFeature(Feature.approximant);
    print(pf);
    pf.removeFeature(Feature.dorsal);
    print(pf);
    pf.removeFeature(Feature.voice);
    print(pf);
    pf.addFeature(Feature.approximant);
    print(pf);
  });
}
