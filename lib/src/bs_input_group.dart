import 'package:flutter/widgets.dart';

import 'bs_form_control.dart';
import 'tokens/bs_form_style.dart';

/// A Bootstrap input group (`.input-group`): a row of [children] — typically
/// [BsInputGroupText] addons around one flexible control — sharing a single
/// border, like Bootstrap merges each child's border into one seamless
/// outline rather than stacking separate boxes.
///
/// The flexible control (e.g. a [BsFormControl]) should be wrapped in
/// [Expanded] and passed `showBorder: false`, since this widget draws the
/// shared border itself.
class BsInputGroup extends StatelessWidget {
  const BsInputGroup({
    super.key,
    required this.children,
    this.size = BsFormControlSize.normal,
    this.style,
  });

  final List<Widget> children;

  /// `.input-group-sm`/`.input-group-lg`.
  final BsFormControlSize size;

  /// Style overrides layered on top of [BsFormStyle.defaults].
  final BsFormStyle? style;

  @override
  Widget build(BuildContext context) {
    final style = BsFormStyle.defaults.merge(this.style);
    final borderRadius = switch (size) {
      BsFormControlSize.small =>
        style.inputBorderRadiusSm ?? BsFormStyle.defaultInputBorderRadiusSm,
      BsFormControlSize.normal =>
        style.inputBorderRadius ?? BsFormStyle.defaultInputBorderRadius,
      BsFormControlSize.large =>
        style.inputBorderRadiusLg ?? BsFormStyle.defaultInputBorderRadiusLg,
    };

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: style.inputBorderColor ?? BsFormStyle.defaultInputBorderColor,
          width: style.inputBorderWidth ?? BsFormStyle.defaultInputBorderWidth,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: children,
          ),
        ),
      ),
    );
  }
}

/// `.input-group-text`: a static label addon inside a [BsInputGroup] (e.g.
/// `@`, `$`, `.00`).
class BsInputGroupText extends StatelessWidget {
  const BsInputGroupText({super.key, required this.child, this.style});

  final Widget child;

  /// Style overrides layered on top of [BsFormStyle.defaults].
  final BsFormStyle? style;

  @override
  Widget build(BuildContext context) {
    final style = BsFormStyle.defaults.merge(this.style);
    return ColoredBox(
      color:
          style.inputGroupAddonBackground ??
          BsFormStyle.defaultInputGroupAddonBackground,
      child: Padding(
        padding:
            style.inputGroupAddonPadding ??
            BsFormStyle.defaultInputGroupAddonPadding,
        child: Center(
          child: DefaultTextStyle.merge(
            style: TextStyle(
              color:
                  style.inputGroupAddonColor ??
                  BsFormStyle.defaultInputGroupAddonColor,
              fontSize: style.inputFontSize ?? BsFormStyle.defaultInputFontSize,
              fontWeight:
                  style.inputFontWeight ?? BsFormStyle.defaultInputFontWeight,
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
