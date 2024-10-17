import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:language_parser_desktop/util/constants.dart';
import 'package:language_parser_desktop/util/layout.dart';

class LPhHeader extends StatelessWidget {
  final String header;
  final String? short;
  final String? prompt;

  const LPhHeader({super.key, required this.header, this.short, this.prompt});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final wide = measureTextWidth(header, context) <= constraints.maxWidth;
      return Container(
        child: wide
            ? Text(
                header,
                maxLines: 1,
                overflow: TextOverflow.fade,
                style: LPFont.headerFontStyle,
              )
            : Tooltip(
                decoration: BoxDecoration(color: LPColor.greyColor),
                message: prompt == null ? header : prompt,
                textStyle: LPFont.headerFontStyle.merge(TextStyle(color: LPColor.greyBrightColor)),
                child: Text(
                  short == null ? header : short!,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  style: LPFont.headerFontStyle.merge(
                      TextStyle(decoration: TextDecoration.underline, decorationStyle: TextDecorationStyle.dotted)),
                ),
              ),
      );
    });
  }
}

class CLPhHeader extends StatelessWidget {
  final String header;
  final String? short;
  final String? prompt;

  const CLPhHeader({super.key, required this.header, this.short, this.prompt});

  @override
  Widget build(BuildContext context) {
    return Center(child: LPhHeader(header: header, short: short, prompt: prompt));
  }
}
