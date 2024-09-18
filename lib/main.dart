import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:language_parser_desktop/util/letters.dart';

import 'features/word/words_list.dart';
import 'util/sqlite.dart' as sl;

void main() async {
  runApp(const MyApp());
  sl.main();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final textTheme =
        Theme.of(context).textTheme.apply(bodyColor: Colors.white70);
    return MaterialApp(
      title: 'Language parser Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.black87, brightness: Brightness.dark),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            fontSize: 16,
            height: 0.0,
            fontFamily: 'Cousine',
            fontFeatures: [
              FontFeature.tabularFigures(),
            ]
          ),
          labelMedium: TextStyle(
              fontSize: 16,
              height: 0.0,
              fontFamily: 'Cousine',
              fontFeatures: [
                FontFeature.tabularFigures(),
              ]
          ),
          displayMedium: TextStyle(
              fontSize: 16,
              height: 0.0,
              fontFamily: 'Cousine',
              fontFeatures: [
                FontFeature.tabularFigures(),
              ]
          ),
        ),
        brightness: Brightness.dark,
      ),
      home: const MyHomePage(title: 'Language Parser Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _nwFile() async {
    var file = await FilePicker.platform.saveFile();
    if (file != null) {
      log("File $file");
      sl.newDb(file);
    }
    _incrementCounter();
  }

  void _opnFile() async {
    var file = await FilePicker.platform.pickFiles();
    if (file != null) {
      log("File $file");
      sl.setDb(file.files[0].path!);
    }
    _incrementCounter();
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
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
            const Text(' [ TBD ] '),
            TextButton(onPressed: _nwFile, child: const Text('[ NEW ]')),
            TextButton(onPressed: _opnFile, child: const Text('[ LOAD ]')),
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
                child:
                    _counter > 0 ? const TableExample() : const Text('NO DATA'),
              )),
        ],
      ))),
    );
  }
}
