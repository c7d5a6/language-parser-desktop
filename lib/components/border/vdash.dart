import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:language_parser_desktop/components/border/border.dart';

import '../../util/layout.dart';

class VDash extends StatelessWidget {
  final int? maxDashes;

  const VDash({super.key, this.maxDashes});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      log('vdash constraints ${constraints.maxWidth}:${constraints.maxHeight} __ $maxDashes');
      return Container(
        width: measureTextWidth('|', context),
        child: DBorder(
          data: calculateDashes(constraints, context),
        ),
      );
    });
  }

  String calculateDashes(BoxConstraints constraints, BuildContext context) {
    double dashHeight = measureTextHeight('|', context);
    var height =
        constraints.maxHeight == double.infinity ? 1 : constraints.maxHeight; //math.min(3000, constraints.maxHeight);
    int numberOfDashes = (height / dashHeight).ceil();
    if (maxDashes != null) {
      numberOfDashes = math.min(maxDashes!, numberOfDashes);
    }
    return '|' * numberOfDashes;
  }
}