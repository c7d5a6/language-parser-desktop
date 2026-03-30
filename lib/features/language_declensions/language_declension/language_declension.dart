import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/border/border.dart';
import 'package:language_parser_desktop/components/border/hdash.dart';
import 'package:language_parser_desktop/components/border/vtabledashes.dart';
import 'package:language_parser_desktop/components/buttons/t_button.dart';
import 'package:language_parser_desktop/components/input/text_field.dart';
import 'package:language_parser_desktop/persistence/entities/declension_rule_entity.dart';
import 'package:language_parser_desktop/persistence/repositories/invalidators/invalidator.dart';
import 'package:language_parser_desktop/services/declension_service.dart';
import 'package:language_parser_desktop/util/constants.dart';

import '../../../service_provider.dart';
import '../../../services/service_manager.dart';
import '../../../text_measure_provider.dart';
import '../../language_phonetics/language_phonetics_header.dart';
import 'rules_list.dart';

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
  int? _selectedRuleId;
  final TextEditingController _ruleNameController = TextEditingController();
  final TextEditingController _ruleBodyController = TextEditingController();
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
      _selectedRuleId = null;
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
    _ruleBodyController.dispose();
    super.dispose();
  }

  @override
  Future<void> invalidate() async {
    _reloadRules();
  }

  @override
  Widget build(BuildContext context) {
    final cWidth = TextMeasureProvider.of(context)!.characterWidth;
    return Column(
      children: [
        // Header
        Table(
          columnWidths: {0: FixedColumnWidth(cWidth), 1: const FlexColumnWidth(1), 2: FixedColumnWidth(cWidth)},
          children: [
            TableRow(
              children: [
                const DBorder(data: '|'),
                Center(child: LPhHeader(header: widget.declension.name.toUpperCase())),
                const DBorder(data: '|'),
              ],
            ),
            TableRow(
              children: [
                const DBorder(data: '+'),
                HDash(),
                const DBorder(data: '+'),
              ],
            ),
          ],
        ),
        Table(
          columnWidths: {
            0: FixedColumnWidth(cWidth),
            1: FixedColumnWidth(22 * cWidth),
            2: FixedColumnWidth(cWidth),
            3: const FlexColumnWidth(1),
            4: FixedColumnWidth(cWidth),
          },
          children: [
            TableRow(
              children: [
                VTableDashes(rowLength: _maxRowsCount()+1, endOnCross: true),
                _buildLeftSection(cWidth),
                VTableDashes(rowLength: _maxRowsCount()+1, endOnCross: true),
                _buildRightSection(cWidth),
                VTableDashes(rowLength: _maxRowsCount()+1, endOnCross: true),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLeftSection(double cWidth) {
    return SizedBox(
      width: 20 * cWidth,
      child: RulesList(
        maxRowsCount: _rules.length + 6,
        rules: _rules,
        selectedRuleId: _selectedRuleId,
        isMainDeclension: widget.declension.main,
        onSetMainDeclension: _setMainDeclension,
        onRuleSelected: _selectRule,
        onAddNewRuleModeChanged: (isActive) {
          if (isActive) {
            _startRuleCreation();
          }
        },
      ),
    );
  }

  Widget _buildRightSection(double cWidth) {
    if (!_createRuleMode) {
      return Container();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Table(
          columnWidths: {0: FixedColumnWidth(10 * cWidth), 1: FixedColumnWidth(cWidth), 2: const FlexColumnWidth(1)},
          children: [
            TableRow(
              children: [
                const Center(child: LPhHeader(header: 'RULE NAME')),
                const DBorder(data: '|'),
                TTextField(controller: _ruleNameController, onChanged: (_) => setState(() {})),
              ],
            ),
            const TableRow(
              children: [
                HDash(),
                DBorder(data: '+'),
                HDash(),
              ],
            ),
          ],
        ),
        Table(
          columnWidths: {0: FixedColumnWidth(10 * cWidth), 1: FixedColumnWidth(cWidth), 2: const FlexColumnWidth(1)},
          children: [
            const TableRow(
              children: [
                Center(child: LPhHeader(header: 'RULE BODY')),
                DBorder(data: '|'),
                SizedBox(),
              ],
            ),
            TableRow(
              children: [
                const HDash(),
                const DBorder(data: '|'),
                SizedBox(
                  height: 6 * cWidth,
                  child: TextFormField(
                    controller: _ruleBodyController,
                    maxLines: null,
                    expands: true,
                    style: LPFont.defaultTextStyle.merge(TextStyle(color: LPColor.greyBrightColor)),
                    decoration: const InputDecoration(border: InputBorder.none, isCollapsed: true),
                  ),
                ),
              ],
            ),
            TableRow(
              children: [
                const HDash(),
                const DBorder(data: '+'),
                Table(
                  columnWidths: {
                    0: FixedColumnWidth(cWidth * 2),
                    1: FixedColumnWidth(cWidth * 5),
                    2: FixedColumnWidth(cWidth * 5),
                    3: FixedColumnWidth(cWidth * 7),
                    4: const FlexColumnWidth(1),
                  },
                  children: [
                    TableRow(
                      children: [
                        const DBorder(data: '[ '),
                        TButton(
                          text: 'SAVE',
                          color: LPColor.greenColor,
                          hover: LPColor.greenBrightColor,
                          disabled: _ruleNameController.text.trim().isEmpty,
                          onPressed: _saveRule,
                        ),
                        const DBorder(data: ' ]-[ '),
                        TButton(
                          text: 'CANCEL',
                          color: LPColor.redColor,
                          hover: LPColor.redBrightColor,
                          onPressed: _cancelRuleCreation,
                        ),
                        const DBorder(data: ' ]-'),
                      ],
                    ),
                  ],
                ),
              ],
            ),
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
    _declensionService.setMainDeclension(widget.languageId, widget.posId, declensionId);
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
    if (_selectedRuleId != null && !_rules.any((r) => r.id == _selectedRuleId)) {
      _selectedRuleId = null;
    }
  }

  void _selectRule(int? ruleId) {
    if (_selectedRuleId != ruleId) {
      setState(() {
        _selectedRuleId = ruleId;
      });
    }
  }

  void _startRuleCreation() {
    setState(() {
      _createRuleMode = true;
      _selectedRuleId = null;
      _ruleNameController.clear();
      _ruleBodyController.clear();
    });
  }

  void _cancelRuleCreation() {
    setState(() {
      _createRuleMode = false;
      _ruleNameController.clear();
      _ruleBodyController.clear();
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
      _ruleBodyController.clear();
    });
  }

  int _maxRowsCount() {
    return _rules.length + RulesList.ADDITIONAL_ROWS;
  }
}
