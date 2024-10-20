import 'dart:developer';

import 'package:flutter/material.dart';

import '../../components/tabs/tabs.dart';

class Grammar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      log('Grammar $constraints');
      return Container(
        width: constraints.maxWidth,
        constraints: BoxConstraints(
          minWidth: 1,
          maxWidth: 3000,
        ),
        child: Tabs(
          tabsInfo: [
            TabContent(tabName: 'Word Classes', shortTabName: 'Word Classes', content: Text('Word Classes')),
            TabContent(tabName: 'Grammatical Categories', shortTabName: 'Grammatical Categories', content: Text('Grammatical Categories'))
          ],
        ),
        height: 1000,
      );
    });
  }
}
