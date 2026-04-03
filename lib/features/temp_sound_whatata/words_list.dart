import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:language_parser_desktop/services/service_manager.dart';
import 'package:language_parser_desktop/services/phonological_rules.dart';

import '../../service_provider.dart';

class TempSoundChhh extends StatefulWidget {
  const TempSoundChhh({super.key});

  @override
  State<TempSoundChhh> createState() => _TableExample();
}

class _TableExample extends State<TempSoundChhh> {
  String _rule = '';
  String _input = '';
  String _result = '';
  String _version = '';
  String _featuresQuery = '';
  String _distinctive = '';
  ServiceManager? serviceManager;
  late PhonologicalRules _phonologicalRules;

  @override
  void didChangeDependencies() {
    log("didChangeDependencies");
    super.didChangeDependencies();
    final sm = ServiceProvider.of(context)?.serviceManager;
    if (serviceManager != sm) {
      serviceManager = sm;
      _phonologicalRules = serviceManager!.phonologicalRules;
      _version = _phonologicalRules.version();
      _updateResult();
      _updateDistinctive();
    }
  } // @override

  void _updateResult() {
    if (_rule.trim().isEmpty || _input.trim().isEmpty) {
      setState(() {
        _result = '';
      });
      return;
    }

    final applyResult = _phonologicalRules.applyRule(_rule, _input);
    final nextResult = applyResult.isError
        ? (applyResult.error ?? 'Unknown error')
        : (applyResult.value ?? '');

    setState(() {
      _result = nextResult;
    });
  }

  void _updateDistinctive() {
    if (_featuresQuery.trim().isEmpty) {
      setState(() {
        _distinctive = '';
      });
      return;
    }
    final d = _phonologicalRules.distinctiveFeatures(_featuresQuery);
    setState(() {
      _distinctive = d;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextFormField(
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            labelText: 'Rule',
            hintText: 't > d / V_V',
          ),
          onChanged: (rule) {
            _rule = rule;
            _updateResult();
          },
        ),
        TextFormField(
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            labelText: 'Input',
            hintText: 'ata',
          ),
          onChanged: (input) {
            _input = input;
            _updateResult();
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Align(
            alignment: Alignment.center,
            child: Text(_result),
          ),
        ),
        const Divider(height: 32),
        SelectableText(
          _version.isEmpty ? 'Version: …' : 'Version: $_version',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        TextFormField(
          textAlign: TextAlign.center,
          decoration: const InputDecoration(
            labelText: 'Distinctive features',
            hintText: 'IPA or segment',
          ),
          onChanged: (q) {
            _featuresQuery = q;
            _updateDistinctive();
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: SelectableText(
            _featuresQuery.trim().isEmpty ? '' : _distinctive,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
