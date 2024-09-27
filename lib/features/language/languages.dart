import 'package:flutter/cupertino.dart';
import 'package:language_parser_desktop/features/language/language_tab.dart';
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
    return LanguageTabs(
      onSelect: selectLanguage,
    );
  }
}
