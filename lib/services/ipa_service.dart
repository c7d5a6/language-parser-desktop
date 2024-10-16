class IpaService {
  //Pulmonic consonants
  //Manner
  static const List<String> plumonicConsonantsNasal = [
    "m̥",
    "m",
    "ɱ",
    "n̼",
    "n̥",
    "n",
    "ɳ̊",
    "ɳ",
    "ɲ̊",
    "ɲ",
    "ŋ̊",
    "ŋ",
    "ɴ"
  ];
  static const List<String> plumonicConsonantsPlosive = [
    "p",
    "b",
    "p̪",
    "b̪",
    "t̼",
    "d̼",
    "t",
    "d",
    "ʈ",
    "ɖ",
    "c",
    "ɟ",
    "k",
    "ɡ",
    "q",
    "ɢ",
    "ʡ",
    "ʔ"
  ];
  static const List<String> plumonicConsonantsSibilantFricative = ["s", "z", "ʃ", "ʒ", "ʂ", "ʐ", "ɕ", "ʑ"];
  static const List<String> plumonicConsonantsNonSibilantFricative = [
    "ɸ",
    "β",
    "f",
    "v",
    "θ̼",
    "ð̼",
    "θ",
    "ð",
    "θ̠",
    "ð̠",
    "ɹ̠̊˔",
    "ɹ̠˔",
    "",
    "ɻ˔",
    "ç",
    "ʝ",
    "x",
    "ɣ",
    "χ",
    "ʁ",
    "ħ",
    "ʕ",
    "h",
    "ɦ"
  ];
  static const List<String> plumonicConsonantsApproximant = ["ʋ", "ɹ", "ɻ", "j", "ɰ", "ʔ̞"];
  static const List<String> plumonicConsonantsTapFlap = ["ⱱ̟", "ⱱ", "ɾ̼", "ɾ̥", "ɾ", "ɽ̊", "ɽ", "ɢ̆", "ʡ̆"];
  static const List<String> plumonicConsonantsTrill = ["ʙ̥", "ʙ", "r̥", "r", "ɽ̊r̥", "ɽr", "ʀ̥", "ʀ", "ʜ", "ʢ"];
  static const List<String> plumonicConsonantsLateralFricative = ["ɬ", "ɮ", "ɭ̊˔", "ɭ˔", "ʎ̝̊", "ʎ̝", "ʟ̝̊", "ʟ̝"];
  static const List<String> plumonicConsonantsLateralApproximant = ["l̥", "l", "ɭ", "ʎ", "ʟ", "ʟ̠"];
  static const List<String> plumonicConsonantsLateralTapFlap = ["ɺ̥", "ɺ", "ɭ̥̆", "ɭ̆", "ʎ̝̆̊", "ʟ̆"];
  static final List<String> plumonicConsonants = List.empty(growable: true)
    ..addAll(plumonicConsonantsNasal)
    ..addAll(plumonicConsonantsPlosive)
    ..addAll(plumonicConsonantsSibilantFricative)
    ..addAll(plumonicConsonantsNonSibilantFricative)
    ..addAll(plumonicConsonantsApproximant)
    ..addAll(plumonicConsonantsTapFlap)
    ..addAll(plumonicConsonantsTrill)
    ..addAll(plumonicConsonantsLateralFricative)
    ..addAll(plumonicConsonantsLateralApproximant)
    ..addAll(plumonicConsonantsLateralTapFlap);

  // Non-pulmonic consonants
  // Manner
  static const List<String> ejectiveStop = ["pʼ", "tʼ", "ʈʼ", "cʼ", "kʼ", "qʼ", "ʡʼ"];
  static const List<String> ejectiveFricative = ["ɸʼ", "fʼ", "θʼ", "sʼ", "ʃʼ", "ʂʼ", "ɕʼ", "xʼ", "χʼ"];
  static const List<String> ejectiveLateralFricative = ["ɬʼ"];
  static final List<String> ejective = List.empty(growable: true)
    ..addAll(ejectiveStop)
    ..addAll(ejectiveFricative)
    ..addAll(ejectiveLateralFricative);
  static const List<String> clickTenuis = ["kʘ", "qʘ", "kǀ", "qǀ", "kǃ", "qǃ", "k‼", "q‼", "kǂ", "qǂ"];
  static const List<String> clickVoiced = ["ɡʘ", "ɢʘ", "ɡǀ", "ɢǀ", "ɡǃ", "ɢǃ", "ɡ‼", "ɢ‼", "ɡǂ", "ɢǂ"];
  static const List<String> clickNasal = ["ŋʘ", "ɴʘ", "ŋǀ", "ɴǀ", "ŋǃ", "ɴǃ", "ŋ‼", "ɴ‼", "ŋǂ", "ɴǂ", "ʞ"];
  static const List<String> clickTenuisLateral = ["kǁ", "qǁ"];
  static const List<String> clickVoicedLateral = ["ɡǁ", "ɢǁ"];
  static const List<String> clickNasalLateral = ["ŋǁ", "ɴǁ"];
  static final List<String> click = List.empty(growable: true)
    ..addAll(clickTenuis)
    ..addAll(clickVoiced)
    ..addAll(clickNasal)
    ..addAll(clickTenuisLateral)
    ..addAll(clickVoicedLateral)
    ..addAll(clickNasalLateral);
  static const List<String> implosiveVoiced = ["ɓ", "ɗ", "ᶑ", "ʄ", "ɠ", "ʛ"];
  static const List<String> implosiveVoiceless = ["ɓ̥", "ɗ̥̥", "ᶑ̊", "ʄ̊", "ɠ̊", "ʛ̥"];
  static final List<String> implosive = List.empty(growable: true)
    ..addAll(implosiveVoiced)
    ..addAll(implosiveVoiceless);

  // Affricates
  // Pulmonic
  static const List<String> affricatePulmonicSibilant = ["ʦ", "ʣ", "ʧ", "ʤ", "ʈ͡ʂ", "ɖ͡ʐ", "ʨ", "ʥ"];
  static const List<String> affricatePulmonicNonSibilant = [
    "p͡ɸ",
    "b͡β",
    "p̪͡f",
    "b̪͡v",
    "t̪͡θ",
    "d̪͡ð",
    "t͡ɹ̝̊",
    "d͡ɹ̝̠",
    "t̠͡ɹ̠̊˔",
    "d̠͡ɹ̠˔",
    "c͡ç",
    "ɟ͡ʝ",
    "k͡x",
    "ɡ͡ɣ",
    "q͡χ",
    "ɢ͡ʁ",
    "ʡ͡ʢ",
    "ʔ͡h"
  ];
  static const List<String> affricatePulmonicLateral = [
    "t͡ɬ",
    "d͡ɮ",
    "ʈ͡ɭ̊˔",
    "ɖ͡ɭ˔",
    "c͡ʎ̝̊",
    "ɟ͡ʎ̝",
    "k͡ʟ̝̊",
    "ɡ͡ʟ̝"
  ];
  static final List<String> affricatePulmonic = List.empty(growable: true)
    ..addAll(affricatePulmonicSibilant)
    ..addAll(affricatePulmonicNonSibilant)
    ..addAll(affricatePulmonicLateral);
  static const List<String> affricateEjectiveCentral = ["t̪͡θʼ", "t͡sʼ", "t̠͡ʃʼ", "ʈ͡ʂʼ", "k͡xʼ", "q͡χʼ"];
  static const List<String> affricateEjectiveLateral = ["t͡ɬʼ", "c͡ʎ̝̊ʼ", "k͡ʟ̝̊ʼ"];
  static final List<String> affricateEjective = List.empty(growable: true)
    ..addAll(affricateEjectiveCentral)
    ..addAll(affricateEjectiveLateral);
  static final List<String> affricate = List.empty(growable: true)
    ..addAll(affricatePulmonic)
    ..addAll(affricateEjective);

  //Co-articulated consonants
  static const List<String> coArticulatedNasal = ["n͡m", "ŋ͡m"];
  static const List<String> coArticulatedPlosive = ["t͡p", "d͡b", "k͡p", "ɡ͡b", "q͡ʡ"];
  static const List<String> coArticulatedFricativeApproximant = ["ɥ̊", "ɥ", "ʍ", "w", "ɧ"];
  static const List<String> coArticulatedLateral = ["ɫ"];
  static final List<String> coArticulated = List.empty(growable: true)
    ..addAll(coArticulatedNasal)
    ..addAll(coArticulatedPlosive)
    ..addAll(coArticulatedFricativeApproximant)
    ..addAll(coArticulatedLateral);

  // All consonants
  static final List<String> consonants = List.empty(growable: true)
    ..addAll(plumonicConsonants)
    ..addAll(ejective)
    ..addAll(click)
    ..addAll(implosive)
    ..addAll(affricate)
    ..addAll(coArticulated);

  ////////////////////////////////////////////////////////////////////////////////////////
  //////////////                 VOWELS
  ////////////////////////////////////////////////////////////////////////////////////////
  static const List<String> vowelClose = ["i", "y", "ɨ", "ʉ", "ɯ", "u"];
  static const List<String> vowelNearClose = ["ɪ", "ʏ", "ʊ"];
  static const List<String> vowelCloseMid = ["e", "ø", "ɘ", "ɵ", "ɤ", "o"];
  static const List<String> vowelMid = ["e̞", "ø̞", "ə", "ɤ̞", "o̞"];
  static const List<String> vowelOpenMid = ["ɛ", "œ", "ɜ", "ɞ", "ʌ", "ɔ"];
  static const List<String> vowelNearOpen = ["æ", "ɐ"];
  static const List<String> vowelOpen = ["a", "ɶ", "ä", "ɑ", "ɒ"];
  static final List<String> vowel = List.empty(growable: true)
    ..addAll(vowelClose)
    ..addAll(vowelNearClose)
    ..addAll(vowelCloseMid)
    ..addAll(vowelMid)
    ..addAll(vowelOpenMid)
    ..addAll(vowelNearOpen)
    ..addAll(vowelOpen);

  ////////////////////////////////////////////////////////////////////////////////////////
  static final List<String> allSounds = List.empty(growable: true)
    ..addAll(consonants)
    ..addAll(vowel);

  ///
  // Additions
  static const List<String> constanantVariants = ["ʰ", "ʷ", "ʲ", "ʷʰ", "ː"];
  static const List<String> vowelVariant = ["ː", "ʼ"];

  static final List<String> allConstanantVariants = getVariables(constanantVariants, consonants);
  static final List<String> allVowelVariants = getVariables(vowelVariant, vowel);
  static final List<String> allSoundsWithVariants = List.empty(growable: true)
    ..addAll(allVowelVariants)
    ..addAll(allConstanantVariants);

  static List<String> getVariables(List<String> addition, List<String> phonemes) {
    final List<String> vrlbs =
        addition.map((s) => phonemes.map((c) => c + s).toList()).fold([], (l, css) => l..addAll(css));
    return List.empty(growable: true)
      ..addAll(phonemes)
      ..addAll(vrlbs);
  }

//        IPA = IPA.normalize('NFD');
  static String cleanIPA(String ipaText) {
    return ipaText
        .trim()
        .replaceAll("g", "ɡ")
        .replaceAll(":", "ː")
        .replaceAll("’", "ʼ")
        .replaceAll("Ø", "∅")
        .replaceAll("ɚ", "ə˞");
//                .replaceAll("\\?", "ʔ");
//                .replaceAll('!VOICELESS PALATAL FRICATIVE', 'ç');
  }
}
