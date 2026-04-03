import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/border/border.dart';
import 'package:language_parser_desktop/components/buttons/t_button.dart';
import 'package:language_parser_desktop/features/grammar/grammar.dart';
import 'package:language_parser_desktop/features/temp_sound_whatata/words_list.dart';
import 'package:language_parser_desktop/features/word/words_list.dart';
import 'package:language_parser_desktop/service_provider.dart';
import 'package:language_parser_desktop/services/service_manager.dart';
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
  ServiceManager? _serviceManagerForPhonoVersion;
  String _phonoLibVersion = '';

  void setIndex(int i) {
    setState(() {
      _tabIndex = i;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final sp = ServiceProvider.of(context);
    if (sp == null) return;
    if (_serviceManagerForPhonoVersion != sp.serviceManager) {
      _serviceManagerForPhonoVersion = sp.serviceManager;
      _phonoLibVersion = sp.serviceManager.phonologicalRules.version();
    }
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
            TButton(text: '[GRAMMAR]', onPressed: () => setIndex(0)),
            DBorder(data: ' - '),
            TButton(text: '[LANGUAGES]', onPressed: () => setIndex(1)),
            DBorder(data: ' - '),
            TButton(text: '[EVOLUTION]', onPressed: () => setIndex(2)),
            DBorder(data: ' - '),
            TButton(text: '[WORDS]', onPressed: () => setIndex(3)),
            DBorder(data: ' - '),
            // TextButton(onPressed: widget.onNewFile, child: const Text('[ NEW ]')),
            // TextButton(onPressed: widget.onOpenFile, child: const Text('[ LOAD ]')),
          ],
        ),
      ),
      bottomNavigationBar: PreferredSize(
        preferredSize: Size(size.width, cHeight * 2),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            DBorder(data: ' - '),
            // TODO: refactor libs version
            SelectableText(
              _phonoLibVersion.isEmpty ? ' libph … ' : ' libph $_phonoLibVersion ',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            DBorder(data: ' - '),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.all(16.0 + paddingDelta),
                child: SelectionArea(
                  child: IndexedStack(
                    index: _tabIndex,
                    children: [
                      Grammar(),
                      Languages(),
                      TempSoundChhh(),
                      const Words(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
