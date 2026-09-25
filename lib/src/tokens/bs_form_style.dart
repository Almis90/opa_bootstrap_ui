import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_colors.dart';
import '../bs_variant.dart';
import 'bs_borders.dart';
import 'bs_shadows.dart';

/// Bootstrap form controls' visual variables: text inputs/textareas,
/// selects, checks/radios/switches, ranges, file inputs, floating labels,
/// input groups, and validation feedback.
///
/// Mirrors the `form-text-variables`, `form-label-variables`,
/// `form-input-variables`, `form-check-variables`, `form-switch-variables`,
/// `input-group-variables`, `form-select-variables`, `form-range-variables`,
/// `form-file-variables`, `form-floating-variables`, `form-feedback-variables`
/// and `form-validation-colors` groups from Bootstrap's SCSS source.
@immutable
class BsFormStyle {
  const BsFormStyle({
    // Help text
    this.textMarginTop,
    this.textFontSize,
    this.textColor,
    // Label
    this.labelMarginBottom,
    // Text input
    this.inputPadding,
    this.inputPaddingSm,
    this.inputPaddingLg,
    this.inputFontSize,
    this.inputFontSizeSm,
    this.inputFontSizeLg,
    this.inputFontWeight,
    this.inputLineHeight,
    this.inputColor,
    this.inputBackground,
    this.inputDisabledBackground,
    this.inputBorderColor,
    this.inputBorderWidth,
    this.inputBoxShadow,
    this.inputBorderRadius,
    this.inputBorderRadiusSm,
    this.inputBorderRadiusLg,
    this.inputFocusBorderColor,
    this.inputFocusBoxShadow,
    this.inputPlaceholderColor,
    this.inputHeight,
    this.inputHeightSm,
    this.inputHeightLg,
    this.inputTransitionDuration,
    // Checks/radios
    this.checkInputSize,
    this.checkPaddingStart,
    this.checkMarginBottom,
    this.checkInputBorder,
    this.checkInputBorderRadius,
    this.checkRadioBorderRadius,
    this.checkInputCheckedColor,
    this.checkInputCheckedBackground,
    this.checkInputDisabledOpacity,
    this.checkInlineMarginEnd,
    // Switches
    this.switchWidth,
    this.switchColor,
    this.switchBorderRadius,
    this.switchTransitionDuration,
    // Input groups
    this.inputGroupAddonPadding,
    this.inputGroupAddonColor,
    this.inputGroupAddonBackground,
    // Select
    this.selectIndicatorColor,
    this.selectBackgroundSize,
    // Range
    this.rangeTrackHeight,
    this.rangeTrackBackground,
    this.rangeTrackBorderRadius,
    this.rangeThumbSize,
    this.rangeThumbBackground,
    this.rangeThumbActiveBackground,
    this.rangeThumbDisabledBackground,
    this.rangeThumbBorderRadius,
    this.rangeThumbBoxShadow,
    // File
    this.fileButtonColor,
    this.fileButtonBackground,
    this.fileButtonHoverBackground,
    // Floating labels
    this.floatingHeight,
    this.floatingLineHeight,
    this.floatingPadding,
    this.floatingInputPaddingTop,
    this.floatingInputPaddingBottom,
    this.floatingLabelOpacity,
    this.floatingLabelDisabledColor,
    // Validation
    this.validColor,
    this.invalidColor,
  });

  /// `$form-text-margin-top` (`.25rem`).
  final double? textMarginTop;

  /// `$form-text-font-size` (`$small-font-size`).
  final double? textFontSize;

  /// `$form-text-color` (`var(--bs-secondary-color)`).
  final Color? textColor;

  /// `$form-label-margin-bottom` (`.5rem`).
  final double? labelMarginBottom;

  /// `$input-padding-y`/`$input-padding-x` (`.375rem`/`.75rem`).
  final EdgeInsetsGeometry? inputPadding;

  /// `$input-padding-y-sm`/`$input-padding-x-sm` (`.25rem`/`.5rem`).
  final EdgeInsetsGeometry? inputPaddingSm;

