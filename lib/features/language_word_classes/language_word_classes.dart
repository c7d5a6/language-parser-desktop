import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/border/border.dart';
import 'package:language_parser_desktop/components/border/hdash.dart';
import 'package:language_parser_desktop/services/pos_service.dart';

import '../../persistence/entities/pos_entity.dart';
import '../../persistence/repositories/invalidators/invalidator.dart';
import '../../service_provider.dart';
import '../../services/service_manager.dart';
import '../../text_measure_provider.dart';
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
  List<Pos> _poses = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final sm = ServiceProvider.of(context)?.serviceManager;
    if (_serviceManager != sm) {
      if (_serviceManager != null) {
        _serviceManager!.repositoryManager.removePosInvalidator(this);
      }
      _serviceManager = sm;
      _serviceManager!.repositoryManager.addPosInvalidator(this);
      _posService = _serviceManager!.posService;
      _getPoses();
    }
  }

  @override
  void dispose() {
    _serviceManager?.repositoryManager.removePosInvalidator(this);
    super.dispose();
  }

  @override
  void invalidate() {
    _getPoses();
  }

  void _getPoses() {
    var list = _posService.getAll()..sort((p1, p2) => p1.name.compareTo(p2.name));
    setState(() {
      _poses = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cWidth = TextMeasureProvider.of(context)!.characterWidth;
    List<TableRow> rows = List.empty(growable: true);
    final posLen = math.max("ENABLE".length + 2, 2 + _poses.fold(5, (l, p) => p.name.length > l ? p.name.length : l));
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
              ? Text(_poses[i].name)
              : Container();
}
