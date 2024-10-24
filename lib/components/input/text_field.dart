import 'package:flutter/material.dart';

import '../../util/constants.dart';

class TTextField extends StatelessWidget {
  final Function(String) onChanged;
  final TextEditingController controller;

  const TTextField({super.key, required this.onChanged, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      controller: controller,
      style: LPFont.defaultTextStyle.merge(TextStyle(color: LPColor.greyBrightColor)),
      decoration: InputDecoration.collapsed(
          hintText: 'Display Name',
          border: UnderlineInputBorder(),
          hintStyle: LPFont.defaultTextStyle.merge(TextStyle(color: LPColor.greyColor))),
    );
  }
}
