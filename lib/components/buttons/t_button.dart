import 'package:flutter/material.dart';
import 'package:language_parser_desktop/util/constants.dart';

class TButton extends StatefulWidget {
  final String _text;
  final void Function()? _onPressed;
  final Color? _color;
  final Color? _hover;
  final Color? _background;
  final bool disabled;

  const TButton(
      {super.key, required text, onPressed, color = LPColor.primaryColor, hover, background, this.disabled = false})
      : _text = text,
        _onPressed = onPressed,
        _color = color,
        _hover = hover == null ? color : hover,
        _background = background == null ? Colors.transparent : background;

  @override
  State<StatefulWidget> createState() => _TButton();
}

class _TButton extends State<TButton> {
  bool hover = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return MouseRegion(
        onEnter: (_) => setState(() => hover = true),
        onExit: (_) => setState(() => hover = false),
        child: GestureDetector(
          onPanDown: widget._onPressed == null ? null : (_) => widget._onPressed!(),
          child: TextButton(
            child: Text(
              widget._text,
              style: LPFont.defaultTextStyle,
              maxLines: 1,
              overflow: TextOverflow.visible,
            ),
            onPressed: widget.disabled ? null : () => {},
            style: TextButton.styleFrom(
                foregroundColor: hover ? widget._hover : widget._color,
                backgroundColor: widget._background,
                minimumSize: Size.zero,
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                enableFeedback: false,
                animationDuration: Duration()),
          ),
        ),
      );
    });
  }
}
