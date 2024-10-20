import 'package:flutter/cupertino.dart';
import 'package:language_parser_desktop/components/border/border.dart';
import 'package:language_parser_desktop/components/buttons/t_button.dart';
import 'package:language_parser_desktop/services/language_service.dart';
import 'package:language_parser_desktop/util/constants.dart';
import 'package:language_parser_desktop/util/ipa_utils.dart';

import '../../service_provider.dart';
import '../../services/service_manager.dart';

class PhoneticButton extends StatefulWidget {
  final String phonetic;
  final bool vowel;
  final bool consonant;
  final bool disabled;
  final Function(String) onPressed;
  final ListOfLanguagePhonemes languagePhonemes;

  const PhoneticButton({
    super.key,
    required this.phonetic,
    required this.languagePhonemes,
    this.vowel = false,
    this.consonant = false,
    required this.disabled,
    required this.onPressed,
  });

  @override
  State<StatefulWidget> createState() => _PhoneticButton();
}

class _PhoneticButton extends State<PhoneticButton> {
  ServiceManager? _serviceManager;
  Color color = LPColor.greyColor;
  Color hoverColor = LPColor.greyBrightColor;

  // @Input() languageSounds?: ListOfLanguagePhonemes;
  // @Output() onClick = new EventEmitter<string>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final sm = ServiceProvider.of(context)?.serviceManager;
    if (_serviceManager != sm) {
      _serviceManager = sm;
    }
  }

  @override
  void initState() {
    updateColor();
  }

  @override
  void didUpdateWidget(PhoneticButton oldWidget) {
    if (widget.languagePhonemes != oldWidget.languagePhonemes) {
      updateColor();
    }
  }

  void updateColor() {
    setState(() {
      color = getColor(false, widget.phonetic);
      hoverColor = getColor(true, widget.phonetic);
    });
  }

  Color getColor(bool bright, String s) {
    return (widget.languagePhonemes.usedMainPhonemes.contains(s) ||
            widget.languagePhonemes.restUsedPhonemes.contains(s))
        ? ((widget.languagePhonemes.selectedMainPhonemes.any((p) => p.phoneme == s) ||
                widget.languagePhonemes.selectedRestPhonemes.any((p) => p.phoneme == s))
            ? (bright ? LPColor.greenBrightColor : LPColor.greenColor)
            : (bright ? LPColor.redBrightColor : LPColor.redColor))
        : ((widget.languagePhonemes.selectedMainPhonemes.any((p) => p.phoneme == s) ||
                widget.languagePhonemes.selectedRestPhonemes.any((p) => p.phoneme == s))
            ? (bright ? LPColor.yellowBrightColor : LPColor.yellowColor)
            : (bright ? LPColor.greyBrightColor : LPColor.greyColor));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TButton(
          text: widget.phonetic,
          color: color,
          hover: hoverColor,
          disabled: widget.disabled,
          onPressed: widget.disabled ? null : () => widget.onPressed(widget.phonetic),
        ),
        if (widget.consonant)
          Row(
              children: IpaUtils.constanantVariants
                  .where((cw) =>
                      cw.length > 0 &&
                      (widget.languagePhonemes.usedMainPhonemes.contains('${widget.phonetic}$cw') ||
                          widget.languagePhonemes.restUsedPhonemes.contains('${widget.phonetic}$cw')))
                  .map((cv) {
            return TButton(
              text: cv,
              color: getColor(false, widget.phonetic + cv),
              hover: getColor(true, widget.phonetic + cv),
              disabled: widget.disabled,
              onPressed: widget.disabled ? null : () => widget.onPressed(widget.phonetic + cv),
            );
          }).toList(growable: false)),
        if (widget.vowel)
          Row(
            children: [
              DBorder(data: '('),
              TButton(
                text: '${widget.phonetic}ː',
                color: getColor(false, widget.phonetic + 'ː'),
                hover: getColor(true, widget.phonetic + 'ː'),
                disabled: widget.disabled,
                onPressed: widget.disabled ? null : () => widget.onPressed(widget.phonetic + 'ː'),
              ),
              DBorder(data: ')'),
            ],
          ),
      ],
    );
  }
}

class CPhoneticButton extends StatelessWidget {
  final String phonetic;
  final bool disabled;
  final Function(String) onPressed;
  final ListOfLanguagePhonemes phonemes;

  const CPhoneticButton(
      {super.key, required this.phonetic, required this.disabled, required this.phonemes, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return PhoneticButton(
      phonetic: phonetic,
      languagePhonemes: phonemes,
      disabled: disabled,
      consonant: true,
      onPressed: onPressed,
    );
  }
}
