import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:language_parser_desktop/features/word/words_list.dart';

import '../../persistence/entities/language_entity.dart';
import '../../service_provider.dart';
import '../../services/language_service.dart';
import '../../services/service_manager.dart';

class LanguageTabs extends StatefulWidget {
  final Function(Language?) onSelect;

  LanguageTabs({super.key, required this.onSelect}) {
    log('Rebuild');
  }

  @override
  State<StatefulWidget> createState() => _LanguageTabs();
}

class _LanguageTabs extends State<LanguageTabs> {
  late List<Language> _languages;
  Language? _selectedLanguage;
  ServiceManager? _serviceManager;
  late LanguageService _languageService;

  _LanguageTabs() {
    log('State');
  }

  @override
  void initState() {
    super.initState();
    log("Init state");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final sm = ServiceProvider.of(context)?.serviceManager;
    if (_serviceManager != sm) {
      _serviceManager = sm;
      _languageService = _serviceManager!.languageService;
      _getLanguages();
    }
  }

  void selectLanguage(int? id) {
    if (id != _selectedLanguage?.id) {
      final s = _languages.firstWhere((lang) => lang.id == id, orElse: null);
      setState(() {
        _selectedLanguage = s;
      });
      widget.onSelect(s);
    }
  }

  void _getLanguages() {
    final langs = _languageService.getAllLanguages();
    setState(() {
      _languages = langs;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: 220),
      child: Column(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
              children: _languages
                  .map((lang) =>
                      LanguageTab(lang.displayName, _selectedLanguage?.id == lang.id, selectLanguage, lang.id))
                  .toList(growable: false)),
        ],
      ),
    );
  }
}

// +-----------
// 1| search
// 1+----------
// 12|  Lang 1
// 12+---------
// 123| Lang 2
// 1234--------
// 123| Lang 3
// 12+---------
// 12|  Lang 4
// 12+---------

class LanguageTab extends StatelessWidget {
  final String _langName;
  final int _id;
  final bool _selected;
  final Function(int?) _onSelect;

  LanguageTab(this._langName, this._selected, this._onSelect, this._id);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [Text(_selected ? "  +" : "    ")],
        ),
        Row(
          children: [
            Text(_selected ? "  " : "   "),
            VDash(),
            TextButton(
              onPressed: () => _onSelect(_id),
              child: Text('$_langName ${_selected ? "yes" : "not"}'),
            ),
          ],
        ),
      ],
    );
  }
}
