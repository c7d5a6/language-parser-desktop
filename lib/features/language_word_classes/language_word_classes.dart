import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/border/border.dart';
import 'package:language_parser_desktop/components/border/hdash.dart';
import 'package:language_parser_desktop/services/pos_service.dart';
import 'package:language_parser_desktop/services/word_service.dart';

import '../../components/buttons/t_button.dart';
import '../../persistence/entities/pos_entity.dart';
import '../../persistence/repositories/invalidators/invalidator.dart';
import '../../service_provider.dart';
import '../../services/service_manager.dart';
import '../../text_measure_provider.dart';
import '../../util/constants.dart';
import '../language_phonetics/language_phonetics_header.dart';

class LanguageWordClasses extends StatefulWidget {
  final int languageId;

  const LanguageWordClasses(this.languageId);

  @override
  State<StatefulWidget> createState() => _LanguageWordClasses();
}

class _LanguageWordClasses extends State<LanguageWordClasses> implements Invalidator {
  ServiceManager? _serviceManager;
  late PosService _posService;
  late WordService _wordService;
  List<Pos> _poses = [];
  Set<int> _usedPoses = {};
  Set<int> _enabledPoses = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final sm = ServiceProvider.of(context)?.serviceManager;
    if (_serviceManager != sm) {
      if (_serviceManager != null) {
        _serviceManager!.repositoryManager.removePosInvalidator(this);
        _serviceManager!.repositoryManager.removePosLangConnectionInvalidator(this);
      }
      _serviceManager = sm;
      _serviceManager!.repositoryManager.addPosInvalidator(this);
      _serviceManager!.repositoryManager.addPosLangConnectionInvalidator(this);
      _posService = _serviceManager!.posService;
      _wordService = _serviceManager!.wordService;
      _getPoses();
    }
  }

  @override
  void didUpdateWidget(LanguageWordClasses oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.languageId != oldWidget.languageId) {
      _getPoses();
    }
  }

  @override
  void dispose() {
    _serviceManager?.repositoryManager.removePosInvalidator(this);
    _serviceManager!.repositoryManager.removePosLangConnectionInvalidator(this);
    super.dispose();
  }

  @override
  void invalidate() {
    _getPoses();
  }

  void _getPoses() {
    var list = _posService.getAll()..sort((p1, p2) => p1.name.compareTo(p2.name));
    var enabled = _posService.getPosIdsByLangId(widget.languageId);
    var used = _wordService.getAllPosIDsByLang(widget.languageId);
    log("Poses used: $used");
    log("Poses enabled: $enabled");
    setState(() {
      _poses = list;
      _usedPoses = used;
      _enabledPoses = enabled;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cWidth = TextMeasureProvider.of(context)!.characterWidth;
    List<TableRow> rows = List.empty(growable: true);
    final posLen = math.max("ENABLE".length + 2, 5 + _poses.fold(5, (l, p) => p.name.length > l ? p.name.length : l));
    for (int i = -2; i < _poses.length; i++) {
      rows.add(TableRow(
          children: [DBorder(data: '|'), getWordClassCell(i), DBorder(data: '|'), Container(), DBorder(data: '|')]));
    }
    return Column(children: [
      Table(
        columnWidths: {
          0: FixedColumnWidth(cWidth),
          1: FixedColumnWidth(cWidth * posLen),
          2: FixedColumnWidth(cWidth),
          3: FlexColumnWidth(1),
          4: FixedColumnWidth(cWidth),
        },
        children: rows,
      ),
      Table(
        columnWidths: {
          0: FixedColumnWidth(cWidth),
          1: FixedColumnWidth(cWidth * posLen),
          2: FixedColumnWidth(cWidth),
          3: FlexColumnWidth(1),
          4: FixedColumnWidth(cWidth),
        },
        children: [
          TableRow(children: [DBorder(data: '+'), HDash(), DBorder(data: '+'), HDash(), DBorder(data: '+')])
        ],
      ),
    ]);
  }

  Widget getWordClassCell(int i) => i == -2
      ? Center(child: LPhHeader(header: 'ENABLED'))
      : i == -1
          ? HDash()
          : i < _poses.length
              ? createBtn(i, _poses)
              : Container();

  Widget createBtn(int i, List<Pos> list) {
    var pos = list[i];
    var used = _usedPoses.contains(pos.id);
    return Row(children: [
      DBorder(data: "["),
      enableBtn(pos.id, used),
      DBorder(data: "] "),
      TButton(
        text: pos.name,
        color: used ? LPColor.greyBrightColor : LPColor.greyColor,
        hover: LPColor.greyBrightColor,
        onPressed: () => {},
        disabled: !used,
      )
    ]);
  }

  TButton enableBtn(int posId, bool used) {
    var enabled = _enabledPoses.contains(posId);
    return TButton(
      text: enabled ? "o" : "x",
      color: enabled
          ? used
              ? LPColor.greenColor
              : LPColor.yellowColor
          : used
              ? LPColor.redColor
              : LPColor.greyColor,
      hover: LPColor.greyBrightColor,
      onPressed: () => enabled
          ? _posService.deletePosLangConnection(widget.languageId, posId)
          : _posService.savePosLangConnection(widget.languageId, posId),
    );
  }
}
