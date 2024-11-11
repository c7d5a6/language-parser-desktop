import 'package:flutter/material.dart';

import '../../util/constants.dart';

class TTextField extends StatelessWidget {
  final Function(String) onChanged;
  final TextEditingController controller;
  final String? hint;

  const TTextField({super.key, required this.onChanged, required this.controller, this.hint});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      controller: controller,
      style: LPFont.defaultTextStyle.merge(TextStyle(color: LPColor.greyBrightColor)),
      decoration: InputDecoration.collapsed(
          hintText: hint,
          border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.red, width: 0.0)),
          hintStyle: LPFont.defaultTextStyle.merge(TextStyle(color: LPColor.greyColor))),
    );
  }
}
