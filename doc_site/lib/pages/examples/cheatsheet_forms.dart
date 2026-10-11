import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'cheatsheet_env.dart';
import '../../src/example_file_input.dart';

/// The "Forms" section of the Cheatsheet: Overview, Disabled forms, Sizing,
/// Input group, Floating labels and Validation (examples 15-21).

/// A text input that keeps its own text (`value="Mark"`).
class CsInput extends StatefulWidget {
  const CsInput({
    super.key,
    this.text = '',
    this.placeholder,
    this.valid,
    this.size = BsFormControlSize.normal,
    this.enabled = true,
    this.obscure = false,
    this.showBorder = true,
  });

  final String text;
  final String? placeholder;
  final bool? valid;
  final BsFormControlSize size;
  final bool enabled;
  final bool obscure;
  final bool showBorder;

  @override
  State<CsInput> createState() => _CsInputState();
}

class _CsInputState extends State<CsInput> {
  late final _controller = TextEditingController(text: widget.text);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BsFormControl(
      controller: _controller,
      placeholder: widget.placeholder,
      valid: widget.valid,
      size: widget.size,
      enabled: widget.enabled,
      obscureText: widget.obscure,
      showBorder: widget.showBorder,
    );
  }
}

/// `.mb-3`.
Widget _mb3(Widget child) =>
    Padding(padding: const EdgeInsets.only(bottom: 16), child: child);

/// `.form-check { margin-bottom: .125rem }`.
Widget _formCheck(Widget child) =>
    Padding(padding: const EdgeInsets.only(bottom: 2), child: child);

/// `<legend>`: `font-size: calc(1.275rem + .3vw)` (1.5rem from `xl`), floated
/// to a full line, with `margin-bottom: .5rem`.
Widget _legend(BuildContext context, String text) {
  final width = MediaQuery.sizeOf(context).width;
  final size = width >= 1200 ? 24.0 : 20.4 + 0.003 * width;
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: TextStyle(
        fontSize: size,
        fontWeight: FontWeight.w400,
        // (`line-height: inherit`: the body's 1.5)
        height: 1.5,
      ),
    ),
  );
}

/// Overview (`#overview`, example 15) and Disabled forms (`#disabled-forms`,
/// example 16): the same form, live and `<fieldset disabled>`.
class CsForm extends StatefulWidget {
  const CsForm({super.key, required this.env, required this.disabled});

  final CsEnv env;
  final bool disabled;

  @override
  State<CsForm> createState() => _CsFormState();
}

class _CsFormState extends State<CsForm> {
  int _select = 0;
  bool _check = false;
  int _radio = -1;
  bool _switch = true;
  double _range = 2.5;

  @override
  Widget build(BuildContext context) {
    final disabled = widget.disabled;
    final s = widget.env.s(disabled ? 16 : 15);
    // The text nodes of the two forms, by what they are.
    final int labelAt = 0;
    final int helpOrPlaceholder = 1;
    final int selectLabel = disabled ? 2 : 3;
    final int checkAt = disabled ? 4 : 8;
    final int legendAt = disabled ? 5 : 9;
    final int radio1 = disabled ? 6 : 10;
    final int radio2 = disabled ? 7 : 11;
    final int uploadAt = disabled ? 8 : 12;
    final int switchAt = disabled ? 9 : 13;
    final int rangeAt = disabled ? 10 : 14;
    final int submitAt = disabled ? 11 : 15;

    Widget field(String label, Widget control, [Widget? after]) => _mb3(
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BsFormLabel(child: Text(label)),
          control,
          ?after,
        ],
      ),
    );
    Widget radio(int index, String label, bool last) {
      final radio = BsFormCheck(
        type: BsFormCheckType.radio,
        value: !disabled && _radio == index,
        onChanged: disabled ? null : (_) => setState(() => _radio = index),
        label: Text(label),
      );
      return last ? _mb3(radio) : _formCheck(radio);
    }

    final blocks = <Widget>[
      if (disabled)
        field(
          s[labelAt],
          CsInput(placeholder: s[helpOrPlaceholder], enabled: false),
        )
      else
        field(
          s[labelAt],
          const CsInput(),
          BsFormText(child: Text(s[helpOrPlaceholder])),
        ),
      if (!disabled) field(s[2], const CsInput(obscure: true)),
      field(
        s[selectLabel],
        BsFormSelect<int>(
          items: [
            if (disabled)
              BsFormSelectItem(value: 0, label: Text(s[3]))
            else
              for (var k = 0; k < 4; k++)
                BsFormSelectItem(value: k, label: Text(s[4 + k])),
          ],
          value: disabled ? 0 : _select,
          onChanged: disabled ? null : (v) => setState(() => _select = v),
        ),
      ),
      _mb3(
        BsFormCheck(
          value: !disabled && _check,
          onChanged: disabled ? null : (v) => setState(() => _check = v),
          label: Text(s[checkAt]),
        ),
      ),
      // <fieldset class="mb-3"><legend>…</legend>
      _mb3(
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _legend(context, s[legendAt]),
            radio(0, s[radio1], false),
            radio(1, s[radio2], true),
          ],
        ),
      ),
      field(
        s[uploadAt],
        ExampleFileInput(enabled: !disabled),
      ),
      _mb3(
        BsFormCheck(
          type: BsFormCheckType.switchToggle,
          value: _switch,
          onChanged: disabled ? null : (v) => setState(() => _switch = v),
          label: Text(s[switchAt]),
        ),
      ),
      field(
        s[rangeAt],
        // (an inline-block: it sits on the baseline, 7px above the line's bottom)
        Padding(
          padding: const EdgeInsets.only(bottom: 7),
          child: BsFormRange(
            value: _range,
            min: 0,
            max: 5,
            onChanged: disabled ? null : (v) => setState(() => _range = v),
          ),
        ),
      ),
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: BsButton(
          onPressed: disabled ? null : () {},
          child: Text(s[submitAt]),
        ),
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: blocks,
    );
  }
}

