import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:language_parser_desktop/components/border/border.dart';
import 'package:language_parser_desktop/components/buttons/t_button.dart';
import 'package:language_parser_desktop/components/input/text_field.dart';
import 'package:language_parser_desktop/components/sound_changes/sound_change_item.dart';
import 'package:language_parser_desktop/util/constants.dart';

import '../../text_measure_provider.dart';

class SoundChangeRow extends StatefulWidget {
  final SoundChangeItem soundChange;
  final bool isAlternateRow;
  final bool isTableEditMode;
  final Map<int, TableColumnWidth> columnWidths;
  final ValueChanged<SoundChangeItem>? onSave;
  final ValueChanged<int>? onDelete;

  const SoundChangeRow({
    super.key,
    required this.soundChange,
    required this.isAlternateRow,
    required this.isTableEditMode,
    required this.columnWidths,
    this.onSave,
    this.onDelete,
  });

  @override
  State<SoundChangeRow> createState() => _SoundChangeRowState();
}

class _SoundChangeRowState extends State<SoundChangeRow> {
  bool _isRowEditMode = false;
  bool _isHovered = false;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.soundChange.soundChange);
  }

  @override
  void didUpdateWidget(covariant SoundChangeRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.soundChange.id != widget.soundChange.id ||
        oldWidget.soundChange.soundChange != widget.soundChange.soundChange) {
      _controller.text = widget.soundChange.soundChange;
      _isRowEditMode = false;
    }
    if (widget.isTableEditMode) {
      _isRowEditMode = false;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cWidth = TextMeasureProvider.of(context)!.characterWidth;
    final rowBackgroundColor = _isHovered
        ? LPColor.selectedBackgroundColor
        : (widget.isAlternateRow ? LPColor.stripedRowBackgroundColor : Colors.transparent);
    if (_isRowEditMode) {
      return MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: Table(
          columnWidths: {
            0: const FlexColumnWidth(1),
            1: FixedColumnWidth(cWidth),
            2: FixedColumnWidth(cWidth * 1.5),
            3: FixedColumnWidth(cWidth),
            4: FixedColumnWidth(cWidth * 1.5),
          },
          children: [
            TableRow(
              decoration: BoxDecoration(color: rowBackgroundColor),
              children: [
                TTextField(controller: _controller, onChanged: (_) => setState(() {})),
                const Center(child: DBorder(data: '|')),
                Center(
                  child: TButton(
                    text: 's',
                    color: LPColor.greenColor,
                    hover: LPColor.greenBrightColor,
                    onPressed: () {
                      final newValue = _controller.text.trim();
                      if (newValue.isEmpty) {
                        return;
                      }
                      widget.soundChange.soundChange = newValue;
                      widget.onSave?.call(widget.soundChange);
                      setState(() {
                        _isRowEditMode = false;
                      });
                    },
                  ),
                ),
                const Center(child: DBorder(data: '|')),
                Center(
                  child: TButton(
                    text: 'x',
                    color: LPColor.redColor,
                    hover: LPColor.redBrightColor,
                    onPressed: () {
                      setState(() {
                        _controller.text = widget.soundChange.soundChange;
                        _isRowEditMode = false;
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    final parsed = widget.soundChange;
    final hasContext = parsed.left.isNotEmpty || parsed.right.isNotEmpty;
    final textStyle = parsed.isCorrect
        ? LPFont.defaultTextStyle
        : LPFont.defaultTextStyle.merge(TextStyle(color: LPColor.redBrightColor));
    final symbolStyle = LPFont.defaultTextStyle.merge(TextStyle(color: LPColor.greyColor));
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Table(
        columnWidths: widget.columnWidths,
        children: [
          TableRow(
            decoration: BoxDecoration(color: rowBackgroundColor),
            children: [
              Center(child: Text(parsed.from, style: textStyle)),
              Center(child: SelectableText('>', style: symbolStyle)),
              Center(child: Text(parsed.to, style: textStyle)),
              Center(child: SelectableText(hasContext ? '/' : '', style: symbolStyle)),
              Align(
                alignment: Alignment.centerRight,
                child: Text(parsed.left, style: textStyle),
              ),
              Center(child: SelectableText(hasContext ? '_' : '', style: symbolStyle)),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(parsed.right, style: textStyle),
              ),
              const Center(child: DBorder(data: '|')),
              widget.isTableEditMode
                  ? Center(
                      child: TButton(
                        text: 'e',
                        color: LPColor.yellowColor,
                        hover: LPColor.yellowBrightColor,
                        onPressed: () {
                          setState(() {
                            _isRowEditMode = true;
                          });
                        },
                      ),
                    )
                  : const Center(child: DBorder(data: ' ')),
              const Center(child: DBorder(data: '|')),
              widget.isTableEditMode
                  ? Center(
                      child: TButton(
                        text: 'x',
                        color: LPColor.redColor,
                        hover: LPColor.redBrightColor,
                        onPressed: widget.onDelete == null
                            ? null
                            : () {
                                log('SoundChangeRow.deletePressed: id=${widget.soundChange.id}');
                                widget.onDelete!(widget.soundChange.id);
                              },
                      ),
                    )
                  : const Center(child: DBorder(data: ' ')),
            ],
          ),
        ],
      ),
    );
  }
}
