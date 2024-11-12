import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/border/border.dart';
import 'package:language_parser_desktop/components/border/hdash.dart';
import 'package:language_parser_desktop/components/buttons/t_button.dart';
import 'package:language_parser_desktop/persistence/entities/grammatical_category_entity.dart';
import 'package:language_parser_desktop/persistence/entities/grammatical_category_value_entity.dart';
import 'package:language_parser_desktop/services/gc_service.dart';
import 'package:language_parser_desktop/util/constants.dart';

import '../../components/input/text_field.dart';
import '../../persistence/repositories/invalidators/invalidator.dart';
import '../../service_provider.dart';
import '../../services/service_manager.dart';
import '../../text_measure_provider.dart';

class GrammarGrammaticalCategories extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GrammarGrammaticalCategories();
}

class _GrammarGrammaticalCategories extends State<GrammarGrammaticalCategories> implements Invalidator {
  ServiceManager? _serviceManager;
  late TextEditingController _gcNameController = TextEditingController();
  late TextEditingController _gcvNameController = TextEditingController();
  late GCService _gcService;
  List<GrammaticalCategory> _gcs = [];
  List<GrammaticalCategoryValue> _gcvs = [];
  bool _gcUpdated = false;
  bool _gcvUpdated = false;
  bool _gcCreating = false;
  bool _gcvCreating = false;
  int? _gcSelected;
  int? _gcvSelected;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final sm = ServiceProvider.of(context)?.serviceManager;
    if (_serviceManager != sm) {
      if (_serviceManager != null) {
        _serviceManager!.repositoryManager.removeGCInvalidator(this);
        _serviceManager!.repositoryManager.removeGCVInvalidator(this);
      }
      _serviceManager = sm;
      _gcNameController = TextEditingController();
      _gcvNameController = TextEditingController();
      _serviceManager!.repositoryManager.addGCValidator(this);
      _serviceManager!.repositoryManager.addGCVValidator(this);
      _gcService = _serviceManager!.gcService;
      _gcUpdated = false;
      _gcvUpdated = false;
      _gcCreating = false;
      _gcvCreating = false;
      _gcSelected = null;
      _gcvSelected = null;
      _getGCs();
    }
  }

  @override
  void dispose() {
    _serviceManager!.repositoryManager.removeGCInvalidator(this);
    _serviceManager!.repositoryManager.removeGCVInvalidator(this);
    super.dispose();
  }

  @override
  void invalidate() {
    _getGCs();
  }

  void _getGCs() {
    var list = _gcService.getAllGCs()..sort((p1, p2) => p1.name.compareTo(p2.name));
    log('GCs $list');
    setState(() {
      _gcs = list;
      _gcUpdated = false;
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
      final gc = i == null ? null : _gcs.firstWhere((p) => p.id == i);
      setState(() {
        _gcUpdated = false;
        _gcSelected = i;
        if (_gcSelected != null) {
          _gcCreating = false;
        }
        if (gc == null) {
          _gcNameController.clear();
        } else {
          _gcNameController.text = gc.name;
        }
      });
      _getGCVs();
    }
  }

  void _getGCVs() {
    final gc = _gcSelected == null ? null : _gcs.firstWhere((p) => p.id == _gcSelected);
    List<GrammaticalCategoryValue> list = gc == null ? [] : _gcService.getAllGCVs(gc.id)
      ..sort((p1, p2) => p1.name.compareTo(p2.name));
    log('GCVs $list');
    setState(() {
      _gcvs = list;
      _gcvUpdated = false;
    });
    _selectGCV(_gcvSelected);
  }

  void _selectGCV(int? i) {
    if (i != null) {
      if (!_gcvs.any((p) => p.id == i)) {
        i = null;
      }
    }
    if (_gcvSelected != i) {
      final gcv = i == null ? null : _gcvs.firstWhere((p) => p.id == i);
      setState(() {
        _gcvUpdated = false;
        _gcvSelected = i;
        if (_gcvSelected != null) {
          _gcvCreating = false;
        }
        if (gcv == null) {
          _gcvNameController.clear();
        } else {
          _gcvNameController.text = gcv.name;
        }
      });
    }
  }

  void _startCreatingGC() {
    setState(() {
      _gcCreating = true;
      _gcUpdated = false;
    });
    _selectGC(null);
  }

  void _startCreatingGCV() {
    setState(() {
      _gcvCreating = true;
      _gcvUpdated = false;
    });
    _selectGCV(null);
  }

  @override
  Widget build(BuildContext context) {
    final cWidth = TextMeasureProvider.of(context)!.characterWidth;

    List<TableRow> rows = List.empty(growable: true);

    final gcLen = 2 + _gcs.fold(5, ((n, gc) => math.max(n, gc.name.length)));
    final gcvLen = 2 + _gcvs.fold(5, ((n, gcv) => math.max(n, gcv.name.length)));
    final rowLength = math.max(math.max(_gcs.length, _gcvs.length) + 2, 2);

    for (int i = 0; i < rowLength; i++) {
      rows.add(TableRow(children: [
        DBorder(data: '|'),
        createGCCell(i),
        DBorder(data: '|'),
        createNameCell(i),
        createNameBorderCell(i),
        createGCNameEditCell(i),
        DBorder(data: '|'),
        createGCVCell(i),
        DBorder(data: '|'),
        createNameCell(i),
        createNameBorderCell(i),
        createGCVNameEditCell(i),
        DBorder(data: '|'),
      ]));
    }
    // int i = 0;
    // rows.add(TableRow(children: [
    //   DBorder(data: '|'),
    //   createGCCell(i),
    //   DBorder(data: '|'),
    //   Container(alignment: Alignment.centerRight, child: DBorder(data: 'Name')),
    //   DBorder(data: '|'),
    //   if (_gcSelected != null || _gcCreating)
    //     TTextField(
    //         onChanged: (_) => setState(() {
    //               _gcUpdated = true;
    //             }),
    //         controller: _gcNameController)
    //   else
    //     Container(),
    //   DBorder(data: '|'),
    //   createGCCell(i),
    //   DBorder(data: '|'),
    // ]));
    return Column(children: [
      Table(
        columnWidths: {
          0: FixedColumnWidth(cWidth),
          1: FixedColumnWidth(cWidth * gcLen),
          2: FixedColumnWidth(cWidth),
          3: FixedColumnWidth(6 * cWidth),
          4: FixedColumnWidth(cWidth),
          5: FlexColumnWidth(2),
          6: FixedColumnWidth(cWidth),
          7: FixedColumnWidth(cWidth * gcvLen),
          8: FixedColumnWidth(cWidth),
          9: FixedColumnWidth(6 * cWidth),
          10: FixedColumnWidth(cWidth),
          11: FlexColumnWidth(2),
          12: FixedColumnWidth(cWidth),
        },
        children: rows,
      ),
      Table(
        columnWidths: {
          0: FixedColumnWidth(cWidth),
          1: FixedColumnWidth(cWidth * gcLen),
          2: FixedColumnWidth(cWidth),
          3: FlexColumnWidth(2),
          4: FixedColumnWidth(cWidth),
          5: FixedColumnWidth(cWidth * gcvLen),
          6: FixedColumnWidth(cWidth),
          7: FlexColumnWidth(2),
          8: FixedColumnWidth(cWidth),
        },
        children: [
          TableRow(children: [
            DBorder(data: '+'),
            HDash(),
            DBorder(data: '+'),
            HDash(),
            DBorder(data: '+'),
            HDash(),
            DBorder(data: '+'),
            HDash(),
            DBorder(data: '+')
          ])
        ],
      )
    ]);
  }

  Widget createGCNameEditCell(int i) {
    switch (i) {
      case 0:
        if (_gcSelected != null || _gcCreating)
          return TTextField(
              onChanged: (_) => setState(() {
                    _gcUpdated = true;
                  }),
              controller: _gcNameController);
        else
          return Container();
      case 1:
        return HDash();
      default:
        return Container();
    }
  }

  Widget createGCVNameEditCell(int i) {
    switch (i) {
      case 0:
        if (_gcvSelected != null || _gcvCreating)
          return TTextField(
              onChanged: (_) => setState(() {
                _gcvUpdated = true;
              }),
              controller: _gcvNameController);
        else
          return Container();
      case 1:
        return HDash();
      default:
        return Container();
    }
  }

  Widget createNameCell(int i) {
    switch (i) {
      case 0:
        return Container(alignment: Alignment.centerRight, child: DBorder(data: 'Name'));
      case 1:
        return HDash();
      default:
        return Container();
    }
  }

  Widget createNameBorderCell(int i) {
    switch (i) {
      case 0:
        return DBorder(data: '|');
      case 1:
        return DBorder(data: '+');
      default:
        return Container();
    }
  }

  Widget createGCCell(int i) => ((i == _gcs.length + 1 && i != 1) || (i == 0 && _gcs.length == 0))
      ? TButton(text: '[ + ]', color: LPColor.greenColor, hover: LPColor.greenBrightColor, onPressed: _startCreatingGC)
      : i == _gcs.length
          ? HDash()
          : (_gcs.length > i)
              ? createValueBtn(i, _selectGC, _gcs, _gcSelected)
              : Container();

  Widget createGCVCell(int i) => ((i == _gcvs.length + 1 && i != 1) || (i == 0 && _gcvs.length == 0))
      ? TButton(text: '[ + ]', color: LPColor.greenColor, hover: LPColor.greenBrightColor, onPressed: _startCreatingGCV)
      : (i == _gcvs.length)
          ? HDash()
          : (_gcvs.length > i)
              ? createValueBtn(i, _selectGCV, _gcvs, _gcvSelected)
              : Container();

  Widget createValueBtn(int i, void Function(int?) select, List<dynamic> list, int? selected) => TButton(
      text: list[i].name,
      color: list[i].id == selected ? LPColor.primaryColor : LPColor.greyColor,
      hover: LPColor.greyBrightColor,
      onPressed: () => select(list[i].id));
}
