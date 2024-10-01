import 'package:flutter/material.dart';

class TButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;

  TButton(this.text, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanDown: (_) => onPressed!(),
      child: TextButton(
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, height: 0.0, fontFamily: 'Cousine', fontFeatures: [
            FontFeature.tabularFigures(),
          ]),
          maxLines: 1,
        ),
        onPressed: () => {},
        style: TextButton.styleFrom(
          foregroundColor: Color(0xffaf7fa8),
          minimumSize: Size.zero,
          padding: EdgeInsets.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          enableFeedback: false,
        ),
      ),
    );
    // return
  }
}
