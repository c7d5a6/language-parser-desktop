import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/border/border.dart';
import 'package:language_parser_desktop/components/border/hdash.dart';
import 'package:language_parser_desktop/components/buttons/t_button.dart';
import 'package:language_parser_desktop/persistence/repositories/language_repository.dart';
import 'package:language_parser_desktop/util/layout.dart';

import '../../persistence/entities/language_entity.dart';
import '../../service_provider.dart';
import '../../services/language_service.dart';
import '../../services/service_manager.dart';
import '../../util/constants.dart';

class LanguageDescription extends StatefulWidget {
  final int languageId;

  LanguageDescription(this.languageId);

  @override
  State<StatefulWidget> createState() => _LanguageDescription();
}

class _LanguageDescription extends State<LanguageDescription> {
  late TextEditingController _displayNameController = TextEditingController();
  ServiceManager? _serviceManager;
  late LanguageService _languageService;
  bool modified = false;
  late Language language;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final sm = ServiceProvider.of(context)?.serviceManager;
    if (_serviceManager != sm) {
      _displayNameController = TextEditingController();
      _serviceManager = sm;
      _languageService = _serviceManager!.languageService;
      _reloadLanguage();
    }
  }

  @override
  void didUpdateWidget(LanguageDescription oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.languageId != oldWidget.languageId) {
      _reloadLanguage();
    }
  }

  void _reloadLanguage() {
    language = _languageService.getLanguage(widget.languageId);
    setState(() {
      _displayNameController.text = language.displayName;
      modified = false;
    });
  }

  void saveLanguage() {
    log(_displayNameController.text);
    _languageService.persist(LanguageUpdatingModel(id: language.id, displayName: _displayNameController.text));
    _reloadLanguage();
  }

  @override
  Widget build(BuildContext context) {
    final canDelete = _languageService.canDelete(language.id);
    var cWidth = measureTextWidth('-', context);
    var emptyRow = TableRow(children: [
      Container(),
      DBorder(data: ' | '),
      Container(),
      DBorder(data: '|'),
    ]);
    return Column(children: [
      Table(
        columnWidths: {
          0: FixedColumnWidth(cWidth * ' Display name'.length),
          1: FixedColumnWidth(3 * cWidth),
          2: FlexColumnWidth(1),
          3: FixedColumnWidth(cWidth),
        },
        children: [
          emptyRow,
          TableRow(children: [
            DBorder(data: ' Display name'),
            DBorder(data: ' | '),
            TextFormField(
              onChanged: (word) {
                setState(() {
                  modified = true;
                });
              },
              controller: _displayNameController,
              style: LPFont.defaultTextStyle.merge(TextStyle(color: LPColor.greyBrightColor)),
              decoration: InputDecoration.collapsed(
                  hintText: 'Display Name',
                  border: UnderlineInputBorder(),
                  hintStyle: LPFont.defaultTextStyle.merge(TextStyle(color: LPColor.greyColor))),
            ),
            DBorder(data: '|'),
          ]),
          emptyRow,
        ],
      ),
      Table(
        columnWidths: {
          0: FlexColumnWidth(1),
          1: FixedColumnWidth(cWidth * 2),
          2: FixedColumnWidth(cWidth * 'Save'.length),
          3: FixedColumnWidth(cWidth * 5),
          4: FixedColumnWidth(cWidth * 'Delete'.length),
          5: FixedColumnWidth(cWidth * 4),
        },
        children: [
          TableRow(children: [
            HDash(),
            DBorder(data: '[ '),
            modified
                ? TButton(
                    text: 'Save',
                    onPressed: () => saveLanguage(),
                    color: LPColor.greenColor,
                    hover: LPColor.greenBrightColor,
                  )
                : DBorder(data: 'Save'),
            DBorder(data: ' ]-[ '),
            canDelete
                ? TButton(
                    text: 'Delete',
                    onPressed: () => _languageService.delete(language.id),
                    color: LPColor.redColor,
                    hover: LPColor.redBrightColor,
                  )
                : DBorder(data: 'Delete'),
            DBorder(data: ' ]-+'),
          ])
        ],
      )
    ]);

    // return ConstrainedBox(
    //   constraints: BoxConstraints(maxHeight: 800, maxWidth: 800),
    //   child: Column(
    //     children: [
    //       Text(language.displayName),
    //     ],
    //   ),
    // );
  }
}
