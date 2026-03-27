import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/border/border.dart';
import 'package:language_parser_desktop/components/border/hdash.dart';
import 'package:language_parser_desktop/components/buttons/t_button.dart';
import 'package:language_parser_desktop/components/input/text_field.dart';
import 'package:language_parser_desktop/persistence/entities/declension_rule_entity.dart';
import 'package:language_parser_desktop/persistence/repositories/invalidators/invalidator.dart';
import 'package:language_parser_desktop/services/declension_service.dart';
import 'package:language_parser_desktop/util/constants.dart';

import '../../service_provider.dart';
import '../../services/service_manager.dart';
import '../../text_measure_provider.dart';
import '../language_phonetics/language_phonetics_header.dart';

class LanguageDeclension extends StatefulWidget {
  final int languageId;
  final int posId;
  final DeclensionRow declension;

  const LanguageDeclension(this.languageId, this.posId, this.declension);

  @override
  State<StatefulWidget> createState() => _LanguageDeclension();
}

class _LanguageDeclension extends State<LanguageDeclension> implements Invalidator {
  ServiceManager? _serviceManager;
  late DeclensionService _declensionService;
  List<DeclensionRule> _rules = [];
  final TextEditingController _ruleNameController = TextEditingController();
  bool _createRuleMode = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final sm = ServiceProvider.of(context)?.serviceManager;
    if (_serviceManager != sm) {
      if (_serviceManager != null) {
        _serviceManager!.repositoryManager.removeDeclensionInvalidator(this);
        _serviceManager!.repositoryManager.removeDeclensionRuleInvalidator(this);
        _serviceManager!.repositoryManager.removeDeclensionRuleSoundChangeInvalidator(this);
      }
      _serviceManager = sm;
      _declensionService = _serviceManager!.declensionService;
      _serviceManager!.repositoryManager.addDeclensionInvalidator(this);
      _serviceManager!.repositoryManager.addDeclensionRuleInvalidator(this);
      _serviceManager!.repositoryManager.addDeclensionRuleSoundChangeInvalidator(this);
      _reloadRules();
    }
  }

  @override
  void didUpdateWidget(LanguageDeclension oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.languageId != oldWidget.languageId ||
        widget.posId != oldWidget.posId ||
        widget.declension.declensionId != oldWidget.declension.declensionId) {
      _createRuleMode = false;
      _ruleNameController.clear();
      _reloadRules();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _serviceManager?.repositoryManager.removeDeclensionInvalidator(this);
    _serviceManager?.repositoryManager.removeDeclensionRuleInvalidator(this);
    _serviceManager?.repositoryManager.removeDeclensionRuleSoundChangeInvalidator(this);
    _ruleNameController.dispose();
    super.dispose();
  }

  @override
  Future<void> invalidate() async {
    _reloadRules();
  }

  @override
  Widget build(BuildContext context) {
    final cWidth = TextMeasureProvider.of(context)!.characterWidth;
    final rowLength = _createRuleMode ? 3 : _leftColumnRowsCount(_rules.length);
    final List<TableRow> rows = [];

    for (int i = 0; i < rowLength; i++) {
      rows.add(
        TableRow(
          children: [
            DBorder(data: '|'),
            _createRuleMode ? _createModeLeftCell(i) : _leftColumnCell(i),
            DBorder(data: '|'),
            _createRuleMode ? _createModeRightCell(i) : _rightColumnCell(i),
            DBorder(data: '|'),
          ],
        ),
      );
    }
    if(!_createRuleMode){
      rows.add(TableRow(children: [DBorder(data: '+'), HDash(), DBorder(data: '+'), HDash(), DBorder(data: '+')]));
    } else {
      rows.add(TableRow(children: [DBorder(data: '+'), HDash(), DBorder(data: '+'), _createModeRightCell(rowLength), DBorder(data: '+')]));
    }

    return Column(
      children: [
        Table(
          columnWidths: {
            0: FixedColumnWidth(cWidth),
            1: FlexColumnWidth(),
            2: FixedColumnWidth(cWidth),
          },
          children: [
            TableRow(
              children: [
                DBorder(data: '|'),
                Center(
                  child: LPhHeader(
                    header: widget.declension.name.toUpperCase(),
                  ),
                ),
                DBorder(data: '|'),
              ],
            ),
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
          columnWidths: {
            0: FixedColumnWidth(cWidth),
            1: FixedColumnWidth(_createRuleMode ? 11 * cWidth : 20 * cWidth),
            2: FixedColumnWidth(cWidth),
            3: FlexColumnWidth(1),
            4: FixedColumnWidth(cWidth),
          },
          children: rows,
        ),
      ],
    );
  }

  int _leftColumnRowsCount(int rulesCount) {
    // static rows: main button, border, rules header, border, border, plus button
    return 6 + rulesCount;
  }

  Widget _leftColumnCell(int rowIndex) {
    const rulesStartIndex = 4;
    final rulesEndIndex = rulesStartIndex + _rules.length;
    if (rowIndex == 0) {
      final isMain = widget.declension.main;
      return Center(
        child: TButton(
          text: '[ MAIN DECLENSION ]',
          color: isMain ? LPColor.greenColor : LPColor.greyColor,
          hover: isMain ? LPColor.greenBrightColor : LPColor.greyBrightColor,
          onPressed: _setMainDeclension,
        ),
      );
    }
    if (rowIndex == 1) {
      return HDash();
    }
    if (rowIndex == 2) {
      return Center(child: LPhHeader(header: 'RULES'));
    }
    if (rowIndex == 3) {
      return HDash();
    }
    if (rowIndex >= rulesStartIndex && rowIndex < rulesEndIndex) {
      return Center(
        child: Text(
          _rules[rowIndex - rulesStartIndex].name,
          style: LPFont.defaultTextStyle,
        ),
      );
    }
    if (rowIndex == rulesEndIndex) {
      return HDash();
    }
    return Center(
      child: TButton(
        text: '[ + ]',
        color: LPColor.greenColor,
        hover: LPColor.greenBrightColor,
        onPressed: _startRuleCreation,
      ),
    );
  }

  Widget _rightColumnCell(int rowIndex) {
    return Container();
  }

  Widget _createModeLeftCell(int rowIndex) {
    if (rowIndex == 0) {
      return Container();
    }
    if (rowIndex == 1) {
      return Center(child: LPhHeader(header: 'RULE NAME'));
    }
    if (rowIndex == 2) {
      return Container();
    }
    return Container();
  }

  Widget _createModeRightCell(int rowIndex) {
    if (rowIndex == 0) {
      return Container();
    }
    if (rowIndex == 1) {
      return TTextField(
        controller: _ruleNameController,
        onChanged: (_) => setState(() {}),
      );
    }
    if (rowIndex == 2) {
      return Container();
    }
    final cWidth = TextMeasureProvider.of(context)!.characterWidth;
    return Table(
      columnWidths: {
        0: FlexColumnWidth(1),
        1: FixedColumnWidth(cWidth * 2),
        2: FixedColumnWidth(cWidth * 5),
        3: FixedColumnWidth(cWidth * 5),
        4: FixedColumnWidth(cWidth * 7),
        5: FixedColumnWidth(cWidth * 4),
      },
      children: [
        TableRow(
          children: [
            HDash(),
            DBorder(data: '[ '),
            TButton(
              text: 'SAVE',
              color: LPColor.greenColor,
              hover: LPColor.greenBrightColor,
              disabled: _ruleNameController.text.trim().isEmpty,
              onPressed: _saveRule,
            ),
            DBorder(data: ' ]-[ '),
            TButton(
              text: 'CANCEL',
              color: LPColor.redColor,
              hover: LPColor.redBrightColor,
              onPressed: _cancelRuleCreation,
            ),
            DBorder(data: ' ]-'),
          ],
        ),
      ],
    );
  }

  void _setMainDeclension() {
    final declensionId = widget.declension.declensionId;
    if (declensionId == null) {
      log('Cannot set main: declension is not saved');
      return;
    }
    _declensionService.setMainDeclension(
      widget.languageId,
      widget.posId,
      declensionId,
    );
  }

  void _reloadRules() {
    final declensionId = widget.declension.declensionId;
    if (declensionId == null) {
      setState(() {
        _rules = [];
      });
      return;
    }
    _rules = _declensionService.getRulesByDeclensionId(declensionId);
  }

  void _startRuleCreation() {
    setState(() {
      _createRuleMode = true;
      _ruleNameController.clear();
    });
  }

  void _cancelRuleCreation() {
    setState(() {
      _createRuleMode = false;
      _ruleNameController.clear();
    });
  }

  void _saveRule() {
    final declensionId = widget.declension.declensionId;
    final name = _ruleNameController.text.trim();
    if (declensionId == null || name.isEmpty) {
      return;
    }

    _declensionService.saveRule(declensionId, name, '');
    setState(() {
      _createRuleMode = false;
      _ruleNameController.clear();
    });
  }
}
