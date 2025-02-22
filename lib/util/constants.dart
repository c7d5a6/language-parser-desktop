import 'package:flutter/material.dart';

class LPColor {
  static const Color primaryColor = Color(0xffaf7fa8);
  static const Color primaryBrightColor = Color(0xffE8B2E0);
  static const Color primaryBrighterColor = Color(0xffEEC8EA);
  static const Color whiteColor = Color(0xffFFFFFF);
  static const Color greyBrightColor = Color(0xffADADAD);
  static const Color greyColor = Color(0xff616161);
  static const Color greenBrightColor = Color(0xff8fd637);
  static const Color greenColor = Color(0xff568a21);
  static const Color redColor = Color(0xffbf2020);
  static const Color redBrightColor = Color(0xffee2d2d);
  static const Color yellowColor = Color(0xffb7a036);
  static const Color yellowBrightColor = Color(0xfff6e44d);
  static const Color borderColor = Color(0xff424242);
  static const Color selectedBackgroundColor = Color(0xff333333);

  static const Color backgroundColor = Color(0xff212121);
}

class LPFont {
  static const String fontFamily = 'Cousine';
  static const double fontSize = 16.0;

  static const TextStyle defaultTextStyle = TextStyle(
      fontSize: fontSize,
      textBaseline: TextBaseline.alphabetic,
      height: 0.0,
      wordSpacing: 0,
      fontFamily: fontFamily,
      fontWeight: FontWeight.normal,
      // inherit: false,
      fontFeatures: [
        FontFeature.tabularFigures(),
      ]);

  static final TextStyle borderFontStyle =
      defaultTextStyle.merge(TextStyle(color: LPColor.borderColor, fontWeight: FontWeight.w900));
  static final TextStyle headerFontStyle =
      defaultTextStyle.merge(TextStyle(color: LPColor.borderColor, fontWeight: FontWeight.w500));
}
