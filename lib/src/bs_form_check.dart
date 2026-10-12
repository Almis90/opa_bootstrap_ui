import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'bs_dashed_border.dart';
import 'bs_focusable.dart';
import 'bs_theme.dart';
import 'bs_variant.dart';
import 'tokens/bs_form_style.dart';
import 'tokens/bs_transitions.dart';
import 'bs_decorated_box.dart';

/// How a [BsFormCheck] renders and toggles: as a checkbox, a radio or a switch.
enum BsFormCheckType {
  /// A square box with a checkmark when [BsFormCheck.value] is true.
  checkbox,

  /// A circular dot, filled when [BsFormCheck.value] is true.
  radio,

  /// A pill-shaped track with a sliding thumb.
  switchToggle,
}

/// A Bootstrap checkbox, radio or switch, with an optional [label] alongside it. Both the
/// control and [label] toggle [value] on tap.
class BsFormCheck extends StatelessWidget {
  const BsFormCheck({
    super.key,
    this.type = BsFormCheckType.checkbox,
    required this.value,
    required this.onChanged,
    this.label,
    this.valid,
    this.style,
  });

  final BsFormCheckType type;

  final bool value;

  /// The validation state: the control's border and the [label] take the success color when true
  /// and the danger color when false.
  final bool? valid;

  /// Disables the control (rendered at [BsFormStyle.checkInputDisabledOpacity])
  /// when null.
  final ValueChanged<bool>? onChanged;

  final Widget? label;

  /// Style overrides layered on top of [BsFormStyle.defaults].
  final BsFormStyle? style;

