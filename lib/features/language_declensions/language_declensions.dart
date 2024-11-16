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

class LanguageDeclensions extends StatefulWidget {
  final int languageId;

  const LanguageDeclensions(this.languageId);

  @override
  State<StatefulWidget> createState() => _LanguageDeclensions();
}

class _LanguageDeclensions extends State<LanguageDeclensions> implements Invalidator {
  ServiceManager? _serviceManager;
  late PosService _posService;
  List<Pos> _poses = [];
  late GCService _gcService;
  List<GrammaticalCategory> _gcs = [];
  Set<int> _gcsEnabled = {};
  List<GrammaticalCategoryValue> _gcvs = [];
  Set<int> _selectedGCVs = {};
  int? _posSelected;

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
      _posSelected = null;
      invalidate();
    }
  }

  @override
  void didUpdateWidget(LanguageDeclensions oldWidget) {
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
  void invalidate() {
    _getGCs();
    _getGCVs();
    _getPoses();
  }

  void _getPoses() {
    var enabled = _posService.getPosIdsByLangId(widget.languageId);
    var list = _posService.getAll().where((pos) => enabled.contains(pos.id)).toList(growable: false)
      ..sort((p1, p2) => p1.name.compareTo(p2.name));
    setState(() {
      _poses = list;
    });
    _selectPos(_posSelected);
  }

  void _selectPos(int? i) {
    if (i != null) {
      if (!_poses.any((p) => p.id == i)) {
        i = null;
      }
    }
    if (_posSelected != i) {
      setState(() {
        _posSelected = i;
      });
      _getGCs();
    }
  }

  void _getGCs() {
    var list = _gcService.getAllGCs()..sort((p1, p2) => p1.name.compareTo(p2.name));
    Set<int> enabled =
        _posSelected == null ? {} : _gcService.getGCsIdsByLangIdAndPosId(widget.languageId, _posSelected!);
    setState(() {
      _gcs = list;
      _gcsEnabled = enabled;
    });
  }

  void _getGCVs() {
    final gc = _posSelected == null ? null : _gcs.firstWhere((p) => p.id == _posSelected);
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
    final posLen = 4 + _poses.fold(0, ((n, pos) => math.max(n, pos.name.length)));
    final gcLen = math.max(6 + _gcs.fold(0, ((n, gc) => math.max(n, gc.name.length))), "USED CATEGORIES".length + 2);
    final gcvLen = 5 + _gcvs.fold(5, ((n, gcv) => math.max(n, gcv.name.length)));
    final rowLength = 2 + math.max(math.max(_poses.length, math.max(_gcs.length, _gcvs.length)), 0);

    List<TableRow> rows = List.empty(growable: true);

    for (int i = 0; i < rowLength; i++) {
      rows.add(TableRow(children: [
        DBorder(data: '|'),
        createPosCell(i),
        DBorder(data: '|'),
        createGCCell(i),
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
        1: FixedColumnWidth(cWidth * posLen),
        2: FixedColumnWidth(cWidth),
        3: FixedColumnWidth(cWidth * gcLen),
        4: FixedColumnWidth(cWidth),
        5: FlexColumnWidth(2),
        6: FixedColumnWidth(cWidth),
      }, children: rows)
    ]);
  }

  Widget createPosCell(int i) => (i < 1)
      ? Container()
      : (_poses.length > i - 1)
          ? createValueBtn(i - 1, _selectPos, _poses, _posSelected)
          : Container();

  Widget createGCCell(int i) {
    var gc = i >= 2 && _gcs.length > i - 2 ? _gcs[i - 2] : null;
    var enabled = _gcsEnabled.contains(gc?.id);
    var selected = false;
    return (i == 0)
        ? Center(child: LPhHeader(header: 'USED CATEGORIES'))
        : (i == 1)
            ? HDash()
            : (_gcs.length > i - 2)
                ? Row(children: [
                    DBorder(data: "["),
                    enablePosBtn(
                        selected,
                        enabled,
                        () => _posService.deletePosGCLangConnection(widget.languageId, _posSelected!, gc!.id),
                        () => _posService.savePosGCLangConnection(widget.languageId, _posSelected!, gc!.id)),
                    DBorder(data: "] "),
                    Text(gc!.name,
                        style: LPFont.defaultTextStyle
                            .merge(TextStyle(color: enabled ? LPColor.greyBrightColor : LPColor.greyColor)))
                  ])
                : Container();
  }

  Widget createGCVCell(int i, double width) {
    var gcv = i >= 2 && _gcvs.length > i - 2 ? _gcvs[i - 2] : null;
    var selected = _selectedGCVs.contains(gcv?.id);
    return (i == 0)
        ? Center(child: LPhHeader(header: 'ENABLED DECLENSIONS'))
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
      disabled: _posSelected == null,
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
      onPressed: _posSelected == null ? () => log("gc not selected") : () => selected ? delete() : save(),
    );
  }

  Widget createValueBtn(int i, void Function(int?) select, List<dynamic> list, int? selected) => TButton(
      text: list[i].name,
      color: list[i].id == selected ? LPColor.primaryColor : LPColor.greyColor,
      hover: LPColor.greyBrightColor,
      onPressed: () => select(list[i].id));
}
