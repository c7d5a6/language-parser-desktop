import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:language_parser_desktop/components/border/border.dart';
import 'package:language_parser_desktop/components/border/hdash.dart';
import 'package:language_parser_desktop/components/buttons/phonetic_button.dart';
import 'package:language_parser_desktop/features/language_phonetics/language_phonetics_header.dart';
import 'package:language_parser_desktop/util/layout.dart';

import '../../services/language_service.dart';

class LanguagePhoneticsPlumonicConsonants extends StatelessWidget {
  final bool disabled;
  final ListOfLanguagePhonemes listOfLanguagePhonemes;
  static const List<String> rowHeaders = [
    "Nasal",
    "Plosive",
    "Sibilant fricative",
    "Sibilant affricate",
    "Non-sibilant fric.",
    "Non-sibilant affr.",
    "Approximant",
    "Tap/flap",
    "Trill",
    "Lateral fricative",
    "Lateral affricate",
    "Ltrl approximant",
    "Lateral tap/flap",
  ];

  const LanguagePhoneticsPlumonicConsonants(
      {super.key,
      required this.disabled,
      required this.listOfLanguagePhonemes});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {

      final cWidth = measureTextWidth('-', context);
      final rowHeaderCharacters = rowHeaders.fold(0, (p, s) => math.max(p, s.length));
      var delta = (constraints.maxWidth % (cWidth * 12));
      final rowHeaderLength = math.max(0, rowHeaderCharacters - (delta / cWidth).floorToDouble()) * cWidth + delta % cWidth;

      return Column(
        children: [
          Table(
            columnWidths: {0: FlexColumnWidth(), 1: FixedColumnWidth(cWidth)},
            children: [
              TableRow(children: [
                Center(child: LPhHeader(header: '--- PLUMONIC CONSONANTS ---')),
                DBorder(data: '|')
              ])
            ],
          ),
          Table(
            columnWidths: {
              0: FixedColumnWidth(rowHeaderLength),
              1: FixedColumnWidth(cWidth),
              2: FlexColumnWidth(),
              3: FixedColumnWidth(cWidth)
            },
            children: [
              TableRow(children: [
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+')
              ])
            ],
          ),
          Table(
            columnWidths: {
              0: FixedColumnWidth(rowHeaderLength),
              1: FixedColumnWidth(cWidth),
              2: FlexColumnWidth(2.5),
              3: FixedColumnWidth(cWidth),
              4: FixedColumnWidth(cWidth),
              5: FixedColumnWidth(cWidth),
              6: FixedColumnWidth(cWidth),
              7: FlexColumnWidth(5),
              8: FixedColumnWidth(cWidth),
              9: FixedColumnWidth(cWidth),
              10: FixedColumnWidth(cWidth),
              11: FixedColumnWidth(cWidth),
              12: FixedColumnWidth(cWidth),
              13: FlexColumnWidth(2.5),
              14: FixedColumnWidth(cWidth),
              15: FixedColumnWidth(cWidth),
              16: FlexColumnWidth(2),
              17: FixedColumnWidth(cWidth),
            },
            children: [
              TableRow(children: [
                Container(
                    alignment: Alignment.centerRight,
                    child: LPhHeader(header: 'Place >')),
                DBorder(data: '|'),
                Center(child: LPhHeader(header: 'Labial')),
                Container(),
                DBorder(data: '|'),
                Container(),
                Container(),
                Center(child: LPhHeader(header: 'Coronal')),
                Container(),
                Container(),
                Container(),
                DBorder(data: '|'),
                Container(),
                Center(child: LPhHeader(header: 'Dorsal')),
                DBorder(data: '|'),
                Container(),
                Center(child: LPhHeader(header: 'Laryngeal')),
                DBorder(data: '|'),
              ])
            ],
          ),
          Table(
            columnWidths: {
              0: FixedColumnWidth(rowHeaderLength),
              1: FixedColumnWidth(cWidth),
              2: FlexColumnWidth(),
              3: FixedColumnWidth(cWidth),
              4: FlexColumnWidth(),
              5: FixedColumnWidth(cWidth),
              6: FlexColumnWidth(),
              7: FixedColumnWidth(cWidth),
              8: FlexColumnWidth(),
              9: FixedColumnWidth(cWidth),
              10: FlexColumnWidth(),
              11: FixedColumnWidth(cWidth),
              12: FlexColumnWidth(),
              13: FixedColumnWidth(cWidth),
              14: FlexColumnWidth(),
              15: FixedColumnWidth(cWidth),
              16: FlexColumnWidth(),
              17: FixedColumnWidth(cWidth),
              18: FlexColumnWidth(),
              19: FixedColumnWidth(cWidth),
              20: FlexColumnWidth(),
              21: FixedColumnWidth(cWidth),
              22: FlexColumnWidth(),
              23: FixedColumnWidth(cWidth),
              24: FlexColumnWidth(),
              25: FixedColumnWidth(cWidth),
            },
            children: [
              TableRow(children: [
                Container(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
              ]),
              TableRow(children: [
                LPhHeader(header: ' ∨ Manner'),
                DBorder(data: '|'),
                CLPhHeader(header: 'Bilabial', short: 'BL'),
                DBorder(data: '|'),
                CLPhHeader(header: 'Labio-dental', short: 'LD'),
                DBorder(data: '|'),
                CLPhHeader(header: 'Linguo-labial', short: 'LL'),
                DBorder(data: '|'),
                CLPhHeader(header: 'Dental', short: 'Den'),
                DBorder(data: '|'),
                CLPhHeader(header: 'Alveolar', short: 'Alv'),
                DBorder(data: '|'),
                CLPhHeader(header: 'Post-alveolar', short: 'PA'),
                DBorder(data: '|'),
                CLPhHeader(header: 'Retro-flex', short: 'RF'),
                DBorder(data: '|'),
                CLPhHeader(header: 'Palatal', short: 'Palatal'),
                DBorder(data: '|'),
                CLPhHeader(header: 'Velar', short: 'Vel'),
                DBorder(data: '|'),
                CLPhHeader(header: 'Uvular', short: 'Uv'),
                DBorder(data: '|'),
                CLPhHeader(header: 'Pharyngeal/epi-glottal', short: 'P/EG'),
                DBorder(data: '|'),
                CLPhHeader(header: 'Glottal', short: 'Gl'),
                DBorder(data: '|'),
              ]),
              TableRow(children: [
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
              ])
            ],
          ),
          Table(
            columnWidths: {
              0: FixedColumnWidth(rowHeaderLength),
              1: FixedColumnWidth(cWidth),
              2: FlexColumnWidth(0.5),
              3: FlexColumnWidth(0.5),
              4: FixedColumnWidth(cWidth),
              5: FlexColumnWidth(1),
              6: FixedColumnWidth(cWidth),
              7: FlexColumnWidth(1),
              8: FixedColumnWidth(cWidth),
              9: FlexColumnWidth(0.5),
              10: FlexColumnWidth(1),
              11: FixedColumnWidth(cWidth),
              12: FixedColumnWidth(cWidth),
              13: FlexColumnWidth(1),
              14: FlexColumnWidth(0.5),
              15: FixedColumnWidth(cWidth),
              16: FlexColumnWidth(0.5),
              17: FlexColumnWidth(0.5),
              18: FixedColumnWidth(cWidth),
              19: FlexColumnWidth(0.5),
              20: FlexColumnWidth(0.5),
              21: FixedColumnWidth(cWidth),
              22: FlexColumnWidth(0.5),
              23: FlexColumnWidth(0.5),
              24: FixedColumnWidth(cWidth),
              25: FlexColumnWidth(1),
              26: FixedColumnWidth(cWidth),
              27: FlexColumnWidth(1),
              28: FixedColumnWidth(cWidth),
              29: FlexColumnWidth(1),
              30: FixedColumnWidth(cWidth),
            },
            children: [
              TableRow(children: [
                Center(child: CLPhHeader(header: rowHeaders[0])),
                DBorder(data: '|'),
                CPhoneticButton(
                    phonetic: 'm̥',
                    languagePhonemes: listOfLanguagePhonemes,
                    disabled: disabled),
                CPhoneticButton(
                    phonetic: 'm',
                    languagePhonemes: listOfLanguagePhonemes,
                    disabled: disabled),
                DBorder(data: '|'),
                CPhoneticButton(
                    phonetic: 'ɱ',
                    languagePhonemes: listOfLanguagePhonemes,
                    disabled: disabled),
                DBorder(data: '|'),
                CPhoneticButton(
                    phonetic: 'n̼',
                    languagePhonemes: listOfLanguagePhonemes,
                    disabled: disabled),
                DBorder(data: '|'),
                Container(),
                CPhoneticButton(
                    phonetic: 'n̥',
                    languagePhonemes: listOfLanguagePhonemes,
                    disabled: disabled),
                Container(),
                Container(),
                CPhoneticButton(
                    phonetic: 'n',
                    languagePhonemes: listOfLanguagePhonemes,
                    disabled: disabled),
                Container(),
                DBorder(data: '|'),
                CPhoneticButton(
                    phonetic: 'ɳ̊',
                    languagePhonemes: listOfLanguagePhonemes,
                    disabled: disabled),
                CPhoneticButton(
                    phonetic: 'ɳ',
                    languagePhonemes: listOfLanguagePhonemes,
                    disabled: disabled),
                DBorder(data: '|'),
                CPhoneticButton(
                    phonetic: 'ɲ̊',
                    languagePhonemes: listOfLanguagePhonemes,
                    disabled: disabled),
                CPhoneticButton(
                    phonetic: 'ɲ',
                    languagePhonemes: listOfLanguagePhonemes,
                    disabled: disabled),
                DBorder(data: '|'),
                CPhoneticButton(
                    phonetic: 'ŋ̊',
                    languagePhonemes: listOfLanguagePhonemes,
                    disabled: disabled),
                CPhoneticButton(
                    phonetic: 'ŋ',
                    languagePhonemes: listOfLanguagePhonemes,
                    disabled: disabled),
                DBorder(data: '|'),
                CPhoneticButton(
                    phonetic: 'ɴ',
                    languagePhonemes: listOfLanguagePhonemes,
                    disabled: disabled),
                DBorder(data: '|'),
                Container(),
                Container(),
                Container(),
                DBorder(data: '|'),
              ]),
              TableRow(children: [
                HDash(),
                DBorder(data: '+'),
                HDash(),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                HDash(),
                HDash(),
                HDash(),
                HDash(),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
              ]),
            ],
          ),
        ],
      );
    });
  }
}