import 'package:flutter/widgets.dart';

import 'bs_clip_rrect.dart';
import 'bs_form_control.dart';
import 'bs_theme.dart';
import 'tokens/bs_form_style.dart';
import 'bs_decorated_box.dart';

/// A Bootstrap input group: a row of [children], typically [BsInputGroupText] addons around
/// one flexible control, sharing a single border so that the children read as one seamless
/// outline rather than separate boxes.
///
/// The flexible control (for example a [BsFormControl]) should be wrapped in [Expanded] and
/// passed `showBorder: false`, since this widget draws the shared border itself.
class BsInputGroup extends StatelessWidget {
  const BsInputGroup({
    super.key,
    required this.children,
    this.size = BsFormControlSize.normal,
    this.valid,
    this.style,
  });

  final List<Widget> children;

  /// The size of the group's controls.
  final BsFormControlSize size;

  /// The validation state of the group's control: tints the shared border.
  final bool? valid;

  /// Style overrides layered on top of [BsFormStyle.defaults].
  final BsFormStyle? style;

  @override
  Widget build(BuildContext context) {
    final isDark = BsTheme.of(context) == Brightness.dark;
    final style = (isDark ? BsFormStyle.darkDefaults : BsFormStyle.defaults)
        .merge(this.style);
    final borderRadius = switch (size) {
      BsFormControlSize.small =>
        style.inputBorderRadiusSm ?? BsFormStyle.defaultInputBorderRadiusSm,
      BsFormControlSize.normal =>
        style.inputBorderRadius ?? BsFormStyle.defaultInputBorderRadius,
      BsFormControlSize.large =>
        style.inputBorderRadiusLg ?? BsFormStyle.defaultInputBorderRadiusLg,
    };

    // // A Container, not a DecoratedBox: the border must add to the group's size instead of
    // // painting over its children.
    return BsDecoratedContainer(
      decoration: BoxDecoration(
        border: Border.all(
          color: switch (valid) {
            false => style.invalidColor ?? BsFormStyle.defaultInvalidColor,
            true => style.validColor ?? BsFormStyle.defaultValidColor,
            null => style.inputBorderColor ?? BsFormStyle.defaultInputBorderColor,
          },
          width: style.inputBorderWidth ?? BsFormStyle.defaultInputBorderWidth,
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: BsClipRRect(
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

/// A static label addon inside a [BsInputGroup] (for example `@`, `$` or `.00`).
class BsInputGroupText extends StatelessWidget {
  const BsInputGroupText({super.key, required this.child, this.style});

  final Widget child;

  /// Style overrides layered on top of [BsFormStyle.defaults].
  final BsFormStyle? style;

  @override
  Widget build(BuildContext context) {
    final isDark = BsTheme.of(context) == Brightness.dark;
    final style = (isDark ? BsFormStyle.darkDefaults : BsFormStyle.defaults)
        .merge(this.style);
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
