import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/border/border.dart';
import 'package:language_parser_desktop/components/border/hdash.dart';
import 'package:language_parser_desktop/components/buttons/t_button.dart';
import 'package:language_parser_desktop/persistence/entities/grammatical_category_entity.dart';
import 'package:language_parser_desktop/persistence/entities/grammatical_category_value_entity.dart';
import 'package:language_parser_desktop/services/gc_service.dart';
import 'package:language_parser_desktop/services/pos_service.dart';
import 'package:language_parser_desktop/util/constants.dart';

import '../../persistence/entities/pos_entity.dart';
import '../../persistence/repositories/invalidators/invalidator.dart';
import '../../service_provider.dart';
import '../../services/service_manager.dart';
import '../../text_measure_provider.dart';
import '../language_phonetics/language_phonetics_header.dart';

class LanguageGrammaticalCategories extends StatefulWidget {
  final int languageId;

  const LanguageGrammaticalCategories(this.languageId);

  @override
  State<StatefulWidget> createState() => _LanguageGrammaticalCategories();
}

class _LanguageGrammaticalCategories extends State<LanguageGrammaticalCategories> implements Invalidator {
  ServiceManager? _serviceManager;
  late GCService _gcService;
  late PosService _posService;
  List<GrammaticalCategory> _gcs = [];
  Set<int> _gcsForClassEnabled = {};
  Set<int> _gcsWithValuesEnabled = {};
  List<GrammaticalCategoryValue> _gcvs = [];
  Set<int> _selectedGCVs = {};
  List<Pos> _poses = [];
  Set<int> _enabledPoses = {};
  Set<int> _selectedPoses = {};
  int? _gcSelected;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final sm = ServiceProvider.of(context)?.serviceManager;
    if (_serviceManager != sm) {
      if (_serviceManager != null) {
        _serviceManager!.repositoryManager.removeGCInvalidator(this);
        _serviceManager!.repositoryManager.removeGCVInvalidator(this);
        _serviceManager!.repositoryManager.removeGCVLangInvalidator(this);
        _serviceManager!.repositoryManager.removePosInvalidator(this);
        _serviceManager!.repositoryManager.removePosLangConnectionInvalidator(this);
        _serviceManager!.repositoryManager.removePosGCLangConnectionInvalidator(this);
      }
      _serviceManager = sm;
      _serviceManager!.repositoryManager.addGCValidator(this);
      _serviceManager!.repositoryManager.addGCVValidator(this);
      _serviceManager!.repositoryManager.addGCVLangInvalidator(this);
      _serviceManager!.repositoryManager.addPosInvalidator(this);
      _serviceManager!.repositoryManager.addPosLangConnectionInvalidator(this);
      _serviceManager!.repositoryManager.addPosGCLangConnectionInvalidator(this);
      _gcService = _serviceManager!.gcService;
      _posService = _serviceManager!.posService;
      _gcSelected = null;
      invalidate();
    }
  }

  @override
  void didUpdateWidget(LanguageGrammaticalCategories oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.languageId != oldWidget.languageId) {
      invalidate();
    }
  }

  @override
  void dispose() {
    _serviceManager!.repositoryManager.removeGCInvalidator(this);
    _serviceManager!.repositoryManager.removeGCVInvalidator(this);
    _serviceManager!.repositoryManager.removeGCVLangInvalidator(this);
    _serviceManager!.repositoryManager.removePosInvalidator(this);
    _serviceManager!.repositoryManager.removePosLangConnectionInvalidator(this);
    _serviceManager!.repositoryManager.removePosGCLangConnectionInvalidator(this);
    super.dispose();
  }

  @override
  Future<void> invalidate() async {
    _getGCs();
    _getGCVs();
    _getPoses();
    _getSelectedPoses();
  }

  void _getGCs() {
    var list = _gcService.getAllGCs()..sort((p1, p2) => p1.name.compareTo(p2.name));
    var used = _gcService.getConnectedGCsIdsByLangId(widget.languageId);
    var withValues = _gcService.getGCsWithValuesEnabled(widget.languageId);
    setState(() {
      _gcs = list;
      _gcsForClassEnabled = used;
      _gcsWithValuesEnabled = withValues;
    });
    _selectGC(_gcSelected);
  }

  void _selectGC(int? i) {
    if (i != null) {
      if (!_gcs.any((p) => p.id == i)) {
        i = null;
      }
    }
    if (_gcSelected != i) {
      setState(() {
        _gcSelected = i;
      });
      _getGCVs();
      _getSelectedPoses();
    }
  }

  void _getPoses() {
    var list = _posService.getAll()..sort((p1, p2) => p1.name.compareTo(p2.name));
    var enabled = _posService.getPosIdsByLangId(widget.languageId);
    setState(() {
      _poses = list;
      _enabledPoses = enabled;
    });
  }

  void _getSelectedPoses() {
    final gc = _gcSelected == null ? null : _gcs.firstWhere((p) => p.id == _gcSelected);
    Set<int> selectedPos = gc == null ? {} : _posService.getPosGCIdsByLangIdGCId(widget.languageId, gc.id);
    log("Selected poses: $selectedPos");
    setState(() {
      _selectedPoses = selectedPos;
    });
  }

  void _getGCVs() {
    final gc = _gcSelected == null ? null : _gcs.firstWhere((p) => p.id == _gcSelected);
    List<GrammaticalCategoryValue> list = gc == null ? [] : _gcService.getAllGCVs(gc.id)
      ..sort((p1, p2) => p1.name.compareTo(p2.name));
    Set<int> selectedGCVs = gc == null ? {} : _gcService.getGCVIdsByLangIdAndGCId(widget.languageId, gc.id);
    log("Selected gcvs: $selectedGCVs");
    setState(() {
      _gcvs = list;
      _selectedGCVs = selectedGCVs;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cWidth = TextMeasureProvider.of(context)!.characterWidth;
    final gcLen = 6 + _gcs.fold(5, ((n, gc) => math.max(n, gc.name.length)));
    final posLen = 5 + _poses.fold(0, ((n, pos) => math.max(n, pos.name.length)));
    final gcvLen = 5 + _gcvs.fold(5, ((n, gcv) => math.max(n, gcv.name.length)));
    final rowLength = 2 + math.max(math.max(_poses.length, math.max(_gcs.length, _gcvs.length)), 0);

    List<TableRow> rows = List.empty(growable: true);

    for (int i = 0; i < rowLength; i++) {
      rows.add(TableRow(children: [
        DBorder(data: '|'),
        createGCCell(i),
        DBorder(data: '|'),
        createPOSCell(i, posLen * cWidth),
        DBorder(data: '|'),
        createGCVCell(i, gcvLen * cWidth),
        DBorder(data: '|'),
      ]));
    }
    rows.add(TableRow(children: [
      DBorder(data: '+'),
      HDash(),
      DBorder(data: '+'),
      HDash(),
      DBorder(data: '+'),
      HDash(),
      DBorder(data: '+')
    ]));
    return Column(children: [
      Table(columnWidths: {
        0: FixedColumnWidth(cWidth),
        1: FixedColumnWidth(cWidth * gcLen),
        2: FixedColumnWidth(cWidth),
        3: FlexColumnWidth(2),
        4: FixedColumnWidth(cWidth),
        5: FlexColumnWidth(2),
        6: FixedColumnWidth(cWidth),
      }, children: rows)
    ]);
  }

  Widget createGCCell(int i) => (i < 1)
      ? Container()
      : (_gcs.length > i - 1)
          ? createValueBtn(_gcs[i - 1], _gcs[i - 1].id == _gcSelected, _selectGC)
          : Container();

  Widget createPOSCell(int i, double posWidth) {
    var pos = i >= 2 && _poses.length > i - 2 ? _poses[i - 2] : null;
    var enabled = _enabledPoses.contains(pos?.id);
    var selected = _selectedPoses.contains(pos?.id);
    return (i == 0)
        ? Center(child: LPhHeader(header: 'ENABLED FOR CLASSES'))
        : (i == 1)
            ? HDash()
            : (_poses.length > i - 2)
                ? Center(
                    child: Container(
                        width: posWidth,
                        child: Row(children: [
                          DBorder(data: "["),
                          enablePosBtn(
                              selected,
                              enabled,
                              () => _posService.deletePosGCLangConnection(widget.languageId, _gcSelected!, pos!.id),
                              () => _posService.savePosGCLangConnection(widget.languageId, _gcSelected!, pos!.id)),
                          DBorder(data: "] "),
                          Text(pos!.name,
                              style: LPFont.defaultTextStyle
                                  .merge(TextStyle(color: enabled ? LPColor.greyBrightColor : LPColor.greyColor)))
                        ])))
                : Container();
  }

  Widget createGCVCell(int i, double width) {
    var gcv = i >= 2 && _gcvs.length > i - 2 ? _gcvs[i - 2] : null;
    var selected = _selectedGCVs.contains(gcv?.id);
    return (i == 0)
        ? Center(child: LPhHeader(header: 'ENABLED VALUES'))
        : (i == 1)
            ? HDash()
            : (_gcvs.length > i - 2)
                ? Center(
                    child: Container(
                        width: width,
                        child: Row(children: [
                          DBorder(data: "["),
                          enablePosBtn(
                            selected,
                            true,
                            () => _gcService.deleteGCVLangConnection(widget.languageId, gcv!.id),
                            () {
                              log("save gcv $gcv");
                              _gcService.saveGCVLangConnection(widget.languageId, gcv!.id);
                            },
                          ),
                          DBorder(data: "] "),
                          Text(gcv!.name,
                              style: LPFont.defaultTextStyle.merge(TextStyle(color: LPColor.greyBrightColor)))
                        ])))
                : Container();
  }

  TButton enablePosBtn(bool selected, bool enabled, void Function() delete, void Function() save) {
    return TButton(
      text: selected ? "o" : "x",
      disabled: _gcSelected == null,
      color: selected
          ? enabled
              ? LPColor.greenColor
              : LPColor.yellowColor
          : LPColor.greyColor,
      hover: selected
          ? enabled
              ? LPColor.greenBrightColor
              : LPColor.yellowBrightColor
          : LPColor.greyBrightColor,
      onPressed: _gcSelected == null ? () => log("gc not selected") : () => selected ? delete() : save(),
    );
  }

  Widget createValueBtn(GrammaticalCategory category, bool selected, void Function(int?) select) {
    var enabled = _gcsForClassEnabled.contains(category.id);
    var withValues = _gcsWithValuesEnabled.contains(category.id);
    var text = category.name;
    return TButton(
        text: selected ? "> ${text} <" : text,
        color: selected
            ? LPColor.primaryBrightColor
            : (enabled && withValues)
                ? LPColor.greyBrightColor
                : (withValues != enabled)
                    ? LPColor.yellowColor
                    : LPColor.greyColor,
        hover: selected
            ? LPColor.primaryBrighterColor
            : (enabled && withValues)
                ? LPColor.whiteColor
                : (withValues != enabled)
                    ? LPColor.yellowBrightColor
                    : LPColor.greyBrightColor,
        background: selected ? LPColor.selectedBackgroundColor : null,
        onPressed: () => select(category.id));
  }
}
