import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:language_parser_desktop/util/constants.dart';

class LanguageOrthography extends StatefulWidget {
  final int? languageId;

  LanguageOrthography(this.languageId);

  @override
  State<StatefulWidget> createState() => _LanguageOrthography();
}

class _LanguageOrthography extends State<LanguageOrthography> {
  @override
  Widget build(BuildContext context) {
    var focusNode = FocusNode();
    var multiStyleTextEditingController = MultiStyleTextEditingController();
    var textField = TextField(
      focusNode: focusNode,
      controller: multiStyleTextEditingController,
      onSubmitted: (s) {
        multiStyleTextEditingController.text = s.endsWith("auto") ? s + "complete" : s;
        focusNode.requestFocus();
      },
    );
    return textField;
  }
}

class MultiStyleTextEditingController extends TextEditingController {
  @override
  TextSpan buildTextSpan({required BuildContext context, TextStyle? style, required bool withComposing}) {
    final textSpanChildren = <TextSpan>[];
    final child = TextSpan(text: text, style: LPFont.defaultTextStyle);
    textSpanChildren.add(child);
    if (text.endsWith("auto")) {
      final auto = TextSpan(text: "complete", style: LPFont.borderFontStyle);
      textSpanChildren.add(auto);
    }
    return TextSpan(children: textSpanChildren);
  }

  @override
  void clearComposing() {
    TextInputFormatter;
    TextEditingValue;
  }
}
