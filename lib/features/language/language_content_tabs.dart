import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/tabs/tabs.dart';

class LanguageContent extends StatelessWidget {
  final List<TabContent> tabsInfo = [
    TabContent(tabName: 'Description', shortTabName: 'Descr.', content: Text('Description')),
    TabContent(tabName: 'Phonetics', shortTabName: '[pʰ]', content: Text('Phonetics')),
    TabContent(tabName: 'Orthography', shortTabName: 'Ort', content: Text('Orthography')),
    TabContent(tabName: 'Grammatical Categories', shortTabName: 'm/n/f', content: Text('GC')),
    TabContent(tabName: 'Declensions', shortTabName: '-us/ūs', content: Text('Decl')),
  ];

  @override
  Widget build(BuildContext context) {
    return Tabs(tabsInfo: tabsInfo);
  }
}
