import 'package:language_parser_desktop/enums/feature.dart';
import 'package:language_parser_desktop/sound_changes/phoneme.dart';
import 'package:test/test.dart';

void main() {
  test('n -> m̥', () {
    Phoneme n = Phoneme('n');
    var changes = PhonemicFeatures.fromSets({Feature.labial}, {Feature.coronal});

    Phoneme m = n.apply(changes);
    Phoneme n_o = n.apply(PhonemicFeatures.fromSets({}, {Feature.voice}));
    Phoneme m_o = m.apply(PhonemicFeatures.fromSets({}, {Feature.voice}));

    expect(m.sound, "m");
    expect(n_o.sound, "n̥");
    expect(m_o.sound, "m̥");
  });
}
