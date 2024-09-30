import 'package:flutter/material.dart';
import 'package:language_parser_desktop/features/language/language_tab.dart';
import 'package:language_parser_desktop/features/language_description/language_description.dart';
import 'package:language_parser_desktop/persistence/entities/language_entity.dart';

class Languages extends StatefulWidget {
  const Languages({super.key});

  @override
  State<StatefulWidget> createState() => _Languages();
}

class _Languages extends State<Languages> {
  Language? selectedLanguage;

  void selectLanguage(Language? language) {
    if (selectedLanguage?.id != language?.id) {
      setState(() {
        selectedLanguage = language;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LanguageTabs(onSelect: selectLanguage),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 1200, maxHeight: 800),
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
