import 'package:flutter/material.dart';
import 'package:language_parser_desktop/persistence/entities/language_phoneme_entity.dart';
import 'package:language_parser_desktop/persistence/repositories/invalidators/invalidator.dart';
import 'package:language_parser_desktop/service_provider.dart';

import '../../services/service_manager.dart';

class GrammarGrammaticalCategories extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _GrammarGrammaticalCategories();
}

class _GrammarGrammaticalCategories extends State<GrammarGrammaticalCategories> implements Invalidator {
  ServiceManager? _serviceManager;
  late List<LanguagePhoneme>? ph;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final sm = ServiceProvider.of(context)?.serviceManager;
    if (_serviceManager != sm) {
      if (_serviceManager != null) {
        _serviceManager!.repositoryManager.removeLanguagePhonemeInvalidator(this);
      }
      _serviceManager = sm;
      _serviceManager!.repositoryManager.addLanguagePhonemeInvalidator(this);
    }
    update();
  }

  void update() {
    setState(() {
      ph = _serviceManager?.languageService.getLanguagePhonemes(1).selectedMainPhonemes;
    });
  }

  @override
  void dispose() {
    _serviceManager!.repositoryManager.removeLanguagePhonemeInvalidator(this);
    super.dispose();
  }

  @override
  void invalidate() {
    update();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: ph == null ? [] : ph!.map((ph) => Text(ph.phoneme)).toList());
  }
}
