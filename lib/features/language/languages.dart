import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:language_parser_desktop/features/language/language_content_tabs.dart';
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
    final Size size = MediaQuery.sizeOf(context);
    return LayoutBuilder(builder: (context, constraints) {
      log('Language $constraints');
      var languageTabs = LanguageTabs(
        onSelect: selectLanguage,
        onCreate: onCreate,
      );
      return Container(
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              languageTabs,
              if (!createLanguage)
                Flexible(
                  child: Container(
                    constraints: BoxConstraints(
                      minWidth: 1,
                      maxWidth: 3000,
                    ),
                    child: LanguageContentTabs(
                      languageId: selectedLanguage?.id,
                    ),
                    height: size.height,
                  ),
                ),
            ],
          ),
        ),
        width: constraints.maxWidth,
      );
    });
  }
}
