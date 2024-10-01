import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:language_parser_desktop/util/constants.dart';

class DBorder extends StatelessWidget {
  final String data;
  final int? maxLines;

  const DBorder({super.key, required this.data, this.maxLines});

  @override
  Widget build(BuildContext context) {
    log("color ${LPFont.borderFontStyle}");
    return SelectionContainer.disabled(
      child: Text(
        data,
        maxLines: maxLines,
        overflow: TextOverflow.fade,
        style: LPFont.borderFontStyle,
      ),
    );
  }
}
