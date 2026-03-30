import 'package:flutter/widgets.dart';

import 'border.dart';

class VTableDashes extends StatelessWidget {
  const VTableDashes({super.key, required this.rowLength, required this.endOnCross});

  final int rowLength;
  final bool endOnCross;

  @override
  Widget build(BuildContext context) {
    return Table(
      children: [
        for (int i = 0; i < rowLength - 1; i++) TableRow(children: [DBorder(data: '|')]),
        TableRow(children: [DBorder(data: endOnCross ? '+' : '|')]),
      ],
    );
  }
}
