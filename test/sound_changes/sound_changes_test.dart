import 'package:language_parser_desktop/enums/feature.dart';
import 'package:language_parser_desktop/sound_changes/phoneme.dart';
import 'package:test/test.dart';

void main() {
  test('n -> m̥', () {
    Phoneme n = Phoneme('n');
    var changes = PhonemicFeatures.fromSets({Feature.labial}, {Feature.coronal});

    Phoneme m = n.apply(changes);
    Phoneme nO = n.apply(PhonemicFeatures.fromSets({}, {Feature.voice}));
    Phoneme mO = m.apply(PhonemicFeatures.fromSets({}, {Feature.voice}));

    expect(m.sound, "m");
    expect(nO.sound, "n̥");
    expect(mO.sound, "m̥");
  });
}
