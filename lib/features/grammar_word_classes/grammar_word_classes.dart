import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/border/border.dart';
import 'package:language_parser_desktop/components/border/hdash.dart';
import 'package:language_parser_desktop/components/buttons/t_button.dart';
import 'package:language_parser_desktop/components/input/text_field.dart';
import 'package:language_parser_desktop/services/pos_service.dart';
import 'package:language_parser_desktop/util/constants.dart';

import '../../persistence/entities/pos_entity.dart';
import '../../persistence/repositories/invalidators/invalidator.dart';
import '../../service_provider.dart';
import '../../services/service_manager.dart';
import '../../text_measure_provider.dart';

class GrammarWordClasses extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GrammarWordClasses();
}

class _GrammarWordClasses extends State<GrammarWordClasses> implements Invalidator {
  ServiceManager? _serviceManager;
  late PosService _posService;
  List<Pos> _poses = [];
  int? _selected;

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
    var list = _posService.getAll();
    log('Poses $list');
    setState(() {
      _poses = list;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cWidth = TextMeasureProvider.of(context)!.characterWidth;
    List<TableRow> rows = List.empty(growable: true);
    final posLen = 2 + _poses.fold(5, (l, p) => p.name.length > l ? p.name.length : l);
    int i = 0;
    posButton(int i) => TButton(
        text: _poses[i].name,
        color: i == _selected ? LPColor.primaryColor : LPColor.greyColor,
        hover: LPColor.greyBrightColor,
        onPressed: () => setState(() {
              _selected = i;
            }));
    rows.add(TableRow(children: [
      DBorder(data: '|'),
      if (_poses.length > i) posButton(i) else Container(),
      DBorder(data: '|'),
      Container(alignment: Alignment.centerRight, child: DBorder(data: 'Name')),
      DBorder(data: '|'),
      TTextField(onChanged: (_) {}, controller: TextEditingController()),
      DBorder(data: '|')
    ]));
    i = 1;
    rows.add(TableRow(children: [
      DBorder(data: '|'),
      if (_poses.length > i) posButton(i) else Container(),
      DBorder(data: '|'),
      Container(alignment: Alignment.centerRight, child: DBorder(data: 'Abbreviation')),
      DBorder(data: '|'),
      TTextField(onChanged: (_) {}, controller: TextEditingController()),
      DBorder(data: '|')
    ]));
    i = 2;
    rows.add(TableRow(children: [
      DBorder(data: '|'),
      if (_poses.length > i) posButton(i) else Container(),
      DBorder(data: '|'),
      HDash(),
      DBorder(data: '+'),
      HDash(),
      DBorder(data: '|')
    ]));
    i = 3;
    for (; i < _poses.length; i++) {
      rows.add(TableRow(children: [
        DBorder(data: '|'),
        if (_poses.length > i) posButton(i) else Container(),
        DBorder(data: '|'),
        Container(),
        Container(),
        Container(),
        DBorder(data: '|')
      ]));
    }
    rows.add(TableRow(children: [
      DBorder(data: '|'),
      HDash(),
      DBorder(data: '|'),
      Container(),
      Container(),
      Container(),
      DBorder(data: '|')
    ]));
    return Column(children: [
      Table(
        columnWidths: {
          0: FixedColumnWidth(cWidth),
          1: FixedColumnWidth(cWidth * posLen),
          2: FixedColumnWidth(cWidth),
          3: FixedColumnWidth(14 * cWidth),
          4: FixedColumnWidth(cWidth),
          5: FlexColumnWidth(2),
          6: FixedColumnWidth(cWidth),
        },
        children: rows,
      ),
      Table(
        columnWidths: {
          0: FixedColumnWidth(cWidth),
          1: FixedColumnWidth(cWidth * posLen),
          2: FixedColumnWidth(cWidth),
          3: FixedColumnWidth(14 * cWidth),
          4: FixedColumnWidth(cWidth),
          5: FlexColumnWidth(2),
          6: FixedColumnWidth(cWidth),
        },
        children: [
          TableRow(children: [
            DBorder(data: '|'),
            TButton(text: '[ + ]', color: LPColor.greenColor, hover: LPColor.greenBrightColor),
            DBorder(data: '|'),
            Container(),
            Container(),
            Container(),
            DBorder(data: '|')
          ])
        ],
      ),
      Table(
        columnWidths: {
          0: FixedColumnWidth(cWidth),
          1: FlexColumnWidth(1),
          2: FixedColumnWidth(cWidth),
        },
        children: [
          TableRow(children: [
            DBorder(data: '+'),
            HDash(),
            DBorder(data: '+'),
          ])
        ],
      ),
    ]);
  }
}
