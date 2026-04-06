import 'package:flutter/material.dart';

import '../../util/constants.dart';

class TTextField extends StatelessWidget {
  final Function(String) onChanged;
  final TextEditingController controller;
  final String? hint;
  final bool? enabled;
  final int? minLines;
  final int? maxLines;

  const TTextField({
    super.key,
    required this.onChanged,
    required this.controller,
    this.hint,
    this.enabled,
    this.minLines,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enabled,
      onChanged: onChanged,
      controller: controller,
      minLines: minLines,
      maxLines: maxLines,
      keyboardType: (maxLines != null && maxLines! > 1) || (minLines != null && minLines! > 1)
          ? TextInputType.multiline
          : TextInputType.text,
      style: LPFont.defaultTextStyle.merge(TextStyle(color: LPColor.greyBrightColor)),
      decoration: InputDecoration.collapsed(
        hintText: hint,
        border: UnderlineInputBorder(borderSide: BorderSide(color: LPColor.greyColor, width: 0.0)),
        hintStyle: LPFont.defaultTextStyle.merge(TextStyle(color: LPColor.greyColor)),
      ),
    );
  }
}
