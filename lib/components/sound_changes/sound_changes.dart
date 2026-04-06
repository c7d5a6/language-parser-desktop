import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/border/border.dart';
import 'package:language_parser_desktop/components/border/hdash.dart';
import 'package:language_parser_desktop/components/buttons/t_button.dart';
import 'package:language_parser_desktop/components/input/text_field.dart';
import 'package:language_parser_desktop/components/sound_changes/sound_change_item.dart';
import 'package:language_parser_desktop/components/sound_changes/sound_change_row.dart';
import 'package:language_parser_desktop/text_measure_provider.dart';
import 'package:language_parser_desktop/util/constants.dart';

class SoundChangesTable extends StatelessWidget {
  final List<SoundChangeSqlRow> soundChanges;
  final bool isTableEditMode;
  final TextEditingController editorController;
  final VoidCallback onEditRequested;
  final VoidCallback onCancelEdit;
  final VoidCallback onSaveAll;
  final ValueChanged<String> onEditorChanged;
  final ValueChanged<SoundChangeItem> onSaveRow;
  final ValueChanged<int> onDelete;

  const SoundChangesTable({
    super.key,
    required this.soundChanges,
    required this.isTableEditMode,
    required this.editorController,
    required this.onEditRequested,
    required this.onCancelEdit,
    required this.onSaveAll,
    required this.onEditorChanged,
    required this.onSaveRow,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final cWidth = TextMeasureProvider.of(context)!.characterWidth;
    final parsed = soundChanges.map(_toItem).toList(growable: false);
    final minRows = 3;
    final emptyRowsCount = parsed.length >= minRows ? 0 : (minRows - parsed.length);
    final editorLines = soundChanges.length < 3 ? 3 : soundChanges.length;

    final fromMax = _maxLen(parsed.map((e) => e.from));
    final toMax = _maxLen(parsed.map((e) => e.to));
    final leftMax = _maxLen(parsed.map((e) => e.left));

    final columnWidths = <int, TableColumnWidth>{
      0: FixedColumnWidth(fromMax * cWidth),
      1: FixedColumnWidth(1 * cWidth),
      2: FixedColumnWidth(toMax * cWidth),
      3: FixedColumnWidth(1 * cWidth),
      4: FixedColumnWidth(leftMax * cWidth),
      5: FixedColumnWidth(1 * cWidth),
      6: const FlexColumnWidth(1),
      7: FixedColumnWidth(cWidth),
      8: FixedColumnWidth(1.5 * cWidth),
      9: FixedColumnWidth(cWidth),
      10: FixedColumnWidth(1.5 * cWidth),
    };
    return Column(
      children: [
        if (!isTableEditMode)
          ...parsed.asMap().entries.map(
            (entry) => SoundChangeRow(
              soundChange: entry.value,
              isAlternateRow: entry.key.isOdd,
              isTableEditMode: true,
              columnWidths: columnWidths,
              onSave: onSaveRow,
              onDelete: onDelete,
            ),
          ),
        if (!isTableEditMode)
          ...List.generate(
            emptyRowsCount,
            (i) => SoundChangeEmptyRow(
              isAlternateRow: (parsed.length + i).isOdd,
              columnWidths: columnWidths,
            ),
          ),
        if (isTableEditMode)
          Table(
            columnWidths: {0: const FlexColumnWidth(1)},
            children: [
              TableRow(
                children: [
                  TTextField(
                    controller: editorController,
                    minLines: editorLines,
                    maxLines: editorLines,
                    onChanged: onEditorChanged,
                  ),
                ],
              ),
            ],
          ),
        if (isTableEditMode)
          Table(
            columnWidths: {
              0: const FlexColumnWidth(1),
              1: FixedColumnWidth(3 * cWidth),
              2: FixedColumnWidth(5 * cWidth),
              3: FixedColumnWidth(5 * cWidth),
              4: FixedColumnWidth(7 * cWidth),
              5: FixedColumnWidth(4 * cWidth),
            },
            children: [
              TableRow(
                children: [
                  const HDash(),
                  const DBorder(data: '-[ '),
                  TButton(
                    text: 'SAVE',
                    color: LPColor.greenColor,
                    hover: LPColor.greenBrightColor,
                    onPressed: onSaveAll,
                  ),
                  const DBorder(data: ' ]-[ '),
                  TButton(
                    text: 'CANCEL',
                    color: LPColor.redColor,
                    hover: LPColor.redBrightColor,
                    onPressed: onCancelEdit,
                  ),
                  const DBorder(data: ' ]-'),
                ],
              ),
            ],
          ),
        if (!isTableEditMode)
          Table(
            columnWidths: {
              0: const FlexColumnWidth(1),
              1: FixedColumnWidth(3 * cWidth),
              2: FixedColumnWidth(5 * cWidth),
              3: FixedColumnWidth(4 * cWidth),
            },
            children: [
              TableRow(
                children: [
                  const HDash(),
                  const DBorder(data: '-[ '),
                  TButton(
                    text: 'EDIT',
                    color: LPColor.yellowColor,
                    hover: LPColor.yellowBrightColor,
                    onPressed: onEditRequested,
                  ),
                  const DBorder(data: ' ]-'),
                ],
              ),
            ],
          ),
      ],
    );
  }

  SoundChangeItem _toItem(SoundChangeSqlRow row) {
    final parsed = _parseChange(row.soundChange);
    return SoundChangeItem(
      id: row.id,
      initialSoundChange: row.soundChange,
      soundChange: row.soundChange,
      isCorrect: row.isCorrect,
      from: parsed.from,
      to: parsed.to,
      left: parsed.left,
      right: parsed.right,
    );
  }

  int _maxLen(Iterable<String> values) {
    var max = 0;
    for (final v in values) {
      if (v.length > max) {
        max = v.length;
      }
    }
    return max + 1;
  }

  _ParsedSoundChange _parseChange(String value) {
    final gtIdx = value.indexOf('>');
    if (gtIdx < 0) {
      return _ParsedSoundChange(value.trim(), '', '', '');
    }

    final from = value.substring(0, gtIdx).trim();
    final afterGt = value.substring(gtIdx + 1).trim();

    final slashIdx = afterGt.indexOf('/');
    if (slashIdx < 0) {
      return _ParsedSoundChange(from, afterGt, '', '');
    }

    final to = afterGt.substring(0, slashIdx).trim();
    final afterSlash = afterGt.substring(slashIdx + 1).trim();

    final underscoreIdx = afterSlash.indexOf('_');
    if (underscoreIdx < 0) {
      return _ParsedSoundChange(from, to, afterSlash, '');
    }

    final left = afterSlash.substring(0, underscoreIdx).trim();
    final right = afterSlash.substring(underscoreIdx + 1).trim();
    return _ParsedSoundChange(from, to, left, right);
  }
}

class SoundChangeEmptyRow extends StatefulWidget {
  final bool isAlternateRow;
  final Map<int, TableColumnWidth> columnWidths;

