import 'package:flutter/widgets.dart';

import 'bs_dropdown.dart';
import 'bs_form_control.dart';
import 'bs_theme.dart';
import 'bs_validation_icon.dart';
import 'tokens/bs_form_style.dart';
import 'bs_decorated_box.dart';

/// A single `<option>` in a [BsFormSelect].
class BsFormSelectItem<T> {
  const BsFormSelectItem({required this.value, required this.label});

  final T value;

  /// Typically a [Text].
  final Widget label;
}

/// A Bootstrap select (`.form-select`): a [BsFormControl]-styled toggle that
/// opens a [BsDropdown] menu of [items].
class BsFormSelect<T> extends StatelessWidget {
  const BsFormSelect({
    super.key,
    required this.items,
    required this.value,
    required this.onChanged,
    this.placeholder,
    this.size = BsFormControlSize.normal,
    this.valid,
    this.style,
  });

  final List<BsFormSelectItem<T>> items;

  /// The currently-selected value, matched against each item's
  /// [BsFormSelectItem.value] by `==`. Null (or no match) shows
  /// [placeholder].
  final T? value;

  /// Disables the control when null.
  final ValueChanged<T>? onChanged;

  /// Shown when [value] doesn't match any [items] entry.
  final Widget? placeholder;

  /// `.form-select-sm`/`.form-select-lg`.
  final BsFormControlSize size;

  /// `.is-valid`/`.is-invalid`: tints the border and shows the feedback icon.
  final bool? valid;

  /// Style overrides layered on top of [BsFormStyle.defaults].
  final BsFormStyle? style;

  @override
  Widget build(BuildContext context) {
    final isDark = BsTheme.of(context) == Brightness.dark;
    final style = (isDark ? BsFormStyle.darkDefaults : BsFormStyle.defaults).merge(this.style);
    final enabled = onChanged != null;
    final padding = switch (size) {
      BsFormControlSize.small =>
        style.inputPaddingSm ?? BsFormStyle.defaultInputPaddingSm,
      BsFormControlSize.normal =>
        style.inputPadding ?? BsFormStyle.defaultInputPadding,
      BsFormControlSize.large =>
        style.inputPaddingLg ?? BsFormStyle.defaultInputPaddingLg,
    };
    final fontSize = switch (size) {
      BsFormControlSize.small =>
        style.inputFontSizeSm ?? BsFormStyle.defaultInputFontSizeSm,
      BsFormControlSize.normal =>
        style.inputFontSize ?? BsFormStyle.defaultInputFontSize,
      BsFormControlSize.large =>
        style.inputFontSizeLg ?? BsFormStyle.defaultInputFontSizeLg,
    };
    final borderRadius = switch (size) {
      BsFormControlSize.small =>
        style.inputBorderRadiusSm ?? BsFormStyle.defaultInputBorderRadiusSm,
      BsFormControlSize.normal =>
        style.inputBorderRadius ?? BsFormStyle.defaultInputBorderRadius,
      BsFormControlSize.large =>
        style.inputBorderRadiusLg ?? BsFormStyle.defaultInputBorderRadiusLg,
    };

    Widget? selectedLabel;
    for (final item in items) {
      if (item.value == value) {
        selectedLabel = item.label;
        break;
      }
    }
    final displayed = selectedLabel ?? placeholder ?? const SizedBox.shrink();

    return BsDropdown(
      toggleBuilder: (context, toggle, isOpen) {
        final borderColor = switch (valid) {
          false => style.invalidColor ?? BsFormStyle.defaultInvalidColor,
          true => style.validColor ?? BsFormStyle.defaultValidColor,
          null =>
            isOpen
                ? (style.inputFocusBorderColor ??
                      BsFormStyle.defaultInputFocusBorderColor)
                : (style.inputBorderColor ??
                      BsFormStyle.defaultInputBorderColor),
        };

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: enabled ? toggle : null,
          child: BsDecoratedContainer(
            padding: padding,
            decoration: BoxDecoration(
              color: enabled
                  ? (style.inputBackground ??
                        BsFormStyle.defaultInputBackground)
                  : (style.inputDisabledBackground ??
                        BsFormStyle.defaultInputDisabledBackground),
              border: Border.all(
                color: borderColor,
                width:
                    style.inputBorderWidth ??
                    BsFormStyle.defaultInputBorderWidth,
              ),
              borderRadius: BorderRadius.circular(borderRadius),
              boxShadow: isOpen
                  ? (style.inputFocusBoxShadow ??
                        BsFormStyle.defaultInputFocusBoxShadow)
                  : null,
            ),
            child: Row(
              children: [
                Expanded(
                  child: DefaultTextStyle.merge(
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight:
                          style.inputFontWeight ??
                          BsFormStyle.defaultInputFontWeight,
                      color: style.inputColor ?? BsFormStyle.defaultInputColor,
                    ),
                    child: displayed,
                  ),
                ),
                if (valid != null) ...[
                  const SizedBox(width: 12),
                  BsValidationIcon(valid: valid!, fontSize: fontSize),
                ],
                const SizedBox(width: 8),
                // `$form-select-indicator`: a 16x12 chevron (`m2 5 6 6 6-6`, a
                // 2px round stroke)
                CustomPaint(
                  size:
                      style.selectBackgroundSize ??
                      BsFormStyle.defaultSelectBackgroundSize,
                  painter: _SelectChevronPainter(
                    style.selectIndicatorColor ??
                        BsFormStyle.defaultSelectIndicatorColor,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      items: [
        for (final item in items)
          BsDropdownItem(
            active: item.value == value,
            onTap: enabled ? () => onChanged!(item.value) : null,
            disabled: !enabled,
            child: item.label,
          ),
      ],
    );
  }
}

class _SelectChevronPainter extends CustomPainter {
  _SelectChevronPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    // `viewBox="0 0 16 16"` shown at `16px 12px`: scaled to fit (`meet`) and
    // centred, so `.75` of its size.
    final scale = size.width / 16 < size.height / 16
        ? size.width / 16
        : size.height / 16;
    canvas.translate(
      (size.width - 16 * scale) / 2,
      (size.height - 16 * scale) / 2,
    );
    canvas.drawPath(
      Path()
        ..moveTo(2 * scale, 5 * scale)
        ..lineTo(8 * scale, 11 * scale)
        ..lineTo(14 * scale, 5 * scale),
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2 * scale
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_SelectChevronPainter oldDelegate) => oldDelegate.color != color;
}
