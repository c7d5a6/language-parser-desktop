import 'dart:developer';
import 'dart:ffi';
import 'package:ffi/ffi.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:language_parser_desktop/services/service_manager.dart';
import 'package:language_parser_desktop/services/word_service.dart';

import '../../persistence/repositories/word_repository.dart';
import '../../service_provider.dart';

const libPath = 'assets/libph_lib.so';

class TempSoundChhh extends StatefulWidget {
  const TempSoundChhh({super.key});

  @override
  State<TempSoundChhh> createState() => _TableExample();
}

class _TableExample extends State<TempSoundChhh> {
  List<wrd> _words = [];
  String _w = "hello";
  ServiceManager? serviceManager;
  late WordService _wordService;

  DynamicLibrary loadLib() {
    if (Platform.isLinux) {
      return DynamicLibrary.open(libPath);
    }
    throw UnsupportedError("Platform not supported");
  }

  @override
  Future<void> didChangeDependencies() async {
    log("didChangeDependencies");
    super.didChangeDependencies();
    final sm = ServiceProvider.of(context)?.serviceManager;
    if (serviceManager != sm) {
      serviceManager = sm;
      _wordService = serviceManager!.wordService;
      await _regenerateWords(null);
    }
  } // @override

  String distinctive(String input, DynamicLibrary lib) {
    final distinctiveFeatures = lib
        .lookupFunction<
          Pointer<Utf8> Function(Pointer<Utf8>),
          Pointer<Utf8> Function(Pointer<Utf8>)
        >("distinctiveFeatures");
    final cStr = input.toNativeUtf8();
    final ptr = distinctiveFeatures(cStr);
    malloc.free(cStr);
    final output = ptr.toDartString();
    // destroyStr(ptr);
    return output;
  }

  Future<void> _regenerateWords(String? search) async {
    log("regenerate words");
    var lib = loadLib();
    final version = lib
        .lookupFunction<Pointer<Utf8> Function(), Pointer<Utf8> Function()>(
          "version",
        );
    // var wrds = await _wordService.getWords(25, search ?? '');
    var v = version().toDartString();
    var d = null;
    if (search != null)
      d = distinctive(search, lib);
    else
      d = " empty";
    setState(() {
      _words = [];
      _w = v + " " + d;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextFormField(
          textAlign: TextAlign.center,
          onChanged: (word) => _regenerateWords(word),
        ),
        Text(_w),
      ],
    );
  }
}
