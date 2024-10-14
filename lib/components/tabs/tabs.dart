import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/border/border.dart';
import 'package:language_parser_desktop/components/border/ldash.dart';
import 'package:language_parser_desktop/util/layout.dart';

import '../../components/border/hdash.dart';
import '../../components/buttons/t_button.dart';
import '../../util/constants.dart';

class TabContent {
  final String tabName;
  final String shortTabName;
  final Widget content;

  TabContent({required this.tabName, required this.shortTabName, required this.content});
}

class Tabs extends StatefulWidget {
  final List<TabContent> tabsInfo;

  const Tabs({super.key, required this.tabsInfo});

  @override
  _TabsState createState() => _TabsState();
}

class _TabsState extends State<Tabs> {
  int _activeTabIndex = 0;

  void _onTabSelected(int index) {
    setState(() {
      _activeTabIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cWSize = measureTextWidth('-', context);
    Map<int, TableColumnWidth> columnWidth = {0: FixedColumnWidth(cWSize)};
    List<Widget> tabsColumns1 = [DBorder(data: ' ')];
    List<Widget> tabsColumns2 = [DBorder(data: ' ')];
    List<Widget> tabsColumns3 = [DBorder(data: '-')];
    for (var i = 0; i < widget.tabsInfo.length; i++) {
      columnWidth.addAll({
        1 + i * 2: FixedColumnWidth(cWSize),
        2 + i * 2: FixedColumnWidth(cWSize *
            (2 + (_activeTabIndex == i ? widget.tabsInfo[i].tabName.length : widget.tabsInfo[i].shortTabName.length)))
      });
      tabsColumns1.add(_activeTabIndex == i || _activeTabIndex == i - 1 ? DBorder(data: '+') : Container());
      tabsColumns1.add(_activeTabIndex == i ? HDash() : LDash());
      tabsColumns2.add(DBorder(data: '|'));
      tabsColumns2.add(TButton(
        onPressed: () => _onTabSelected(i),
        text: _activeTabIndex == i ? widget.tabsInfo[i].tabName : widget.tabsInfo[i].shortTabName,
        color: _activeTabIndex == i ? LPColor.primaryColor : LPColor.greyColor,
        hover: LPColor.greyBrightColor,
      ));
      tabsColumns3.add(_activeTabIndex == i || _activeTabIndex == i - 1 ? DBorder(data: '+') : DBorder(data: '-'));
      tabsColumns3.add(_activeTabIndex == i ? Container() : HDash());
    }
    columnWidth.addAll({widget.tabsInfo.length * 2 + 1: FixedColumnWidth(cWSize)});
    columnWidth.addAll({widget.tabsInfo.length * 2 + 2: FlexColumnWidth(1)});
    columnWidth.addAll({widget.tabsInfo.length * 2 + 3: FixedColumnWidth(cWSize)});
    tabsColumns1.add(_activeTabIndex == widget.tabsInfo.length - 1 ? DBorder(data: '+') : Container());
    tabsColumns2.add(DBorder(data: '|'));
    tabsColumns3.add(_activeTabIndex == widget.tabsInfo.length - 1 ? DBorder(data: '+') : DBorder(data: '-'));
    tabsColumns1.add(Container());
    tabsColumns2.add(Container());
    tabsColumns3.add(HDash());
    tabsColumns1.add(Container());
    tabsColumns2.add(Container());
    tabsColumns3.add(DBorder(data: '+'));
    var list = widget.tabsInfo.map((e) => e.content).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Table(
          defaultVerticalAlignment: TableCellVerticalAlignment.middle,
          border: TableBorder.all(style: BorderStyle.none),
          columnWidths: columnWidth,
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