  const SoundChangeEmptyRow({
    super.key,
    required this.isAlternateRow,
    required this.columnWidths,
  });

  @override
  State<SoundChangeEmptyRow> createState() => _SoundChangeEmptyRowState();
}

class _SoundChangeEmptyRowState extends State<SoundChangeEmptyRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final rowBackgroundColor = _isHovered
        ? LPColor.selectedBackgroundColor
        : (widget.isAlternateRow ? LPColor.stripedRowBackgroundColor : Colors.transparent);
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Table(
        columnWidths: widget.columnWidths,
        children: [
          TableRow(
            decoration: BoxDecoration(color: rowBackgroundColor),
            children: const [
              SizedBox(),
              SizedBox(),
              SizedBox(),
              SizedBox(),
              SizedBox(),
              SizedBox(),
              SizedBox(),
              Center(child: DBorder(data: '|')),
              Center(child: DBorder(data: ' ')),
              Center(child: DBorder(data: '|')),
              Center(child: DBorder(data: ' ')),
            ],
          ),
        ],
      ),
    );
  }
}

class SoundChangeSqlRow {
  final int id;
  final String soundChange;
  final bool isCorrect;

  const SoundChangeSqlRow({required this.id, required this.soundChange, this.isCorrect = true});
}

class _ParsedSoundChange {
  final String from;
  final String to;
  final String left;
  final String right;

  const _ParsedSoundChange(this.from, this.to, this.left, this.right);
}
