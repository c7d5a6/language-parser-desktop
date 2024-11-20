import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/border/border.dart';
import 'package:language_parser_desktop/components/border/hdash.dart';
import 'package:language_parser_desktop/components/buttons/t_button.dart';
import 'package:language_parser_desktop/components/input/text_field.dart';
import 'package:language_parser_desktop/persistence/repositories/pos_repository.dart';
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
  bool _updated = false;
  bool creating = false;
  int? _selected;
  late TextEditingController _nameController = TextEditingController();
  late TextEditingController _abbrController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final sm = ServiceProvider.of(context)?.serviceManager;
    if (_serviceManager != sm) {
      if (_serviceManager != null) {
        _serviceManager!.repositoryManager.removePosInvalidator(this);
      }
      _serviceManager = sm;
      _nameController = TextEditingController();
      _abbrController = TextEditingController();
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
  Future<void> invalidate() async {
    _getPoses();
  }

  void _getPoses() {
    var list = _posService.getAll()..sort((p1, p2) => p1.name.compareTo(p2.name));
    log('Poses $list');
    setState(() {
      _poses = list;
      _updated = false;
    });
    _select(_selected);
  }

  void _select(int? i) {
    if (i != null) {
      if (!_poses.any((p) => p.id == i)) {
        i = null;
      }
    }
    if (_selected != i) {
      final pos = i == null ? null : _poses.firstWhere((p) => p.id == i);
      setState(() {
        _updated = false;
        _selected = i;
        if (_selected != null) {
          creating = false;
        }
        if (pos == null) {
          _nameController.clear();
          _abbrController.clear();
        } else {
          _nameController.text = pos.name;
          if (pos.abbreviation != null) {
            _abbrController.text = pos.abbreviation!;
          } else {
            _abbrController.clear();
          }
        }
      });
    }
  }

  void _startCreating() {
    setState(() {
      creating = true;
    });
    _select(null);
  }

  @override
  Widget build(BuildContext context) {
    final cWidth = TextMeasureProvider.of(context)!.characterWidth;
    List<TableRow> rows = List.empty(growable: true);
    final posLen = 5 + _poses.fold(5, (l, p) => p.name.length > l ? p.name.length : l);
    final buttons = _selected == null
        ? (creating
            ? Table(
                columnWidths: {
                  0: FlexColumnWidth(1),
                  1: FixedColumnWidth(cWidth),
                  2: FixedColumnWidth(cWidth * 7),
                  3: FixedColumnWidth(cWidth * 2 + 1)
                },
                children: [
                  TableRow(children: [
                    HDash(),
                    DBorder(data: '['),
                    TButton(
                      text: 'Create',
                      color: LPColor.greenColor,
                      hover: LPColor.greenBrightColor,
                      disabled: _nameController.text.isEmpty,
                      onPressed: () {
                        final pos = _posService.save(PosCreatingModel(
                            _nameController.text, _abbrController.text.isEmpty ? null : _abbrController.text));
                        _select(pos.id);
                      },
                    ),
                    DBorder(data: ']-')
                  ])
                ],
              )
            : HDash())
        : Table(
            columnWidths: {
              0: FlexColumnWidth(1),
              1: FixedColumnWidth(cWidth),
              2: FixedColumnWidth(cWidth * 6),
              3: FixedColumnWidth(cWidth * 3 + 1),
              4: FixedColumnWidth(cWidth * 8),
              5: FixedColumnWidth(cWidth * 2 + 1)
            },
            children: [
              TableRow(children: [
                HDash(),
                DBorder(data: '['),
                TButton(
                    text: 'Save',
                    color: LPColor.greenColor,
                    hover: LPColor.greenBrightColor,
                    disabled: !_updated,
                    onPressed: () =>
                        _posService.persist(PosUpdatingModel(_selected!, _nameController.text, _abbrController.text))),
                DBorder(data: ']-['),
                TButton(
                    text: 'Delete',
                    color: LPColor.redColor,
                    hover: LPColor.redBrightColor,
                    onPressed: () => _posService.delete(_selected!)),
                DBorder(data: ']-')
              ])
            ],
          );
    int i = 0;
    posButton(int i) => TButton(
        text: _poses[i].id == _selected ? "< ${_poses[i].name} >" : _poses[i].name,
        color: _poses[i].id == _selected ? LPColor.primaryColor : LPColor.greyColor,
        hover: LPColor.greyBrightColor,
        onPressed: () => _select(_poses[i].id));
    rows.add(TableRow(children: [
      DBorder(data: '|'),
      if (_poses.length > i) posButton(i) else Container(),
      DBorder(data: '|'),
      Container(alignment: Alignment.centerRight, child: DBorder(data: 'Name')),
      DBorder(data: '|'),
      if (_selected != null || creating)
        TTextField(
            onChanged: (_) => setState(() {
                  _updated = true;
                }),
            controller: _nameController)
      else
        Container(),
      DBorder(data: '|')
    ]));
    i = 1;
    rows.add(TableRow(children: [
      DBorder(data: '|'),
      if (_poses.length > i) posButton(i) else Container(),
      DBorder(data: '|'),
      Container(alignment: Alignment.centerRight, child: DBorder(data: 'Abbreviation')),
      DBorder(data: '|'),
      if (_selected != null || creating)
        TTextField(
            onChanged: (_) => setState(() {
                  _updated = true;
                }),
            controller: _abbrController)
      else
        Container(),
      DBorder(data: '|')
    ]));
    i = 2;
    rows.add(TableRow(children: [
      DBorder(data: '|'),
      if (_poses.length > i) posButton(i) else Container(),
      DBorder(data: '|'),
      HDash(),
      DBorder(data: '+'),
      buttons,
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
            TButton(
                text: '[ + ]', color: LPColor.greenColor, hover: LPColor.greenBrightColor, onPressed: _startCreating),
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
