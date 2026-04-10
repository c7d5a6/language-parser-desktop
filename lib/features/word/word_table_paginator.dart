import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/border/border.dart';
import 'package:language_parser_desktop/components/buttons/t_button.dart';
import 'package:language_parser_desktop/text_measure_provider.dart';
import 'package:language_parser_desktop/util/constants.dart';

/// Builds ordered page indices with `'...'` markers between gaps (1-based pages).
List<Object> pageNumberSequence(int currentPage, int totalPages) {
  if (totalPages < 1) return const [];
  final pages = <int>{};
  for (var p = 1; p <= math.min(3, totalPages); p++) {
    pages.add(p);
  }
  for (var p = math.max(1, currentPage - 2); p <= math.min(totalPages, currentPage + 2); p++) {
    pages.add(p);
  }
  for (var p = math.max(1, totalPages - 2); p <= totalPages; p++) {
    pages.add(p);
  }
  final sorted = pages.toList()..sort();
  final out = <Object>[];
  for (var i = 0; i < sorted.length; i++) {
    if (i > 0 && sorted[i] > sorted[i - 1] + 1) {
      out.add('...');
    }
    out.add(sorted[i]);
  }
  return out;
}

/// `| Page … | « | < | 1, 2, 3 … | > | » |` row for use below a words table.
class WordTablePaginator extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int wordsOnThisPage;
  final int pageSize;
  final ValueChanged<int> onPageSelected;

  const WordTablePaginator({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.wordsOnThisPage,
    required this.pageSize,
    required this.onPageSelected,
  });

  @override
  Widget build(BuildContext context) {
    final cWidth = TextMeasureProvider.of(context)!.characterWidth;
    final edge = FixedColumnWidth(cWidth);
    final seq = pageNumberSequence(currentPage, totalPages);
    final status = 'Page $currentPage of $totalPages ($wordsOnThisPage words)';
    final statusCol = FixedColumnWidth((status.length + 4) * cWidth);
    final navCol = FixedColumnWidth(4 * cWidth);

    return Table(
      columnWidths: <int, TableColumnWidth>{
        0: edge,
        1: statusCol,
        2: edge,
        3: navCol,
        4: edge,
        5: navCol,
        6: edge,
        7: const FlexColumnWidth(1),
        8: edge,
        9: navCol,
        10: edge,
        11: navCol,
        12: edge,
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          children: [
            const DBorder(data: '|'),
            Center(child: DBorder(data: status)),
            const DBorder(data: '|'),
            TButton(
              text: ' « ',
              color: LPColor.primaryColor,
              hover: LPColor.primaryBrightColor,
              disabled: currentPage <= 1,
              onPressed: currentPage <= 1 ? null : () => onPageSelected(1),
            ),
            const DBorder(data: '|'),
            TButton(
              text: ' < ',
              color: LPColor.primaryColor,
              hover: LPColor.primaryBrightColor,
              disabled: currentPage <= 1,
              onPressed: currentPage <= 1 ? null : () => onPageSelected(currentPage - 1),
            ),
            const DBorder(data: '|'),
            LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minWidth: constraints.maxWidth),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: _buildNumberRow(seq),
                    ),
                  ),
                );
              },
            ),
            const DBorder(data: '|'),
            TButton(
              text: ' > ',
              color: LPColor.primaryColor,
              hover: LPColor.primaryBrightColor,
              disabled: currentPage >= totalPages,
              onPressed: currentPage >= totalPages ? null : () => onPageSelected(currentPage + 1),
            ),
            const DBorder(data: '|'),
            TButton(
              text: ' » ',
              color: LPColor.primaryColor,
              hover: LPColor.primaryBrightColor,
              disabled: currentPage >= totalPages,
              onPressed: currentPage >= totalPages ? null : () => onPageSelected(totalPages),
            ),
            const DBorder(data: '|'),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildNumberRow(List<Object> seq) {
    final out = <Widget>[];
    for (var i = 0; i < seq.length; i++) {
      if (i > 0) {
        out.add(Text(', ', style: LPFont.defaultTextStyle.merge(TextStyle(color: LPColor.greyColor))));
      }
      final item = seq[i];
      if (item == '...') {
        out.add(
          SelectionContainer.disabled(
            child: Text(' ... ', style: LPFont.defaultTextStyle.merge(TextStyle(color: LPColor.greyColor))),
          ),
        );
      } else {
        final p = item as int;
        final isCurrent = p == currentPage;
        out.add(
          TButton(
            text: '$p',
            color: isCurrent ? LPColor.primaryColor : LPColor.greyColor,
            hover: isCurrent ? LPColor.primaryBrightColor : LPColor.greyBrightColor,
            onPressed: isCurrent ? () {} : () => onPageSelected(p),
          ),
        );
      }
    }
    return out;
  }
}
