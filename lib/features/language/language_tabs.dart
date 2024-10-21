import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:language_parser_desktop/features/language/language_creating.dart';

import '../../components/border/border.dart';
import '../../components/border/hdash.dart';
import '../../persistence/entities/language_entity.dart';
import '../../persistence/repositories/language_repository.dart';
import '../../service_provider.dart';
import '../../services/language_service.dart';
import '../../services/service_manager.dart';
import '../../text_measure_provider.dart';
import 'language_new_button.dart';
import 'language_search.dart';
import 'language_tab.dart';

class LanguageTabs extends StatefulWidget {
  final Function(Language?) onSelect;
  final Function() onCreate;

  LanguageTabs({super.key, required this.onSelect, required this.onCreate}) {}

  @override
  State<StatefulWidget> createState() => _LanguageTabs();
}

class _LanguageTabs extends State<LanguageTabs> {
  late List<Language> _languages;
  Language? _selectedLanguage;
  ServiceManager? _serviceManager;
  late LanguageService _languageService;
  bool creating = false;
  String search = '';

  _LanguageTabs() {}

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final sm = ServiceProvider.of(context)?.serviceManager;
    if (_serviceManager != sm) {
      _serviceManager = sm;
      _languageService = _serviceManager!.languageService;
      _languageService.langsUpdated = () => _getLanguages();
      _getLanguages();
    }
  }

  void selectLanguage(int? id) {
    final s = id == null ? null : _languages.firstWhere((lang) => lang.id == id, orElse: null);
    if (id != _selectedLanguage?.id) {
      setState(() {
        _selectedLanguage = s;
        creating = false;
      });
      widget.onSelect(s);
    } else {
      setState(() {
        creating = false;
      });
      widget.onSelect(s);
    }
  }

  void _getLanguages() {
    log('Get languages');
    final langs = _languageService.getAllLanguages()..sort((a, b) => a.displayName.compareTo(b.displayName));
    setState(() {
      _languages = langs;
    });
    if (_selectedLanguage != null) {
      if (!langs.any((lang) => lang.id == _selectedLanguage?.id)) {
        selectLanguage(null);
      }
    }
  }

  void _createLanguage() {
    setState(() {
      creating = true;
      _selectedLanguage = null;
      widget.onCreate();
    });
  }

  void _saveLanguage(LanguageCreatingModel model) {
    final toSelect = _languageService.save(model);
    _getLanguages();
    selectLanguage(toSelect.id);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final cWSize = TextMeasureProvider.of(context)!.characterWidth;
      double maxLanguageWidth = cWSize * 8 +
          cWSize * _languages.map((language) => language.displayName.length).fold(0, (a, b) => a > b ? a : b);
      maxLanguageWidth = math.max(maxLanguageWidth, cWSize * 9);
      List<Widget> tabs = [];
      for (final (index, lang) in _languages.indexed) {
        if (lang.id != _selectedLanguage?.id && !lang.displayName.toLowerCase().contains(search.toLowerCase())) {
          continue;
        }
        tabs.add(LanguageTab(
          langName: lang.displayName,
          selected: _selectedLanguage?.id == lang.id,
          prevSelected: index < _languages.length - 1 && _languages[index + 1].id == _selectedLanguage?.id,
          onSelect: selectLanguage,
          id: lang.id,
          cWSize: cWSize,
        ));
      }
      return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: maxLanguageWidth,
          child: Column(
            children: [
              LanguageNewButton(
                cWSize: cWSize,
                onPressed: _createLanguage,
              ),
              LanguageSearch(
                cWSize: cWSize,
                onChanged: (s) => {
                  setState(() {
                    search = s;
                  })
                },
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: tabs,
              ),
            ],
          ),
        ),
        if (creating) LanguageCreating(createLanguage: _saveLanguage),
      ]);
    });
  }
}

class HDashWithPrefix extends StatelessWidget {
  const HDashWithPrefix({super.key, String? prefix, String? postfix})
      : _prefix = prefix,
        _postfix = postfix;

  final String? _prefix;
  final String? _postfix;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;
      final prefixWidth = _prefix == null ? 0 : _prefix.length * TextMeasureProvider.of(context)!.characterWidth;
      final postfixWidth = _postfix == null ? 0 : _postfix.length * TextMeasureProvider.of(context)!.characterWidth;
      final width = maxWidth - ((_prefix != null) ? prefixWidth : 0) - ((_postfix != null) ? postfixWidth : 0);
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          (_prefix != null
              ? DBorder(
                  data: _prefix,
                  maxLines: 1,
                )
              : Container()),
          Container(
            width: width - 1.25,
            child: HDash(),
          ),
          (_postfix != null
              ? DBorder(
                  data: _postfix,
                  maxLines: 1,
                )
              : Container()),
        ],
      );
    });
  }
}
