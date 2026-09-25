import 'package:flutter/widgets.dart';

import 'bs_theme.dart';
import 'tokens/bs_form_style.dart';

/// `.form-check-input[type=checkbox]`/`[type=radio]`/`.form-switch`: how a
/// [BsFormCheck] renders and toggles.
enum BsFormCheckType {
  /// A square box with a checkmark when [BsFormCheck.value] is true.
  checkbox,

  /// A circular dot, filled when [BsFormCheck.value] is true.
  radio,

  /// `.form-switch`: a pill-shaped track with a sliding thumb.
  switchToggle,
}

/// A Bootstrap checkbox, radio, or switch (`.form-check`), with an optional
/// [label] alongside it. Both the control and [label] toggle [value] on tap.
class BsFormCheck extends StatelessWidget {
  const BsFormCheck({
    super.key,
    this.type = BsFormCheckType.checkbox,
    required this.value,
    required this.onChanged,
    this.label,
    this.style,
  });

  final BsFormCheckType type;

  final bool value;

  /// Disables the control (rendered at [BsFormStyle.checkInputDisabledOpacity])
  /// when null.
  final ValueChanged<bool>? onChanged;

  final Widget? label;

  /// Style overrides layered on top of [BsFormStyle.defaults].
  final BsFormStyle? style;

  @override
  Widget build(BuildContext context) {
    final isDark = BsTheme.of(context) == Brightness.dark;
    final style = (isDark ? BsFormStyle.darkDefaults : BsFormStyle.defaults).merge(this.style);
    final enabled = onChanged != null;
    final onTap = enabled ? () => onChanged!(!value) : null;

    final control = switch (type) {
      BsFormCheckType.switchToggle => _BsFormSwitchGlyph(
        value: value,
        style: style,
      ),
      _ => _BsFormCheckGlyph(type: type, value: value, style: style),
    };

    return Opacity(
      opacity: enabled
          ? 1
          : (style.checkInputDisabledOpacity ??
                BsFormStyle.defaultCheckInputDisabledOpacity),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            control,
            if (label != null) ...[
              const SizedBox(width: 8),
              Flexible(child: label!),
            ],
          ],
        ),
      ),
    );
  }
}

class _BsFormCheckGlyph extends StatelessWidget {
  const _BsFormCheckGlyph({
    required this.type,
    required this.value,
    required this.style,
  });

  final BsFormCheckType type;
  final bool value;
  final BsFormStyle style;

  @override
  Widget build(BuildContext context) {
    final size = style.checkInputSize ?? BsFormStyle.defaultCheckInputSize;
    final border =
        style.checkInputBorder ?? BsFormStyle.defaultCheckInputBorder;
    final radius = type == BsFormCheckType.radio
        ? (style.checkRadioBorderRadius ??
              BsFormStyle.defaultCheckRadioBorderRadius)
        : (style.checkInputBorderRadius ??
              BsFormStyle.defaultCheckInputBorderRadius);
    final checkedBackground =
        style.checkInputCheckedBackground ??
        BsFormStyle.defaults.checkInputCheckedBackground!;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: value
            ? checkedBackground
            : (style.inputBackground ?? BsFormStyle.defaultInputBackground),
        border: value ? null : Border.fromBorderSide(border),
        borderRadius: BorderRadius.circular(radius),
      ),
      child: !value
          ? null
          : type == BsFormCheckType.radio
          ? Center(
              child: Container(
                width: size * 0.4,
                height: size * 0.4,
                decoration: BoxDecoration(
                  color:
                      style.checkInputCheckedColor ??
                      BsFormStyle.defaultCheckInputCheckedColor,
                  shape: BoxShape.circle,
                ),
              ),
            )
          : CustomPaint(
              size: Size.square(size),
              painter: _BsCheckmarkPainter(
                style.checkInputCheckedColor ??
                    BsFormStyle.defaultCheckInputCheckedColor,
              ),
            ),
    );
  }
}

class _BsCheckmarkPainter extends CustomPainter {
  _BsCheckmarkPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.width * 0.14
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(size.width * 0.22, size.height * 0.52)
      ..lineTo(size.width * 0.42, size.height * 0.72)
      ..lineTo(size.width * 0.78, size.height * 0.28);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BsCheckmarkPainter oldDelegate) =>
      oldDelegate.color != color;
}

class _BsFormSwitchGlyph extends StatelessWidget {
  const _BsFormSwitchGlyph({required this.value, required this.style});

  final bool value;
  final BsFormStyle style;

  @override
  Widget build(BuildContext context) {
    final width = style.switchWidth ?? BsFormStyle.defaultSwitchWidth;
    final height = style.checkInputSize ?? BsFormStyle.defaultCheckInputSize;
    final trackColor = value
        ? (style.checkInputCheckedBackground ??
              BsFormStyle.defaults.checkInputCheckedBackground!)
        : (style.switchColor ?? BsFormStyle.defaultSwitchColor);
    final thumbSize = height * 0.75;

    return AnimatedContainer(
      duration:
          style.switchTransitionDuration ??
          BsFormStyle.defaultSwitchTransitionDuration,
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
                style.checkInputBorder ?? BsFormStyle.defaultCheckInputBorder,
              ),
        borderRadius: BorderRadius.circular(
          style.switchBorderRadius ?? BsFormStyle.defaultSwitchBorderRadius,
        ),
      ),
      child: AnimatedAlign(
        duration:
            style.switchTransitionDuration ??
            BsFormStyle.defaultSwitchTransitionDuration,
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: thumbSize,
          height: thumbSize,
          decoration: BoxDecoration(
            color: value
                ? (style.checkInputCheckedColor ??
                      BsFormStyle.defaultCheckInputCheckedColor)
                : (style.switchColor ?? BsFormStyle.defaultSwitchColor),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
