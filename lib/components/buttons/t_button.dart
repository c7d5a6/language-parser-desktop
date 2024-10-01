import 'package:flutter/material.dart';

class TButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;

  TButton(this.text, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: const TextStyle(fontSize: 16, height: 0.0, fontFamily: 'Cousine', fontFeatures: [
          FontFeature.tabularFigures(),
        ]),
        maxLines: 1,
      ),
      style: TextButton.styleFrom(
        minimumSize: Size.zero,
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        enableFeedback: false,
      ),
    );
  }
}
