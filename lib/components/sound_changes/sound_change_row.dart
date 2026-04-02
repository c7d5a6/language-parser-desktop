import 'package:flutter/material.dart';
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
    if (_isRowEditMode) {
      return Table(
        columnWidths: {
          0: const FlexColumnWidth(1),
          1: FixedColumnWidth(cWidth),
          2: FixedColumnWidth(cWidth * 1.5),
          3: FixedColumnWidth(cWidth),
          4: FixedColumnWidth(cWidth * 1.5),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(
              color: widget.isAlternateRow ? LPColor.stripedRowBackgroundColor : Colors.transparent,
            ),
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
      );
    }

    final parsed = widget.soundChange;
    return Table(
      columnWidths: widget.columnWidths,
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: widget.isAlternateRow ? LPColor.stripedRowBackgroundColor : Colors.transparent,
          ),
          children: [
            Center(child: Text(parsed.from, style: LPFont.defaultTextStyle)),
            const Center(child: DBorder(data: '>')),
            Center(child: Text(parsed.to, style: LPFont.defaultTextStyle)),
            const Center(child: DBorder(data: '/')),
            Align(
              alignment: Alignment.centerRight,
              child: Text(parsed.left, style: LPFont.defaultTextStyle),
            ),
            const Center(child: DBorder(data: '_')),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(parsed.right, style: LPFont.defaultTextStyle),
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
                      onPressed: widget.onDelete == null ? null : () => widget.onDelete!(widget.soundChange.id),
                    ),
                  )
                : const Center(child: DBorder(data: ' ')),
          ],
        ),
      ],
    );
  }
}
