import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/buttons/t_button.dart';
import 'package:language_parser_desktop/components/dashes/hdash.dart';
import 'package:language_parser_desktop/features/word/words_list.dart';

import '../../persistence/entities/language_entity.dart';
import '../../service_provider.dart';
import '../../services/language_service.dart';
import '../../services/service_manager.dart';
import '../../util/layout.dart';

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
  String search = '';

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
    return LayoutBuilder(builder: (context, constraints) {
      //#25 what is this -5 px???
      double maxLanguageWidth = -5 +
          measureTextWidth('-' * 7, context) +
          _languages.map((language) => measureTextWidth(language.displayName, context)).reduce((a, b) => a > b ? a : b);
      maxLanguageWidth = math.max(maxLanguageWidth, 150);
      List<Widget> tabs = [];
      for (final (index, lang) in _languages.indexed) {
        if (lang.id != _selectedLanguage?.id && !lang.displayName.contains(search)) {
          continue;
        }
        tabs.add(LanguageTab(
            lang.displayName,
            _selectedLanguage?.id == lang.id,
            index < _languages.length - 1 && _languages[index + 1].id == _selectedLanguage?.id,
            selectLanguage,
            lang.id));
      }
      return Container(
        width: maxLanguageWidth,
        child: Column(
          children: [
            VDashWithPrefix(prefix: '+'),
            Row(
              children: [
                VDash(),
                LayoutBuilder(builder: (context, constraints) {
                  log('$constraints');
                  return Container(
                      width: maxLanguageWidth - measureTextWidth('|', context) - 1,
                      child: Center(
                        child: TButton('[ + ]', () => {}),
                      ));
                }),
              ],
            ),
            VDashWithPrefix(prefix: '+'),
            Row(
              children: [
                Text(' '),
                VDash(),
                Text(' '),
                Container(
                  width: 100,
                  height: 21,
                  child: TextField(
                    onChanged: (s) => {
                      setState(() {
                        search = s;
                      })
                    },
                    decoration: InputDecoration.collapsed(hintText: 'Search', border: InputBorder.none),
                  ),
                )
              ],
            ),
            VDashWithPrefix(prefix: ' +'),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: tabs,
            ),
          ],
        ),
      );
    });
  }
}

class LanguageTab extends StatelessWidget {
  final String _langName;
  final int _id;
  final bool _selected;
  final bool _prevSelected;
  final Function(int?) _onSelect;

  LanguageTab(this._langName, this._selected, this._prevSelected, this._onSelect, this._id);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [Text(_selected ? "  " : "   "), VDash(), TButton(' $_langName ', () => _onSelect(_id))]),
        VDashWithPrefix(prefix: _selected || _prevSelected ? "  +" : "    "),
      ],
    );
  }
}

class VDashWithPrefix extends StatelessWidget {
  const VDashWithPrefix({
    super.key,
    required String prefix,
  }) : _prefix = prefix;

  final String _prefix;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final maxWidth = constraints.maxWidth;
      final width = maxWidth - measureTextWidth(_prefix, context);
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(_prefix),
          Container(
            width: width - 1,
            child: HDash(),
          ),
        ],
      );
    });
  }
}
