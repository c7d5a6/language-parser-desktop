import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import 'constants.dart';

double measureTextWidth(String text, BuildContext context) {
  assert(text.length > 0, 'Text "${text}" length should be not empty');
  final style = DefaultTextStyle.of(context).style.merge(LPFont.borderFontStyle);
  final TextPainter textPainter = TextPainter(
    text: TextSpan(
      text: text,
      style: style,
    ),
    textDirection: ui.TextDirection.ltr,
  )..layout();
  var width = textPainter.width;
  assert(width > 0, 'Text ${text} width ${width} should be bigger than 0');
  return width * 1.0000000;
}

double measureTextHeight(String text, BuildContext context) {
  assert(text.length > 0, 'Text "${text}" length should be not empty');
  final TextPainter textPainter = TextPainter(
    text: TextSpan(
      text: text,
      style: LPFont.defaultTextStyle,
    ),
    textDirection: ui.TextDirection.ltr,
  )..layout();
  var height = textPainter.height;
  assert(height > 0, 'Text ${text} width ${height} should be bigger than 0');
  return height;
}
