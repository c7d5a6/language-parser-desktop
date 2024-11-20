import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/border/border.dart';
import 'package:language_parser_desktop/components/border/hdash.dart';
import 'package:language_parser_desktop/components/buttons/t_button.dart';
import 'package:language_parser_desktop/features/language_declensions/language_declension.dart';
import 'package:language_parser_desktop/persistence/entities/grammatical_category_entity.dart';
import 'package:language_parser_desktop/services/declension_service.dart';
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
  late DeclensionService _declensionService;
  late GCService _gcService;
  late PosService _posService;
  List<Pos> _poses = [];
  Set<int> _posesUsed = {};
  Set<int> _posesEnabled = {};
  int? _posSelected;
  List<GrammaticalCategory> _gcs = [];
  Set<int> _gcsEnabled = {};
  List<DeclensionRow> _declensions = [];
  int? _declensionSelected;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final sm = ServiceProvider.of(context)?.serviceManager;
    if (_serviceManager != sm) {
      if (_serviceManager != null) {
        _serviceManager!.repositoryManager.removeDeclensionCategoryPosLangConnectionInvalidator(this);
        _serviceManager!.repositoryManager.removeDeclensionInvalidator(this);
        _serviceManager!.repositoryManager.removeGCInvalidator(this);
        _serviceManager!.repositoryManager.removeGCVInvalidator(this);
        _serviceManager!.repositoryManager.removeGCVLangInvalidator(this);
        _serviceManager!.repositoryManager.removePosInvalidator(this);
        _serviceManager!.repositoryManager.removePosLangConnectionInvalidator(this);
        _serviceManager!.repositoryManager.removePosGCLangConnectionInvalidator(this);
      }
      _serviceManager = sm;
      _serviceManager!.repositoryManager.addDeclensionCategoryPosLangConnectionInvalidator(this);
      _serviceManager!.repositoryManager.addDeclensionInvalidator(this);
      _serviceManager!.repositoryManager.addGCValidator(this);
      _serviceManager!.repositoryManager.addGCVValidator(this);
      _serviceManager!.repositoryManager.addGCVLangInvalidator(this);
      _serviceManager!.repositoryManager.addPosInvalidator(this);
      _serviceManager!.repositoryManager.addPosLangConnectionInvalidator(this);
      _serviceManager!.repositoryManager.addPosGCLangConnectionInvalidator(this);
      _gcService = _serviceManager!.gcService;
      _posService = _serviceManager!.posService;
      _declensionService = _serviceManager!.declensionService;
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
    _serviceManager!.repositoryManager.removeDeclensionCategoryPosLangConnectionInvalidator(this);
    _serviceManager!.repositoryManager.removeDeclensionInvalidator(this);
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
    _getPoses();
    _getGCs();
    _getDeclensions();
  }

  void _getPoses() {
    var enabled = _posService.getPosIdsByLangId(widget.languageId);
    var used = _declensionService.getPosIdsByLangId(widget.languageId);
    var list = _posService
        .getAll()
        .where((pos) => enabled.contains(pos.id) || used.contains(pos.id))
        .toList(growable: false)
      ..sort((p1, p2) => p1.name.compareTo(p2.name));
    setState(() {
      _poses = list;
      _posesUsed = used;
      _posesEnabled = enabled;
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
      _getDeclensions();
    }
  }

  void _getGCs() {
    var list = _gcService.getAllGCs()..sort((p1, p2) => p1.name.compareTo(p2.name));
    Set<int> enabled =
        _posSelected == null ? {} : _declensionService.getGCsIdsByLangIdAndPosId(widget.languageId, _posSelected!);
    setState(() {
      _gcs = list;
      _gcsEnabled = enabled;
    });
  }

  void _getDeclensions() {
    if (_posSelected != null) {
      var declensions = _declensionService.getDeclensions(widget.languageId, _posSelected!);
      log("Declensions: $declensions");
      _declensions = declensions;
    }
  }

  void _selectDeclension(int? i) {
    if (i != null) {
      if (!_declensions.any((p) => p.used && p.declensionId == i)) {
        i = null;
      }
    }
    if (_declensionSelected != i) {
      setState(() {
        _declensionSelected = i;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cWidth = TextMeasureProvider.of(context)!.characterWidth;
    final posLen = 5 + _poses.fold(0, ((n, pos) => math.max(n, pos.name.length)));
    final gcLen =
        math.max(6 + _gcs.fold(0, ((n, gc) => math.max(n, gc.name.length))), "USED FOR DECLENSION".length + 2);
    final rowLength = 2 + math.max(math.max(_poses.length, math.max(_gcs.length, _declensions.length)), 0);

    List<TableRow> rows = List.empty(growable: true);

    DeclensionRow? declension = _declensions.where((d) => d.used && d.declensionId == _declensionSelected).firstOrNull;

    for (int i = 0; i < rowLength; i++) {
      rows.add(TableRow(children: [
        DBorder(data: '|'),
        createPosCell(i),
        DBorder(data: '|'),
        createGCCell(i),
        DBorder(data: '|'),
        createDeclensionCell(i),
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
      }, children: rows),
      if (declension != null) LanguageDeclension(widget.languageId, declension)
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
    return (i == 0)
        ? Center(child: LPhHeader(header: 'USED FOR DECLENSION'))
        : (i == 1)
            ? HDash()
            : (_gcs.length > i - 2)
                ? Row(children: [
                    DBorder(data: "["),
                    enableBtn(
                        enabled,
                        enabled,
                        () => _declensionService.deleteConnection(widget.languageId, gc!.id, _posSelected!),
                        () => _declensionService.saveConnection(widget.languageId, gc!.id, _posSelected!)),
                    DBorder(data: "] "),
                    Text(gc!.name,
                        style: LPFont.defaultTextStyle
                            .merge(TextStyle(color: enabled ? LPColor.greyBrightColor : LPColor.greyColor)))
                  ])
                : Container();
  }

  TButton enableBtn(bool selected, bool enabled, void Function() delete, void Function() save) {
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

  Widget createValueBtn(int i, void Function(int?) select, List<dynamic> list, int? selected) {
    var elem = list[i];
    var id = elem.id;
    var used = _posesUsed.contains(id);
    var enabled = _posesEnabled.contains(id);
    return TButton(
        text: (id == selected) ? "> ${elem.name} <" : elem.name,
        color: id == selected
            ? LPColor.primaryColor
            : !used
                ? LPColor.greyColor
                : enabled
                    ? LPColor.greyBrightColor
                    : LPColor.redColor,
        hover: id == selected
            ? LPColor.primaryBrightColor
            : !used
                ? LPColor.greyBrightColor
                : enabled
                    ? LPColor.whiteColor
                    : LPColor.redBrightColor,
        background: id == selected ? LPColor.selectedBackgroundColor : null,
        onPressed: () => select(id));
  }

  createDeclensionCell(int i) {
    var declension = i >= 2 && _declensions.length > i - 2 ? _declensions[i - 2] : null;
    return (i == 0)
        ? Center(child: LPhHeader(header: 'ENABLED DECLENSIONS'))
        : (i == 1)
            ? HDash()
            : (_declensions.length > i - 2)
                // ? Row(children: declension!.map((d) => Text("${d.name} ")).toList())
                ? Row(children: [declensionEnableButton(declension!), declensionButton(declension!)])
                : Container();
  }

  Widget declensionEnableButton(DeclensionRow declension) => Row(children: [
        DBorder(data: "["),
        declension.used
            ? TButton(
                text: 'o',
                color: declension.deprecated ? LPColor.redColor : LPColor.greenColor,
                hover: declension.deprecated ? LPColor.redBrightColor : LPColor.greenBrightColor,
                onPressed: () => _declensionService.delete(declension.declensionId!),
              )
            : TButton(
                text: 'x',
                color: LPColor.greyColor,
                hover: LPColor.greyBrightColor,
                onPressed: () => _declensionService.save(widget.languageId, _posSelected!, declension.valuesIds),
              ),
        DBorder(data: "] "),
      ]);

  Widget declensionButton(DeclensionRow declension) {
    var selected = declension.declensionId == _declensionSelected;
    var main = declension.main ? "*" : "";
    return declension.used
        ? TButton(
            text: selected ? "< $main${declension.name} >" : "$main${declension.name}",
            color: selected
                ? LPColor.primaryColor
                : declension.deprecated
                    ? LPColor.redColor
                    : LPColor.greyColor,
            hover: selected
                ? LPColor.primaryBrightColor
                : declension.deprecated
                    ? LPColor.redBrightColor
                    : LPColor.greyBrightColor,
            onPressed: () => _selectDeclension(declension.declensionId),
          )
        : Text(declension.name, style: LPFont.defaultTextStyle.merge(TextStyle(color: LPColor.greyColor)));
  }
}
