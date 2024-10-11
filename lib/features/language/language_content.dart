import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/border/border.dart';
import 'package:language_parser_desktop/components/border/hdash.dart';
import 'package:language_parser_desktop/components/buttons/t_button.dart';
import 'package:language_parser_desktop/util/layout.dart';

class LanguageContent extends StatefulWidget {
  @override
  _LanguageContentState createState() => _LanguageContentState();
}

class _LanguageContentState extends State<LanguageContent> {
  int _activeTabIndex = 0; // Tracks the selected tab

  final List<String> tabs = ['General', 'Localization', 'Advanced'];

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
    return Table(
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: TableBorder.all(style: BorderStyle.none),
      columnWidths: <int, TableColumnWidth>{
        0: FixedColumnWidth(cWSize),
        1: FixedColumnWidth(cWSize),
        2: FlexColumnWidth(1),
        3: FixedColumnWidth(cWSize),
        4: FlexColumnWidth(1),
        5: FixedColumnWidth(cWSize),
      },
      children: [
        TableRow(children: [
          DBorder(data: ' '),
          Container(),
          Container(),
          Container(),
          Container(),
          Container(),
        ]),
        TableRow(
          children: [
            DBorder(data: ' '),
            DBorder(data: '+'),
            HDash(),
            DBorder(data: '+'),
            HDash(),
            DBorder(data: '+'),
          ],
        ),
        TableRow(
          children: [
            DBorder(data: '_'),
            DBorder(data: '|'),
            TButton(
              onPressed: () => _onTabSelected(0),
              text: 'Fisrt Tab',
            ),
            DBorder(data: '|'),
            TButton(
              onPressed: () => _onTabSelected(1),
              text: 'Second Tab',
            ),
            DBorder(data: '|'),
          ],
        ),
      ],
    );
  }
}

// import 'package:flutter/material.dart';
//
// class LanguageSettingsTabs extends StatefulWidget {
//   @override
//   _LanguageSettingsTabsState createState() => _LanguageSettingsTabsState();
// }
//
// class _LanguageSettingsTabsState extends State<LanguageSettingsTabs> {
//   int _activeTabIndex = 0; // Tracks the selected tab
//
//   final List<String> tabs = ['General', 'Localization', 'Advanced'];
//
//   // Method to change the active tab index
//   void _onTabSelected(int index) {
//     setState(() {
//       _activeTabIndex = index;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Language Settings')),
//       body: Column(
//         children: [
//           // Custom tab headers
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: List.generate(tabs.length, (index) {
//               return GestureDetector(
//                 onTap: () => _onTabSelected(index),
//                 child: Container(
//                   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                   decoration: BoxDecoration(
//                     border: Border.all(color: Colors.black),
//                     color: _activeTabIndex == index ? Colors.grey : Colors.white,
//                   ),
//                   child: Text(
//                     _asciiTabLabel(tabs[index]),
//                     style: TextStyle(fontFamily: 'Courier'),
//                   ),
//                 ),
//               );
//             }),
//           ),
//
//           // Content of the selected tab
//           Expanded(
//             child: IndexedStack(
//               index: _activeTabIndex,
//               children: [
//                 Center(child: Text('General Settings')),
//                 Center(child: Text('Localization Settings')),
//                 Center(child: Text('Advanced Settings')),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // Simulate ASCII graphics for tab labels
//   String _asciiTabLabel(String tabName) {
//     return '[$tabName]';
//   }
// }
//
// void main() => runApp(MaterialApp(home: LanguageSettingsTabs()));
