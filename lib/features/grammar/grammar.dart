import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:language_parser_desktop/features/grammar_grammatical_categories/grammar_grammatical_categories.dart';
import 'package:language_parser_desktop/features/grammar_word_classes/grammar_word_classes.dart';

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
            TabContent(tabName: 'Word Classes', shortTabName: 'Word Classes', content: GrammarWordClasses()),
            TabContent(
                tabName: 'Grammatical Categories',
                shortTabName: 'Grammatical Categories',
                content: GrammarGrammaticalCategories())
          ],
        ),
        height: 1000,
      );
    });
  }
}
