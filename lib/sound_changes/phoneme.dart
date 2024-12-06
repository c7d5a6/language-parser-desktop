import 'package:language_parser_desktop/enums/feature.dart' show Feature;
import 'package:language_parser_desktop/util/pair.dart';

class Phoneme {
  String? _original;
  bool unknownType = false;
  PhonemicFeatures features;

  Phoneme(String phoneme)
      : _original = phoneme,
        features = PhonemicFeatures() {
    if (constPhonemes.containsKey(phoneme)) {
      features = constPhonemes[phoneme]!.features.copy();
    } else {
      unknownType = true;
    }
  }

  Phoneme._phoneme(this._original, this.features);

  String get sound {
    if (_original == null) {
      _original = findOriginal();
    }
    return _original!;
  }

  Pair<int, int> get mask => Pair(features._plusMask, features._minusMask);

  Phoneme withDiacritic(String diacritic) {
    assert(_original != null);
    assert(constDiacritics.containsKey(diacritic));
    var newFeatures = features.apply(constDiacritics[diacritic]!);
    return Phoneme._phoneme(_original! + diacritic, newFeatures);
  }

  Phoneme apply(PhonemicFeatures changes) {
    var newFeatures = features.apply(changes);
    return Phoneme._phoneme(null, newFeatures);
  }

  String findOriginal() {
    for (Phoneme phoneme in constFeatureMasks.values) {
      if (phoneme.mask == mask) return phoneme.sound;
      for (String diacritic in constDiacritics.keys) {
        var newPhoneme = phoneme.withDiacritic(diacritic);
        if (newPhoneme.mask == mask) return phoneme.sound + diacritic;
      }
    }
    assert(false);
    return '';
  }
}

class PhonemicFeatures {
  Set<Feature> _plusFeatures = {};
  int _plusMask = 0;
  Set<Feature> _minusFeatures = {};
  int _minusMask = 0;

  PhonemicFeatures();

  PhonemicFeatures.fromSets(Set<Feature> plus, Set<Feature> minus) {
    plusFeatures = plus;
    minusFeatures = minus;
  }

  set plusFeatures(Set<Feature> plus) {
    assert(plus.length == (plus.toSet()..removeAll(_minusFeatures)).length);
    _plusFeatures = plus;
    _plusMask = plus.fold(0, (p, f) => f.hash | p);
  }

  set minusFeatures(Set<Feature> minus) {
    assert(minus.length == (minus.toSet()..removeAll(_plusFeatures)).length);
    _minusFeatures = minus;
    _minusMask = minus.fold(0, (p, f) => f.hash | p);
  }

  void addFeature(Feature feature) {
    _removeFeatureFromMinus(feature);
    _addFeatureToPlus(feature);
  }

  void removeFeature(Feature feature) {
    _addFeatureToMinus(feature);
    _removeFeatureFromPlus(feature);
    switch (feature) {
      case Feature.dorsal:
        {
          disableFeature(Feature.high);
          disableFeature(Feature.low);
          disableFeature(Feature.front);
          disableFeature(Feature.back);
        }
      case Feature.coronal:
        {
          disableFeature(Feature.anterior);
          disableFeature(Feature.distributed);
          disableFeature(Feature.strident);
        }
      default:
        {}
    }
  }

  void disableFeature(Feature feature) {
    _removeFeatureFromPlus(feature);
    _removeFeatureFromMinus(feature);
  }

  void _addFeatureToPlus(Feature feature) {
    _plusFeatures.add(feature);
    _plusMask = _plusMask | (feature.hash);
  }

  void _addFeatureToMinus(Feature feature) {
    _minusFeatures.add(feature);
    _minusMask = _minusMask | (feature.hash);
  }

  void _removeFeatureFromPlus(Feature feature) {
    _plusFeatures.remove(feature);
    _plusMask = _plusMask & (~feature.hash);
  }

  void _removeFeatureFromMinus(Feature feature) {
    _minusFeatures.remove(feature);
    _minusMask = _minusMask & (~feature.hash);
  }

  @override
  String toString() {
    return 'PhonemicFeatures{_plusMask: $_plusMask, _minusMask: $_minusMask}';
  }

  PhonemicFeatures copy() {
    return PhonemicFeatures.fromSets(_plusFeatures.toSet(), _minusFeatures.toSet());
  }

  PhonemicFeatures apply(PhonemicFeatures changes) {
    var newFeatures = PhonemicFeatures.fromSets(_plusFeatures.toSet(), _minusFeatures.toSet());
    changes._minusFeatures.forEach((f) => newFeatures.removeFeature(f));
    changes._plusFeatures.forEach((f) => newFeatures.addFeature(f));
    return newFeatures;
  }
}

Phoneme generatePhoneme(String phoneme, Set<Feature> plus, Set<Feature> minus) {
  return Phoneme._phoneme(phoneme, PhonemicFeatures.fromSets(plus, minus));
}

Map<String, Phoneme> constPhonemes = {
  "n": generatePhoneme("n", {
    Feature.consonantal,
    Feature.sonorant,
    Feature.nasal,
    Feature.voice,
    Feature.coronal,
    Feature.anterior
  }, {
    Feature.syllabic,
    Feature.stress,
    Feature.long,
    Feature.continuant,
    Feature.approximant,
    Feature.tap,
    Feature.trill,
    Feature.spread_glottis,
    Feature.constricted_glottis,
    Feature.labial,
    Feature.round,
    Feature.labiodental,
    Feature.distributed,
    Feature.strident,
    Feature.lateral,
    Feature.dorsal,
  }),
  "m": generatePhoneme("m", {
    Feature.consonantal,
    Feature.sonorant,
    Feature.nasal,
    Feature.voice,
    Feature.labial,
  }, {
    Feature.syllabic,
    Feature.stress,
    Feature.long,
    Feature.continuant,
    Feature.approximant,
    Feature.tap,
    Feature.trill,
    Feature.spread_glottis,
    Feature.constricted_glottis,
    Feature.round,
    Feature.labiodental,
    Feature.coronal,
    Feature.lateral,
    Feature.dorsal,
  }),
};

Map<Pair<int, int>, Phoneme> constFeatureMasks = Map.fromIterable(
  constPhonemes.values,
  key: (phoneme) => phoneme.mask,
  value: (phoneme) => phoneme,
);

Map<String, PhonemicFeatures> constDiacritics = {
  /*◌͏̪*/ "\u032A": PhonemicFeatures.fromSets({Feature.anterior, Feature.distributed}, {}),
  /*◌̥*/ "\u0325": PhonemicFeatures.fromSets({}, {Feature.voice})
};
