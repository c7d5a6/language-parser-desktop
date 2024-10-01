import 'package:flutter/material.dart';
import 'package:language_parser_desktop/features/language/language_tab.dart';
import 'package:language_parser_desktop/features/language_description/language_description.dart';
import 'package:language_parser_desktop/features/word/words_list.dart';
import 'package:language_parser_desktop/persistence/entities/language_entity.dart';

import '../../components/border/vdash.dart';

class Languages extends StatefulWidget {
  const Languages({super.key});

  @override
  State<StatefulWidget> createState() => _Languages();
}

class _Languages extends State<Languages> {
  Language? selectedLanguage;
  bool createLanguage = false;

  void selectLanguage(Language? language) {
    if (selectedLanguage?.id != language?.id) {
      setState(() {
        selectedLanguage = language;
        createLanguage = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LanguageTabs(onSelect: selectLanguage),
        VDash(maxDashes: 100),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1000, maxHeight: 800),
          child: DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                bottom: const TabBar(
                  tabs: [
                    Tab(
                      text: 'Description',
                    ),
                    Tab(
                      text: 'Lang tab 2',
                    ),
                    Tab(
                      text: 'Lang tab 3',
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: [
                  selectedLanguage == null ? Text("Nothing") : LanguageDescription(selectedLanguage!.id),
                  Icon(Icons.directions_transit),
                  Icon(Icons.directions_bike),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
