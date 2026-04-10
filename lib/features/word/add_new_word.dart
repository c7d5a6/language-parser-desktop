import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/border/border.dart';
import 'package:language_parser_desktop/components/border/hdash.dart';
import 'package:language_parser_desktop/components/buttons/t_button.dart';
import 'package:language_parser_desktop/components/input/dropdown_field.dart';
import 'package:language_parser_desktop/components/input/text_field.dart';
import 'package:language_parser_desktop/persistence/entities/language_entity.dart';
import 'package:language_parser_desktop/persistence/entities/pos_entity.dart';
import 'package:language_parser_desktop/persistence/entities/word_entity.dart';
import 'package:language_parser_desktop/persistence/repositories/invalidators/invalidator.dart';
import 'package:language_parser_desktop/persistence/repositories/word_repository.dart';
import 'package:language_parser_desktop/service_provider.dart';
import 'package:language_parser_desktop/services/language_service.dart';
import 'package:language_parser_desktop/services/pos_service.dart';
import 'package:language_parser_desktop/services/service_manager.dart';
import 'package:language_parser_desktop/services/word_service.dart';
import 'package:language_parser_desktop/text_measure_provider.dart';
import 'package:language_parser_desktop/util/constants.dart';

enum NewWordType { newWord }

class AddNewWord extends StatefulWidget {
  const AddNewWord({super.key});

  @override
  State<AddNewWord> createState() => _AddNewWordState();
}

class _AddNewWordState extends State<AddNewWord> implements Invalidator {
  ServiceManager? _serviceManager;
  late LanguageService _languageService;
  late PosService _posService;
  late WordService _wordService;

  final TextEditingController _wordController = TextEditingController();
  final TextEditingController _commentController = TextEditingController();

  List<Language> _languages = [];
  List<Pos> _poses = [];
  Set<int> _enabledPoses = {};

