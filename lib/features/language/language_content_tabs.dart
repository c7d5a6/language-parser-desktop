import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/tabs/tabs.dart';
import 'package:language_parser_desktop/features/language_description/language_description.dart';

class LanguageContentTabs extends StatelessWidget {
  final int? languageId;

  LanguageContentTabs({super.key, required this.languageId});

  @override
  Widget build(BuildContext context) {
    final List<TabContent> tabsInfo = languageId == null
        ? [
            TabContent(tabName: 'Phonetics', shortTabName: '[pʰ]', content: Text('Phonetics')),
          ]
        : [
            TabContent(tabName: 'Description', shortTabName: 'Descr.', content: LanguageDescription(languageId!)),
            TabContent(tabName: 'Phonetics', shortTabName: '[pʰ]', content: Text('Phonetics')),
            TabContent(tabName: 'Orthography', shortTabName: 'Ort', content: Text('Orthography')),
            TabContent(tabName: 'Grammatical Categories', shortTabName: 'm/n/f', content: Text('GC')),
            TabContent(tabName: 'Declensions', shortTabName: '-us/ūs', content: Text('Decl')),
          ];
    return Tabs(tabsInfo: tabsInfo);
  }
}