  /// `$input-padding-y-lg`/`$input-padding-x-lg` (`.5rem`/`1rem`).
  final EdgeInsetsGeometry? inputPaddingLg;

  /// `$input-font-size` (`$font-size-base`).
  final double? inputFontSize;

  /// `$input-font-size-sm` (`$font-size-sm`).
  final double? inputFontSizeSm;

  /// `$input-font-size-lg` (`$font-size-lg`).
  final double? inputFontSizeLg;

  /// `$input-font-weight` (`$font-weight-base`).
  final FontWeight? inputFontWeight;

  /// `$input-line-height` (`$line-height-base`).
  final double? inputLineHeight;

  /// `$input-color` (`var(--bs-body-color)`).
  final Color? inputColor;

  /// `$input-bg` (`var(--bs-body-bg)`).
  final Color? inputBackground;

  /// `$input-disabled-bg` (`var(--bs-secondary-bg)`).
  final Color? inputDisabledBackground;

  /// `$input-border-color` (`var(--bs-border-color)`).
  final Color? inputBorderColor;

  /// `$input-border-width` (`var(--bs-border-width)`).
  final double? inputBorderWidth;

  /// `$input-box-shadow` (`var(--bs-box-shadow-inset)`).
  final List<BoxShadow>? inputBoxShadow;

  /// `$input-border-radius` (`var(--bs-border-radius)`).
  final double? inputBorderRadius;

  /// `$input-border-radius-sm` (`var(--bs-border-radius-sm)`).
  final double? inputBorderRadiusSm;

  /// `$input-border-radius-lg` (`var(--bs-border-radius-lg)`).
  final double? inputBorderRadiusLg;

  /// `$input-focus-border-color` (`tint-color($component-active-bg, 50%)`).
  final Color? inputFocusBorderColor;

  /// `$input-focus-box-shadow` (`$input-btn-focus-box-shadow`).
  final List<BoxShadow>? inputFocusBoxShadow;

  /// `$input-placeholder-color` (`var(--bs-secondary-color)`).
  final Color? inputPlaceholderColor;

  /// `$input-height` (line-height + padding + border, normal size).
  final double? inputHeight;

  /// `$input-height-sm`.
  final double? inputHeightSm;

  /// `$input-height-lg`.
  final double? inputHeightLg;

  /// `$input-transition` (`border-color .15s ease-in-out, box-shadow .15s ease-in-out`).
  final Duration? inputTransitionDuration;

  /// `$form-check-input-width` (`1em`).
  final double? checkInputSize;

  /// `$form-check-padding-start` (`$form-check-input-width + .5em`).
  final double? checkPaddingStart;

  /// `$form-check-margin-bottom` (`.125rem`).
  final double? checkMarginBottom;

  /// `$form-check-input-border` (`var(--bs-border-width) solid var(--bs-border-color)`).
  final BorderSide? checkInputBorder;

  /// `$form-check-input-border-radius` (`.25em`).
  final double? checkInputBorderRadius;

  /// `$form-check-radio-border-radius` (`50%`).
  final double? checkRadioBorderRadius;

  /// `$form-check-input-checked-color` (`$component-active-color`).
  final Color? checkInputCheckedColor;

  /// `$form-check-input-checked-bg-color` (`$component-active-bg`).
  final Color? checkInputCheckedBackground;

  /// `$form-check-input-disabled-opacity` (`.5`).
  final double? checkInputDisabledOpacity;

  /// `$form-check-inline-margin-end` (`1rem`).
  final double? checkInlineMarginEnd;

  /// `$form-switch-width` (`2em`).
  final double? switchWidth;

  /// `$form-switch-color` (`rgba($black, .25)`), the unchecked thumb color.
  final Color? switchColor;

  /// `$form-switch-border-radius` (`$form-switch-width`).
  final double? switchBorderRadius;

  /// `$form-switch-transition` (`background-position .15s ease-in-out`).
  final Duration? switchTransitionDuration;

