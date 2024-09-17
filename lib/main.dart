import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'features/word/words_list.dart';
import 'util/sqlite.dart' as sl;

void main() async {
  // generateSQL();
  // initDB();
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
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.black87, brightness: Brightness.dark),
        useMaterial3: true,
        textTheme: GoogleFonts.ubuntuMonoTextTheme(textTheme),
        brightness: Brightness.dark,
      ),
      home: const MyHomePage(title: 'Language Parser Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _nwFile() async {
    var file = await FilePicker.platform.saveFile();
    if (file != null) {
      print("File $file");
      sl.newDb(file);
    }
    _incrementCounter();
  }

  void _opnFile() async {
    var file = await FilePicker.platform.pickFiles();
    if (file != null) {
      print("File $file");
      sl.setDb(file.files[0].path!);
    }
    _incrementCounter();
  }

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
          // Center is a layout widget. It takes a single child and positions it
          // in the middle of the parent.
          child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextButton(onPressed: _nwFile, child: const Text('[ NEW ]')),
              TextButton(onPressed: _opnFile, child: const Text('[ LOAD ]')),
            ],
          ),
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: SelectionArea(
                child:
                    _counter > 0 ? const TableExample() : const Text('NO DATA'),
              )),
        ],
      )),
    );
  }
}
