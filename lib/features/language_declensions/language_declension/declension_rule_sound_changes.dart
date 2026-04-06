import 'package:flutter/material.dart';
import 'dart:developer';
import 'package:language_parser_desktop/components/sound_changes/sound_change_item.dart';
import 'package:language_parser_desktop/components/sound_changes/sound_changes.dart';
import 'package:language_parser_desktop/persistence/entities/declension_rule_sound_change_entity.dart';
import 'package:language_parser_desktop/persistence/repositories/invalidators/invalidator.dart';
import 'package:language_parser_desktop/service_provider.dart';
import 'package:language_parser_desktop/services/declension_service.dart';
import 'package:language_parser_desktop/services/service_manager.dart';

class DeclensionRuleSoundChanges extends StatefulWidget {
  final int ruleId;

  const DeclensionRuleSoundChanges({super.key, required this.ruleId});

  @override
  State<DeclensionRuleSoundChanges> createState() => _DeclensionRuleSoundChangesState();
}

class _DeclensionRuleSoundChangesState extends State<DeclensionRuleSoundChanges> implements Invalidator {
  ServiceManager? _serviceManager;
  DeclensionService? _declensionService;
  final TextEditingController _editorController = TextEditingController();

  bool _isTableEditMode = false;
  List<DeclensionRuleSoundChange> _soundChanges = const [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final sm = ServiceProvider.of(context)?.serviceManager;
    if (_serviceManager != sm) {
      if (_serviceManager != null) {
        _serviceManager!.repositoryManager.removeDeclensionRuleSoundChangeInvalidator(this);
      }
      _serviceManager = sm;
      _declensionService = sm?.declensionService;
      _serviceManager?.repositoryManager.addDeclensionRuleSoundChangeInvalidator(this);
      _reload();
    }
  }

  @override
  void didUpdateWidget(covariant DeclensionRuleSoundChanges oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ruleId != widget.ruleId) {
      _isTableEditMode = false;
      _reload();
      setState(() {});
    }
  }

  @override
  void dispose() {
    _serviceManager?.repositoryManager.removeDeclensionRuleSoundChangeInvalidator(this);
    _editorController.dispose();
    super.dispose();
  }

  @override
  Future<void> invalidate() async {
    _reload();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return SoundChangesTable(
      soundChanges: _soundChanges
          .map(
            (row) => SoundChangeSqlRow(
              id: row.id,
              soundChange: row.change,
              isCorrect: row.isCorrect,
            ),
          )
          .toList(growable: false),
      isTableEditMode: _isTableEditMode,
      editorController: _editorController,
      onEditorChanged: (_) => setState(() {}),
      onEditRequested: () {
        setState(() {
          _editorController.text = _composeEditorValue();
          _isTableEditMode = true;
        });
      },
      onCancelEdit: () {
        setState(() {
          _editorController.text = _composeEditorValue();
          _isTableEditMode = false;
        });
      },
      onSaveAll: () {
        _declensionService?.replaceRuleSoundChangesFromEditor(widget.ruleId, _editorController.text);
        setState(() {
          _isTableEditMode = false;
        });
      },
      onSaveRow: (SoundChangeItem updatedRow) {
        _declensionService?.updateRuleSoundChange(updatedRow.id, updatedRow.soundChange);
      },
      onDelete: (int id) {
        log('DeclensionRuleSoundChanges.onDelete: ruleId=${widget.ruleId} soundChangeId=$id');
        _declensionService?.deleteRuleSoundChange(id);
      },
    );
  }

  void _reload() {
    _soundChanges = _declensionService?.getRuleSoundChanges(widget.ruleId) ?? const [];
    if (!_isTableEditMode) {
      _editorController.text = _composeEditorValue();
    }
  }

  String _composeEditorValue() {
    return _soundChanges.map((e) => e.change).join('\n');
  }
}
