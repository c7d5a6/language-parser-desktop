import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/border/hdash.dart';
import 'package:language_parser_desktop/persistence/entities/word_list.dart';
import 'package:language_parser_desktop/persistence/repositories/invalidators/invalidator.dart';
import 'package:language_parser_desktop/service_provider.dart';
import 'package:language_parser_desktop/services/service_manager.dart';
import 'package:language_parser_desktop/services/word_service.dart';
import 'package:language_parser_desktop/text_measure_provider.dart';
import 'package:language_parser_desktop/util/constants.dart';

import 'word_table_row.dart';

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
      ),
    );
  }
}

class WordsTable extends StatefulWidget {
  const WordsTable({super.key});

  @override
  State<WordsTable> createState() => _WordsTableState();
}

class _WordsTableState extends State<WordsTable> implements Invalidator {
  List<WordList> _words = [];
  ServiceManager? _serviceManager;
  late WordService _wordService;
  String _search = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final sm = ServiceProvider.of(context)?.serviceManager;
    if (_serviceManager != sm) {
      if (_serviceManager != null) {
        _serviceManager!.repositoryManager.removeWordInvalidator(this);
      }
      _serviceManager = sm;
      _serviceManager!.repositoryManager.addWordInvalidator(this);
      _wordService = _serviceManager!.wordService;
      _regenerateWords(_search);
    }
  }

  @override
  void dispose() {
    _serviceManager?.repositoryManager.removeWordInvalidator(this);
    super.dispose();
  }

  @override
  Future<void> invalidate() async {
    if (!mounted) return;
    _regenerateWords(_search);
  }

  void _regenerateWords(String search) {
    log('regenerate words');
    if (!mounted) return;
    setState(() {
      _search = search;
      _words = _wordService.getWords(250, search);
    });
  }

  /// Column content string lengths (for monospace `characterWidth` sizing).
  void _accumulateWordColumnMaxLengths(WordList w, _WordColumnMaxLens acc) {
    acc.written = math.max(acc.written, w.writtenForm.length);
    acc.ipa = math.max(acc.ipa, w.phonetic.length + 4);
    acc.category = math.max(acc.category, w.categoryLabel.length + 2);
  }

  Map<int, TableColumnWidth> _wordTableColumnWidths(double cWidth) {
    final edge = FixedColumnWidth(cWidth);
    final acc = _WordColumnMaxLens();
    for (final w in _words) {
      _accumulateWordColumnMaxLengths(w, acc);
    }
    if (_words.isEmpty) {
      acc.written = acc.ipa = acc.category = 1;
    }
    final padWritten = cWidth * 2;
    return <int, TableColumnWidth>{
      0: edge,
      1: FixedColumnWidth(math.max(1, acc.written) * cWidth + padWritten),
      2: edge,
      3: FixedColumnWidth(math.max(1, acc.ipa) * cWidth + padWritten),
      4: edge,
      5: FixedColumnWidth(math.max(1, acc.category) * cWidth),
      6: edge,
      7: const FlexColumnWidth(1),
      8: edge,
    };
  }

  @override
  Widget build(BuildContext context) {
    final cWidth = TextMeasureProvider.of(context)!.characterWidth;
    final edge = FixedColumnWidth(cWidth);
    final borderWidths = <int, TableColumnWidth>{0: edge, 1: const FlexColumnWidth(), 2: edge};
    final rowWidths = _wordTableColumnWidths(cWidth);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        TextFormField(
          textAlign: TextAlign.start,
          style: LPFont.defaultTextStyle,
          onChanged: _regenerateWords,
          decoration: InputDecoration.collapsed(
            hintText: 'search words',
            hintStyle: LPFont.defaultTextStyle.merge(TextStyle(color: LPColor.greyColor)),
          ),
        ),
        const SizedBox(height: 8),
        Table(
          border: TableBorder.all(style: BorderStyle.none),
          columnWidths: borderWidths,
          children: const [
            TableRow(children: [XDash(), HDash(), XDash()]),
          ],
        ),
        Table(
          border: TableBorder.all(style: BorderStyle.none),
          columnWidths: rowWidths,
          defaultVerticalAlignment: TableCellVerticalAlignment.bottom,
          children: _words.map(buildWordTableRow).toList(growable: false),
        ),
        Table(
          border: TableBorder.all(style: BorderStyle.none),
          columnWidths: borderWidths,
          children: const [
            TableRow(children: [XDash(), HDash(), XDash()]),
          ],
        ),
      ],
    );
  }
}

class _WordColumnMaxLens {
  int written = 0;
  int ipa = 0;
  int category = 0;
}
