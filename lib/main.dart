import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:language_parser_desktop/app.dart';
import 'package:language_parser_desktop/features/open_file/open_file_screen.dart';
import 'package:language_parser_desktop/persistence/repository_manager.dart';
import 'package:language_parser_desktop/service_provider.dart';
import 'package:language_parser_desktop/services/service_manager.dart';
import 'package:language_parser_desktop/text_measure_provider.dart';
import 'package:language_parser_desktop/util/constants.dart';
import 'package:language_parser_desktop/util/layout.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Language parser Demo',
      theme: ThemeData(
        inputDecorationTheme: InputDecorationTheme(
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: LPColor.primaryColor, width: 1.0)),
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: LPColor.greyColor, width: 1.0))),
        colorScheme: ColorScheme.fromSeed(
            seedColor: Color(0xffaf7fa8), brightness: Brightness.dark, surface: LPColor.backgroundColor),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16, height: 0.0, fontFamily: 'Cousine', fontFeatures: [
            FontFeature.tabularFigures(),
          ]),
          labelMedium: TextStyle(fontSize: 16, height: 0.0, fontFamily: 'Cousine', fontFeatures: [
            FontFeature.tabularFigures(),
          ]),
          displayMedium: TextStyle(fontSize: 16, height: 0.0, fontFamily: 'Cousine', fontFeatures: [
            FontFeature.tabularFigures(),
          ]),
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
  String? _filePath;
  late RepositoryManager _repositoryManager;
  ServiceManager? _serviceManager;

  bool get isFileOpened => _filePath != null;

  @override
  void initState() {
    super.initState();
    _repositoryManager = RepositoryManager();
  }

  void newFile() async {
    var filePath = await FilePicker.platform.saveFile();
    if (filePath != null) {
      _repositoryManager.openDatabase(filePath);
      _serviceManager = ServiceManager(_repositoryManager);
    } else {
      _repositoryManager.dispose();
      _serviceManager = null;
    }
    setState(() {
      _filePath = filePath;
    });
  }

  void openFile() async {
    var file = await FilePicker.platform.pickFiles();
    if (kDebugMode && file != null) {
      assert(file.files.isNotEmpty);
    }
    var filePath = file?.files[0].path;
    if (filePath != null) {
      _repositoryManager.openDatabase(filePath);
      _serviceManager = ServiceManager(_repositoryManager);
    } else {
      _repositoryManager.dispose();
      _serviceManager = null;
    }
    setState(() {
      _filePath = filePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: TextMeasureProvider(
      characterWidth: measureTextWidth('a', context),
      child: isFileOpened
          ? ServiceProvider(_serviceManager!,
              child: App(
                onOpenFile: openFile,
                onNewFile: newFile,
              ))
          : OpenFileScreen(
              onOpenFile: openFile,
              onNewFile: newFile,
            ),
    ));
  }
}
