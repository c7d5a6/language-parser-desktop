import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/tabs/tabs.dart';
import 'package:language_parser_desktop/features/language_description/language_description.dart';
import 'package:language_parser_desktop/features/language_phonetics/language_phonetics.dart';

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
      TabContent(tabName: 'Phonetics', shortTabName: 'Phonetics', content: LanguagePhonetics(languageId)),
      TabContent(tabName: 'Orthography', shortTabName: 'Orthography', content: Text('Orthography')),
      TabContent(tabName: 'Grammatical Categories', shortTabName: 'Grammatical Categories', content: Text('GC')),
      TabContent(tabName: 'Declensions', shortTabName: 'Declensions', content: Text('Decl')),
            // TabContent(tabName: 'Description', shortTabName: 'Descr.', content: LanguageDescription(languageId!)),
            // TabContent(tabName: 'Phonetics', shortTabName: '[pʰ]', content: LanguagePhonetics(languageId)),
            // TabContent(tabName: 'Orthography', shortTabName: 'Ort', content: Text('Orthography')),
            // TabContent(tabName: 'Grammatical Categories', shortTabName: 'm/n/f', content: Text('GC')),
            // TabContent(tabName: 'Declensions', shortTabName: '-us/ūs', content: Text('Decl')),
          ];
    return Tabs(tabsInfo: tabsInfo, langPrefix: true);
  }
}
