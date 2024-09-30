import 'dart:developer';

import 'package:flutter/widgets.dart';

import '../../util/layout.dart';

class HDash extends StatelessWidget {
  const HDash({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return SelectionContainer.disabled(
        child: Container(child: calculateDashes(constraints, context)),
      );
    });
  }

  Widget calculateDashes(BoxConstraints constraints, BuildContext context) {
    double dashWidth = measureTextWidth('-', context);
    log('Calculate dashes $dashWidth');
    final width = constraints.maxWidth;
    log('Calculate dashes $width');
    int numberOfDashes = (width / dashWidth).ceil();
    final dashes = '-' * numberOfDashes;
    return Text(
      dashes,
      overflow: TextOverflow.fade,
      style: const TextStyle(fontSize: 16, height: 0.0),
      maxLines: 1,
    );
  }
}

