enum Feature {
  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////// MANNER FEATURES ///////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  // +-------------+--------+---------+--------+-------------+
  // |    Vowels   | Glides | Liquids | Nasals |  Obstruents |
  // +=============+========+=========+========+=============+
  // | [+syllabic] |               [−syllabic]               |
  // +-------------+--------+--------------------------------+
  // |    [−consonantal]    |         [+consonantal]         |
  // +----------------------+---------+----------------------+
  // |         [+approximant]         |    [−approximant]    |
  // +--------------------------------+--------+-------------+
  // |               [+sonorant]               | [−sonorant] |
  // +-----------------------------------------+-------------+
  syllabic,
  consonantal,
  approximant,
  sonorant,
  // +--------------------+------------+---------------+
  // |        Stops       | Affricates |   Fricatives  |
  // +====================+============+===============+
  // |          [−continuant]          | [+continuant] |
  // +--------------------+------------+---------------+
  // | [−delayed release] |     [+delayed release]     |
  // +--------------------+----------------------------+
  continuant,
  delayed_release,
  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////////////// VOWEL FEATURES  ///////////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  // +----------+---------+---------+
  // |   Front  | Central |   Back  |
  // +==========+=========+=========+
  // |       [−back]      | [+back] |
  // +----------+---------+---------+
  // | [+front] |      [−front]     |
  // +----------+-------------------+
  back,
  front,
  // upper high [+high] [−low] [+tense]
  // lower high [+high] [−low] [-tense]
  // upper mid  [-high] [−low] [+tense]
  // lower mid  [-high] [−low] [-tense]
  // low        [-high] [+low]
  high,
  low,
  tense,
  // ////////////// Rounding ///////////////////
  round,
  // +-----------------------+---------------------+---------------------+---------------------+
  // |                       |   [+front, −back]   |   [−front, −back]   |   [−front, +back]   |
  // |                       +----------+----------+----------+----------+----------+----------+
  // |                       | [−round] | [+round] | [−round] | [+round] | [−round] | [+round] |
  // +=======================+==========+==========+==========+==========+==========+==========+
  // | [+high, −low, +tense] |     i    |     y    |     ɨ    |     ʉ    |     ɯ    |     u    |
  // +-----------------------+----------+----------+----------+----------+----------+----------+
  // | [+high, −low, −tense] |     ɪ    |     ʏ    |          |          |          |     ʊ    |
  // +-----------------------+----------+----------+----------+----------+----------+----------+
  // | [−high, −low, +tense] |     e    |     ø    |     ɘ    |     ɵ    |     ɤ    |     o    |
  // +-----------------------+----------+----------+----------+----------+----------+----------+
  // | [−high, −low, −tense] |     ɛ    |     œ    |     ɜ    |     ɞ    |     ʌ    |     ɔ    |
  // +-----------------------+----------+----------+----------+----------+----------+----------+
  // |         [−high, +low] |     æ    |     ɶ    |     a    |          |     ɑ    |     ɒ    |
  // +-----------------------+----------+----------+----------+----------+----------+----------+
  //
  // ////////////// Other vowel features ///////////////////
  //
  //
  long,
  nasal,
  stress,
  //
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  ////////////////////////////////////////// PLACE FEATURES FOR CONSONANTS  ////////////////////////////////////////////
  //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  //
  // ////////////// Major articulator features ///////////////////
  //
  labial,
  coronal,
  dorsal,
  //
  // ////////////// Features for classifying the coronals ///////////////////
  //
  anterior,
  distributed,
  strident,
  lateral,
  //
  // ////////////// Features used for classifying the labials ///////////////////
  //
  // round,
  labiodental,
  //
  // ////////////// Features used for classifying the dorsals ///////////////////
  //
  // high,
  // low,
  // front,
  // back,
  //
  // ////////////// Secondary articulations ///////////////////
  //
  // palatalization (IPA [ʲ]):    add [+dorsal, +high, −low, +front, −back]
  // velarization (IPA [ˠ]):      add [+dorsal, +high, −low, −front, +back]
  // pharyngealization (IPA [ˤ]): add [+dorsal, −high, +low, −front, +back]
  // labialization (IPA [ʷ]):     add [+labial, +round]

  ;

  int get hash => 1 << this.index;
}

enum Notation {
  place,
}
