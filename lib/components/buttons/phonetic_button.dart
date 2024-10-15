import 'package:flutter/cupertino.dart';
import 'package:language_parser_desktop/components/buttons/t_button.dart';
import 'package:language_parser_desktop/services/ipa_service.dart';
import 'package:language_parser_desktop/util/constants.dart';

import '../../service_provider.dart';
import '../../services/service_manager.dart';

class PhoneticButton extends StatefulWidget {
  final String phonetic;
  final bool vowel;
  final bool consonant;
  final bool used;
  final bool selected;

  const PhoneticButton({
    super.key,
    required this.phonetic,
    required this.used,
    required this.selected,
    this.vowel = false,
    this.consonant = false,
  });

  @override
  State<StatefulWidget> createState() => _PhonecticButton();
}

class _PhonecticButton extends State<PhoneticButton> {
  ServiceManager? _serviceManager;
  late IpaService _ipaService;

  // @Input() languageSounds?: ListOfLanguagePhonemes;
  // @Output() onClick = new EventEmitter<string>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final sm = ServiceProvider.of(context)?.serviceManager;
    if (_serviceManager != sm) {
      _serviceManager = sm;
      _ipaService = _serviceManager!.ipaService;
    }
  }

  @override
  Widget build(BuildContext context) {
    var color = widget.used
        ? (widget.selected ? LPColor.greenColor : LPColor.redColor)
        : (widget.selected ? LPColor.yellowColor : LPColor.greyColor);
    return Row(
      children: [
        TButton(text: widget.phonetic),
        if (widget.consonant)
          Row(
              children: IpaService.consonantVariants.where((cw) => cw.length > 0).map((cv) {
            return TButton(
              text: cv,
              color: color,
            );
          }).toList(growable: false)),
        if (widget.vowel) TButton(text: 'ː')
      ],
    );
  }
}
