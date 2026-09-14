import 'package:flutter/material.dart';
import 'package:language_parser_desktop/features/language_phonetics/language_phonetics_non_pulmonic_consonants.dart';
import 'package:language_parser_desktop/features/language_phonetics/language_phonetics_other_phonemes.dart';
import 'package:language_parser_desktop/features/language_phonetics/language_phonetics_plumonic_consonants.dart';
import 'package:language_parser_desktop/features/language_phonetics/language_phonetics_vowels.dart';
import 'package:language_parser_desktop/persistence/entities/language_phoneme_entity.dart';

import '../../service_provider.dart';
import '../../services/language_service.dart';
import '../../services/service_manager.dart';

class LanguagePhonetics extends StatefulWidget {
  final int? languageId;

  const LanguagePhonetics(this.languageId, {super.key});

  @override
  State<StatefulWidget> createState() => _LanguagePhonetics();
}

class _LanguagePhonetics extends State<LanguagePhonetics> {
  ServiceManager? _serviceManager;
  late LanguageService _languageService;
  late ListOfLanguagePhonemes listOfLanguagePhonemes;
  late bool disabled;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final sm = ServiceProvider.of(context)?.serviceManager;
    if (_serviceManager != sm) {
      _serviceManager = sm;
      _languageService = _serviceManager!.languageService;
      _reloadPhonetics();
    }
  }

  @override
  void initState() {
    super.initState();
    disabled = widget.languageId == null;
  }

  @override
  void didUpdateWidget(LanguagePhonetics oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.languageId != oldWidget.languageId) {
      var d = widget.languageId == null;
      if (d != disabled) {
        setState(() {
          disabled = d;
        });
      }
      _reloadPhonetics();
    }
  }

  void _reloadPhonetics() {
    final l = widget.languageId != null
        ? _languageService.getLanguagePhonemes(widget.languageId!)
        : ListOfLanguagePhonemes(0, [], [], [], []);
    setState(() {
      listOfLanguagePhonemes = l;
    });
  }

  void updatePhoneme(String phoneme) {
    if (widget.languageId == null) return;
    final List<LanguagePhoneme> phonemes = List.empty(growable: true)
      ..addAll(listOfLanguagePhonemes.selectedMainPhonemes)
      ..addAll(listOfLanguagePhonemes.selectedRestPhonemes);
    final idx = phonemes.indexWhere((ph) => ph.phoneme == phoneme);
    if (idx != -1) {
      _languageService.deletePhoneme(phonemes[idx].id);
    } else {
      _languageService.addPhoneme(widget.languageId!, phoneme);
    }
    _reloadPhonetics();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          LanguagePhoneticsPlumonicConsonants(
              phonemes: listOfLanguagePhonemes, disabled: disabled, onPress: updatePhoneme),
          LanguagePhoneticsVowels(phonemes: listOfLanguagePhonemes, disabled: disabled, onPress: updatePhoneme),
          LanguagePhoneticsNonPulmonicConsonants(
              phonemes: listOfLanguagePhonemes, disabled: disabled, onPress: updatePhoneme),
          LanguagePhoneticsOtherPhonemes(
              phonemes: listOfLanguagePhonemes, disabled: disabled, onPress: updatePhoneme),
        ],
      ),
    );
  }
}
