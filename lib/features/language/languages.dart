import 'package:flutter/material.dart';
import 'package:language_parser_desktop/features/language/language_content.dart';
import 'package:language_parser_desktop/features/language/language_tabs.dart';
import 'package:language_parser_desktop/persistence/entities/language_entity.dart';

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
    } else {
      setState(() {
        createLanguage = false;
      });
    }
  }

  void onCreate() {
    setState(() {
      selectedLanguage = null;
      createLanguage = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LanguageTabs(
          onSelect: selectLanguage,
          onCreate: onCreate,
        ),
        if (!createLanguage)
          Container(
            width: 800,
            height: 800,
            child: LanguageContent(),
          )
      ],
    );
  }
}
