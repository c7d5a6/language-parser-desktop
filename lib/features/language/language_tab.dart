import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/border/border.dart';
import 'package:language_parser_desktop/components/border/hdash.dart';

import '../../components/buttons/t_button.dart';
import '../../util/constants.dart';

class LanguageTab extends StatelessWidget {
  final String langName;
  final int id;
  final bool selected;
  final bool prevSelected;
  final double cWSize;
  final Function(int?) onSelect;

  const LanguageTab(
      {super.key,
      required this.langName,
      required this.id,
      required this.selected,
      required this.prevSelected,
      required this.cWSize,
      required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(style: BorderStyle.none),
      columnWidths: <int, TableColumnWidth>{
        0: FixedColumnWidth(cWSize),
        1: FixedColumnWidth(cWSize),
        2: FixedColumnWidth(cWSize),
        3: FixedColumnWidth(cWSize),
        4: FlexColumnWidth(1),
        5: FixedColumnWidth(cWSize),
      },
      children: [
        TableRow(children: [
          Container(),
          Container(),
          selected ? DBorder(data: '|') : Container(),
          selected ? DBorder(data: ' ') : DBorder(data: '|'),
          Container(
              alignment: Alignment.centerLeft,
              child: TButton(
                text: ' $langName ',
                onPressed: () => onSelect(id),
                color: selected ? LPColor.primaryColor : LPColor.greyColor,
                hover: LPColor.greyBrightColor,
              )),
          selected ? DBorder(data: ' ') : DBorder(data: '|'),
        ]),
        TableRow(children: [
          Container(),
          Container(),
          selected || prevSelected ? DBorder(data: '+') : Container(),
          selected || prevSelected ? DBorder(data: '-') : Container(),
          HDash(),
          selected || prevSelected ? DBorder(data: '+') : DBorder(data: '|'),
        ]),
      ],
    );
  }
}
