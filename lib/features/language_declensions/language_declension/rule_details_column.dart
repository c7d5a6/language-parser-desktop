import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/border/border.dart';
import 'package:language_parser_desktop/components/border/hdash.dart';
import 'package:language_parser_desktop/components/buttons/t_button.dart';
import 'package:language_parser_desktop/components/input/text_field.dart';
import 'package:language_parser_desktop/persistence/entities/declension_rule_entity.dart';
import 'package:language_parser_desktop/util/constants.dart';

import '../../../text_measure_provider.dart';
import '../../language_phonetics/language_phonetics_header.dart';

class RuleDetailsColumn extends StatelessWidget {
  final DeclensionRule? selectedRule;
  final String ruleName;
  final TextEditingController nameController;
  final TextEditingController wordPatternController;
  final VoidCallback onChanged;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const RuleDetailsColumn({
    super.key,
    required this.ruleName,
    required this.selectedRule,
    required this.nameController,
    required this.wordPatternController,
    required this.onChanged,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final cWidth = TextMeasureProvider.of(context)!.characterWidth;
    if (selectedRule == null) {
      return Container();
    }
    final name = nameController.text.trim();
    final pattern = wordPatternController.text;
    final hasChanges = name != selectedRule!.name || pattern != (selectedRule!.wordPattern ?? '');

    return Column(
      children: [
        Center(child: LPhHeader(header: ruleName.trim().toUpperCase())),
        HDash(),
        Table(
          columnWidths: {0: FixedColumnWidth(14 * cWidth), 1: FixedColumnWidth(cWidth), 2: const FlexColumnWidth(1)},
          children: [
            TableRow(
              children: [
                const Center(child: LPhHeader(header: 'RULE NAME')),
                const DBorder(data: '|'),
                TTextField(controller: nameController, onChanged: (_) => onChanged()),
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
                TTextField(enabled: false, controller: wordPatternController, onChanged: (_) => onChanged()),
              ],
            ),
            const TableRow(
              children: [
                HDash(),
                DBorder(data: '+'),
                HDash(),
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
                          disabled: !hasChanges || name.isEmpty,
                          onPressed: onSave,
                        ),
                        const DBorder(data: ' ]-[ '),
                        TButton(
                          text: 'CANCEL',
                          color: LPColor.redColor,
                          hover: LPColor.redBrightColor,
                          disabled: !hasChanges,
                          onPressed: onCancel,
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
}
