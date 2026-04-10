import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/border/border.dart';
import 'package:language_parser_desktop/components/border/hdash.dart';
import 'package:language_parser_desktop/persistence/entities/word_list.dart';
import 'package:language_parser_desktop/persistence/repositories/invalidators/invalidator.dart';
import 'package:language_parser_desktop/service_provider.dart';
import 'package:language_parser_desktop/services/service_manager.dart';
import 'package:language_parser_desktop/services/word_service.dart';
import 'package:language_parser_desktop/text_measure_provider.dart';
import 'package:language_parser_desktop/util/constants.dart';

import 'word_table_paginator.dart';
import 'word_table_row.dart';

class WordsTable extends StatefulWidget {
  const WordsTable({super.key});

  @override
  State<WordsTable> createState() => _WordsTableState();
}

class _WordsTableState extends State<WordsTable> implements Invalidator {
  static const int _pageSize = 20;

  List<WordListItem> _words = [];
  int _currentPage = 1;
  int _totalCount = 0;
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
      _loadWordsPage();
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
    _loadWordsPage();
  }

  int get _totalPages {
    if (_totalCount <= 0) return 1;
    return (_totalCount + _pageSize - 1) ~/ _pageSize;
  }

  void _regenerateWords(String search) {
    log('regenerate words');
    if (!mounted) return;
    setState(() {
      _search = search;
      _currentPage = 1;
    });
    _loadWordsPage();
  }

  void _loadWordsPage() {
    if (!mounted) return;
    var page = _currentPage;
    var result = _wordService.getWordsPage(_pageSize, page - 1, _search);
    final totalPages = result.totalCount <= 0 ? 1 : (result.totalCount + _pageSize - 1) ~/ _pageSize;
    if (page > totalPages) {
      page = totalPages;
      result = _wordService.getWordsPage(_pageSize, page - 1, _search);
    }
    if (!mounted) return;
    setState(() {
      _currentPage = page;
      _totalCount = result.totalCount;
      _words = result.words;
    });
  }

  void _goToPage(int page) {
    if (!mounted) return;
    _currentPage = page;
    _loadWordsPage();
  }

  /// Column content string lengths (for monospace `characterWidth` sizing).
  void _accumulateWordColumnMaxLengths(WordListItem w, _WordColumnMaxLens acc) {
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
            TableRow(
              children: [
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
              ],
            ),
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
            TableRow(
              children: [
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
              ],
            ),
          ],
        ),
        WordTablePaginator(
          currentPage: _currentPage,
          totalPages: _totalPages,
          wordsOnThisPage: _words.length,
          pageSize: _pageSize,
          onPageSelected: _goToPage,
        ),
        Table(
          border: TableBorder.all(style: BorderStyle.none),
          columnWidths: borderWidths,
          children: const [
            TableRow(
              children: [
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
              ],
            ),
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
