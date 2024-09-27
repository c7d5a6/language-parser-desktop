import 'package:flutter/material.dart';

class OpenFileScreen extends StatelessWidget {
  final Function() onOpenFile;
  final Function() onNewFile;

  const OpenFileScreen({super.key, required this.onOpenFile, required this.onNewFile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('No file is currently opened.'),
            const SizedBox(height: 20),
            TextButton(onPressed: onNewFile, child: const Text('[ NEW ]')),
            TextButton(onPressed: onOpenFile, child: const Text('[ LOAD ]')),
          ],
        ),
      ),
    );
  }
}
