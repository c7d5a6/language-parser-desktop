import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/border/border.dart';
import 'package:language_parser_desktop/components/border/hdash.dart';
import 'package:language_parser_desktop/components/buttons/t_button.dart';
import 'package:language_parser_desktop/components/input/text_field.dart';
import 'package:language_parser_desktop/persistence/entities/declension_rule_entity.dart';
import 'package:language_parser_desktop/util/constants.dart';

import '../../../text_measure_provider.dart';
import '../../language_phonetics/language_phonetics_header.dart';
import 'rule_gc_values_connections.dart';

class RuleDetailsColumn extends StatefulWidget {
  static final int ROW_COUNT = 11;

  final int languageId;
  final int posId;
  final bool isConnectionsEditMode;
  final VoidCallback onConnectionsEditRequested;
  final Set<int> selectedDeclensionGcIds;
  final DeclensionRule? selectedRule;
  final void Function(String name, String pattern) onSave;
  final VoidCallback onCancel;

  const RuleDetailsColumn({
    super.key,
    required this.languageId,
    required this.posId,
    required this.isConnectionsEditMode,
    required this.onConnectionsEditRequested,
    required this.selectedDeclensionGcIds,
    required this.selectedRule,
    required this.onSave,
    required this.onCancel,
  });

  @override
  State<RuleDetailsColumn> createState() => _RuleDetailsColumnState();
}

class _RuleDetailsColumnState extends State<RuleDetailsColumn> {
  late TextEditingController _nameController;
  late TextEditingController _wordPatternController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _wordPatternController = TextEditingController();
    _syncFromSelectedRule();
  }

  @override
  void didUpdateWidget(covariant RuleDetailsColumn oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedRule?.id != oldWidget.selectedRule?.id) {
      _syncFromSelectedRule();
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _wordPatternController.dispose();
    super.dispose();
  }

  void _syncFromSelectedRule() {
    final rule = widget.selectedRule;
    if (rule == null) {
      _nameController.clear();
      _wordPatternController.clear();
      return;
    }
    _nameController.text = rule.name;
    _wordPatternController.text = rule.wordPattern ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final cWidth = TextMeasureProvider.of(context)!.characterWidth;
    final selectedRule = widget.selectedRule;
    if (selectedRule == null) {
      return Container();
    }
    final ruleName = selectedRule.name;
    final name = _nameController.text.trim();
    final pattern = _wordPatternController.text;
    final hasChanges = name != selectedRule.name || pattern != (selectedRule.wordPattern ?? '');

    return Column(
      children: [
        Table(
          columnWidths: {0: FixedColumnWidth(cWidth), 1: const FlexColumnWidth(1), 2: FixedColumnWidth(cWidth)},
          children: [
            TableRow(
              children: [
                const DBorder(data: ' '),
                Center(child: LPhHeader(header: ruleName.trim().toUpperCase())),
                const DBorder(data: ' '),
              ],
            ),
            const TableRow(
              children: [
                DBorder(data: '*'),
                HDash(),
                DBorder(data: '*'),
              ],
            ),
          ],
        ),
        Table(
          columnWidths: {0: FixedColumnWidth(14 * cWidth), 1: FixedColumnWidth(cWidth), 2: const FlexColumnWidth(1)},
          children: [
            const TableRow(
              children: [
                DBorder(data: ' '),
                SizedBox(),
                SizedBox(),
              ],
            ),
            TableRow(
              children: [
                Container(),
                const DBorder(data: '+'),
                const HDash(),
              ],
            ),
            TableRow(
              children: [
                const Center(child: LPhHeader(header: 'RULE NAME')),
                const DBorder(data: '|'),
                TTextField(
                  controller: _nameController,
                  onChanged: (_) => setState(() {}),
                ),
              ],
            ),
            const TableRow(
              children: [
                HDash(),
                DBorder(data: '|'),
                HDash(),
              ],
            ),
            TableRow(
              children: [
                const Center(child: LPhHeader(header: 'WORD PATTERN')),
                const DBorder(data: '|'),
                TTextField(
                  enabled: false,
                  controller: _wordPatternController,
                  onChanged: (_) => setState(() {}),
                ),
              ],
            ),
            TableRow(
              children: [
                Container(),
                const DBorder(data: '+'),
                const HDash(),
              ],
            ),
          ],
        ),
        DBorder(data: ' '),
        Align(
          alignment: Alignment.centerLeft,
          child: LPhHeader(header: ' FOR GRAMMATICAL CATEGORIES:'),
        ),
        RuleGCValuesConnections(
          languageId: widget.languageId,
          posId: widget.posId,
          selectedDeclensionGcIds: widget.selectedDeclensionGcIds,
          selectedRule: selectedRule,
          isEditMode: widget.isConnectionsEditMode,
          onEditRequested: widget.onConnectionsEditRequested,
        ),
        Table(
          columnWidths: {
            0: const FlexColumnWidth(1),
            1: FixedColumnWidth(cWidth * 2),
            2: FixedColumnWidth(cWidth * 5),
            3: FixedColumnWidth(cWidth * 5),
            4: FixedColumnWidth(cWidth * 7),
            5: FixedColumnWidth(cWidth * 4),
          },
          children: [
            TableRow(
              children: [
                const HDash(),
                const DBorder(data: '[ '),
                TButton(
                  text: 'SAVE',
                  color: LPColor.greenColor,
                  hover: LPColor.greenBrightColor,
                  disabled: !hasChanges || name.isEmpty,
                  onPressed: () => widget.onSave(name, pattern),
                ),
                const DBorder(data: ' ]-[ '),
                TButton(
                  text: 'CANCEL',
                  color: LPColor.redColor,
                  hover: LPColor.redBrightColor,
                  disabled: !hasChanges,
                  onPressed: widget.onCancel,
                ),
                const DBorder(data: ' ]-'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
