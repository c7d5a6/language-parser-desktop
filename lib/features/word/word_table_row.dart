import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/buttons/t_button.dart';
import 'package:language_parser_desktop/components/border/vdash.dart';
import 'package:language_parser_desktop/persistence/entities/word_list.dart';
import 'package:language_parser_desktop/util/constants.dart';

TableRow buildWordTableRow(WordListItem row) {
  final comment = row.word.comment ?? '';
  final fromLang = 'from ${row.word.language.displayName}';
  final fromWithComment = comment.trim().isEmpty ? ' $fromLang ' : ' $fromLang. $comment ';

  return TableRow(children: <Widget>[
    const VDash(),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Text(
        row.writtenForm,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: LPFont.defaultTextStyle.merge(TextStyle(color: LPColor.greenColor)),
      ),
    ),
    const VDash(),
    TButton(
      text: ' / ${row.phonetic} / ',
      color: LPColor.primaryColor,
      hover: LPColor.primaryBrightColor,
      onPressed: () {},
    ),
    const VDash(),
    Text(
      ' ${row.categoryLabel} ',
      maxLines: 1,
      softWrap: false,
      style: LPFont.borderFontStyle,
    ),
    const VDash(),
    Text(
      fromWithComment,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: LPFont.borderFontStyle,
    ),
    const VDash(),
  ]);
}
