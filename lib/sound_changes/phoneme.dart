import 'package:language_parser_desktop/enums/feature.dart' show Feature;

class Phoneme {
  String original;
  bool unknownType = false;
  _PhonemicFeatures features;

  Phoneme(String phoneme)
      : original = phoneme,
        features = _PhonemicFeatures() {
    //get start features
    //get unknowntype
  }

  Phoneme._phoneme(this.original, this.features);

  void addDiacritic(String diacritic) {
    original = original + diacritic;
    //add features;
  }
}

class _PhonemicFeatures {
  Set<Feature> _plusFeatures = {};
  int _plusMask = 0;
  Set<Feature> _minusFeatures = {};
  int _minusMask = 0;

  _PhonemicFeatures();

  _PhonemicFeatures.fromSets(Set<Feature> plus, Set<Feature> minus) {
    _plusFeatures = plus;
    _minusFeatures = minus;
    _plusMask = plus.fold(0, (p, f) => f.hash | p);
    _minusMask = minus.fold(0, (p, f) => f.hash | p);
  }
}

Phoneme generatePhoneme(String phoneme, Set<Feature> plus, Set<Feature> minus) {
  return Phoneme._phoneme(phoneme, _PhonemicFeatures.fromSets(plus, minus));
}

Map<String, Phoneme> constPhonemes = {
  "ɒ": generatePhoneme("ɒ", {
    Feature.syllabic,
    Feature.sonorant,
    Feature.continuant,
    Feature.approximant,
    Feature.voice,
    Feature.labial,
    Feature.round,
    Feature.dorsal,
    Feature.low,
    Feature.back
  }, {}),
  // }, {Feature.stress,Feature.long,Feature.consonantal,Feature.tap,Feature.trill,Feature.nasal,Feature.sp}),
};
