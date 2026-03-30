import 'package:flutter/material.dart';

import '../../util/constants.dart';

class TDropdownField<T> extends StatelessWidget {
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final bool enabled;

  const TDropdownField({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        highlightColor: LPColor.primaryColor,
        splashColor: LPColor.primaryColor,
      ),
      child: SizedBox(
        height: LPFont.fontSize + 2,
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            value: value,
            isDense: true,
            iconSize: 14,
            dropdownColor: LPColor.backgroundColor,
            style: LPFont.defaultTextStyle.merge(TextStyle(color: LPColor.greyBrightColor)),
            items: items,
            onChanged: enabled ? onChanged : null,
          ),
        ),
      ),
    );
  }
}