  int? _selectedLanguageId;
  int? _selectedPosId;
  NewWordType _selectedType = NewWordType.newWord;
  bool _saving = false;
  String _status = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final sm = ServiceProvider.of(context)?.serviceManager;
    if (_serviceManager != sm) {
      if (_serviceManager != null) {
        _serviceManager!.repositoryManager.removeLanguageInvalidator(this);
        _serviceManager!.repositoryManager.removePosInvalidator(this);
        _serviceManager!.repositoryManager.removePosLangConnectionInvalidator(this);
        _serviceManager!.repositoryManager.removeWordInvalidator(this);
      }
      _serviceManager = sm;
      _serviceManager!.repositoryManager.addLanguageInvalidator(this);
      _serviceManager!.repositoryManager.addPosInvalidator(this);
      _serviceManager!.repositoryManager.addPosLangConnectionInvalidator(this);
      _serviceManager!.repositoryManager.addWordInvalidator(this);
      _languageService = _serviceManager!.languageService;
      _posService = _serviceManager!.posService;
      _wordService = _serviceManager!.wordService;
      invalidate();
    }
  }

  @override
  void dispose() {
    _wordController.dispose();
    _commentController.dispose();
    _serviceManager?.repositoryManager.removeLanguageInvalidator(this);
    _serviceManager?.repositoryManager.removePosInvalidator(this);
    _serviceManager?.repositoryManager.removePosLangConnectionInvalidator(this);
    _serviceManager?.repositoryManager.removeWordInvalidator(this);
    super.dispose();
  }

  @override
  Future<void> invalidate() async {
    if (!mounted) return;
    final languages = _languageService.getAllLanguages()..sort((a, b) => a.displayName.compareTo(b.displayName));
    final poses = _posService.getAll()..sort((a, b) => a.name.compareTo(b.name));
    final selectedLanguageId = languages.any((l) => l.id == _selectedLanguageId)
        ? _selectedLanguageId
        : (languages.isNotEmpty ? languages.first.id : null);
    final enabledPoses = selectedLanguageId == null ? <int>{} : _posService.getPosIdsByLangId(selectedLanguageId);
    final selectedPosId = enabledPoses.contains(_selectedPosId) ? _selectedPosId : null;

    setState(() {
      _languages = languages;
      _poses = poses;
      _selectedLanguageId = selectedLanguageId;
      _enabledPoses = enabledPoses;
      _selectedPosId = selectedPosId;
    });
  }

  void _onLanguageChanged(int? languageId) {
    if (languageId == null) {
      return;
    }
    setState(() {
      _selectedLanguageId = languageId;
      _enabledPoses = _posService.getPosIdsByLangId(languageId);
      _selectedPosId = null;
      _status = '';
    });
  }

  Future<void> _onAddNewWord() async {
    final word = _wordController.text.trim();
    if (word.isEmpty || _selectedLanguageId == null || _selectedPosId == null || _saving) {
      return;
    }

    setState(() {
      _saving = true;
      _status = '';
    });
    try {
      _wordService.saveWord(WordCreatingModel(
        word,
        _selectedLanguageId!,
        _selectedPosId!,
        _commentController.text.trim().isEmpty ? null : _commentController.text.trim(),
        WordSource.newWord,
      ));
      setState(() {
        _saving = false;
        _wordController.clear();
        _commentController.clear();
        _selectedPosId = null;
        _status = 'Added new word';
      });
    } catch (e) {
      setState(() {
        _saving = false;
        _status = 'Failed to add word: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cWidth = TextMeasureProvider.of(context)!.characterWidth;
    final availablePoses = _poses.where((p) => _enabledPoses.contains(p.id)).toList(growable: false);
    final canSubmit = !_saving && _selectedLanguageId != null && _selectedPosId != null && _wordController.text.trim().isNotEmpty;

    return Table(
      columnWidths: {
        0: FixedColumnWidth(cWidth),
        1: FixedColumnWidth(11 * cWidth),
        2: FixedColumnWidth(cWidth),
        3: FixedColumnWidth(18 * cWidth),
        4: FixedColumnWidth(cWidth),
        5: FixedColumnWidth(8 * cWidth),
        6: FixedColumnWidth(cWidth),
        7: const FlexColumnWidth(1),
        8: FixedColumnWidth(cWidth),
      },
      children: [
        TableRow(children: _edge('+')),
        TableRow(children: [
          const DBorder(data: '|'),
          _label('LANGUAGE'),
          const DBorder(data: '|'),
          TDropdownField<int>(
            value: _selectedLanguageId,
            items: _languages
                .map((language) => DropdownMenuItem<int>(value: language.id, child: Text(language.displayName)))
                .toList(growable: false),
            onChanged: _onLanguageChanged,
          ),
          const DBorder(data: '|'),
          _label('TYPE'),
          const DBorder(data: '|'),
          TDropdownField<NewWordType>(
            value: _selectedType,
            items: const [DropdownMenuItem<NewWordType>(value: NewWordType.newWord, child: Text('NEW'))],
            onChanged: (value) {
              if (value != null) {
                setState(() {
                  _selectedType = value;
                });
              }
            },
          ),
          const DBorder(data: '|'),
        ]),
        TableRow(children: [
          const DBorder(data: '|'),
          _label('WORD'),
          const DBorder(data: '|'),
          TTextField(
            controller: _wordController,
            onChanged: (_) => setState(() => _status = ''),
            hint: 'word',
          ),
          const DBorder(data: '|'),
          _label('CATEGORY'),
          const DBorder(data: '|'),
          TDropdownField<int>(
            value: _selectedPosId,
            items: availablePoses
                .map((pos) => DropdownMenuItem<int>(value: pos.id, child: Text(pos.name)))
                .toList(growable: false),
            onChanged: (value) => setState(() {
              _selectedPosId = value;
              _status = '';
            }),
          ),
          const DBorder(data: '|'),
        ]),
        TableRow(children: [
          const DBorder(data: '|'),
          _label('COMMENT'),
          const DBorder(data: '|'),
          TTextField(
            controller: _commentController,
            onChanged: (_) => setState(() => _status = ''),
            hint: 'optional comment',
          ),
          const DBorder(data: '+'),
          const HDash(),
          const DBorder(data: '['),
          TButton(
            text: ' ADD NEW WORD ',
            color: LPColor.greenColor,
            hover: LPColor.greenBrightColor,
            disabled: !canSubmit,
            onPressed: _onAddNewWord,
          ),
          const DBorder(data: ']|'),
        ]),
        TableRow(children: [
          const DBorder(data: '|'),
          const HDash(),
          const DBorder(data: '|'),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              _status.isNotEmpty ? _status : 'Select category and enter word',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: LPFont.defaultTextStyle.merge(
                TextStyle(color: _status.isNotEmpty ? LPColor.greenColor : LPColor.greyColor),
              ),
            ),
          ),
          const DBorder(data: '|'),
          const HDash(),
          const DBorder(data: '+'),
          const HDash(),
          const DBorder(data: '+'),
        ]),
        TableRow(children: _edge('+')),
      ],
    );
  }

  Widget _label(String value) {
    return SelectionContainer.disabled(
      child: Text(
        value,
        style: LPFont.defaultTextStyle.merge(TextStyle(color: LPColor.greyColor)),
      ),
    );
  }

  List<Widget> _edge(String edgeSymbol) {
    return [
      DBorder(data: edgeSymbol),
      const HDash(),
      DBorder(data: edgeSymbol),
      const HDash(),
      DBorder(data: edgeSymbol),
      const HDash(),
      DBorder(data: edgeSymbol),
      const HDash(),
      DBorder(data: edgeSymbol),
    ];
  }
}
