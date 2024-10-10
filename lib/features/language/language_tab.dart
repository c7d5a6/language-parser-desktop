import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/buttons/t_button.dart';
import 'package:language_parser_desktop/features/language/language_creating.dart';
import 'package:language_parser_desktop/util/constants.dart';

import '../../components/border/border.dart';
import '../../components/border/hdash.dart';
import '../../components/border/vdash.dart';
import '../../persistence/entities/language_entity.dart';
import '../../service_provider.dart';
import '../../services/language_service.dart';
import '../../services/service_manager.dart';
import '../../util/layout.dart';

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
      _getLanguages();
    }
  }

  void selectLanguage(int? id) {
    final s = _languages.firstWhere((lang) => lang.id == id, orElse: null);
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
    final langs = _languageService.getAllLanguages()..sort((a, b) => a.displayName.compareTo(b.displayName));
    setState(() {
      _languages = langs;
    });
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
      final cWSize = measureTextWidth('-', context);
      log('CWSIZE $cWSize');
      //TODO: #25 what is this -5 px???
      double maxLanguageWidth = cWSize * 8 +
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
      return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          width: maxLanguageWidth,
          child: Column(
            children: [
              LanguageNewButton(
                cWSize: cWSize,
                onPressed: _createLanguage,
              ),
              LanguageSearchWidget(
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

class LanguageSearchWidget extends StatelessWidget {
  const LanguageSearchWidget({
    super.key,
    required this.cWSize,
    required this.onChanged,
  });

  final double cWSize;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder.all(style: BorderStyle.none),
        columnWidths: <int, TableColumnWidth>{
          0: FixedColumnWidth(cWSize),
          1: FixedColumnWidth(cWSize),
          2: FlexColumnWidth(1),
          3: FixedColumnWidth(cWSize),
        },
        children: [
          TableRow(children: [
            DBorder(data: ' '),
            DBorder(data: '|'),
            TextField(
              onChanged: onChanged,
              style: LPFont.defaultTextStyle.merge(TextStyle(color: LPColor.greyBrightColor)),
              decoration: InputDecoration.collapsed(
                  hintText: 'Search',
                  border: InputBorder.none,
                  hintStyle: LPFont.defaultTextStyle.merge(TextStyle(color: LPColor.greyColor))),
            ),
            DBorder(data: '|')
          ]),
          TableRow(children: [DBorder(data: ' '), DBorder(data: '+'), HDash(), DBorder(data: '|')]),
        ]);
    // return Row(
    //   children: [
    //     Text(' '),
    //     VDash(maxDashes: 1),
    //     Text(' '),
    //     Container(
    //       width: maxLanguageWidth - 5 * measureTextWidth('|', context) - 1,
    //       height: measureTextHeight('|', context),
    //       child: TextField(
    //         // onChanged: (s) => {
    //         //   setState(() {
    //         //     search = s;
    //         //   })
    //         // },
    //         style: LPFont.defaultTextStyle.merge(TextStyle(color: LPColor.greyBrightColor)),
    //         decoration: InputDecoration.collapsed(
    //             hintText: 'Search',
    //             border: InputBorder.none,
    //             hintStyle: LPFont.defaultTextStyle.merge(TextStyle(color: LPColor.greyColor))),
    //       ),
    //     ),
    //     Text(' '),
    //     VDash(maxDashes: 1),
    //   ],
    // );
  }
}

class LanguageNewButton extends StatelessWidget {
  const LanguageNewButton({
    super.key,
    required this.cWSize,
    required this.onPressed,
  });

  final double cWSize;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Table(
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        border: TableBorder.all(style: BorderStyle.none),
        columnWidths: <int, TableColumnWidth>{
          0: FixedColumnWidth(cWSize),
          1: FlexColumnWidth(1),
          2: FixedColumnWidth(cWSize),
        },
        children: [
          TableRow(children: [DBorder(data: '+'), HDash(), DBorder(data: '+')]),
          TableRow(children: [
            DBorder(data: '|'),
            TButton(
              text: '[ + ]',
              color: LPColor.greenColor,
              hover: LPColor.greenBrightColor,
              onPressed: onPressed,
            ),
            DBorder(data: '|')
          ]),
          TableRow(children: [DBorder(data: '+'), HDash(), DBorder(data: '+')]),
        ]);
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
    return LayoutBuilder(builder: (context, constraints) {
      final tabLength = measureTextWidth('-' * ((_selected ? 0 : 1) + 6 + _langName.length), context);
      return Column(
        children: [
          Row(children: [
            Text(_selected ? "  " : "   "),
            VDash(
              maxDashes: 1,
            ),
            TButton(
              text: ' $_langName ',
              onPressed: () => _onSelect(_id),
              color: _selected ? LPColor.primaryColor : LPColor.greyColor,
              hover: LPColor.greyBrightColor,
            ),
            //TODO: why - 2?
            Container(
              width: constraints.maxWidth - tabLength - 2,
            ),
            (_selected
                ? Container()
                : VDash(
                    maxDashes: 1,
                  )),
          ]),
          HDashWithPrefix(
            prefix: _selected || _prevSelected ? "  +" : "    ",
            postfix: _selected || _prevSelected ? "+" : "|",
          ),
        ],
      );
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
      final width = maxWidth -
          ((_prefix != null) ? measureTextWidth(_prefix, context) : 0) -
          ((_postfix != null) ? measureTextWidth(_postfix, context) : 0);
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
