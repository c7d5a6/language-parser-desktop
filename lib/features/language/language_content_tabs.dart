import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/tabs/tabs.dart';
import 'package:language_parser_desktop/features/language_description/language_description.dart';
import 'package:language_parser_desktop/features/language_grammatical_categories/language_grammatical_categories.dart';
import 'package:language_parser_desktop/features/language_phonetics/language_phonetics.dart';
import 'package:language_parser_desktop/features/language_word_classes/language_word_classes.dart';

class LanguageContentTabs extends StatelessWidget {
  final int? languageId;

  LanguageContentTabs({super.key, required this.languageId});

  @override
  Widget build(BuildContext context) {
    final List<TabContent> tabsInfo = languageId == null
        ? [
            TabContent(tabName: 'Phonetics', shortTabName: '[pʰ]', content: LanguagePhonetics(languageId)),
          ]
        : [
            TabContent(tabName: 'Description', shortTabName: 'Description', content: LanguageDescription(languageId!)),
            TabContent(tabName: 'Phonetics', shortTabName: '[pʰ]', content: LanguagePhonetics(languageId)),
            TabContent(tabName: 'Word Classes', shortTabName: 'adj.', content: LanguageWordClasses(languageId!)),
            TabContent(
                tabName: 'Grammatical Categories',
                shortTabName: 'm/n/f',
                content: LanguageGrammaticalCategories(languageId!)),
            TabContent(tabName: 'Declensions', shortTabName: '-us/ūs', content: Text('Decl')),
            TabContent(tabName: 'Orthography', shortTabName: 'abc', content: Text('Orthography')),
          ];
    return Tabs(tabsInfo: tabsInfo, langPrefix: true);
  }
}
