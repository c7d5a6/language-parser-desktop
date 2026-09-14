import 'package:flutter/cupertino.dart';
import 'package:language_parser_desktop/components/border/border.dart';
import 'package:language_parser_desktop/components/border/hdash.dart';
import 'package:language_parser_desktop/components/buttons/phonetic_button.dart';
import 'package:language_parser_desktop/features/language_phonetics/language_phonetics_header.dart';
import 'package:language_parser_desktop/features/language_phonetics/language_phonetics_plumonic_consonants.dart';
import 'package:language_parser_desktop/util/constants.dart';

import '../../services/language_service.dart';
import '../../text_measure_provider.dart';

/// IPA vowel trapezoid — port of language-parser-ui vowels.component.html.
///
/// Outer frame spans full width. Inner trapezoid is centered and width-capped
/// from the natural size of a Close-row vowel pair (no FittedBox shrink).
class LanguagePhoneticsVowels extends StatelessWidget {
  final bool disabled;
  final ListOfLanguagePhonemes phonemes;
  final Function(String) onPress;

  const LanguagePhoneticsVowels({super.key, required this.disabled, required this.phonemes, required this.onPress});

  static const int chartFlex = 35;

  /// Flex span of one Close-row pair cell (`i(iː) * y(yː)`).
  static const int pairFlex = 5;

  /// Monospace width of `i(iː) * y(yː)` plus slack for wider IPA glyphs (ː, ɨ, …).
  static const int pairSymbolCount = 14;

  List<String> _glidingPhonemes() {
    final result = <String>[
      ...phonemes.restUsedPhonemes,
      ...phonemes.selectedRestPhonemes.map((p) => p.phoneme),
    ];
    return result.where((s) => s.trim().isNotEmpty && s.contains('̯')).toSet().toList()..sort();
  }

  Widget _v(String phonetic) =>
      VPhoneticButton(phonetic: phonetic, phonemes: phonemes, disabled: disabled, onPressed: onPress);

