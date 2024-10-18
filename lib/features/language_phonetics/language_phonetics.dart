import 'package:flutter/material.dart';
import 'package:language_parser_desktop/features/language_phonetics/language_phonetics_plumonic_consonants.dart';
import 'package:language_parser_desktop/persistence/entities/language_phoneme_entity.dart';

import '../../service_provider.dart';
import '../../services/language_service.dart';
import '../../services/service_manager.dart';

class LanguagePhonetics extends StatefulWidget {
  final int? languageId;

  LanguagePhonetics(this.languageId);

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
    return Column(children: [
      LanguagePhoneticsPlumonicConsonants(phonemes: listOfLanguagePhonemes, disabled: disabled, onPress: updatePhoneme),
      // PhoneticButton(phonetic: 'a', languagePhonemes: listOfLanguagePhonemes, vowel: true, disabled: widget.languageId == null),
      // PhoneticButton(phonetic: 'i', languagePhonemes: listOfLanguagePhonemes, vowel: true, disabled: widget.languageId == null),
      // PhoneticButton(phonetic: 's', languagePhonemes: listOfLanguagePhonemes, consonant: true, disabled: widget.languageId == null),
      // PhoneticButton(phonetic: 'd', languagePhonemes: listOfLanguagePhonemes, consonant: true, disabled: widget.languageId == null),
      // PhoneticButton(phonetic: 'f', languagePhonemes: listOfLanguagePhonemes, disabled: widget.languageId == null),
      // PhoneticButton(phonetic: 'g', languagePhonemes: listOfLanguagePhonemes, consonant: true, disabled: widget.languageId == null),
      // PhoneticButton(phonetic: 'h', languagePhonemes: listOfLanguagePhonemes, disabled: widget.languageId == null),
      // PhoneticButton(phonetic: '1', languagePhonemes: listOfLanguagePhonemes, disabled: widget.languageId == null),
      // PhoneticButton(phonetic: '2', languagePhonemes: listOfLanguagePhonemes, disabled: widget.languageId == null),
      // PhoneticButton(phonetic: '3', languagePhonemes: listOfLanguagePhonemes, disabled: widget.languageId == null),
      // PhoneticButton(phonetic: '4', languagePhonemes: listOfLanguagePhonemes, consonant: true, disabled: widget.languageId == null),
    ]);
  }
}
