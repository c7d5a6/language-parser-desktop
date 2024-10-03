import 'package:flutter/material.dart';

class LPColor {
  static const Color primaryColor = Color(0xffaf7fa8);
  static const Color greyBrightColor = Color(0xffBDBDBD);
  static const Color greyColor = Color(0xff616161);
  static const Color greenBrightColor = Color(0xff8fd637);
  static const Color greenColor = Color(0xff568a21);
  static const Color borderColor = Color(0xff424242);


  static const Color backgroundColor = Color(0xff212121);
}

class LPFont {
  static const String fontFamily = 'Cousine';
  static const double fontSize = 16.0;

  static const TextStyle defaultTextStyle =
      TextStyle(fontSize: fontSize, height: 0.0, fontFamily: fontFamily, fontFeatures: [
    FontFeature.tabularFigures(),
  ]);

  static final TextStyle borderFontStyle =
      defaultTextStyle.merge(TextStyle(color: LPColor.borderColor, fontWeight: FontWeight.w900));
}
