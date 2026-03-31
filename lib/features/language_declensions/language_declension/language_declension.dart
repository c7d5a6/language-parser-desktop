import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/border/border.dart';
import 'package:language_parser_desktop/components/border/hdash.dart';
import 'package:language_parser_desktop/components/border/vtabledashes.dart';
import 'package:language_parser_desktop/persistence/entities/declension_rule_entity.dart';
import 'package:language_parser_desktop/persistence/repositories/invalidators/invalidator.dart';
import 'package:language_parser_desktop/services/declension_service.dart';

import '../../../service_provider.dart';
import '../../../services/service_manager.dart';
import '../../../text_measure_provider.dart';
import '../../language_phonetics/language_phonetics_header.dart';
import 'add_rule_mode.dart';
import 'rule_details_column.dart';
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
  final TextEditingController _newRuleNameController = TextEditingController();
  final TextEditingController _ruleBodyController = TextEditingController();
  bool _createRuleMode = false;
  bool _ruleConnectionsEditMode = false;

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
      _newRuleNameController.clear();
      _reloadRules();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _serviceManager?.repositoryManager.removeDeclensionInvalidator(this);
    _serviceManager?.repositoryManager.removeDeclensionRuleInvalidator(this);
    _serviceManager?.repositoryManager.removeDeclensionRuleSoundChangeInvalidator(this);
    _newRuleNameController.dispose();
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
        if (!_createRuleMode)
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
                  VTableDashes(rowLength: _rules.length + RulesList.ADDITIONAL_ROWS + 1, endOnCross: true),
                  _buildLeftSection(cWidth),
                  VTableDashes(rowLength: _maxRowsCount() + 1, endOnCross: true),
                  _buildRightSection(cWidth),
                  VTableDashes(rowLength: RuleDetailsColumn.ROW_COUNT + 1, endOnCross: true),
                ],
              ),
            ],
          ),
        if (_createRuleMode)
          AddRuleMode(
            ruleNameController: _newRuleNameController,
            ruleBodyController: _ruleBodyController,
            onNameChanged: (_) => setState(() {}),
            onSave: _saveRule,
            onCancel: _cancelRuleCreation,
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
        onRuleEnabledToggle: _toggleRuleEnabled,
        onAddNewRuleModeChanged: (isActive) {
          if (isActive) {
            _startRuleCreation();
          }
        },
      ),
    );
  }

  Widget _buildRightSection(double cWidth) {
    return RuleDetailsColumn(
      languageId: widget.languageId,
      posId: widget.posId,
      isConnectionsEditMode: _ruleConnectionsEditMode,
      onConnectionsEditRequested: () {
        setState(() {
          _ruleConnectionsEditMode = true;
        });
      },
      selectedDeclensionGcIds: widget.declension.values.map((v) => v.gc.id).toSet(),
      selectedRule: _selectedRule(),
      onSave: _saveSelectedRuleChanges,
      onCancel: _cancelSelectedRuleChanges,
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
        _ruleConnectionsEditMode = false;
      });
    }
  }

  void _startRuleCreation() {
    setState(() {
      _createRuleMode = true;
      _selectedRuleId = null;
      _ruleConnectionsEditMode = false;
      _newRuleNameController.clear();
      _ruleBodyController.clear();
    });
  }

  void _cancelRuleCreation() {
    setState(() {
      _createRuleMode = false;
      _ruleConnectionsEditMode = false;
      _newRuleNameController.clear();
      _ruleBodyController.clear();
    });
  }

  void _saveRule() {
    final declensionId = widget.declension.declensionId;
    final name = _newRuleNameController.text.trim();
    if (declensionId == null || name.isEmpty) {
      return;
    }

    _declensionService.saveRule(declensionId, name, '');
    setState(() {
      _createRuleMode = false;
      _newRuleNameController.clear();
      _ruleBodyController.clear();
    });
  }

  DeclensionRule? _selectedRule() {
    if (_selectedRuleId == null) {
      return null;
    }
    try {
      return _rules.firstWhere((r) => r.id == _selectedRuleId);
    } catch (_) {
      return null;
    }
  }

  void _saveSelectedRuleChanges(String newName, String newPattern) {
    final selectedRule = _selectedRule();
    if (selectedRule == null) {
      return;
    }
    if (newName.isEmpty) {
      return;
    }
    _declensionService.updateRule(selectedRule.id, newName, newPattern, selectedRule.enabled);
    _ruleConnectionsEditMode = false;
    _reloadRules();
    setState(() {});
  }

  void _cancelSelectedRuleChanges() {
    _ruleConnectionsEditMode = false;
    _reloadRules();
    setState(() {});
  }

  void _toggleRuleEnabled(DeclensionRule rule) {
    _declensionService.updateRule(rule.id, rule.name, rule.wordPattern ?? '', !rule.enabled);
    _reloadRules();
    setState(() {});
  }

  int _maxRowsCount() {
    return math.max(_rules.length + RulesList.ADDITIONAL_ROWS, RuleDetailsColumn.ROW_COUNT);
  }
}
