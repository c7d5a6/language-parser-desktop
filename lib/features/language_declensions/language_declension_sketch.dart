import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/border/border.dart';
import 'package:language_parser_desktop/components/border/hdash.dart';
import 'package:language_parser_desktop/components/border/vdash.dart';
import 'package:language_parser_desktop/components/buttons/t_button.dart';
import 'package:language_parser_desktop/components/input/text_field.dart';
import 'package:language_parser_desktop/text_measure_provider.dart';
import 'package:language_parser_desktop/util/constants.dart';

import '../../components/border/vtabledashes.dart';
import '../language_phonetics/language_phonetics_header.dart';

/// Static sketch of LanguageDeclension layout with three hardcoded rules.
class LanguageDeclensionSketch extends StatelessWidget {
  const LanguageDeclensionSketch({super.key});

  @override
  Widget build(BuildContext context) {
    final cWidth = TextMeasureProvider.of(context)!.characterWidth;
    const rules = ['NOM.SG', 'GEN.SG', 'DAT.SG'];
    final rowLength = math.max(_leftColumnRowsCount(rules.length), 5 /*right column row number*/);

    return Table(
      columnWidths: {
        0: FixedColumnWidth(cWidth),
        1: FixedColumnWidth(20 * cWidth),
        2: FixedColumnWidth(cWidth),
        3: const FlexColumnWidth(1),
        4: FixedColumnWidth(cWidth),
      },
      children: [
        TableRow(
          children: [
            VTableDashes(rowLength: rowLength, endOnCross: true),
            // LEFT nested table: header + rules/cells
            Table(
              columnWidths: {0: FixedColumnWidth(20 * cWidth)},
              children: [
                const TableRow(
                  children: [Center(child: LPhHeader(header: 'DECLENSION SKETCH'))],
                ),
                const TableRow(children: [HDash()]),
                for (int i = 0; i < rowLength; i++) TableRow(children: [_leftColumnCell(i, rules)]),
                const TableRow(children: [HDash()]),
              ],
            ),
            VTableDashes(rowLength: rowLength, endOnCross: true),
            // RIGHT nested column: rule name + body editor
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Table(
                  columnWidths: {
                    0: FixedColumnWidth(10 * cWidth),
                    1: FixedColumnWidth(cWidth),
                    2: const FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      children: [
                        const Center(child: LPhHeader(header: 'RULE NAME')),
                        const DBorder(data: '|'),
                        TTextField(
                          controller: TextEditingController(text: 'static_example'),
                          onChanged: (_) {},
                        ),
                      ],
                    ),
                    const TableRow(
                      children: [
                        HDash(),
                        DBorder(data: '+'),
                        HDash(),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 6 * cWidth,
                  child: TextFormField(
                    maxLines: null,
                    expands: true,
                    initialValue: 'static multi-line\ntext area sketch',
                    style: LPFont.defaultTextStyle.merge(TextStyle(color: LPColor.greyBrightColor)),
                    decoration: const InputDecoration(border: InputBorder.none, isCollapsed: true),
                  ),
                ),
              ],
            ),
            VTableDashes(rowLength: rowLength, endOnCross: true),
          ],
        ),
      ],
    );
  }
}

int _leftColumnRowsCount(int rulesCount) {
  // static rows: main button, border, rules header, border, border, plus button
  return 7 + rulesCount;
}

Widget _leftColumnCell(int rowIndex, List<String> rules) {
  const rulesStartIndex = 4;
  final rulesEndIndex = rulesStartIndex + rules.length;
  if (rowIndex == 0) {
    const isMain = true;
    return Center(
      child: TButton(
        text: '[ MAIN DECLENSION ]',
        color: isMain ? LPColor.greenColor : LPColor.greyColor,
        hover: isMain ? LPColor.greenBrightColor : LPColor.greyBrightColor,
        onPressed: null,
      ),
    );
  }
  if (rowIndex == 1) {
    return const HDash();
  }
  if (rowIndex == 2) {
    return const Center(child: LPhHeader(header: 'RULES'));
  }
  if (rowIndex == 3) {
    return const HDash();
  }
  if (rowIndex >= rulesStartIndex && rowIndex < rulesEndIndex) {
    return Center(child: Text(rules[rowIndex - rulesStartIndex], style: LPFont.defaultTextStyle));
  }
  if (rowIndex == rulesEndIndex) {
    return const HDash();
  }
  return Center(
    child: TButton(text: '[ + ]', color: LPColor.greenColor, hover: LPColor.greenBrightColor, onPressed: null),
  );
}
