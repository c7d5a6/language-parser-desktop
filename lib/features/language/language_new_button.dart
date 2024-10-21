import 'package:flutter/material.dart';

import '../../components/border/border.dart';
import '../../components/border/hdash.dart';
import '../../components/buttons/t_button.dart';
import '../../util/constants.dart';

class LanguageNewButton extends StatelessWidget {
  const LanguageNewButton({
    super.key,
    required this.cWSize,
    required this.onPressed,
  });

  final double cWSize;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder.all(style: BorderStyle.none),
        columnWidths: <int, TableColumnWidth>{
          0: FixedColumnWidth(cWSize),
          1: FlexColumnWidth(1),
        },
        children: [
          TableRow(children: [DBorder(data: '+'), HDash()]),
          TableRow(children: [
            DBorder(data: '|'),
            TButton(
              text: '[ + ]',
              color: LPColor.greenColor,
              hover: LPColor.greenBrightColor,
              onPressed: onPressed,
            ),
          ]),
          TableRow(children: [DBorder(data: '+'), HDash()]),
        ]);
  }
}
