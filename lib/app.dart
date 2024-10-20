import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/border/border.dart';
import 'package:language_parser_desktop/components/buttons/t_button.dart';
import 'package:language_parser_desktop/features/grammar/grammar.dart';

import 'features/language/languages.dart';

class App extends StatefulWidget {
  final Function() onOpenFile;
  final Function() onNewFile;

  const App({super.key, required this.onOpenFile, required this.onNewFile});

  @override
  State<StatefulWidget> createState() => _App();
}

class _App extends State<App> {
  int _tabIndex = 0;

  void setIndex(int i) {
    setState(() {
      _tabIndex = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(10, 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TButton(text: '[ LANGUAGES ]', onPressed: () => setIndex(0)),
            DBorder(data: ' - '),
            TButton(text: '[ GRAMMAR ]', onPressed: () => setIndex(1)),
            const Text(' [ TBD ] '),
            TextButton(onPressed: widget.onNewFile, child: const Text('[ NEW ]')),
            TextButton(onPressed: widget.onOpenFile, child: const Text('[ LOAD ]')),
          ],
        ),
      ),
      bottomNavigationBar: const Text(' f o o t e r '),
      body: SingleChildScrollView(
          child: Center(
              child: Column(
        children: [
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: SelectionArea(
                  child: IndexedStack(
                index: _tabIndex,
                children: [Languages(), Grammar()],
              ))),
        ],
      ))),
    );
  }
}
