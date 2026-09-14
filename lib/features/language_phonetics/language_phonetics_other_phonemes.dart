import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/border/border.dart';
import 'package:language_parser_desktop/components/border/hdash.dart';
import 'package:language_parser_desktop/components/buttons/phonetic_button.dart';
import 'package:language_parser_desktop/components/buttons/t_button.dart';
import 'package:language_parser_desktop/components/input/text_field.dart';
import 'package:language_parser_desktop/features/language_phonetics/language_phonetics_header.dart';
import 'package:language_parser_desktop/util/constants.dart';

import '../../services/language_service.dart';
import '../../text_measure_provider.dart';

class LanguagePhoneticsOtherPhonemes extends StatefulWidget {
  final bool disabled;
  final ListOfLanguagePhonemes phonemes;
  final Function(String) onPress;

  const LanguagePhoneticsOtherPhonemes(
      {super.key, required this.disabled, required this.phonemes, required this.onPress});

  @override
  State<LanguagePhoneticsOtherPhonemes> createState() => _LanguagePhoneticsOtherPhonemesState();
}

class _LanguagePhoneticsOtherPhonemesState extends State<LanguagePhoneticsOtherPhonemes> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<String> _restPhonemes() {
    final result = <String>[
      ...widget.phonemes.restUsedPhonemes,
      ...widget.phonemes.selectedRestPhonemes.map((p) => p.phoneme),
    ];
    return result.where((s) => s.trim().isNotEmpty && !s.contains('̯')).toSet().toList()..sort();
  }

  void _addNewSound() {
    final sound = _controller.text.trim();
    if (sound.isEmpty || widget.disabled) return;
    widget.onPress(sound);
    _controller.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final cWidth = TextMeasureProvider.of(context)!.characterWidth;
      const addLabel = '[ + ]';
      var delta = ((constraints.maxWidth) % (cWidth * 12));
      final rowHeaderLength =
          math.max(0, addLabel.length - 0 - (delta / cWidth).floorToDouble()) * cWidth + delta % cWidth;
      final rest = _restPhonemes();
      final canAdd = !widget.disabled && _controller.text.trim().isNotEmpty;

      return Column(
        children: [
          Row(
            children: [
              Expanded(child: Center(child: LPhHeader(header: '--- OTHER PHONEMES ---'))),
              SizedBox(width: cWidth, child: DBorder(data: '|')),
            ],
          ),
          Table(
            columnWidths: {
              0: FlexColumnWidth(),
              1: FixedColumnWidth(cWidth),
            },
            children: [
              TableRow(children: [HDash(), DBorder(data: '+')]),
            ],
          ),
          Table(
            columnWidths: {
              0: FixedColumnWidth(cWidth),
              1: FlexColumnWidth(),
              2: FixedColumnWidth(cWidth),
            },
            children: [
              TableRow(children: [
                DBorder(data: '|'),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < rest.length; i++) ...[
                        if (i > 0) Text(', ', style: LPFont.headerFontStyle),
                        PhoneticButton(
                          phonetic: rest[i],
                          languagePhonemes: widget.phonemes,
                          disabled: widget.disabled,
                          onPressed: widget.onPress,
                        ),
                      ],
                    ],
                  ),
                ),
                DBorder(data: '|'),
              ]),
              TableRow(children: [DBorder(data: '+'), HDash(), DBorder(data: '+')]),
            ],
          ),
          Table(
            columnWidths: {
              0: FixedColumnWidth(rowHeaderLength),
              1: FixedColumnWidth(cWidth),
              2: FlexColumnWidth(),
              3: FixedColumnWidth(cWidth),
            },
            children: [
              TableRow(children: [
                Center(
                  child: TButton(
                    text: addLabel,
                    color: canAdd ? LPColor.greenColor : LPColor.greyColor,
                    hover: canAdd ? LPColor.greenBrightColor : LPColor.greyBrightColor,
                    disabled: !canAdd,
                    onPressed: canAdd ? _addNewSound : null,
                  ),
                ),
                DBorder(data: '|'),
                TTextField(
                  controller: _controller,
                  enabled: !widget.disabled,
                  hint: 'new sound',
                  onChanged: (_) => setState(() {}),
                ),
                DBorder(data: '|'),
              ]),
              TableRow(children: [HDash(), DBorder(data: '+'), HDash(), DBorder(data: '+')]),
            ],
          ),
        ],
      );
    });
  }
}
