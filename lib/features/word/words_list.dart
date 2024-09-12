import 'package:flutter/material.dart';

class HDash extends StatelessWidget {
  const HDash({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Text(
        '-' * (constraints.maxWidth / 7).round(),
        softWrap: false,
        overflow: TextOverflow.fade,
      );
    });
  }
}

var words = ['word 1', 'word 2', 'asdada asd', 'master plan', 'word 2'];

class TableExample extends StatelessWidget {
  const TableExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(style: BorderStyle.none),
      columnWidths: const <int, TableColumnWidth>{
        0: FixedColumnWidth(8),
        // 1: IntrinsicColumnWidth(),
        1: IntrinsicColumnWidth(),
        2: FixedColumnWidth(8),
        3: IntrinsicColumnWidth(),
        4: FixedColumnWidth(8),
        5: IntrinsicColumnWidth(),
        6: FixedColumnWidth(8),
        7: FlexColumnWidth(),
        8: FixedColumnWidth(8),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
      children: words
          .map(
            (w) => TableRow(children: <Widget>[
              const Text('|', style: const TextStyle(fontSize: 14, height: 0.0), maxLines: 1,),
              Text(' $w ', style: const TextStyle(fontSize: 14, height: 0.0),),
              const Text('|', style: const TextStyle(fontSize: 14, height: 0.0),),
              Text(' / $w / ', style: const TextStyle(fontSize: 14, height: 0.0),),
              const Text('|', style: const TextStyle(fontSize: 14, height: 0.0),),
              const Text(' n. ', style: const TextStyle(fontSize: 14, height: 0.0),),
              Container(color: Colors.red,height: 14,),
              const Text(' Comment of the word ', style: const TextStyle(fontSize: 14, height: 0.0),),
              const Text('|', style: const TextStyle(fontSize: 14, height: 0.0),),
            ]),
          )
          .toList(growable: false),
    );
  }
}