  Widget _pair(String left, String right) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _v(left),
          Text(' * ', style: LPFont.headerFontStyle),
          _v(right),
        ],
      );

  Widget _u(double unit, int flex, [Widget? child]) => SizedBox(
        width: unit * flex,
        child: child == null
            ? const SizedBox.shrink()
            : Center(
                // Guard sub-pixel / IPA glyph overflow without clipping yellow stripes.
                child: FittedBox(fit: BoxFit.scaleDown, child: child),
              ),
      );

  Widget _dash(double unit, int flex) => SizedBox(width: unit * flex, child: const HDash());

  Widget _bar(double unit) => SizedBox(width: unit, child: Center(child: DBorder(data: '|')));

  Widget _slash(double unit) =>
      SizedBox(width: unit, child: Center(child: Text('\\', style: LPFont.borderFontStyle)));

  /// Row header (pulmonic-aligned) | spacer | centered trapezoid | spacer | right border.
  Widget _row({
    required double headerW,
    required double cW,
    required double chartW,
    required Widget header,
    required List<Widget> chart,
    String junction = '|',
  }) {
    return Row(
      children: [
        SizedBox(width: headerW, child: header),
        SizedBox(width: cW, child: DBorder(data: junction)),
        const Expanded(child: SizedBox.shrink()),
        SizedBox(
          width: chartW,
          child: Row(children: chart),
        ),
        const Expanded(child: SizedBox.shrink()),
        SizedBox(width: cW, child: DBorder(data: junction == '+' ? '+' : '|')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final cW = TextMeasureProvider.of(context)!.characterWidth;
      const labels = [
        ['Close', 'Cl'],
        ['Near-close', 'NCl'],
        ['Close-mid', 'CM'],
        ['Mid', 'Mid'],
        ['Open-mid', 'OM'],
        ['Near-open', 'NO'],
        ['Open', 'Op'],
        ['Gliding', 'Gl'],
      ];
      final headerW = LanguagePhoneticsPlumonicConsonants.sharedRowHeaderWidth(
        constraints.maxWidth,
        cW,
        extraChars: labels.fold(0, (p, s) => p > s[0].length ? p : s[0].length),
      );
      // Unit sized so a flex-5 pair cell fits `i(iː) * y(yː)` at full font size.
      final unit = (pairSymbolCount * cW) / pairFlex;
      final chartW = unit * chartFlex;
      final gliding = _glidingPhonemes();

      Widget label(String text, String? short) =>
          text.isEmpty ? const SizedBox.shrink() : Center(child: CLPhHeader(header: text, short: short));

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Center(child: LPhHeader(header: '--- VOWELS ---'))),
              SizedBox(width: cW, child: DBorder(data: '|')),
            ],
          ),
          Row(
            children: [
              SizedBox(width: headerW, child: const HDash()),
              SizedBox(width: cW, child: DBorder(data: '+')),
              const Expanded(child: HDash()),
              SizedBox(width: cW, child: DBorder(data: '+')),
            ],
          ),
          _row(
            headerW: headerW,
            cW: cW,
            chartW: chartW,
            header: const SizedBox.shrink(),
            chart: [
              _u(unit, 1),
              _u(unit, 5, const LPhHeader(header: 'Front')),
              _u(unit, 3),
              _bar(unit),
              _u(unit, 12, const LPhHeader(header: 'Central')),
              _u(unit, 1),
              _bar(unit),
              _u(unit, 5),
              _u(unit, 5, const LPhHeader(header: 'Back')),
              _u(unit, 1),
            ],
          ),
          _row(
            headerW: headerW,
            cW: cW,
            chartW: chartW,
            header: const HDash(),
            junction: '+',
            chart: [_dash(unit, 35)],
          ),
          _row(
            headerW: headerW,
            cW: cW,
            chartW: chartW,
            header: label(labels[0][0], labels[0][1]),
            chart: [
              _u(unit, 1),
              _u(unit, 5, _pair('i', 'y')),
              _u(unit, 1),
              _dash(unit, 5),
              _u(unit, 1),
              _u(unit, 5, _pair('ɨ', 'ʉ')),
              _u(unit, 1),
              _dash(unit, 9),
              _u(unit, 1),
              _u(unit, 5, _pair('ɯ', 'u')),
              _u(unit, 1),
            ],
          ),
          _row(
            headerW: headerW,
            cW: cW,
            chartW: chartW,
            header: const HDash(),
            junction: '+',
            chart: [
              _u(unit, 4),
              _slash(unit),
              _u(unit, 11),
              _slash(unit),
              _u(unit, 14),
              _bar(unit),
              _u(unit, 3),
            ],
          ),
          _row(
            headerW: headerW,
            cW: cW,
            chartW: chartW,
            header: label(labels[1][0], labels[1][1]),
            chart: [
              _u(unit, 5),
              _slash(unit),
              _u(unit, 1),
              _u(unit, 5, _pair('ɪ', 'ʏ')),
              _u(unit, 5),
              _slash(unit),
              _u(unit, 9),
              _u(
                  unit,
                  3,
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    Text('* ', style: LPFont.headerFontStyle),
                    _v('ʊ'),
                  ])),
              _u(unit, 1),
              _bar(unit),
              _u(unit, 3),
            ],
          ),
          _row(
            headerW: headerW,
            cW: cW,
            chartW: chartW,
            header: const HDash(),
            junction: '+',
            chart: [
              _u(unit, 6),
              _slash(unit),
              _u(unit, 11),
              _slash(unit),
              _u(unit, 12),
              _bar(unit),
              _u(unit, 3),
            ],
          ),
          _row(
            headerW: headerW,
            cW: cW,
            chartW: chartW,
            header: label(labels[2][0], labels[2][1]),
            chart: [
              _u(unit, 5),
              _u(unit, 5, _pair('e', 'ø')),
              _u(unit, 1),
              _dash(unit, 5),
              _u(unit, 1),
              _u(unit, 5, _pair('ɘ', 'ɵ')),
              _u(unit, 1),
              _dash(unit, 5),
              _u(unit, 1),
              _u(unit, 5, _pair('ɤ', 'o')),
              _u(unit, 1),
            ],
          ),
          _row(
            headerW: headerW,
            cW: cW,
            chartW: chartW,
            header: const HDash(),
            junction: '+',
            chart: [
              _u(unit, 8),
              _slash(unit),
              _u(unit, 10),
              _slash(unit),
              _u(unit, 11),
              _bar(unit),
              _u(unit, 3),
            ],
          ),
          _row(
            headerW: headerW,
            cW: cW,
            chartW: chartW,
            header: label(labels[3][0], labels[3][1]),
            chart: [
              _u(unit, 7),
              _u(unit, 5, _pair('e̞', 'ø̞')),
              _u(unit, 1),
              _u(unit, 6),
              _u(unit, 3, _v('ə')),
              _u(unit, 6),
              _u(unit, 1),
              _u(unit, 5, _pair('ɤ̞', 'o̞')),
              _u(unit, 1),
            ],
          ),
          _row(
            headerW: headerW,
            cW: cW,
            chartW: chartW,
            header: const HDash(),
            junction: '+',
            chart: [
              _u(unit, 10),
              _slash(unit),
              _u(unit, 9),
              _slash(unit),
              _u(unit, 10),
              _bar(unit),
              _u(unit, 3),
            ],
          ),
          _row(
            headerW: headerW,
            cW: cW,
            chartW: chartW,
            header: label(labels[4][0], labels[4][1]),
            chart: [
              _u(unit, 9),
              _u(unit, 5, _pair('ɛ', 'œ')),
              _u(unit, 1),
              _dash(unit, 3),
              _u(unit, 1),
              _u(unit, 5, _pair('ɜ', 'ɞ')),
              _u(unit, 1),
              _dash(unit, 3),
              _u(unit, 1),
              _u(unit, 5, _pair('ʌ', 'ɔ')),
              _u(unit, 1),
            ],
          ),
          _row(
            headerW: headerW,
            cW: cW,
            chartW: chartW,
            header: const HDash(),
            junction: '+',
            chart: [
              _u(unit, 12),
              _slash(unit),
              _u(unit, 8),
              _slash(unit),
              _u(unit, 9),
              _bar(unit),
              _u(unit, 3),
            ],
          ),
          _row(
            headerW: headerW,
            cW: cW,
            chartW: chartW,
            header: label(labels[5][0], labels[5][1]),
            chart: [
              _u(unit, 11),
              _u(
                  unit,
                  3,
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    _v('æ'),
                    Text(' *', style: LPFont.headerFontStyle),
                  ])),
              _u(unit, 7),
              _u(unit, 3, _v('ɐ')),
              _u(unit, 7),
              _bar(unit),
              _u(unit, 3),
            ],
          ),
          _row(
            headerW: headerW,
            cW: cW,
            chartW: chartW,
            header: const HDash(),
            junction: '+',
            chart: [
              _u(unit, 14),
              _slash(unit),
              _u(unit, 7),
              _slash(unit),
              _u(unit, 8),
              _bar(unit),
              _u(unit, 3),
            ],
          ),
          _row(
            headerW: headerW,
            cW: cW,
            chartW: chartW,
            header: label(labels[6][0], labels[6][1]),
            chart: [
              _u(unit, 13),
              _u(unit, 5, _pair('a', 'ɶ')),
              _u(unit, 1),
              _dash(unit, 1),
              _u(unit, 1),
              _u(
                  unit,
                  4,
                  Row(mainAxisSize: MainAxisSize.min, children: [
                    _v('ä'),
                    Text(' *', style: LPFont.headerFontStyle),
                  ])),
              _dash(unit, 3),
              _u(unit, 1),
              _u(unit, 5, _pair('ɑ', 'ɒ')),
              _u(unit, 1),
            ],
          ),
          _row(
            headerW: headerW,
            cW: cW,
            chartW: chartW,
            header: const HDash(),
            junction: '+',
            chart: [_dash(unit, 35)],
          ),
          _row(
            headerW: headerW,
            cW: cW,
            chartW: chartW,
            header: label(labels[7][0], labels[7][1]),
            chart: [
              SizedBox(
                width: chartW,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < gliding.length; i++) ...[
                        if (i > 0) Text(', ', style: LPFont.headerFontStyle),
                        PhoneticButton(
                          phonetic: gliding[i],
                          languagePhonemes: phonemes,
                          disabled: disabled,
                          onPressed: onPress,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
          _row(
            headerW: headerW,
            cW: cW,
            chartW: chartW,
            header: const HDash(),
            junction: '+',
            chart: [_dash(unit, 35)],
          ),
        ],
      );
    });
  }
}
