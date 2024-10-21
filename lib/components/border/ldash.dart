import 'package:flutter/widgets.dart';
import 'package:language_parser_desktop/components/border/border.dart';

import '../../text_measure_provider.dart';
import '../../util/layout.dart';

class LDash extends StatelessWidget {
  const LDash({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return DBorder(
        data: calculateDashes(constraints, context),
        maxLines: 1,
      );
    });
  }

  String calculateDashes(BoxConstraints constraints, BuildContext context) {
    final dashWidth = TextMeasureProvider.of(context)!.characterWidth;
    final width = constraints.maxWidth;
    int numberOfDashes = (width / dashWidth).ceil();
    return '_' * numberOfDashes;
  }
}
