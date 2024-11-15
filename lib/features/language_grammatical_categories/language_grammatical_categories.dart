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
  void invalidate() {
    _getGCs();
    _getGCVs();
    _getPoses();
  }

  void _getGCs() {
    var list = _gcService.getAllGCs()..sort((p1, p2) => p1.name.compareTo(p2.name));
    log('GCs $list');
    setState(() {
      _gcs = list;
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
    log("Poses enabled: $enabled");
    setState(() {
      _poses = list;
      _enabledPoses = enabled;
    });
  }

  void _getSelectedPoses() {
    final gc = _gcSelected == null ? null : _gcs.firstWhere((p) => p.id == _gcSelected);
    Set<int> selectedPos = gc == null ? {} : _posService.getPosGCIdsByLangIdGCId(widget.languageId, gc.id);
    setState(() {
      _selectedPoses = selectedPos;
    });
  }

  void _getGCVs() {
    final gc = _gcSelected == null ? null : _gcs.firstWhere((p) => p.id == _gcSelected);
    List<GrammaticalCategoryValue> list = gc == null ? [] : _gcService.getAllGCVs(gc.id)
      ..sort((p1, p2) => p1.name.compareTo(p2.name));
    Set<int> selectedGCVs = gc == null ? {} : _gcService.getGCVIdsByLangIdAndGCId(widget.languageId, gc.id);
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
          ? createValueBtn(i - 1, _selectGC, _gcs, _gcSelected)
          : Container();

  Widget createPOSCell(int i, double posWidth) {
    var pos = i >= 2 && _poses.length > i - 2 ? _poses[i - 2] : null;
    var enabled = _enabledPoses.contains(pos?.id);
    return (i == 0)
        ? Center(child: LPhHeader(header: 'ENABLE FOR CLASSES'))
        : (i == 1)
            ? HDash()
            : (_poses.length > i - 2)
                ? Center(
                    child: Container(
                        width: posWidth,
                        child: Row(children: [
                          DBorder(data: "["),
                          enablePosBtn(pos!.id, enabled),
                          DBorder(data: "] "),
                          Text(pos.name,
                              style: LPFont.defaultTextStyle
                                  .merge(TextStyle(color: enabled ? LPColor.greyBrightColor : LPColor.greyColor)))
                        ])))
                : Container();
  }

  TButton enablePosBtn(int posId, bool posEnabled) {
    return TButton(
      text: posEnabled ? "o" : "x",
      disabled: _gcSelected == null,
      color: posEnabled
          ? false
              ? LPColor.greenColor
              : LPColor.yellowColor
          : false
              ? LPColor.redColor
              : LPColor.greyColor,
      hover: posEnabled
          ? false
              ? LPColor.greenBrightColor
              : LPColor.yellowBrightColor
          : false
              ? LPColor.redBrightColor
              : LPColor.greyBrightColor,
      onPressed: () => posEnabled
          ? _posService.deletePosLangConnection(widget.languageId, posId)
          : _posService.savePosLangConnection(widget.languageId, posId),
    );
  }

  Widget createGCVCell(int i, double width) {
    var gcv = i >= 2 && _gcvs.length > i - 2 ? _gcvs[i - 2] : null;
    return (i == 0)
        ? Center(child: LPhHeader(header: 'ENABLE VALUES'))
        : (i == 1)
            ? HDash()
            : (_gcvs.length > i - 2)
                ? Center(
                    child: Container(
                        width: width,
                        child: Row(children: [
                          DBorder(data: "["),
                          enablePosBtn(gcv!.id, true),
                          DBorder(data: "] "),
                          Text(gcv.name,
                              style: LPFont.defaultTextStyle.merge(TextStyle(color: LPColor.greyBrightColor)))
                        ])))
                : Container();
  }

  Widget createValueBtn(int i, void Function(int?) select, List<dynamic> list, int? selected) => TButton(
      text: list[i].name,
      color: list[i].id == selected ? LPColor.primaryColor : LPColor.greyColor,
      hover: LPColor.greyBrightColor,
      onPressed: () => select(list[i].id));
}
