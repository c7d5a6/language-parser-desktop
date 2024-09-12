import 'package:flutter/material.dart';
import 'package:language_parser_desktop/util/word_generator.dart';

class HDash extends StatelessWidget {
  const HDash({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return SelectionContainer.disabled(
          child: Text(
        '-' * (constraints.maxWidth / 7).round(),
        overflow: TextOverflow.fade,
        style: const TextStyle(fontSize: 14, height: 0.0),
        maxLines: 1,
      ));
    });
  }
}

class VDash extends StatelessWidget {
  const VDash({super.key});

  @override
  Widget build(BuildContext context) {
    return const SelectionContainer.disabled(
        child: Text(
      '|',
      style: TextStyle(fontSize: 14, height: 0.0),
      maxLines: 1,
      softWrap: false,
      overflow: TextOverflow.fade,
    ));
  }
}

class XDash extends StatelessWidget {
  const XDash({super.key});

  @override
  Widget build(BuildContext context) {
    return const SelectionContainer.disabled(
        child: Text(
      '+',
      style: TextStyle(fontSize: 14, height: 0.0),
      maxLines: 1,
      softWrap: false,
      overflow: TextOverflow.fade,
    ));
  }
}

class TableExample extends StatefulWidget {
  const TableExample({super.key});

  @override
  State<TableExample> createState() => _TableExample();
}

class _TableExample extends State<TableExample> {
  List<wrd> _words = [];

  _TableExample() : _words = generateWords(25);

  void _regenerateWords() {
    setState(() {
      _words = generateWords(25);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Table(
          border: TableBorder.all(style: BorderStyle.none),
          columnWidths: const <int, TableColumnWidth>{
            0: FixedColumnWidth(8),
            1: FlexColumnWidth(),
            2: FixedColumnWidth(8),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.baseline,
          textBaseline: TextBaseline.ideographic,
          children: const [
            TableRow(children: [
              XDash(),
              HDash(),
              XDash(),
            ]),
          ],
        ),
        Table(
          border: TableBorder.all(style: BorderStyle.none),
          columnWidths: const <int, TableColumnWidth>{
            0: FixedColumnWidth(8),
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
          children: _words
              .map(
                (w) => TableRow(children: <Widget>[
                  const VDash(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      w.written,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 14, height: 0.0),
                    ),
                  ),
                  const VDash(),
                  SizedBox(
                    height: 16,
                    child: TextButton(
                      onPressed: () => {},
                      child: Text(
                        ' / ${w.word} / ',
                        maxLines: 1,
                        style: const TextStyle(fontSize: 14, height: 0.0),
                      ),
                    ),
                  ),
                  const VDash(),
                  Text(
                    ' ${w.pos} ',
                    maxLines: 1,
                    softWrap: false,
                    style: const TextStyle(fontSize: 14, height: 0.0),
                  ),
                  const VDash(),
                  Text(
                    ' ${w.comment} ',
                    maxLines: 1,
                    style: const TextStyle(fontSize: 14, height: 0.0),
                  ),
                  const VDash(),
                ]),
              )
              .toList(growable: false),
        ),
        Table(
          border: TableBorder.all(style: BorderStyle.none),
          columnWidths: const <int, TableColumnWidth>{
            0: FixedColumnWidth(8),
            1: FlexColumnWidth(),
            2: FixedColumnWidth(8),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
          children: const [
            TableRow(children: [
              XDash(),
              HDash(),
              XDash(),
            ]),
          ],
        ),
        TextButton(
            onPressed: () => _regenerateWords(), child: const Text('Generate')),
      ],
    );
  }
}
