import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/border/border.dart';
import 'package:language_parser_desktop/components/border/hdash.dart';
import 'package:language_parser_desktop/components/input/dropdown_field.dart';
import 'package:language_parser_desktop/persistence/entities/language_entity.dart';
import 'package:language_parser_desktop/persistence/entities/pos_entity.dart';
import 'package:language_parser_desktop/persistence/entities/word_list.dart';
import 'package:language_parser_desktop/persistence/repositories/invalidators/invalidator.dart';
import 'package:language_parser_desktop/service_provider.dart';
import 'package:language_parser_desktop/services/language_service.dart';
import 'package:language_parser_desktop/services/pos_service.dart';
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
  late LanguageService _languageService;
  late PosService _posService;
  String _search = '';

  int? _filterLanguageId;
  int? _filterPosId;
  List<Language> _languages = [];
  List<Pos> _poses = [];
  Set<int> _enabledPosIdsForLang = {};
  Set<int> _usedPosIdsForLang = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final sm = ServiceProvider.of(context)?.serviceManager;
    if (_serviceManager != sm) {
      if (_serviceManager != null) {
        _detachInvalidators();
      }
      _serviceManager = sm;
      _serviceManager!.repositoryManager.addWordInvalidator(this);
      _serviceManager!.repositoryManager.addLanguageInvalidator(this);
      _serviceManager!.repositoryManager.addPosInvalidator(this);
      _serviceManager!.repositoryManager.addPosLangConnectionInvalidator(this);
      _wordService = _serviceManager!.wordService;
      _languageService = _serviceManager!.languageService;
      _posService = _serviceManager!.posService;
      setState(_syncFilterLists);
      _loadWordsPage();
    }
  }

  void _detachInvalidators() {
    final rm = _serviceManager!.repositoryManager;
    rm.removeWordInvalidator(this);
    rm.removeLanguageInvalidator(this);
    rm.removePosInvalidator(this);
    rm.removePosLangConnectionInvalidator(this);
  }

  @override
  void dispose() {
    _serviceManager?.repositoryManager.removeWordInvalidator(this);
    _serviceManager?.repositoryManager.removeLanguageInvalidator(this);
    _serviceManager?.repositoryManager.removePosInvalidator(this);
    _serviceManager?.repositoryManager.removePosLangConnectionInvalidator(this);
    super.dispose();
  }

  @override
  Future<void> invalidate() async {
    if (!mounted) return;
    setState(_syncFilterLists);
    _loadWordsPage();
  }

  void _syncFilterLists() {
    _languages = _languageService.getAllLanguages()..sort((a, b) => a.displayName.compareTo(b.displayName));
    _poses = _posService.getAll()..sort((a, b) => a.name.compareTo(b.name));
    if (_filterLanguageId != null && !_languages.any((l) => l.id == _filterLanguageId)) {
      _filterLanguageId = null;
    }
    if (_filterPosId != null && !_poses.any((p) => p.id == _filterPosId)) {
      _filterPosId = null;
    }
    if (_filterLanguageId != null) {
      _enabledPosIdsForLang = _posService.getPosIdsByLangId(_filterLanguageId!);
      _usedPosIdsForLang = _wordService.getAllPosIDsByLang(_filterLanguageId!);
    } else {
      _enabledPosIdsForLang = {};
      _usedPosIdsForLang = {};
    }
  }

  int get _totalPages {
    if (_totalCount <= 0) return 1;
    return (_totalCount + _pageSize - 1) ~/ _pageSize;
  }

  void _regenerateWords(String search) {
    if (!mounted) return;
    setState(() {
      _search = search;
      _currentPage = 1;
    });
    _loadWordsPage();
  }

  void _onFilterLanguageChanged(int? languageId) {
    if (!mounted) return;
    setState(() {
      _filterLanguageId = languageId;
      _currentPage = 1;
      _syncFilterLists();
    });
    _loadWordsPage();
  }

  void _onFilterPosChanged(int? posId) {
    if (!mounted) return;
    setState(() {
      _filterPosId = posId;
      _currentPage = 1;
    });
    _loadWordsPage();
  }

  Color _posDropdownItemColor(Pos p) {
    if (_filterLanguageId == null) {
      return LPColor.greyBrightColor;
    }
    if (_enabledPosIdsForLang.contains(p.id)) {
      return LPColor.greyBrightColor;
    }
    if (_usedPosIdsForLang.contains(p.id)) {
      return LPColor.redColor;
    }
    return LPColor.greyColor;
  }

  void _loadWordsPage() {
    if (!mounted) return;
    var page = _currentPage;
    var result = _wordService.getWordsPage(
      _pageSize,
      page - 1,
      _search,
      languageId: _filterLanguageId,
      posId: _filterPosId,
    );
    final totalPages = result.totalCount <= 0 ? 1 : (result.totalCount + _pageSize - 1) ~/ _pageSize;
    if (page > totalPages) {
      page = totalPages;
      result = _wordService.getWordsPage(
        _pageSize,
        page - 1,
        _search,
        languageId: _filterLanguageId,
        posId: _filterPosId,
      );
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

  Widget _filterLabel(String value) {
    return SelectionContainer.disabled(
      child: Text(
        value,
        style: LPFont.defaultTextStyle.merge(TextStyle(color: LPColor.greyColor)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cWidth = TextMeasureProvider.of(context)!.characterWidth;
    final edge = FixedColumnWidth(cWidth);
    final borderWidths = <int, TableColumnWidth>{0: edge, 1: const FlexColumnWidth(), 2: edge};
    final rowWidths = _wordTableColumnWidths(cWidth);

    final filterRowWidths = <int, TableColumnWidth>{
      0: edge,
      1: FixedColumnWidth(11 * cWidth),
      2: edge,
      3: FixedColumnWidth(18 * cWidth),
      4: edge,
      5: FixedColumnWidth(8 * cWidth),
      6: edge,
      7: const FlexColumnWidth(1),
      8: edge,
    };

    final languageItems = <DropdownMenuItem<int?>>[
      DropdownMenuItem<int?>(value: null, child: Text('All', style: LPFont.defaultTextStyle)),
      ..._languages.map(
        (language) => DropdownMenuItem<int?>(
          value: language.id,
          child: Text(language.displayName),
        ),
      ),
    ];

    final posItems = <DropdownMenuItem<int?>>[
      DropdownMenuItem<int?>(
        value: null,
        child: Text('All', style: LPFont.defaultTextStyle.merge(TextStyle(color: LPColor.greyBrightColor))),
      ),
      ..._poses.map(
        (pos) => DropdownMenuItem<int?>(
          value: pos.id,
          child: Text(
            pos.name,
            style: LPFont.defaultTextStyle.merge(TextStyle(color: _posDropdownItemColor(pos))),
          ),
        ),
      ),
    ];

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
          columnWidths: filterRowWidths,
          children: [
            TableRow(
              children: [
                const DBorder(data: '|'),
                _filterLabel('LANGUAGE'),
                const DBorder(data: '|'),
                TDropdownField<int?>(
                  value: _filterLanguageId,
                  items: languageItems,
                  onChanged: _onFilterLanguageChanged,
                ),
                const DBorder(data: '|'),
                _filterLabel('CATEGORY'),
                const DBorder(data: '|'),
                TDropdownField<int?>(
                  value: _filterPosId,
                  items: posItems,
                  onChanged: _onFilterPosChanged,
                ),
                const DBorder(data: '|'),
              ],
            ),
          ],
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