/// Overview (example 15) and Disabled forms (example 16).
List<Widget> cheatsheetOverview(BuildContext context, CsEnv env) => [
  CsForm(env: env, disabled: false),
];

List<Widget> cheatsheetDisabledForms(BuildContext context, CsEnv env) => [
  CsForm(env: env, disabled: true),
];

/// Sizing (`#sizing`, examples 17-18).
List<Widget> cheatsheetSizing(BuildContext context, CsEnv env) {
  Widget sized(int example, BsFormControlSize size) {
    final s = env.s(example);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _mb3(CsInput(placeholder: s[0], size: size)),
        _mb3(_SelectSized(size: size, labels: s.sublist(1))),
        // The last block's `margin-bottom` collapses out of the example.
        BsFormFile(size: size, onPressed: () {}),
      ],
    );
  }

  return [
    sized(17, BsFormControlSize.large),
    sized(18, BsFormControlSize.small),
  ];
}

class _SelectSized extends StatefulWidget {
  const _SelectSized({required this.size, required this.labels});

  final BsFormControlSize size;
  final List<String> labels;

  @override
  State<_SelectSized> createState() => _SelectSizedState();
}

class _SelectSizedState extends State<_SelectSized> {
  int _value = 0;

  @override
  Widget build(BuildContext context) {
    return BsFormSelect<int>(
      size: widget.size,
      items: [
        for (var i = 0; i < widget.labels.length; i++)
          BsFormSelectItem(value: i, label: Text(widget.labels[i])),
      ],
      value: _value,
      onChanged: (v) => setState(() => _value = v),
    );
  }
}

/// Input group (`#input-group`, example 19).
List<Widget> cheatsheetInputGroup(BuildContext context, CsEnv env) {
  final s = env.s(19);
  // The Arabic markup lists `.00` before `$`.
  final prefix = env.rtl ? s[7] : s[6];
  final suffix = env.rtl ? s[6] : s[7];
  Widget addon(String text) => BsInputGroupText(child: Text(text));
  Widget control({String? placeholder}) =>
      Expanded(child: CsInput(placeholder: placeholder, showBorder: false));
  return [
    Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _mb3(
          BsInputGroup(
            children: [
              addon(s[0]),
              control(placeholder: s[1]),
            ],
          ),
        ),
        _mb3(
          BsInputGroup(
            children: [
              control(placeholder: s[2]),
              addon(s[3]),
            ],
          ),
        ),
        BsFormLabel(child: Text(s[4])),
        _mb3(BsInputGroup(children: [addon(s[5]), control()])),
        _mb3(BsInputGroup(children: [addon(prefix), control(), addon(suffix)])),
        BsInputGroup(
          children: [
            addon(s[8]),
            Expanded(
              child: ConstrainedBox(
                constraints: const BoxConstraints(minHeight: 60),
                child: const CsInput(showBorder: false),
              ),
            ),
          ],
        ),
      ],
    ),
  ];
}

