import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/border/border.dart';
import 'package:language_parser_desktop/components/border/hdash.dart';
import 'package:language_parser_desktop/components/buttons/t_button.dart';
import 'package:language_parser_desktop/services/declension_service.dart';
import 'package:language_parser_desktop/util/constants.dart';

import '../../service_provider.dart';
import '../../services/service_manager.dart';
import '../../text_measure_provider.dart';
import '../language_phonetics/language_phonetics_header.dart';

class LanguageDeclension extends StatefulWidget {
  final int languageId;
  final int posId;
  final DeclensionRow declension;

  const LanguageDeclension(this.languageId, this.posId, this.declension);

  @override
  State<StatefulWidget> createState() => _LanguageDeclension();
}

class _LanguageDeclension extends State<LanguageDeclension> {
  ServiceManager? _serviceManager;
  late DeclensionService _declensionService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final sm = ServiceProvider.of(context)?.serviceManager;
    if (_serviceManager != sm) {
      _serviceManager = sm;
      _declensionService = _serviceManager!.declensionService;
    }
  }

  @override
  void didUpdateWidget(LanguageDeclension oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.languageId != oldWidget.languageId ||
        widget.posId != oldWidget.posId ||
        widget.declension.declensionId != oldWidget.declension.declensionId) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final cWidth = TextMeasureProvider.of(context)!.characterWidth;
    final rules = widget.declension.values
        .map((value) => value.name)
        .toList(growable: false);
    final rowLength = _leftColumnRowsCount(rules.length);
    final List<TableRow> rows = [];

    for (int i = 0; i < rowLength; i++) {
      rows.add(
        TableRow(
          children: [
            DBorder(data: '|'),
            _leftColumnCell(i, rules),
            DBorder(data: '|'),
            _rightColumnCell(i),
            DBorder(data: '|'),
          ],
        ),
      );
    }
    rows.add(
      TableRow(
        children: [
          DBorder(data: '+'),
          HDash(),
          DBorder(data: '+'),
          HDash(),
          DBorder(data: '+'),
        ],
      ),
    );

    return Column(
      children: [
        Table(
          columnWidths: {
            0: FixedColumnWidth(cWidth),
            1: FlexColumnWidth(),
            2: FixedColumnWidth(cWidth),
          },
          children: [
            TableRow(
              children: [
                DBorder(data: '|'),
                Center(
                  child: LPhHeader(
                    header: widget.declension.name.toUpperCase(),
                  ),
                ),
                DBorder(data: '|'),
              ],
            ),
            TableRow(
              children: [
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
              ],
            ),
          ],
        ),
        Table(
          columnWidths: {
            0: FixedColumnWidth(cWidth),
            1: FlexColumnWidth(3),
            2: FixedColumnWidth(cWidth),
            3: FlexColumnWidth(2),
            4: FixedColumnWidth(cWidth),
          },
          children: rows,
        ),
      ],
    );
  }

  int _leftColumnRowsCount(int rulesCount) {
    // static rows: main button, border, rules header, border, border, plus button
    return 6 + rulesCount;
  }

  Widget _leftColumnCell(int rowIndex, List<String> rules) {
    const rulesStartIndex = 4;
    final rulesEndIndex = rulesStartIndex + rules.length;
    if (rowIndex == 0) {
      final isMain = widget.declension.main;
      return Center(
        child: TButton(
          text: '[ MAIN DECLENSION ]',
          color: isMain ? LPColor.greenColor : LPColor.greyColor,
          hover: isMain ? LPColor.greenBrightColor : LPColor.greyBrightColor,
          onPressed: _setMainDeclension,
        ),
      );
    }
    if (rowIndex == 1) {
      return HDash();
    }
    if (rowIndex == 2) {
      return Center(child: LPhHeader(header: 'RULES'));
    }
    if (rowIndex == 3) {
      return HDash();
    }
    if (rowIndex >= rulesStartIndex && rowIndex < rulesEndIndex) {
      return Center(
        child: Text(
          rules[rowIndex - rulesStartIndex],
          style: LPFont.defaultTextStyle,
        ),
      );
    }
    if (rowIndex == rulesEndIndex) {
      return HDash();
    }
    return Center(
      child: TButton(
        text: '[ + ]',
        color: LPColor.greenColor,
        hover: LPColor.greenBrightColor,
        onPressed: () => log('Add rule TODO'),
      ),
    );
  }

  Widget _rightColumnCell(int rowIndex) {
    return Container();
  }

  void _setMainDeclension() {
    final declensionId = widget.declension.declensionId;
    if (declensionId == null) {
      log('Cannot set main: declension is not saved');
      return;
    }
    _declensionService.setMainDeclension(
      widget.languageId,
      widget.posId,
      declensionId,
    );
  }
}
