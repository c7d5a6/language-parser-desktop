import 'package:flutter/material.dart';

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
      body: const SingleChildScrollView(
          child: Center(
              child: Column(
        children: [
          Padding(
              padding: EdgeInsets.all(16.0),
              child: SelectionArea(
                child: Languages(),
              )),
        ],
      ))),
    );
  }
}
