import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/border/border.dart';
import 'package:language_parser_desktop/components/border/hdash.dart';
import 'package:language_parser_desktop/components/buttons/t_button.dart';
import 'package:language_parser_desktop/components/input/text_field.dart';
import 'package:language_parser_desktop/util/constants.dart';

import '../../../text_measure_provider.dart';
import '../../language_phonetics/language_phonetics_header.dart';

class AddRuleMode extends StatelessWidget {
  final TextEditingController ruleNameController;
  final TextEditingController ruleBodyController;
  final ValueChanged<String> onNameChanged;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const AddRuleMode({
    super.key,
    required this.ruleNameController,
    required this.ruleBodyController,
    required this.onNameChanged,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    final cWidth = TextMeasureProvider.of(context)!.characterWidth;
    const rowLength = 8;
    return Column(
      children: [
        Table(
          columnWidths: {
            0: FixedColumnWidth(cWidth),
            1: FixedColumnWidth(13 * cWidth),
            2: FixedColumnWidth(cWidth),
            3: const FlexColumnWidth(1),
            4: FixedColumnWidth(cWidth),
          },
          children: [
            TableRow(
              children: [
                DBorder(data: '|'),
                Container(),
                DBorder(data: '|'),
                Container(),
                DBorder(data: '|'),
              ],
            ),
            TableRow(
              children: [
                DBorder(data: '|'),
                Center(child: LPhHeader(header: 'RULE NAME')),
                DBorder(data: '|'),
                TTextField(controller: ruleNameController, onChanged: onNameChanged),
                DBorder(data: '|'),
              ],
            ),
            TableRow(
              children: [
                DBorder(data: '|'),
                Container(),
                DBorder(data: '|'),
                Container(),
                DBorder(data: '|'),
              ],
            ),
          ],
        ),
        Table(
          children: [
            TableRow(
              children: [
                Table(
                  columnWidths: {
                    0: FixedColumnWidth(cWidth),
                    1: FixedColumnWidth(13 * cWidth),
                    2: FixedColumnWidth(cWidth),
                    3: const FlexColumnWidth(1),
                    4: FixedColumnWidth(cWidth * 2),
                    5: FixedColumnWidth(cWidth * 5),
                    6: FixedColumnWidth(cWidth * 5),
                    7: FixedColumnWidth(cWidth * 7),
                    8: FixedColumnWidth(cWidth * 4),
                    9: FixedColumnWidth(cWidth),
                  },
                  children: [
                    TableRow(
                      children: [
                        DBorder(data: '+'),
                        HDash(),
                        DBorder(data: '+'),
                        HDash(),
                        const DBorder(data: '[ '),
                        TButton(
                          text: 'SAVE',
                          color: LPColor.greenColor,
                          hover: LPColor.greenBrightColor,
                          disabled: ruleNameController.text.trim().isEmpty,
                          onPressed: onSave,
                        ),
                        const DBorder(data: ' ]-[ '),
                        TButton(
                          text: 'CANCEL',
                          color: LPColor.redColor,
                          hover: LPColor.redBrightColor,
                          onPressed: onCancel,
                        ),
                        const DBorder(data: ' ]-'),
                        const DBorder(data: '+'),
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
