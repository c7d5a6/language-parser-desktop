import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/border/border.dart';
import 'package:language_parser_desktop/components/border/hdash.dart';
import 'package:language_parser_desktop/components/buttons/t_button.dart';

import '../../text_measure_provider.dart';

class GrammarWordClasses extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GrammarWordClasses();
}

class _GrammarWordClasses extends State<GrammarWordClasses> {
  @override
  Widget build(BuildContext context) {
    final cWidth = TextMeasureProvider.of(context)!.characterWidth;
    List<TableRow> rows = List.empty(growable: true);
    rows.add(TableRow(children: [
      DBorder(data: '|'),
      TButton(text: 'Adjective'),
      DBorder(data: '|'),
      Center(child: DBorder(data: 'Name')),
      DBorder(data: '|'),
      Container(),
      DBorder(data: '|')
    ]));
    return Column(children: [
      Table(
        columnWidths: {
          0: FixedColumnWidth(cWidth),
          1: FlexColumnWidth(1),
          2: FixedColumnWidth(cWidth),
          3: FixedColumnWidth(14 * cWidth),
          4: FixedColumnWidth(cWidth),
          5: FlexColumnWidth(2),
          6: FixedColumnWidth(cWidth),
        },
        children: rows,
      ),
      Table(
        columnWidths: {
          0: FixedColumnWidth(cWidth),
          1: FlexColumnWidth(1),
          2: FixedColumnWidth(cWidth),
          3: FixedColumnWidth(14 * cWidth),
          4: FixedColumnWidth(cWidth),
          5: FlexColumnWidth(2),
          6: FixedColumnWidth(cWidth),
        },
        children: [
          TableRow(children: [
            DBorder(data: '|'),
            TButton(text: '[ + ]'),
            DBorder(data: '|'),
            Container(),
            Container(),
            Container(),
            DBorder(data: '|')
          ])
        ],
      ),
      Table(
        columnWidths: {
          0: FixedColumnWidth(cWidth),
          1: FlexColumnWidth(1),
          2: FixedColumnWidth(cWidth),
        },
        children: [
          TableRow(children: [
            DBorder(data: '+'),
            HDash(),
            DBorder(data: '+'),
          ])
        ],
      ),
    ]);
  }
}