  @override
  Widget build(BuildContext context) {
    final isDark = BsTheme.of(context) == Brightness.dark;
    final style = (isDark ? BsFormStyle.darkDefaults : BsFormStyle.defaults)
        .merge(this.style);
    final enabled = onChanged != null;
    final onTap = enabled ? () => onChanged!(!value) : null;

    final accent = valid == null
        ? null
        : (valid! ? BsVariant.success.color : BsVariant.danger.color);
    return Opacity(
      opacity: enabled
          ? 1
          : (style.checkInputDisabledOpacity ??
                BsFormStyle.defaultCheckInputDisabledOpacity),
      // (a checkbox is toggled with Space)
      child: _SpaceToggles(
        enabled: enabled,
        onToggle: onTap,
        // // Focus, not keyboard focus only: a clicked checkbox keeps its ring.
        child: BsFocusableBuilder(
          enabled: enabled,
          builder: (context, focused) {
            final control = switch (type) {
              BsFormCheckType.switchToggle => _BsFormSwitchGlyph(
                value: value,
                style: style,
                focused: focused,
                accent: accent,
              ),
              _ => _BsFormCheckGlyph(
                type: type,
                value: value,
                style: style,
                accent: accent,
                focused: focused,
              ),
            };
            // (a Builder: the focus node is the one just above it)
            return Builder(
              builder: (context) => GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onTap == null
                    ? null
                    : () {
                        Focus.of(context).requestFocus();
                        onTap();
                      },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    control,
                    if (label != null) ...[
                      const SizedBox(width: 8),
                      Flexible(
                        child: accent == null
                            ? label!
                            : DefaultTextStyle.merge(
                                style: TextStyle(color: accent),
                                child: label!,
                              ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Space presses the [Focus]ed control beneath it, as it does a native
/// checkbox, radio or switch.
class _SpaceToggles extends StatelessWidget {
  const _SpaceToggles({
    required this.enabled,
    required this.onToggle,
    required this.child,
  });

  final bool enabled;
  final VoidCallback? onToggle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onKeyEvent: !enabled || onToggle == null
          ? null
          : (node, event) {
              if (event is KeyDownEvent &&
                  event.logicalKey == LogicalKeyboardKey.space) {
                onToggle!();
                return KeyEventResult.handled;
              }
              return KeyEventResult.ignored;
            },
      child: child,
    );
  }
}

class _BsFormCheckGlyph extends StatelessWidget {
  const _BsFormCheckGlyph({
    required this.type,
    required this.value,
    required this.style,
    this.size,
    this.dashed = false,
    this.background,
    this.accent,
    this.focused = false,
  });

  final BsFormCheckType type;
  final bool value;
  final BsFormStyle style;

  /// `:focus`: the light-blue border and the ring.
  final bool focused;

  /// A validation color for the border (and the checked fill).
  final Color? accent;

  /// The box's side. Defaults to the control's font size (16 logical pixels).
  final double? size;

  /// Draws the border dashed.
  final bool dashed;

  /// A background in place of the default.
  final Color? background;

  @override
  Widget build(BuildContext context) {
    final size =
        this.size ?? style.checkInputSize ?? BsFormStyle.defaultCheckInputSize;
    final border =
        style.checkInputBorder ?? BsFormStyle.defaultCheckInputBorder;
    final radius = type == BsFormCheckType.radio
        ? (style.checkRadioBorderRadius ??
              BsFormStyle.defaultCheckRadioBorderRadius)
        : (style.checkInputBorderRadius ??
              BsFormStyle.defaultCheckInputBorderRadius);
    final checkedBackground =
        accent ??
        style.checkInputCheckedBackground ??
        BsFormStyle.defaults.checkInputCheckedBackground!;
    // // A checked box keeps its border, in the checked background's color; the glyph is drawn
    // // inside it.
    final borderSide = value
        ? BorderSide(color: checkedBackground, width: border.width)
        : accent != null
        ? BorderSide(color: accent!, width: border.width)
        : focused
        ? BorderSide(
            color:
                style.inputFocusBorderColor ??
                BsFormStyle.defaultInputFocusBorderColor,
            width: border.width,
          )
        : border;

    return BsDecoratedContainer(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: value
            ? checkedBackground
            : (background ??
                  style.inputBackground ??
                  BsFormStyle.defaultInputBackground),
        border: dashed && !value
            ? BsDashedBorder(color: border.color, width: border.width)
            : Border.fromBorderSide(borderSide),
        borderRadius: BorderRadius.circular(radius),
        boxShadow: focused ? _focusRing(style, accent) : null,
      ),
      child: !value
          ? null
          : type == BsFormCheckType.radio
          // // A plain DecoratedBox: a smooth dot is centered exactly, while a snapped box would round
          // // its half-pixel edges and push the dot off center.
          ? Center(
              child: SizedBox(
                // // The dot's diameter is half of the box inside its border.
                width: (size - 2 * border.width) / 2,
                height: (size - 2 * border.width) / 2,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color:
                        style.checkInputCheckedColor ??
                        BsFormStyle.defaultCheckInputCheckedColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            )
          : CustomPaint(
              size: Size.square(size - 2 * border.width),
              painter: _BsCheckmarkPainter(
                style.checkInputCheckedColor ??
                    BsFormStyle.defaultCheckInputCheckedColor,
              ),
            ),
    );
  }
}

/// The focus ring: a translucent ring in the primary color, or in the validation color of an
/// invalid or valid control.
List<BoxShadow> _focusRing(BsFormStyle style, Color? accent) => accent != null
    ? [BoxShadow(color: accent.withValues(alpha: 0.25), spreadRadius: 4)]
    : (style.inputFocusBoxShadow ?? BsFormStyle.defaultInputFocusBoxShadow);

/// The checkbox's tick: `M6 10l3 3l6-6` in a 20-unit viewBox, 3 units thick,
/// with round caps and joins.
class _BsCheckmarkPainter extends CustomPainter {
  _BsCheckmarkPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.width / 20;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3 * unit
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(6 * unit, 10 * unit)
      ..lineTo(9 * unit, 13 * unit)
      ..lineTo(15 * unit, 7 * unit);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BsCheckmarkPainter oldDelegate) =>
      oldDelegate.color != color;
}

/// A bare checkbox or radio: the control without a label or its own wrapper, for building
/// rows that lay out the control themselves, for example inside a list group item. Its side
/// is the [fontSize] (scale it to resize the control). It reports taps through [onChanged],
/// and is disabled (half transparent) when that is null.
class BsFormCheckInput extends StatelessWidget {
  const BsFormCheckInput({
    super.key,
    this.type = BsFormCheckType.checkbox,
    required this.value,
    required this.onChanged,
    this.fontSize = 16,
    this.dashed = false,
    this.background,
    this.style,
  }) : assert(type != BsFormCheckType.switchToggle);

  final BsFormCheckType type;
  final bool value;
  final ValueChanged<bool>? onChanged;

  /// The font size that the control's side is measured against.
  final double fontSize;

  /// Draws the border dashed.
  final bool dashed;

  /// `bg-*` on the control, in place of the input background.
  final Color? background;

  final BsFormStyle? style;

  @override
  Widget build(BuildContext context) {
    final isDark = BsTheme.of(context) == Brightness.dark;
    final style = (isDark ? BsFormStyle.darkDefaults : BsFormStyle.defaults)
        .merge(this.style);
    final enabled = onChanged != null;
    return Opacity(
      opacity: enabled
          ? 1
          : (style.checkInputDisabledOpacity ??
                BsFormStyle.defaultCheckInputDisabledOpacity),
      child: _SpaceToggles(
        enabled: enabled,
        onToggle: enabled ? () => onChanged!(!value) : null,
        child: BsFocusableBuilder(
          enabled: enabled,
          builder: (context, focused) => Builder(
            builder: (context) => GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: enabled
                  ? () {
                      Focus.of(context).requestFocus();
                      onChanged!(!value);
                    }
                  : null,
              // // A fixed-size box that a stretching flex line cannot grow.
              child: Align(
                alignment: AlignmentDirectional.topStart,
                widthFactor: 1,
                heightFactor: 1,
                child: _BsFormCheckGlyph(
                  type: type,
                  value: value,
                  style: style,
                  size:
                      (style.checkInputSize ??
                          BsFormStyle.defaultCheckInputSize) *
                      fontSize /
                      16,
                  dashed: dashed,
                  background: background,
                  focused: focused,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BsFormSwitchGlyph extends StatelessWidget {
  const _BsFormSwitchGlyph({
    required this.value,
    required this.style,
    this.focused = false,
    this.accent,
  });

  final bool value;
  final BsFormStyle style;

  /// `:focus`: the light-blue border and thumb, and the ring.
  final bool focused;
  final Color? accent;

  @override
  Widget build(BuildContext context) {
    final width = style.switchWidth ?? BsFormStyle.defaultSwitchWidth;
    final height = style.checkInputSize ?? BsFormStyle.defaultCheckInputSize;
    final trackColor = value
        ? (style.checkInputCheckedBackground ??
              BsFormStyle.defaults.checkInputCheckedBackground!)
        : (style.switchColor ?? BsFormStyle.defaultSwitchColor);
    final thumbSize = height * 0.75;
    final focusColor =
        style.inputFocusBorderColor ?? BsFormStyle.defaultInputFocusBorderColor;
    final transitionDuration = BsTransitions.resolve(
      context,
      style.switchTransitionDuration ??
          BsFormStyle.defaultSwitchTransitionDuration,
    );

    return BsAnimatedContainer(
      duration: transitionDuration,
      width: width,
      height: height,
      padding: EdgeInsets.symmetric(horizontal: (height - thumbSize) / 2),
      decoration: BoxDecoration(
        color: value
            ? trackColor
            : (style.inputBackground ?? BsFormStyle.defaultInputBackground),
        border: value
            ? null
            : Border.fromBorderSide(
                focused
                    ? BorderSide(
                        color: focusColor,
                        width:
                            (style.checkInputBorder ??
                                    BsFormStyle.defaultCheckInputBorder)
                                .width,
                      )
                    : style.checkInputBorder ??
                          BsFormStyle.defaultCheckInputBorder,
              ),
        borderRadius: BorderRadius.circular(
          style.switchBorderRadius ?? BsFormStyle.defaultSwitchBorderRadius,
        ),
        boxShadow: focused ? _focusRing(style, accent) : null,
      ),
      child: AnimatedAlign(
        duration: transitionDuration,
        // The checked thumb migrates toward the reading-end side (matching
        // Bootstrap's own RTLCSS-flipped background-position for
        // .form-switch), not always physically right.
        alignment: value
            ? AlignmentDirectional.centerEnd
            : AlignmentDirectional.centerStart,
        child: BsDecoratedContainer(
          width: thumbSize,
          height: thumbSize,
          decoration: BoxDecoration(
            color: value
                ? (style.checkInputCheckedColor ??
                      BsFormStyle.defaultCheckInputCheckedColor)
                : focused
                ? focusColor
                : (style.switchColor ?? BsFormStyle.defaultSwitchColor),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
