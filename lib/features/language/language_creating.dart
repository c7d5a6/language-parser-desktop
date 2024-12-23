import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/border/border.dart';
import 'package:language_parser_desktop/components/border/hdash.dart';
import 'package:language_parser_desktop/components/border/vdash.dart';
import 'package:language_parser_desktop/components/buttons/t_button.dart';
import 'package:language_parser_desktop/util/layout.dart';

import '../../persistence/repositories/language_repository.dart';
import '../../text_measure_provider.dart';
import '../../util/constants.dart';

class LanguageCreating extends StatefulWidget {
  final void Function(LanguageCreatingModel model) createLanguage;

  const LanguageCreating({super.key, required this.createLanguage});

  @override
  State<StatefulWidget> createState() => _LanguageCreating();
}

class _LanguageCreating extends State<LanguageCreating> {
  LanguageCreatingModel model = LanguageCreatingModel();

  @override
  Widget build(BuildContext context) {
    final symbolWidth = TextMeasureProvider.of(context)!.characterWidth;
    var symbolHeight = measureTextHeight('|', context);
    return Container(
      constraints: BoxConstraints(
        minWidth: 100,
        maxWidth: 1000,
      ),
      child: Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.intrinsicHeight,
        border: TableBorder.all(style: BorderStyle.none),
        columnWidths: <int, TableColumnWidth>{
          0: FixedColumnWidth(symbolWidth),
          1: FlexColumnWidth(1),
          2: FixedColumnWidth(symbolWidth),
        },
        children: [
          TableRow(
            children: [
              DBorder(data: '+'),
              HDash(),
              DBorder(data: '+'),
            ],
          ),
          TableRow(
            children: [
              VDash(),
              Container(
                child: Column(
                  children: [
                    TextField(
                      onChanged: (s) => {
                        setState(() {
                          model.displayName = s;
                        })
                      },
                      style: LPFont.defaultTextStyle.merge(TextStyle(color: LPColor.greyBrightColor)),
                      decoration: InputDecoration.collapsed(
                          hintText: 'Display name',
                          filled: true,
                          fillColor: Colors.black,
                          // border: InputBorder.,
                          hintStyle: LPFont.defaultTextStyle.merge(TextStyle(color: LPColor.greyColor))),
                    ),
                    Container(
                      height: symbolHeight,
                    ),
                    Center(
                        child: TButton(
                      text: '[ SAVE ]',
                      color: LPColor.greenColor,
                      hover: LPColor.greenBrightColor,
                      onPressed: () => widget.createLanguage(model),
                    )),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
              VDash(),
            ],
          ),
          TableRow(
            children: [
              DBorder(data: '+'),
              HDash(),
              DBorder(data: '+'),
            ],
          )
        ],
      ),
    );
  }
}
