import 'package:flutter/material.dart';
import 'package:language_parser_desktop/util/constants.dart';

class TButton extends StatefulWidget {
  final String _text;
  final void Function()? _onPressed;
  final Color? _color;
  final Color? _hover;

  const TButton({super.key, required text, onPressed, color = LPColor.primaryColor, hover})
      : _text = text,
        _onPressed = onPressed,
        _color = color,
        _hover = hover == null ? color : hover;

  @override
  State<StatefulWidget> createState() => _TButton();
}

class _TButton extends State<TButton> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => hover = true),
      onExit: (_) => setState(() => hover = false),
      child: GestureDetector(
        onPanDown: (_) => widget._onPressed!(),
        child: TextButton(
          child: Text(
            widget._text,
            style: const TextStyle(fontSize: 16, height: 0.0, fontFamily: 'Cousine', fontFeatures: [
              FontFeature.tabularFigures(),
            ]),
            maxLines: 1,
          ),
          onPressed: () => {},
          style: TextButton.styleFrom(
            foregroundColor: hover ? widget._hover : widget._color,
            minimumSize: Size.zero,
            padding: EdgeInsets.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            enableFeedback: false,
          ),
        ),
      ),
    );
  }
}
