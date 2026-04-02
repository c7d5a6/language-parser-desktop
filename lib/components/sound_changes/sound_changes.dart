import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/border/border.dart';
import 'package:language_parser_desktop/components/border/hdash.dart';
import 'package:language_parser_desktop/components/buttons/t_button.dart';
import 'package:language_parser_desktop/components/sound_changes/sound_change_item.dart';
import 'package:language_parser_desktop/components/sound_changes/sound_change_row.dart';
import 'package:language_parser_desktop/text_measure_provider.dart';
import 'package:language_parser_desktop/util/constants.dart';

class SoundChangesTable extends StatefulWidget {
  final List<SoundChangeSqlRow> soundChanges;
  final ValueChanged<SoundChangeItem>? onSaveRow;
  final ValueChanged<int>? onDelete;

  const SoundChangesTable({super.key, required this.soundChanges, this.onSaveRow, this.onDelete});

  @override
  State<SoundChangesTable> createState() => _SoundChangesTableState();
}

class _SoundChangesTableState extends State<SoundChangesTable> {
  bool _isTableEditMode = false;

  @override
  Widget build(BuildContext context) {
    final cWidth = TextMeasureProvider.of(context)!.characterWidth;
    final parsed = widget.soundChanges.map(_toItem).toList(growable: false);

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
    final controlsColumnWidths = <int, TableColumnWidth>{
      0: const FlexColumnWidth(1),
      1: FixedColumnWidth(3 * cWidth),
      2: FixedColumnWidth(5 * cWidth),
      3: FixedColumnWidth(4 * cWidth),
    };

    return Column(
      children: [
        if (!_isTableEditMode)
          ...parsed.asMap().entries.map(
            (entry) => SoundChangeRow(
              soundChange: entry.value,
              isAlternateRow: entry.key.isOdd,
              isTableEditMode: true,
              columnWidths: columnWidths,
              onSave: widget.onSaveRow,
              onDelete: widget.onDelete,
            ),
          ),
        Table(
          columnWidths: controlsColumnWidths,
          children: [
            TableRow(
              children: [
                const HDash(),
                const DBorder(data: '-[ '),
                TButton(
                  text: _isTableEditMode ? 'cancel' : 'EDIT',
                  color: LPColor.yellowColor,
                  hover: LPColor.yellowBrightColor,
                  onPressed: () {
                    setState(() {
                      _isTableEditMode = !_isTableEditMode;
                    });
                  },
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

class SoundChangeSqlRow {
  final int id;
  final String soundChange;

  const SoundChangeSqlRow({required this.id, required this.soundChange});
}

class _ParsedSoundChange {
  final String from;
  final String to;
  final String left;
  final String right;

  const _ParsedSoundChange(this.from, this.to, this.left, this.right);
}
