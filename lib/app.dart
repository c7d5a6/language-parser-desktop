import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/border/border.dart';
import 'package:language_parser_desktop/components/buttons/t_button.dart';
import 'package:language_parser_desktop/features/grammar/grammar.dart';
import 'package:language_parser_desktop/text_measure_provider.dart';
import 'package:language_parser_desktop/util/layout.dart';

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
    final size = MediaQuery.sizeOf(context);
    log('main size $size');
    final cHeight = measureTextHeight('|', context);
    final cWidth = TextMeasureProvider.of(context)!.characterWidth;
    final paddingDelta = ((size.width - 16 * 2) % cWidth) / 2;
    log('main padding delta $paddingDelta');
    log('main padding delta ${1238.6 / cWidth}');
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(size.width, cHeight * 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DBorder(data: ' - '),
            TButton(text: '[LANGUAGES]', onPressed: () => setIndex(0)),
            DBorder(data: ' - '),
            TButton(text: '[GRAMMAR]', onPressed: () => setIndex(1)),
            DBorder(data: ' - '),
            TextButton(onPressed: widget.onNewFile, child: const Text('[ NEW ]')),
            TextButton(onPressed: widget.onOpenFile, child: const Text('[ LOAD ]')),
          ],
        ),
      ),
      bottomNavigationBar:
          PreferredSize(preferredSize: Size(size.width, cHeight * 2), child: const Text(' f o o t e r ')),
      body: SingleChildScrollView(
          child: Center(
              child: Column(
        children: [
          Padding(
              padding: EdgeInsets.all(16.0 + paddingDelta),
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
