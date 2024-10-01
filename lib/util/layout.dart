import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

import 'constants.dart';

double measureTextWidth(String text, BuildContext context) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(
      text: text,
      style: LPFont.defaultTextStyle,
    ),
    textDirection: ui.TextDirection.ltr,
  )..layout();
  return textPainter.width;
}

double measureTextHeight(String text, BuildContext context) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(
      text: text,
      style: LPFont.defaultTextStyle,
    ),
    textDirection: ui.TextDirection.ltr,
  )..layout();
  return textPainter.height;
}
