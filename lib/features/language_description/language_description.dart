import 'package:flutter/material.dart';

import '../../persistence/entities/language_entity.dart';
import '../../service_provider.dart';
import '../../services/language_service.dart';
import '../../services/service_manager.dart';

class LanguageDescription extends StatefulWidget {
  final int languageId;

  LanguageDescription(this.languageId);

  @override
  State<StatefulWidget> createState() => _LanguageDescription();
}

class _LanguageDescription extends State<LanguageDescription> {
  ServiceManager? _serviceManager;
  late LanguageService _languageService;
  late Language language;


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final sm = ServiceProvider.of(context)?.serviceManager;
    if (_serviceManager != sm) {
      _serviceManager = sm;
      _languageService = _serviceManager!.languageService;
      _reloadLanguage();
    }
  }

  @override
  void didUpdateWidget(LanguageDescription oldWidget) {
    super.didUpdateWidget(oldWidget);
    if(widget.languageId != oldWidget.languageId){
      _reloadLanguage();
    }
  }

  void _reloadLanguage() {
    language = _languageService.getLanguage(widget.languageId);
  }

  @override
  Widget build(BuildContext context) {
    final txtController = TextEditingController(text: language.displayName);
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 800, maxWidth: 800),
      child: Column(
        children: [
          TextFormField(
            onChanged: (word) => {},
            controller: txtController,
          ),
          Text(language.displayName),
        ],
      ),
    );
  }

}
