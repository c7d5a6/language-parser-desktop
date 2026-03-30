import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/border/hdash.dart';
import 'package:language_parser_desktop/components/buttons/t_button.dart';
import 'package:language_parser_desktop/persistence/entities/declension_rule_entity.dart';
import 'package:language_parser_desktop/util/constants.dart';

import '../../language_phonetics/language_phonetics_header.dart';

class RulesList extends StatelessWidget {
  static final int ADDITIONAL_ROWS = 6;

  final List<DeclensionRule> rules;
  final int? selectedRuleId;
  final bool isMainDeclension;
  final maxRowsCount;
  final VoidCallback onSetMainDeclension;
  final ValueChanged<int?> onRuleSelected;
  final ValueChanged<bool> onAddNewRuleModeChanged;

  const RulesList({
    super.key,
    required this.rules,
    required this.selectedRuleId,
    required this.isMainDeclension,
    required this.maxRowsCount,
    required this.onSetMainDeclension,
    required this.onRuleSelected,
    required this.onAddNewRuleModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {0: FlexColumnWidth(1)},
      children: [
        for (int i = 0; i < rules.length + 6; i++) TableRow(children: [_cell(i)]),
        const TableRow(children: [HDash()]),
      ],
    );
  }

  Widget _cell(int rowIndex) {
    const rulesStartIndex = 4;
    final rulesEndIndex = rulesStartIndex + rules.length;
    if (rowIndex == 0) {
      return Center(
        child: TButton(
          text: '[ MAIN DECLENSION ]',
          color: isMainDeclension ? LPColor.greenColor : LPColor.greyColor,
          hover: isMainDeclension ? LPColor.greenBrightColor : LPColor.greyBrightColor,
          onPressed: onSetMainDeclension,
        ),
      );
    }
    if (rowIndex == 1) {
      return const HDash();
    }
    if (rowIndex == 2) {
      return const Center(child: LPhHeader(header: 'RULES'));
    }
    if (rowIndex == 3) {
      return const HDash();
    }
    if (rowIndex >= rulesStartIndex && rowIndex < rulesEndIndex) {
      final rule = rules[rowIndex - rulesStartIndex];
      final selected = rule.id == selectedRuleId;
      return Center(
        child: TButton(
          text: selected ? '< ${rule.name} >' : rule.name,
          color: selected ? LPColor.primaryColor : LPColor.greyColor,
          hover: selected ? LPColor.primaryBrightColor : LPColor.greyBrightColor,
          onPressed: () => onRuleSelected(rule.id),
        ),
      );
    }
    if (rowIndex == rulesEndIndex) {
      return const HDash();
    }
    if (rowIndex == rulesEndIndex + 1) {
      return Center(
        child: TButton(
          text: '[ + ]',
          color: LPColor.greenColor,
          hover: LPColor.greenBrightColor,
          onPressed: () => onAddNewRuleModeChanged(true),
        ),
      );
    }
    return Container();
  }
}
