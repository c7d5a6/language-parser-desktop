import 'package:flutter/material.dart';
import 'package:language_parser_desktop/components/tabs/tabs.dart';

import 'add_new_word.dart';
import 'words_table.dart';

class Words extends StatelessWidget {
  const Words({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: constraints.maxWidth,
          constraints: const BoxConstraints(
            minWidth: 1,
            maxWidth: 3000,
          ),
          height: 1000,
          child: Tabs(
            tabsInfo: [
              TabContent(
                tabName: 'Add New',
                shortTabName: 'Add New',
                content: const AddNewWord(),
              ),
              TabContent(
                tabName: 'List',
                shortTabName: 'List',
                content: const WordsTable(),
              ),
            ],
          ),
        );
      },
    );
  }
}
