import 'package:flutter/cupertino.dart';
import 'package:language_parser_desktop/components/border/border.dart';
import 'package:language_parser_desktop/components/border/hdash.dart';
import 'package:language_parser_desktop/components/buttons/phonetic_button.dart';
import 'package:language_parser_desktop/features/language_phonetics/language_phonetics_header.dart';
import 'package:language_parser_desktop/features/language_phonetics/language_phonetics_plumonic_consonants.dart';

import '../../services/language_service.dart';
import '../../text_measure_provider.dart';

class LanguagePhoneticsNonPulmonicConsonants extends StatelessWidget {
  final bool disabled;
  final ListOfLanguagePhonemes phonemes;
  final Function(String) onPress;

  const LanguagePhoneticsNonPulmonicConsonants(
      {super.key, required this.disabled, required this.phonemes, required this.onPress});

  static const _places = ['bl', 'ld', 'den', 'alv', 'pa', 'rf', 'plt', 'vel', 'uv', 'peg'];

  Widget _p(String phonetic) => Center(
      child: PhoneticButton(
          phonetic: phonetic, languagePhonemes: phonemes, disabled: disabled, onPressed: onPress));

  Widget _pair(String a, String b) => Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [_p(a), _p(b)],
      );

  /// Vertical separator omitted when both neighbouring place cells are empty.
  Widget _vSep(bool left, bool right) =>
      (!left && !right) ? Container() : DBorder(data: '|');

  Widget _hCell(bool active) => active ? const HDash() : Container();

  Widget _hJun(bool left, bool right) {
    if (!left && !right) return Container();
    return DBorder(data: '+');
  }

  Map<int, TableColumnWidth> _widths(double rowHeaderLength, double groupWidth, double cWidth) => {
        0: FixedColumnWidth(rowHeaderLength),
        1: FixedColumnWidth(cWidth),
        2: FixedColumnWidth(groupWidth),
        3: FixedColumnWidth(cWidth),
        4: FlexColumnWidth(),
        5: FixedColumnWidth(cWidth),
        6: FlexColumnWidth(),
        7: FixedColumnWidth(cWidth),
        8: FlexColumnWidth(),
        9: FixedColumnWidth(cWidth),
        10: FlexColumnWidth(),
        11: FixedColumnWidth(cWidth),
        12: FlexColumnWidth(),
        13: FixedColumnWidth(cWidth),
        14: FlexColumnWidth(),
        15: FixedColumnWidth(cWidth),
        16: FlexColumnWidth(),
        17: FixedColumnWidth(cWidth),
        18: FlexColumnWidth(),
        19: FixedColumnWidth(cWidth),
        20: FlexColumnWidth(),
        21: FixedColumnWidth(cWidth),
        22: FlexColumnWidth(),
        23: FixedColumnWidth(cWidth),
      };

  /// [active] = place keys that should show a horizontal dash (cell has content above or below).
  Widget _dash({
    required double rowHeaderLength,
    required double groupWidth,
    required double cWidth,
    required Set<String> active,
    bool mannerDash = true,
    bool groupDash = true,
  }) {
    bool a(String k) => active.contains(k);
    return Table(
      columnWidths: _widths(rowHeaderLength, groupWidth, cWidth),
      children: [
        TableRow(children: [
          mannerDash ? const HDash() : Container(),
          DBorder(data: '+'),
          groupDash ? const HDash() : Container(),
          DBorder(data: '+'),
          _hCell(a('bl')),
          _hJun(a('bl'), a('ld')),
          _hCell(a('ld')),
          _hJun(a('ld'), a('den')),
          _hCell(a('den')),
          _hJun(a('den'), a('alv')),
          _hCell(a('alv')),
          _hJun(a('alv'), a('pa')),
          _hCell(a('pa')),
          _hJun(a('pa'), a('rf')),
          _hCell(a('rf')),
          _hJun(a('rf'), a('plt')),
          _hCell(a('plt')),
          _hJun(a('plt'), a('vel')),
          _hCell(a('vel')),
          _hJun(a('vel'), a('uv')),
          _hCell(a('uv')),
          _hJun(a('uv'), a('peg')),
          _hCell(a('peg')),
          DBorder(data: a('peg') ? '+' : '|'),
        ]),
      ],
    );
  }

  Widget _row({
    required double rowHeaderLength,
    required double groupWidth,
    required double cWidth,
    required String manner,
    required String? mannerShort,
    required String group,
    required String? groupShort,
    Widget? bl,
    Widget? ld,
    Widget? den,
    Widget? alv,
    Widget? pa,
    Widget? rf,
    Widget? plt,
    Widget? vel,
    Widget? uv,
    Widget? peg,
  }) {
    final has = {
      'bl': bl != null,
      'ld': ld != null,
      'den': den != null,
      'alv': alv != null,
      'pa': pa != null,
      'rf': rf != null,
      'plt': plt != null,
      'vel': vel != null,
      'uv': uv != null,
      'peg': peg != null,
    };
    return Table(
      columnWidths: _widths(rowHeaderLength, groupWidth, cWidth),
      children: [
        TableRow(children: [
          manner.isEmpty ? Container() : Center(child: CLPhHeader(header: manner, short: mannerShort)),
          DBorder(data: '|'),
          group.isEmpty ? Container() : Center(child: CLPhHeader(header: group, short: groupShort)),
          DBorder(data: '|'),
          bl ?? Container(),
          _vSep(has['bl']!, has['ld']!),
          ld ?? Container(),
          _vSep(has['ld']!, has['den']!),
          den ?? Container(),
          _vSep(has['den']!, has['alv']!),
          alv ?? Container(),
          _vSep(has['alv']!, has['pa']!),
          pa ?? Container(),
          _vSep(has['pa']!, has['rf']!),
          rf ?? Container(),
          _vSep(has['rf']!, has['plt']!),
          plt ?? Container(),
          _vSep(has['plt']!, has['vel']!),
          vel ?? Container(),
          _vSep(has['vel']!, has['uv']!),
          uv ?? Container(),
          _vSep(has['uv']!, has['peg']!),
          peg ?? Container(),
          DBorder(data: '|'),
        ]),
      ],
    );
  }

  Set<String> _union(Set<String> a, Set<String> b) => {...a, ...b};

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final cWidth = TextMeasureProvider.of(context)!.characterWidth;
      const groupHeaders = [
        'Plosive',
        'Affricate',
        'Fricative',
        'Lateral affr.',
        'Lateral fric.',
        'Tenuis',
        'Voiced',
        'Nasal',
        'Tenuis ltrl',
        'Voiced ltrl',
        'Nasal ltrl',
      ];
      final groupChars = groupHeaders.fold(0, (p, s) => p > s.length ? p : s.length);
      final rowHeaderLength = LanguagePhoneticsPlumonicConsonants.sharedRowHeaderWidth(
        constraints.maxWidth,
        cWidth,
        extraChars: 'Implosive'.length,
      );
      final groupWidth = groupChars * cWidth;

      // Place columns present on each sound row (for empty-aware dash borders).
      const plosive = {'bl', 'alv', 'rf', 'plt', 'vel', 'uv', 'peg'};
      const affricate = {'den', 'alv', 'pa', 'rf', 'vel', 'uv'};
      const fricative = {'bl', 'ld', 'den', 'alv', 'pa', 'rf', 'plt', 'vel', 'uv'};
      const latAff = {'alv', 'plt', 'vel'};
      const latFric = {'alv'};
      const clickTenuis = {'bl', 'den', 'alv', 'rf', 'plt'};
      const clickVoiced = {'bl', 'den', 'alv', 'rf', 'plt'};
      const clickNasal = {'bl', 'den', 'alv', 'rf', 'plt', 'vel'};
      const clickTLtrl = {'alv'};
      const clickVLtrl = {'alv'};
      const clickNLtrl = {'alv'};
      const implosive = {'bl', 'alv', 'rf', 'plt', 'vel', 'uv'};

      return Column(
        children: [
          Row(
            children: [
              Expanded(child: Center(child: LPhHeader(header: '--- NON-PLUMONIC CONSONANTS ---'))),
              SizedBox(width: cWidth, child: DBorder(data: '|')),
            ],
          ),
          Table(
            columnWidths: {
              0: FixedColumnWidth(rowHeaderLength + cWidth + groupWidth),
              1: FixedColumnWidth(cWidth),
              2: FlexColumnWidth(),
              3: FixedColumnWidth(cWidth),
            },
            children: [
              TableRow(children: [HDash(), DBorder(data: '+'), HDash(), DBorder(data: '+')])
            ],
          ),
          Table(
            columnWidths: {
              0: FixedColumnWidth(rowHeaderLength + cWidth + groupWidth),
              1: FixedColumnWidth(cWidth),
              2: FlexColumnWidth(2),
              3: FixedColumnWidth(cWidth),
              4: FlexColumnWidth(4),
              5: FixedColumnWidth(cWidth),
              6: FlexColumnWidth(3),
              7: FixedColumnWidth(cWidth),
              8: FlexColumnWidth(1),
              9: FixedColumnWidth(cWidth),
            },
            children: [
              TableRow(children: [
                Container(alignment: Alignment.centerRight, child: LPhHeader(header: 'Place >')),
                DBorder(data: '|'),
                Center(child: LPhHeader(header: 'Labial')),
                DBorder(data: '|'),
                Center(child: LPhHeader(header: 'Coronal')),
                DBorder(data: '|'),
                Center(child: LPhHeader(header: 'Dorsal')),
                DBorder(data: '|'),
                Center(child: LPhHeader(header: 'Laryngeal')),
                DBorder(data: '|'),
              ]),
            ],
          ),
          Table(
            columnWidths: _widths(rowHeaderLength, groupWidth, cWidth),
            children: [
              TableRow(children: [
                Container(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
                HDash(),
                DBorder(data: '+'),
              ]),
              TableRow(children: [
                LPhHeader(header: ' v Manner'),
                DBorder(data: '|'),
                Center(child: LPhHeader(header: 'Group')),
                DBorder(data: '|'),
                CLPhHeader(header: 'Bilabial', short: 'BL'),
                DBorder(data: '|'),
                CLPhHeader(header: 'Labio-dental', short: 'LD'),
                DBorder(data: '|'),
                CLPhHeader(header: 'Dental', short: 'Den'),
                DBorder(data: '|'),
                CLPhHeader(header: 'Alveolar', short: 'Alv'),
                DBorder(data: '|'),
                CLPhHeader(header: 'Post-alveolar', short: 'PA'),
                DBorder(data: '|'),
                CLPhHeader(header: 'Retro-flex', short: 'RF'),
                DBorder(data: '|'),
                CLPhHeader(header: 'Palatal', short: 'Plt'),
                DBorder(data: '|'),
                CLPhHeader(header: 'Velar', short: 'Vel'),
                DBorder(data: '|'),
                CLPhHeader(header: 'Uvular', short: 'Uv'),
                DBorder(data: '|'),
                CLPhHeader(header: 'Pharyngeal/epi-glottal', short: 'P/EG'),
                DBorder(data: '|'),
              ]),
            ],
          ),
          _dash(
            rowHeaderLength: rowHeaderLength,
            groupWidth: groupWidth,
            cWidth: cWidth,
            active: _places.toSet(),
          ),
          _row(
            rowHeaderLength: rowHeaderLength,
            groupWidth: groupWidth,
            cWidth: cWidth,
            manner: 'Ejective',
            mannerShort: 'Ej',
            group: 'Plosive',
            groupShort: 'Pl',
            bl: _p('pʼ'),
            alv: _p('tʼ'),
            rf: _p('ʈʼ'),
            plt: _p('cʼ'),
            vel: _p('kʼ'),
            uv: _p('qʼ'),
            peg: _p('ʡʼ'),
          ),
          _dash(
            rowHeaderLength: rowHeaderLength,
            groupWidth: groupWidth,
            cWidth: cWidth,
            active: _union(plosive, affricate),
            mannerDash: false,
          ),
          _row(
            rowHeaderLength: rowHeaderLength,
            groupWidth: groupWidth,
            cWidth: cWidth,
            manner: '',
            mannerShort: '',
            group: 'Affricate',
            groupShort: 'Aff',
            den: _p('t̪͡θʼ'),
            alv: _p('t͡sʼ'),
            pa: _p('t̠͡ʃʼ'),
            rf: _p('ʈ͡ʂʼ'),
            vel: _p('k͡xʼ'),
            uv: _p('q͡χʼ'),
          ),
          _dash(
            rowHeaderLength: rowHeaderLength,
            groupWidth: groupWidth,
            cWidth: cWidth,
            active: _union(affricate, fricative),
            mannerDash: false,
          ),
          _row(
            rowHeaderLength: rowHeaderLength,
            groupWidth: groupWidth,
            cWidth: cWidth,
            manner: '',
            mannerShort: '',
            group: 'Fricative',
            groupShort: 'Fr',
            bl: _p('ɸʼ'),
            ld: _p('fʼ'),
            den: _p('θʼ'),
            alv: _p('sʼ'),
            pa: _p('ʃʼ'),
            rf: _p('ʂʼ'),
            plt: _p('ɕʼ'),
            vel: _p('xʼ'),
            uv: _p('χʼ'),
          ),
          _dash(
            rowHeaderLength: rowHeaderLength,
            groupWidth: groupWidth,
            cWidth: cWidth,
            active: _union(fricative, latAff),
            mannerDash: false,
          ),
          _row(
            rowHeaderLength: rowHeaderLength,
            groupWidth: groupWidth,
            cWidth: cWidth,
            manner: '',
            mannerShort: '',
            group: 'Lateral affr.',
            groupShort: 'LAf',
            alv: _p('t͡ɬʼ'),
            plt: _p('c͡ʎ̝̊ʼ'),
            vel: _p('k͡ʟ̝̊ʼ'),
          ),
          _dash(
            rowHeaderLength: rowHeaderLength,
            groupWidth: groupWidth,
            cWidth: cWidth,
            active: _union(latAff, latFric),
            mannerDash: false,
          ),
          _row(
            rowHeaderLength: rowHeaderLength,
            groupWidth: groupWidth,
            cWidth: cWidth,
            manner: '',
            mannerShort: '',
            group: 'Lateral fric.',
            groupShort: 'LFr',
            alv: _p('ɬʼ'),
          ),
          _dash(
            rowHeaderLength: rowHeaderLength,
            groupWidth: groupWidth,
            cWidth: cWidth,
            active: _union(latFric, clickTenuis),
          ),
          _row(
            rowHeaderLength: rowHeaderLength,
            groupWidth: groupWidth,
            cWidth: cWidth,
            manner: 'Click',
            mannerShort: 'Cl',
            group: 'Tenuis',
            groupShort: 'Ten',
            bl: _pair('kʘ', 'qʘ'),
            den: _pair('kǀ', 'qǀ'),
            alv: _pair('kǃ', 'qǃ'),
            rf: _pair('k‼', 'q‼'),
            plt: _pair('kǂ', 'qǂ'),
          ),
          _dash(
            rowHeaderLength: rowHeaderLength,
            groupWidth: groupWidth,
            cWidth: cWidth,
            active: _union(clickTenuis, clickVoiced),
            mannerDash: false,
          ),
          _row(
            rowHeaderLength: rowHeaderLength,
            groupWidth: groupWidth,
            cWidth: cWidth,
            manner: '',
            mannerShort: '',
            group: 'Voiced',
            groupShort: 'Voi',
            bl: _pair('ɡʘ', 'ɢʘ'),
            den: _pair('ɡǀ', 'ɢǀ'),
            alv: _pair('ɡǃ', 'ɢǃ'),
            rf: _pair('ɡ‼', 'ɢ‼'),
            plt: _pair('ɡǂ', 'ɢǂ'),
          ),
          _dash(
            rowHeaderLength: rowHeaderLength,
            groupWidth: groupWidth,
            cWidth: cWidth,
            active: _union(clickVoiced, clickNasal),
            mannerDash: false,
          ),
          _row(
            rowHeaderLength: rowHeaderLength,
            groupWidth: groupWidth,
            cWidth: cWidth,
            manner: '',
            mannerShort: '',
            group: 'Nasal',
            groupShort: 'Nas',
            bl: _pair('ŋʘ', 'ɴʘ'),
            den: _pair('ŋǀ', 'ɴǀ'),
            alv: _pair('ŋǃ', 'ɴǃ'),
            rf: _pair('ŋ‼', 'ɴ‼'),
            plt: _pair('ŋǂ', 'ɴǂ'),
            vel: _p('ʞ'),
          ),
          _dash(
            rowHeaderLength: rowHeaderLength,
            groupWidth: groupWidth,
            cWidth: cWidth,
            active: _union(clickNasal, clickTLtrl),
            mannerDash: false,
          ),
          _row(
            rowHeaderLength: rowHeaderLength,
            groupWidth: groupWidth,
            cWidth: cWidth,
            manner: '',
            mannerShort: '',
            group: 'Tenuis ltrl',
            groupShort: 'TLt',
            alv: _pair('kǁ', 'qǁ'),
          ),
          _dash(
            rowHeaderLength: rowHeaderLength,
            groupWidth: groupWidth,
            cWidth: cWidth,
            active: _union(clickTLtrl, clickVLtrl),
            mannerDash: false,
          ),
          _row(
            rowHeaderLength: rowHeaderLength,
            groupWidth: groupWidth,
            cWidth: cWidth,
            manner: '',
            mannerShort: '',
            group: 'Voiced ltrl',
            groupShort: 'VLt',
            alv: _pair('ɡǁ', 'ɢǁ'),
          ),
          _dash(
            rowHeaderLength: rowHeaderLength,
            groupWidth: groupWidth,
            cWidth: cWidth,
            active: _union(clickVLtrl, clickNLtrl),
            mannerDash: false,
          ),
          _row(
            rowHeaderLength: rowHeaderLength,
            groupWidth: groupWidth,
            cWidth: cWidth,
            manner: '',
            mannerShort: '',
            group: 'Nasal ltrl',
            groupShort: 'NLt',
            alv: _pair('ŋǁ', 'ɴǁ'),
          ),
          _dash(
            rowHeaderLength: rowHeaderLength,
            groupWidth: groupWidth,
            cWidth: cWidth,
            active: _union(clickNLtrl, implosive),
          ),
          _row(
            rowHeaderLength: rowHeaderLength,
            groupWidth: groupWidth,
            cWidth: cWidth,
            manner: 'Implosive',
            mannerShort: 'Impl',
            group: '',
            groupShort: '',
            bl: _pair('ɓ̥', 'ɓ'),
            alv: _pair('ɗ̥̥', 'ɗ'),
            rf: _pair('ᶑ̊', 'ᶑ'),
            plt: _pair('ʄ̊', 'ʄ'),
            vel: _pair('ɠ̊', 'ɠ'),
            uv: _pair('ʛ̥', 'ʛ'),
          ),
          _dash(
            rowHeaderLength: rowHeaderLength,
            groupWidth: groupWidth,
            cWidth: cWidth,
            active: implosive,
          ),
        ],
      );
    });
  }
}