  /// `$input-group-addon-padding-y`/`$input-group-addon-padding-x`.
  final EdgeInsetsGeometry? inputGroupAddonPadding;

  /// `$input-group-addon-color` (`$input-color`).
  final Color? inputGroupAddonColor;

  /// `$input-group-addon-bg` (`var(--bs-tertiary-bg)`).
  final Color? inputGroupAddonBackground;

  /// `$form-select-indicator-color` (`$gray-800`).
  final Color? selectIndicatorColor;

  /// `$form-select-bg-size` (`16px 12px`).
  final Size? selectBackgroundSize;

  /// `$form-range-track-height` (`.5rem`).
  final double? rangeTrackHeight;

  /// `$form-range-track-bg` (`var(--bs-secondary-bg)`).
  final Color? rangeTrackBackground;

  /// `$form-range-track-border-radius` (`1rem`).
  final double? rangeTrackBorderRadius;

  /// `$form-range-thumb-width`/`$form-range-thumb-height` (`1rem`).
  final double? rangeThumbSize;

  /// `$form-range-thumb-bg` (`$component-active-bg`).
  final Color? rangeThumbBackground;

  /// `$form-range-thumb-active-bg` (`tint-color($component-active-bg, 70%)`).
  final Color? rangeThumbActiveBackground;

  /// `$form-range-thumb-disabled-bg` (`var(--bs-secondary-color)`).
  final Color? rangeThumbDisabledBackground;

  /// `$form-range-thumb-border-radius` (`1rem`).
  final double? rangeThumbBorderRadius;

  /// `$form-range-thumb-box-shadow` (`0 .1rem .25rem rgba($black, .1)`).
  final List<BoxShadow>? rangeThumbBoxShadow;

  /// `$form-file-button-color` (`$input-color`).
  final Color? fileButtonColor;

  /// `$form-file-button-bg` (`var(--bs-tertiary-bg)`).
  final Color? fileButtonBackground;

  /// `$form-file-button-hover-bg` (`var(--bs-secondary-bg)`).
  final Color? fileButtonHoverBackground;

  /// `$form-floating-height` (`add(3.5rem, $input-height-border)`).
  final double? floatingHeight;

  /// `$form-floating-line-height` (`1.25`), applied to the wrapped
  /// [BsFormControl] in place of [inputLineHeight].
  final double? floatingLineHeight;

  /// `$form-floating-padding-y`/`$form-floating-padding-x` (`1rem`/`$input-padding-x`).
  final EdgeInsetsGeometry? floatingPadding;

  /// `$form-floating-input-padding-t` (`1.625rem`): the wrapped control's
  /// top padding, which makes room for the floated label above the text.
  final double? floatingInputPaddingTop;

  /// `$form-floating-input-padding-b` (`.625rem`): the wrapped control's
  /// bottom padding.
  final double? floatingInputPaddingBottom;

  /// `$form-floating-label-opacity` (`.65`).
  final double? floatingLabelOpacity;

  /// `$form-floating-label-disabled-color` (`$gray-600`).
  final Color? floatingLabelDisabledColor;

  /// `$form-valid-color`/`$form-valid-border-color` (`$success`).
  final Color? validColor;

  /// `$form-invalid-color`/`$form-invalid-border-color` (`$danger`).
  final Color? invalidColor;

