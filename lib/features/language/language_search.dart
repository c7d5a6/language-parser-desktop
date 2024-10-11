import 'package:flutter/material.dart';

import '../../components/border/border.dart';
import '../../components/border/hdash.dart';
import '../../util/constants.dart';

class LanguageSearch extends StatelessWidget {
  const LanguageSearch({
    super.key,
    required this.cWSize,
    required this.onChanged,
  });

  final double cWSize;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder.all(style: BorderStyle.none),
        columnWidths: <int, TableColumnWidth>{
          0: FixedColumnWidth(cWSize),
          1: FixedColumnWidth(cWSize),
          2: FlexColumnWidth(1),
          3: FixedColumnWidth(cWSize),
        },
        children: [
          TableRow(children: [
            DBorder(data: ' '),
            DBorder(data: '|'),
            Container(
                alignment: Alignment.centerRight,
                child: TextField(
                  onChanged: onChanged,
                  style: LPFont.defaultTextStyle.merge(TextStyle(color: LPColor.greyBrightColor)),
                  decoration: InputDecoration.collapsed(
                      hintText: 'Search',
                      border: InputBorder.none,
                      hintStyle: LPFont.defaultTextStyle.merge(TextStyle(color: LPColor.greyColor))),
                )),
            DBorder(data: '|')
          ]),
          TableRow(children: [DBorder(data: ' '), DBorder(data: '+'), HDash(), DBorder(data: '|')]),
        ]);
  }
}