/// Floating labels (`#floating-labels`, example 20).
List<Widget> cheatsheetFloatingLabels(BuildContext context, CsEnv env) {
  final s = env.s(20);
  return [
    Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _mb3(BsFormFloating(label: Text(s[1]))),
        BsFormFloating(label: Text(s[2]), obscureText: true),
      ],
    ),
  ];
}

/// Validation (`#validation`, example 21).
List<Widget> cheatsheetValidation(BuildContext context, CsEnv env) {
  final s = env.s(21);
  const md4 = BsResponsiveValue<BsCol>(xs: BsCol(12), md: BsCol(4));
  const md6 = BsResponsiveValue<BsCol>(xs: BsCol(12), md: BsCol(6));
  const md3 = BsResponsiveValue<BsCol>(xs: BsCol(12), md: BsCol(3));
  Widget feedback(String text, {required bool valid}) => Padding(
    // `.valid-feedback`, `.invalid-feedback`: `margin-top: .25rem; font-size:
    // .875em`.
    padding: const EdgeInsets.only(top: 4),
    child: Text(
      text,
      style: TextStyle(
        fontSize: 14,
        height: 1.5,
        color: valid ? BsVariant.success.color : BsVariant.danger.color,
      ),
    ),
  );
  Widget group(
    BsResponsive<BsCol> col,
    String label,
    Widget control,
    String message, {
    required bool valid,
  }) {
    return BsFlexItem(
      col: col,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BsFormLabel(child: Text(label)),
          control,
          feedback(message, valid: valid),
        ],
      ),
    );
  }

  return [
    BsRow(
      g: BsSpacing.s3,
      children: [
        group(md4, s[0], CsInput(text: s[1], valid: true), s[2], valid: true),
        group(md4, s[3], CsInput(text: s[4], valid: true), s[5], valid: true),
        group(md4, s[6], _InvalidGroup(addon: s[7]), s[8], valid: false),
        group(md6, s[9], const CsInput(valid: false), s[10], valid: false),
        group(
          md3,
          s[11],
          BsFormSelect<int>(
            valid: false,
            items: [BsFormSelectItem(value: 1, label: Text(s[13]))],
            value: null,
            placeholder: Text(s[12]),
            onChanged: (_) {},
          ),
          s[14],
          valid: false,
        ),
        group(md3, s[15], const CsInput(valid: false), s[16], valid: false),
        BsFlexItem(
          col: const BsResponsiveValue(xs: BsCol(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BsFormCheck(
                value: false,
                valid: false,
                onChanged: (_) {},
                label: Text(s[17]),
              ),
              // (inside the `.form-check`: indented by its padding, and
              // followed by its `margin-bottom`)
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 24, bottom: 2),
                child: feedback(s[18], valid: false),
              ),
            ],
          ),
        ),
        BsFlexItem(
          col: const BsResponsiveValue(xs: BsCol(12)),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: BsButton(onPressed: () {}, child: Text(s[19])),
          ),
        ),
      ],
    ),
  ];
}

/// `<div class="input-group has-validation"><span class="input-group-text">`
/// and an `.is-invalid` control: only the control's border turns red, the
/// addon's stays as it is.
class _InvalidGroup extends StatelessWidget {
  const _InvalidGroup({required this.addon});

  final String addon;

  @override
  Widget build(BuildContext context) {
    final style = DefaultTextStyle.of(context).style;
    final text = TextPainter(
      text: TextSpan(text: addon, style: style),
      textDirection: Directionality.of(context),
    )..layout();
    // The addon: its text between 12px of padding, and the 1px of border it
    // shares with the control.
    final edge = text.width + 25;
    final red = BsVariant.danger.color;
    return Stack(
      children: [
        BsInputGroup(
          children: [
            BsInputGroupText(child: Text(addon)),
            const Expanded(child: CsInput(valid: false, showBorder: false)),
          ],
        ),
        PositionedDirectional(
          start: edge - 1,
          end: 0,
          top: 0,
          bottom: 0,
          child: IgnorePointer(
            child: DecoratedBox(
              decoration: BoxDecoration(
                border: Border.all(color: red),
                borderRadius: const BorderRadiusDirectional.horizontal(
                  end: Radius.circular(6),
                ).resolve(Directionality.of(context)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
