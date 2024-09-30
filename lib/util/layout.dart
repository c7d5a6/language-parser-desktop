import 'dart:ui' as ui;

import 'package:flutter/widgets.dart';

double measureTextWidth(String text, BuildContext context) {
  final TextPainter textPainter = TextPainter(
    text: TextSpan(
        text: text,
        style: const TextStyle(fontSize: 16, height: 0.0, fontFamily: 'Cousine', fontFeatures: [
          FontFeature.tabularFigures(),
        ])),
    textDirection: ui.TextDirection.ltr,
  )..layout();
  return textPainter.width;
}
