import 'package:flutter/material.dart';

class LPColor {
  static final Color primaryColor = Color(0xffaf7fa8);
  static final Color borderColor = Color(0xff3d3d3d);
}

class LPFont {
  static final String fontFamily = 'Cousine';
  static final double fontSize = 16.0;

  static final TextStyle defaultTextStyle =
      TextStyle(fontSize: fontSize, height: 0.0, fontFamily: fontFamily, fontFeatures: [
    FontFeature.tabularFigures(),
  ]);

  static final TextStyle borderFontStyle =
      defaultTextStyle.merge(TextStyle(color: LPColor.borderColor, fontWeight: FontWeight.w900));
}
