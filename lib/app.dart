import 'package:flutter/material.dart';

import 'features/word/words_list.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(10, 20),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(' [ TBD ] '),
            // TextButton(onPressed: newFile, child: const Text('[ NEW ]')),
            // TextButton(onPressed: openFile, child: const Text('[ LOAD ]')),
          ],
        ),
      ),
      bottomNavigationBar: Text(' f o o t e r '),
      body: SingleChildScrollView(
          child: Center(
              child: Column(
        children: [
          Padding(
              padding: EdgeInsets.all(16.0),
              child: SelectionArea(
                child: TableExample(),
              )),
        ],
      ))),
    );
  }
}
