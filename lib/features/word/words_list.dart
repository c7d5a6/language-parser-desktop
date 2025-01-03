import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:language_parser_desktop/services/service_manager.dart';
import 'package:language_parser_desktop/services/word_service.dart';

import '../../components/border/hdash.dart';
import '../../components/border/vdash.dart';
import '../../persistence/repositories/word_repository.dart';
import '../../service_provider.dart';

class XDash extends StatelessWidget {
  const XDash({super.key});

  @override
  Widget build(BuildContext context) {
    return const SelectionContainer.disabled(
        child: Text(
      '+',
      style: TextStyle(fontSize: 16, height: 0.0),
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
  ServiceManager? serviceManager;
  late WordService _wordService;

  @override
  Future<void> didChangeDependencies() async {
    log("didChangeDependencies");
    super.didChangeDependencies();
    final sm = ServiceProvider.of(context)?.serviceManager;
    if (serviceManager != sm) {
      serviceManager = sm;
      _wordService = serviceManager!.wordService;
      await _regenerateWords(null);
    }
  } // @override

  Future<void> _regenerateWords(String? search) async {
    log("regenerate words");
    // var wrds = await _wordService.getWords(25, search ?? '');
    setState(() {
      _words = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextFormField(
          textAlign: TextAlign.center,
          onChanged: (word) => _regenerateWords(word),
        ),
        const VerticalDivider(),
        Table(
          border: TableBorder.all(style: BorderStyle.none),
          columnWidths: const <int, TableColumnWidth>{
            0: FixedColumnWidth(16),
            1: FlexColumnWidth(),
            2: FixedColumnWidth(16),
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
            0: FixedColumnWidth(16),
            1: IntrinsicColumnWidth(),
            2: FixedColumnWidth(16),
            3: IntrinsicColumnWidth(),
            4: FixedColumnWidth(16),
            5: IntrinsicColumnWidth(),
            6: FixedColumnWidth(16),
            7: FlexColumnWidth(),
            8: FixedColumnWidth(16),
          },
          defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
          children: _words
              .map(
                (w) => TableRow(children: <Widget>[
                  const VDash(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      w.written,
                      maxLines: 1,
                      style: const TextStyle(fontSize: 16, height: 0.0),
                    ),
                  ),
                  const VDash(),
                  SizedBox(
                    height: 16 * 1.2,
                    child: TextButton(
                      onPressed: () => {},
                      child: Text(
                        ' / ${w.word} / ',
                        maxLines: 1,
                        style: const TextStyle(fontSize: 16, height: 0.0, fontFamily: 'Cousine', fontFeatures: [
                          FontFeature.tabularFigures(),
                        ]),
                      ),
                    ),
                  ),
                  const VDash(),
                  Text(
                    ' ${w.pos} ',
                    maxLines: 1,
                    softWrap: false,
                    style: const TextStyle(fontSize: 16, height: 0.0),
                  ),
                  const VDash(),
                  Text(
                    ' ${w.comment} ',
                    maxLines: 1,
                    style: const TextStyle(fontSize: 16, height: 0.0),
                  ),
                  const VDash(),
                ]),
              )
              .toList(growable: false),
        ),
        Table(
          border: TableBorder.all(style: BorderStyle.none),
          columnWidths: const <int, TableColumnWidth>{
            0: FixedColumnWidth(16),
            1: FlexColumnWidth(),
            2: FixedColumnWidth(16),
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
      ],
    );
  }
}