  BsFormStyle merge(BsFormStyle? other) {
    if (other == null) return this;
    return BsFormStyle(
      textMarginTop: other.textMarginTop ?? textMarginTop,
      textFontSize: other.textFontSize ?? textFontSize,
      textColor: other.textColor ?? textColor,
      labelMarginBottom: other.labelMarginBottom ?? labelMarginBottom,
      inputPadding: other.inputPadding ?? inputPadding,
      inputPaddingSm: other.inputPaddingSm ?? inputPaddingSm,
      inputPaddingLg: other.inputPaddingLg ?? inputPaddingLg,
      inputFontSize: other.inputFontSize ?? inputFontSize,
      inputFontSizeSm: other.inputFontSizeSm ?? inputFontSizeSm,
      inputFontSizeLg: other.inputFontSizeLg ?? inputFontSizeLg,
      inputFontWeight: other.inputFontWeight ?? inputFontWeight,
      inputLineHeight: other.inputLineHeight ?? inputLineHeight,
      inputColor: other.inputColor ?? inputColor,
      inputBackground: other.inputBackground ?? inputBackground,
      inputDisabledBackground:
          other.inputDisabledBackground ?? inputDisabledBackground,
      inputBorderColor: other.inputBorderColor ?? inputBorderColor,
      inputBorderWidth: other.inputBorderWidth ?? inputBorderWidth,
      inputBoxShadow: other.inputBoxShadow ?? inputBoxShadow,
      inputBorderRadius: other.inputBorderRadius ?? inputBorderRadius,
      inputBorderRadiusSm: other.inputBorderRadiusSm ?? inputBorderRadiusSm,
      inputBorderRadiusLg: other.inputBorderRadiusLg ?? inputBorderRadiusLg,
      inputFocusBorderColor:
          other.inputFocusBorderColor ?? inputFocusBorderColor,
      inputFocusBoxShadow: other.inputFocusBoxShadow ?? inputFocusBoxShadow,
      inputPlaceholderColor:
          other.inputPlaceholderColor ?? inputPlaceholderColor,
      inputHeight: other.inputHeight ?? inputHeight,
      inputHeightSm: other.inputHeightSm ?? inputHeightSm,
      inputHeightLg: other.inputHeightLg ?? inputHeightLg,
      inputTransitionDuration:
          other.inputTransitionDuration ?? inputTransitionDuration,
      checkInputSize: other.checkInputSize ?? checkInputSize,
      checkPaddingStart: other.checkPaddingStart ?? checkPaddingStart,
      checkMarginBottom: other.checkMarginBottom ?? checkMarginBottom,
      checkInputBorder: other.checkInputBorder ?? checkInputBorder,
      checkInputBorderRadius:
          other.checkInputBorderRadius ?? checkInputBorderRadius,
      checkRadioBorderRadius:
          other.checkRadioBorderRadius ?? checkRadioBorderRadius,
      checkInputCheckedColor:
          other.checkInputCheckedColor ?? checkInputCheckedColor,
      checkInputCheckedBackground:
          other.checkInputCheckedBackground ?? checkInputCheckedBackground,
      checkInputDisabledOpacity:
          other.checkInputDisabledOpacity ?? checkInputDisabledOpacity,
      checkInlineMarginEnd: other.checkInlineMarginEnd ?? checkInlineMarginEnd,
      switchWidth: other.switchWidth ?? switchWidth,
      switchColor: other.switchColor ?? switchColor,
      switchBorderRadius: other.switchBorderRadius ?? switchBorderRadius,
      switchTransitionDuration:
          other.switchTransitionDuration ?? switchTransitionDuration,
      inputGroupAddonPadding:
          other.inputGroupAddonPadding ?? inputGroupAddonPadding,
      inputGroupAddonColor: other.inputGroupAddonColor ?? inputGroupAddonColor,
      inputGroupAddonBackground:
          other.inputGroupAddonBackground ?? inputGroupAddonBackground,
      selectIndicatorColor: other.selectIndicatorColor ?? selectIndicatorColor,
      selectBackgroundSize: other.selectBackgroundSize ?? selectBackgroundSize,
      rangeTrackHeight: other.rangeTrackHeight ?? rangeTrackHeight,
      rangeTrackBackground: other.rangeTrackBackground ?? rangeTrackBackground,
      rangeTrackBorderRadius:
          other.rangeTrackBorderRadius ?? rangeTrackBorderRadius,
      rangeThumbSize: other.rangeThumbSize ?? rangeThumbSize,
      rangeThumbBackground: other.rangeThumbBackground ?? rangeThumbBackground,
      rangeThumbActiveBackground:
          other.rangeThumbActiveBackground ?? rangeThumbActiveBackground,
      rangeThumbDisabledBackground:
          other.rangeThumbDisabledBackground ?? rangeThumbDisabledBackground,
      rangeThumbBorderRadius:
          other.rangeThumbBorderRadius ?? rangeThumbBorderRadius,
      rangeThumbBoxShadow: other.rangeThumbBoxShadow ?? rangeThumbBoxShadow,
      fileButtonColor: other.fileButtonColor ?? fileButtonColor,
      fileButtonBackground: other.fileButtonBackground ?? fileButtonBackground,
      fileButtonHoverBackground:
          other.fileButtonHoverBackground ?? fileButtonHoverBackground,
      floatingHeight: other.floatingHeight ?? floatingHeight,
      floatingLineHeight: other.floatingLineHeight ?? floatingLineHeight,
      floatingPadding: other.floatingPadding ?? floatingPadding,
      floatingInputPaddingTop:
          other.floatingInputPaddingTop ?? floatingInputPaddingTop,
      floatingInputPaddingBottom:
          other.floatingInputPaddingBottom ?? floatingInputPaddingBottom,
      floatingLabelOpacity: other.floatingLabelOpacity ?? floatingLabelOpacity,
      floatingLabelDisabledColor:
          other.floatingLabelDisabledColor ?? floatingLabelDisabledColor,
      validColor: other.validColor ?? validColor,
      invalidColor: other.invalidColor ?? invalidColor,
    );
  }

