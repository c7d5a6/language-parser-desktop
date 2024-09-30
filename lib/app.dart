import 'package:flutter/material.dart';
import 'package:language_parser_desktop/util/layout.dart';

import 'features/language/languages.dart';

class App extends StatelessWidget {
  final Function() onOpenFile;
  final Function() onNewFile;

  const App({super.key, required this.onOpenFile, required this.onNewFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size(10, 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(' [ TBD ] '),
            TextButton(onPressed: onNewFile, child: const Text('[ NEW ]')),
            TextButton(onPressed: onOpenFile, child: const Text('[ LOAD ]')),
          ],
        ),
      ),
      bottomNavigationBar: const Text(' f o o t e r '),
      body: SingleChildScrollView(
          child: Center(
              child: Column(
                children: [
                  const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: SelectionArea(
                        child: Languages(),
                      )),
                  Container(width: measureTextWidth('-', context), height: 16, color: Colors.red,),
                  Text(
                    '-',
                    overflow: TextOverflow.fade,
                    style: const TextStyle(fontSize: 16, height: 0.0),
                    maxLines: 1,
                  ),
                ],
              ))),
    );
  }
}
