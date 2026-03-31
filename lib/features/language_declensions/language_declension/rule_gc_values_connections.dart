import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/buttons/t_button.dart';
import 'package:language_parser_desktop/components/input/dropdown_field.dart';
import 'package:language_parser_desktop/features/language_phonetics/language_phonetics_header.dart';
import 'package:language_parser_desktop/persistence/entities/declension_rule_entity.dart';
import 'package:language_parser_desktop/persistence/entities/grammatical_category_entity.dart';
import 'package:language_parser_desktop/persistence/entities/grammatical_category_value_entity.dart';
import 'package:language_parser_desktop/persistence/repositories/invalidators/invalidator.dart';
import 'package:language_parser_desktop/service_provider.dart';
import 'package:language_parser_desktop/services/declension_service.dart';
import 'package:language_parser_desktop/services/gc_service.dart';
import 'package:language_parser_desktop/services/service_manager.dart';
import 'package:language_parser_desktop/util/constants.dart';

class RuleGCValuesConnections extends StatefulWidget {
  final int languageId;
  final int posId;
  final Set<int> selectedDeclensionGcIds;
  final DeclensionRule? selectedRule;
  final bool isEditMode;
  final VoidCallback onEditRequested;

  const RuleGCValuesConnections({
    super.key,
    required this.languageId,
    required this.posId,
    required this.selectedDeclensionGcIds,
    required this.selectedRule,
    required this.isEditMode,
    required this.onEditRequested,
  });

  @override
  State<RuleGCValuesConnections> createState() => _RuleGCValuesConnectionsState();
}

class _RuleGCValuesConnectionsState extends State<RuleGCValuesConnections> implements Invalidator {
  ServiceManager? _serviceManager;
  late DeclensionService _declensionService;
  late GCService _gcService;
  List<GrammaticalCategory> _categories = [];
  final Map<int, List<GrammaticalCategoryValue>> _valuesByGc = {};
  final Map<int, int?> _selectedValueByGc = {};
  final Map<int, int?> _initialSelectedValueByGc = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final sm = ServiceProvider.of(context)?.serviceManager;
    if (_serviceManager != sm) {
      if (_serviceManager != null) {
        _serviceManager!.repositoryManager.removeDeclensionRuleGCConnectionInvalidator(this);
        _serviceManager!.repositoryManager.removeGCInvalidator(this);
        _serviceManager!.repositoryManager.removeGCVInvalidator(this);
      }
      _serviceManager = sm;
      _declensionService = _serviceManager!.declensionService;
      _gcService = _serviceManager!.gcService;
      _serviceManager!.repositoryManager.addDeclensionRuleGCConnectionInvalidator(this);
      _serviceManager!.repositoryManager.addGCValidator(this);
      _serviceManager!.repositoryManager.addGCVValidator(this);
      _reload();
    }
  }

  @override
  void didUpdateWidget(covariant RuleGCValuesConnections oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedRule?.id != oldWidget.selectedRule?.id ||
        widget.languageId != oldWidget.languageId ||
        widget.posId != oldWidget.posId) {
      _reload();
    }
    if (oldWidget.isEditMode && !widget.isEditMode) {
      _reload();
    }
  }

  @override
  void dispose() {
    _serviceManager?.repositoryManager.removeDeclensionRuleGCConnectionInvalidator(this);
    _serviceManager?.repositoryManager.removeGCInvalidator(this);
    _serviceManager?.repositoryManager.removeGCVInvalidator(this);
    super.dispose();
  }

  @override
  Future<void> invalidate() async {
    _reload();
  }

  void _reload() {
    final rule = widget.selectedRule;
    if (rule == null) {
      setState(() {
        _categories = [];
        _valuesByGc.clear();
        _selectedValueByGc.clear();
      });
      return;
    }
    final enabledGcIds = _gcService.getGCsIdsByLangIdAndPosId(widget.languageId, widget.posId);
    final allCats = _gcService.getAllGCs().where((gc) => enabledGcIds.contains(gc.id)).toList(growable: false)
      ..sort((a, b) => a.name.compareTo(b.name));
    final selectedGcvIds = _declensionService.getRuleGCVIds(rule.id);
    final valuesByGc = <int, List<GrammaticalCategoryValue>>{};
    final selectedByGc = <int, int?>{};
    for (final gc in allCats) {
      final langGcvIds = _gcService.getGCVIdsByLangIdAndGCId(widget.languageId, gc.id);
      final values = _gcService.getAllGCVs(gc.id).where((v) => langGcvIds.contains(v.id)).toList(growable: false)
        ..sort((a, b) => a.name.compareTo(b.name));
      valuesByGc[gc.id] = values;
      final selected = values.where((v) => selectedGcvIds.contains(v.id)).toList(growable: false);
      selectedByGc[gc.id] = selected.isNotEmpty ? selected.first.id : null;
    }
    setState(() {
      _categories = allCats;
      _valuesByGc
        ..clear()
        ..addAll(valuesByGc);
      _selectedValueByGc
        ..clear()
        ..addAll(selectedByGc);
      _initialSelectedValueByGc
        ..clear()
        ..addAll(selectedByGc);
    });
  }

  @override
  Widget build(BuildContext context) {
    final rule = widget.selectedRule;
    if (rule == null) {
      return Container();
    }
    if (!widget.isEditMode) {
      final selectedNames = _categories
          .map((gc) {
            final id = _selectedValueByGc[gc.id];
            if (id == null) return null;
            return _valuesByGc[gc.id]?.firstWhere((v) => v.id == id, orElse: () => GrammaticalCategoryValue(0, '', gc));
          })
          .whereType<GrammaticalCategoryValue>()
          .where((v) => v.id != 0)
          .map((v) => v.name)
          .toList(growable: false);
      var textForCategories = ' ${selectedNames.join(', ')}';
      textForCategories = textForCategories.trim().isEmpty ? ' any' : textForCategories;
      return Row(
        children: [
          Text(textForCategories, style: LPFont.defaultTextStyle),
          TButton(
            text: ' [edit categories] ',
            color: LPColor.greyColor,
            hover: LPColor.greyBrightColor,
            onPressed: widget.onEditRequested,
          ),
        ],
      );
    }

    final editableCategories = _categories
        .where((gc) => !widget.selectedDeclensionGcIds.contains(gc.id))
        .toList(growable: false);
    if (editableCategories.isEmpty) {
      return Text(
        'All enabled categories are already connected.',
        style: LPFont.defaultTextStyle.merge(TextStyle(color: LPColor.greyColor)),
      );
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 8,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: editableCategories
            .map((gc) {
              final values = _valuesByGc[gc.id] ?? const <GrammaticalCategoryValue>[];
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LPhHeader(header: ' ${gc.name}: '),
                  TDropdownField<int?>(
                    value: _selectedValueByGc[gc.id],
                    items: [
                      DropdownMenuItem<int?>(value: null, child: Text('- any value -', style: LPFont.defaultTextStyle)),
                      ...values.map(
                        (v) => DropdownMenuItem<int?>(
                          value: v.id,
                          child: Text(v.name, style: LPFont.defaultTextStyle),
                        ),
                      ),
                    ],
                    onChanged: (newValue) {
                      setState(() {
                        _selectedValueByGc[gc.id] = newValue;
                      });
                    },
                  ),
                ],
              );
            })
            .toList(growable: false),
      ),
    );
  }
}
