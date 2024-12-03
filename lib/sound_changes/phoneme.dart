import 'package:language_parser_desktop/enums/feature.dart';

class Phoneme {
  String original;
  bool unknownType = false;
  Set<Feature> features = {};
  int futureMask = 0;

  Phoneme(String phoneme) : this.original = phoneme {
    //get start features
    //get unknowntype
  }

  void addDiacritic(String diacritic) {
    original = original + diacritic;
    //add features;
  }
}
