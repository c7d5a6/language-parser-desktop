import 'package:flutter/widgets.dart';

class TextMeasureProvider extends InheritedWidget {
  final double characterWidth;

  const TextMeasureProvider({super.key, required this.characterWidth, required super.child});

  static TextMeasureProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<TextMeasureProvider>();
  }

  @override
  bool updateShouldNotify(TextMeasureProvider oldWidget) {
    return this.characterWidth != oldWidget.characterWidth;
  }
}
