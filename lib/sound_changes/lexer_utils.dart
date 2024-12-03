const whitespaces = {
  0x0009, //     0009..000D    ; White_Space # Cc   <control-0009>..<control-000D>
  0x000A, // --/--
  0x000B, // --/--
  0x000C, // --/--
  0x000D, // --/--
  0x0020, //     0020          ; White_Space # Zs   SPACE
  0x0085, //     0085          ; White_Space # Cc   <control-0085>
  0x00A0, //     00A0          ; White_Space # Zs   NO-BREAK SPACE
  0x1680, //     1680          ; White_Space # Zs   OGHAM SPACE MARK
  0x2000, //     2000..200A    ; White_Space # Zs   EN QUAD..HAIR SPACE
  0x2001, // --/--
  0x2002, // --/--
  0x2003, // --/--
  0x2004, // --/--
  0x2005, // --/--
  0x2006, // --/--
  0x2007, // --/--
  0x2008, // --/--
  0x2009, // --/--
  0x200A, // --/--
  0x2028, //     2028          ; White_Space # Zl   LINE SEPARATOR
  0x2029, //     2029          ; White_Space # Zp   PARAGRAPH SEPARATOR
  0x202F, //     202F          ; White_Space # Zs   NARROW NO-BREAK SPACE
  0x205F, //     205F          ; White_Space # Zs   MEDIUM MATHEMATICAL SPACE
  0x3000, //     3000          ; White_Space # Zs   IDEOGRAPHIC SPACE
  0xFEFF, //     FEFF          ; BOM                ZERO WIDTH NO_BREAK SPACE
};

bool isWhitespace(String s) {
  return s.codeUnits.fold(true, (prev, code) => prev && whitespaces.contains(code));
}

const diacritics = {
  0x02B0, // ʰ
  // 'ⁿ',
  // 'ᶿ',
  // 'ᵊ',
  0x02B7, // ʷ
  // 'ʲ',
  // 'ˠ',
  0x02E4, // ˤ
  0x02F3, 0x0325, // ˳ ◌̥
};

bool isDiacritics(String s) {
  return s.codeUnits.fold(true, (prev, code) => prev && diacritics.contains(code));
}
