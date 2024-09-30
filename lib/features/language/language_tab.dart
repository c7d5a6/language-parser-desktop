import 'dart:developer';

import 'package:flutter/material.dart';
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
      double maxLanguageWidth = measureTextWidth('-' * 7, context) +
          _languages.map((language) => measureTextWidth(language.displayName, context)).reduce((a, b) => a > b ? a : b);
      List<Widget> tabs = [];
      for (final (index, lang) in _languages.indexed) {
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
            HDash(),
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
  final bool _prevSelected;
  final Function(int?) _onSelect;

  LanguageTab(this._langName, this._selected, this._prevSelected, this._onSelect, this._id);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _onSelect(_id),
          child: Row(children: [
            Text(_selected ? "  " : "   "),
            VDash(),
            SizedBox(
              height: 16 * 1.2,
              child: Text(
                ' $_langName ',
                style: const TextStyle(fontSize: 16, height: 0.0, fontFamily: 'Cousine', fontFeatures: [
                  FontFeature.tabularFigures(),
                ]),
                maxLines: 1,
              ),
            ),
          ]),
        ),
        LayoutBuilder(builder: (context, constraints) {
          final maxWidth = constraints.maxWidth;
          log('Max width $maxWidth');
          var prefix = _selected || _prevSelected ? "  +" : "    ";
          final width = maxWidth - measureTextWidth(prefix, context);
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(prefix),
              Container(
                width: width - 1,
                child: HDash(),
              ),
            ],
          );
        }),
      ],
    );
  }
}