  static const double defaultTextMarginTop = 4;
  static const double defaultTextFontSize = 14;
  static const Color defaultTextColor = BsColors.gray600;
  static const double defaultLabelMarginBottom = 8;

  static const EdgeInsets defaultInputPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 6,
  );
  static const EdgeInsets defaultInputPaddingSm = EdgeInsets.symmetric(
    horizontal: 8,
    vertical: 4,
  );
  static const EdgeInsets defaultInputPaddingLg = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  );
  static const double defaultInputFontSize = 16;
  static const double defaultInputFontSizeSm = 14;
  static const double defaultInputFontSizeLg = 20;
  static const FontWeight defaultInputFontWeight = FontWeight.normal;
  static const double defaultInputLineHeight = 1.5;
  static const Color defaultInputColor = BsColors.gray900;
  static const Color defaultInputBackground = BsColors.white;
  static const Color defaultInputDisabledBackground = BsColors.gray200;
  static const Color defaultInputBorderColor = BsBorders.color;
  static const double defaultInputBorderWidth = BsBorders.width;
  static const List<BoxShadow> defaultInputBoxShadow = BsShadows.shadowInset;
  static const double defaultInputBorderRadius = BsBorders.radius;
  static const double defaultInputBorderRadiusSm = BsBorders.radiusSm;
  static const double defaultInputBorderRadiusLg = BsBorders.radiusLg;
  static const Color defaultInputPlaceholderColor = BsColors.gray600;

  /// `$input-height-border` (`$input-border-width * 2`).
  static const double defaultInputHeightBorder = defaultInputBorderWidth * 2;

  /// `$input-height`: `$input-line-height * 1em + $input-padding-y * 2 + border`.
  static const double defaultInputHeight =
      defaultInputLineHeight * defaultInputFontSize +
      12 +
      defaultInputHeightBorder;
  static const double defaultInputHeightSm =
      defaultInputLineHeight * defaultInputFontSize +
      8 +
      defaultInputHeightBorder;
  static const double defaultInputHeightLg =
      defaultInputLineHeight * defaultInputFontSize +
      16 +
      defaultInputHeightBorder;

  static const Duration defaultInputTransitionDuration = Duration(
    milliseconds: 150,
  );

  static const double defaultCheckInputSize = 16;
  static const double defaultCheckPaddingStart = defaultCheckInputSize + 8;
  static const double defaultCheckMarginBottom = 2;
  static const BorderSide defaultCheckInputBorder = BorderSide(
    color: defaultInputBorderColor,
    width: defaultInputBorderWidth,
  );
  static const double defaultCheckInputBorderRadius = 4;
  static const double defaultCheckRadioBorderRadius = 800;
  static const Color defaultCheckInputCheckedColor = BsColors.white;
  static const double defaultCheckInputDisabledOpacity = 0.5;
  static const double defaultCheckInlineMarginEnd = 16;

  static const double defaultSwitchWidth = 32;
  static const Color defaultSwitchColor = Color(0x40000000);
  static const double defaultSwitchBorderRadius = defaultSwitchWidth;
  static const Duration defaultSwitchTransitionDuration = Duration(
    milliseconds: 150,
  );

  static const EdgeInsets defaultInputGroupAddonPadding = defaultInputPadding;
  static const Color defaultInputGroupAddonColor = defaultInputColor;
  static const Color defaultInputGroupAddonBackground = BsColors.gray100;

  static const Color defaultSelectIndicatorColor = BsColors.gray800;
  static const Size defaultSelectBackgroundSize = Size(16, 12);

  static const double defaultRangeTrackHeight = 8;
  static const Color defaultRangeTrackBackground = BsColors.gray200;
  static const double defaultRangeTrackBorderRadius = 16;
  static const double defaultRangeThumbSize = 16;
  static const Color defaultRangeThumbDisabledBackground = BsColors.gray600;

  /// `$form-range-thumb-border-radius` (`1rem`).
  static const double defaultRangeThumbBorderRadius = 16;

  /// `$form-range-thumb-box-shadow: 0 .1rem .25rem rgba($black, .1)`.
  static const List<BoxShadow> defaultRangeThumbBoxShadow = [
    BoxShadow(color: Color(0x1A000000), offset: Offset(0, 1.6), blurRadius: 4),
  ];

  static const Color defaultFileButtonColor = defaultInputColor;
  static const Color defaultFileButtonBackground = BsColors.gray100;
  static const Color defaultFileButtonHoverBackground = BsColors.gray200;

  /// `$form-floating-height` (`add(3.5rem, $input-height-border)`).
  static const double defaultFloatingHeight = 56 + defaultInputHeightBorder;

  /// `$form-floating-line-height` (`1.25`).
  static const double defaultFloatingLineHeight = 1.25;

  static const EdgeInsets defaultFloatingPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 16,
  );

  /// `$form-floating-input-padding-t` (`1.625rem`).
  static const double defaultFloatingInputPaddingTop = 26;

  /// `$form-floating-input-padding-b` (`.625rem`).
  static const double defaultFloatingInputPaddingBottom = 10;

  static const double defaultFloatingLabelOpacity = 0.65;

  /// `$form-floating-label-disabled-color` (`$gray-600`).
  static const Color defaultFloatingLabelDisabledColor = BsColors.gray600;

  static Color get defaultValidColor => BsVariant.success.color;
  static Color get defaultInvalidColor => BsVariant.danger.color;

  static Color get defaultInputFocusBorderColor =>
      _tint(BsVariant.primary.color, 0.5);

  /// `$input-focus-box-shadow` (`$input-btn-focus-box-shadow` /
  /// `$focus-ring-box-shadow`): `0 0 0 .25rem rgba($primary, .25)`.
  static List<BoxShadow> get defaultInputFocusBoxShadow => [
    BoxShadow(
      color: BsVariant.primary.color.withValues(alpha: 0.25),
      spreadRadius: 4,
    ),
  ];

  static Color get defaultRangeThumbBackground => BsVariant.primary.color;
  static Color get defaultRangeThumbActiveBackground =>
      _tint(BsVariant.primary.color, 0.7);

  static Color _tint(Color color, double weight) =>
      Color.lerp(color, const Color(0xFFFFFFFF), weight)!;

  static BsFormStyle get defaults => BsFormStyle(
    textMarginTop: defaultTextMarginTop,
    textFontSize: defaultTextFontSize,
    textColor: defaultTextColor,
    labelMarginBottom: defaultLabelMarginBottom,
    inputPadding: defaultInputPadding,
    inputPaddingSm: defaultInputPaddingSm,
    inputPaddingLg: defaultInputPaddingLg,
    inputFontSize: defaultInputFontSize,
    inputFontSizeSm: defaultInputFontSizeSm,
    inputFontSizeLg: defaultInputFontSizeLg,
    inputFontWeight: defaultInputFontWeight,
    inputLineHeight: defaultInputLineHeight,
    inputColor: defaultInputColor,
    inputBackground: defaultInputBackground,
    inputDisabledBackground: defaultInputDisabledBackground,
    inputBorderColor: defaultInputBorderColor,
    inputBorderWidth: defaultInputBorderWidth,
    inputBoxShadow: defaultInputBoxShadow,
    inputBorderRadius: defaultInputBorderRadius,
    inputBorderRadiusSm: defaultInputBorderRadiusSm,
    inputBorderRadiusLg: defaultInputBorderRadiusLg,
    inputFocusBorderColor: defaultInputFocusBorderColor,
    inputFocusBoxShadow: defaultInputFocusBoxShadow,
    inputPlaceholderColor: defaultInputPlaceholderColor,
    inputHeight: defaultInputHeight,
    inputHeightSm: defaultInputHeightSm,
    inputHeightLg: defaultInputHeightLg,
    inputTransitionDuration: defaultInputTransitionDuration,
    checkInputSize: defaultCheckInputSize,
    checkPaddingStart: defaultCheckPaddingStart,
    checkMarginBottom: defaultCheckMarginBottom,
    checkInputBorder: defaultCheckInputBorder,
    checkInputBorderRadius: defaultCheckInputBorderRadius,
    checkRadioBorderRadius: defaultCheckRadioBorderRadius,
    checkInputCheckedColor: defaultCheckInputCheckedColor,
    checkInputCheckedBackground: BsVariant.primary.color,
    checkInputDisabledOpacity: defaultCheckInputDisabledOpacity,
    checkInlineMarginEnd: defaultCheckInlineMarginEnd,
    switchWidth: defaultSwitchWidth,
    switchColor: defaultSwitchColor,
    switchBorderRadius: defaultSwitchBorderRadius,
    switchTransitionDuration: defaultSwitchTransitionDuration,
    inputGroupAddonPadding: defaultInputGroupAddonPadding,
    inputGroupAddonColor: defaultInputGroupAddonColor,
    inputGroupAddonBackground: defaultInputGroupAddonBackground,
    selectIndicatorColor: defaultSelectIndicatorColor,
    selectBackgroundSize: defaultSelectBackgroundSize,
    rangeTrackHeight: defaultRangeTrackHeight,
    rangeTrackBackground: defaultRangeTrackBackground,
    rangeTrackBorderRadius: defaultRangeTrackBorderRadius,
    rangeThumbSize: defaultRangeThumbSize,
    rangeThumbBackground: defaultRangeThumbBackground,
    rangeThumbActiveBackground: defaultRangeThumbActiveBackground,
    rangeThumbDisabledBackground: defaultRangeThumbDisabledBackground,
    rangeThumbBorderRadius: defaultRangeThumbBorderRadius,
    rangeThumbBoxShadow: defaultRangeThumbBoxShadow,
    fileButtonColor: defaultFileButtonColor,
    fileButtonBackground: defaultFileButtonBackground,
    fileButtonHoverBackground: defaultFileButtonHoverBackground,
    floatingHeight: defaultFloatingHeight,
    floatingLineHeight: defaultFloatingLineHeight,
    floatingPadding: defaultFloatingPadding,
    floatingInputPaddingTop: defaultFloatingInputPaddingTop,
    floatingInputPaddingBottom: defaultFloatingInputPaddingBottom,
    floatingLabelOpacity: defaultFloatingLabelOpacity,
    floatingLabelDisabledColor: defaultFloatingLabelDisabledColor,
    validColor: defaultValidColor,
    invalidColor: defaultInvalidColor,
  );
}
