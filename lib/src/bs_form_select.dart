import 'package:flutter/widgets.dart';

import 'bs_dropdown.dart';
import 'bs_form_control.dart';
import 'tokens/bs_form_style.dart';

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

  /// Style overrides layered on top of [BsFormStyle.defaults].
  final BsFormStyle? style;

  @override
  Widget build(BuildContext context) {
    final style = BsFormStyle.defaults.merge(this.style);
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
        final borderColor = isOpen
            ? (style.inputFocusBorderColor ??
                  BsFormStyle.defaultInputFocusBorderColor)
            : (style.inputBorderColor ?? BsFormStyle.defaultInputBorderColor);

        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: enabled ? toggle : null,
          child: Container(
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
                const SizedBox(width: 8),
                BsDropdownCaret(
                  color:
                      style.selectIndicatorColor ??
                      BsFormStyle.defaultSelectIndicatorColor,
                  size:
                      (style.selectBackgroundSize ??
                              BsFormStyle.defaultSelectBackgroundSize)
                          .width,
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
