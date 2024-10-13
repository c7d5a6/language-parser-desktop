import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/border/border.dart';
import 'package:language_parser_desktop/components/border/ldash.dart';
import 'package:language_parser_desktop/util/layout.dart';

import '../../components/border/hdash.dart';
import '../../components/buttons/t_button.dart';
import '../../util/constants.dart';

class TabsContent {
  final String tabName;
  final String shortTabName;
  final Widget content;

  TabsContent(
      {required this.tabName,
      required this.shortTabName,
      required this.content});
}

class LanguageContent extends StatefulWidget {
  @override
  _LanguageContentState createState() => _LanguageContentState();
}

class _LanguageContentState extends State<LanguageContent> {
  int _activeTabIndex = 0; // Tracks the selected tab

  final List<TabsContent> tabsInfo = [
    TabsContent(
        tabName: 'Description',
        shortTabName: 'Description',
        content: Text('Description')),
    TabsContent(
        tabName: 'Phonetics',
        shortTabName: 'Phonetics',
        content: Text('Phonetics')),
    TabsContent(
        tabName: 'Orthography',
        shortTabName: 'Orthography',
        content: Text('Orthography')),
  ];

  // Method to change the active tab index
  void _onTabSelected(int index) {
    setState(() {
      _activeTabIndex = index;
    });
  }

// Widget for creating a new language

  @override
  Widget build(BuildContext context) {
    final cWSize = measureTextWidth('-', context);
    Map<int, TableColumnWidth> colmnWidth = {0: FixedColumnWidth(cWSize)};
    List<Widget> tabsColumns1 = [DBorder(data: ' ')];
    List<Widget> tabsColumns2 = [DBorder(data: ' ')];
    List<Widget> tabsColumns3 = [DBorder(data: '-')];
    for (var i = 0; i < tabsInfo.length; i++) {
      colmnWidth.addAll({
        1 + i * 2: FixedColumnWidth(cWSize),
        2 + i * 2: FixedColumnWidth(cWSize * (2 + tabsInfo[i].tabName.length))
      });
      tabsColumns1.add(_activeTabIndex == i || _activeTabIndex == i - 1
          ? DBorder(data: '+')
          : Container());
      tabsColumns1.add(_activeTabIndex == i ? HDash() : LDash());
      tabsColumns2.add(DBorder(data: '|'));
      tabsColumns2.add(TButton(
        onPressed: () => _onTabSelected(i),
        text: tabsInfo[i].tabName,
        color: _activeTabIndex == i ? LPColor.primaryColor : LPColor.greyColor,
        hover: LPColor.greyBrightColor,
      ));
      tabsColumns3.add(_activeTabIndex == i || _activeTabIndex == i - 1
          ? DBorder(data: '+')
          : DBorder(data: '-'));
      tabsColumns3.add(_activeTabIndex == i ? Container() : HDash());
    }
    colmnWidth.addAll({tabsInfo.length * 2 + 1: FixedColumnWidth(cWSize)});
    colmnWidth.addAll({tabsInfo.length * 2 + 2: FlexColumnWidth(1)});
    tabsColumns1.add(_activeTabIndex == tabsInfo.length - 1
        ? DBorder(data: '+')
        : Container());
    tabsColumns2.add(DBorder(data: '|'));
    tabsColumns3.add(_activeTabIndex == tabsInfo.length - 1
        ? DBorder(data: '+')
        : DBorder(data: '-'));
    tabsColumns1.add(Container());
    tabsColumns2.add(Container());
    tabsColumns3.add(HDash());
    var list = tabsInfo.map((e) => e.content).toList();
    return Column(
      children: [
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: TableBorder.all(style: BorderStyle.none),
          columnWidths: colmnWidth,
          children: [
            TableRow(children: tabsColumns1),
            TableRow(children: tabsColumns2),
            TableRow(children: tabsColumns3),
          ],
        ),
        Expanded(
          child: IndexedStack(
            index: _activeTabIndex,
            children: list,
          ),
        ),
      ],
    );
  }
}
