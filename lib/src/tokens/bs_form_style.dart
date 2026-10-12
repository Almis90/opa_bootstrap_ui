import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_color_utils.dart';
import '../bs_colors.dart';
import '../bs_variant.dart';
import 'bs_body.dart';
import 'bs_borders.dart';
import 'bs_shadows.dart';

/// Visual variables of a Bootstrap form.
///
/// Every field is nullable: null falls back to the matching `default…` constant.
/// [merge] layers overrides on top of [defaults] or, in dark mode, [darkDefaults].
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

  final double? textMarginTop;

  final double? textFontSize;

  final Color? textColor;

  final double? labelMarginBottom;

  /// Padding of a text input.
  final EdgeInsetsGeometry? inputPadding;

  /// Padding of a small text input.
  final EdgeInsetsGeometry? inputPaddingSm;

  /// Padding of a large text input.
  final EdgeInsetsGeometry? inputPaddingLg;

  final double? inputFontSize;

  final double? inputFontSizeSm;

  final double? inputFontSizeLg;

  final FontWeight? inputFontWeight;

  final double? inputLineHeight;

  final Color? inputColor;

  final Color? inputBackground;

  final Color? inputDisabledBackground;

  final Color? inputBorderColor;

  final double? inputBorderWidth;

  /// Inset shadow of a text input. Null by default (no shadow); pass [defaultInputBoxShadow] to opt
  /// in. The focus ring, [inputFocusBoxShadow], is always shown.
  final List<BoxShadow>? inputBoxShadow;

  final double? inputBorderRadius;

  final double? inputBorderRadiusSm;

  final double? inputBorderRadiusLg;

  final Color? inputFocusBorderColor;

  final List<BoxShadow>? inputFocusBoxShadow;

  final Color? inputPlaceholderColor;

  final double? inputHeight;

  final double? inputHeightSm;

  final double? inputHeightLg;

  final Duration? inputTransitionDuration;

  final double? checkInputSize;

  final double? checkPaddingStart;

  final double? checkMarginBottom;

  final BorderSide? checkInputBorder;

  final double? checkInputBorderRadius;

  final double? checkRadioBorderRadius;

  final Color? checkInputCheckedColor;

  final Color? checkInputCheckedBackground;

  final double? checkInputDisabledOpacity;

  final double? checkInlineMarginEnd;

  final double? switchWidth;

  /// Color of the unchecked switch thumb.
  final Color? switchColor;

  final double? switchBorderRadius;

  final Duration? switchTransitionDuration;

  final EdgeInsetsGeometry? inputGroupAddonPadding;

  final Color? inputGroupAddonColor;

  final Color? inputGroupAddonBackground;

  final Color? selectIndicatorColor;

  final Size? selectBackgroundSize;

  final double? rangeTrackHeight;

  final Color? rangeTrackBackground;

  final double? rangeTrackBorderRadius;

  final double? rangeThumbSize;

  final Color? rangeThumbBackground;

  final Color? rangeThumbActiveBackground;

  final Color? rangeThumbDisabledBackground;

  final double? rangeThumbBorderRadius;

  /// Shadow of the range thumb. Null by default (no shadow); pass [defaultRangeThumbBoxShadow] to
  /// opt in.
  final List<BoxShadow>? rangeThumbBoxShadow;

  final Color? fileButtonColor;

  final Color? fileButtonBackground;

  final Color? fileButtonHoverBackground;

  final double? floatingHeight;

  /// Line height of the control wrapped by a floating label, in place of [inputLineHeight].
  final double? floatingLineHeight;

  /// Padding of a floating-label field.
  final EdgeInsetsGeometry? floatingPadding;

  /// Top padding of the wrapped control, which makes room for the floated label above the text.
  final double? floatingInputPaddingTop;

  /// Bottom padding of the wrapped control.
  final double? floatingInputPaddingBottom;

  final double? floatingLabelOpacity;

  final Color? floatingLabelDisabledColor;

  /// Color of the valid state's border and feedback.
  final Color? validColor;

  /// Color of the invalid state's border and feedback.
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

  static const Color defaultDarkTextColor = BsBody.darkSecondaryColor;

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

  static const Color defaultDarkInputColor = BsBody.darkColor;

  static const Color defaultInputBackground = BsColors.white;

  static const Color defaultDarkInputBackground = BsBody.darkBackground;

  static const Color defaultInputDisabledBackground = BsColors.gray200;

  static const Color defaultDarkInputDisabledBackground = BsBody.darkSecondaryBackground;

  static const Color defaultInputBorderColor = BsBorders.color;

  static const Color defaultDarkInputBorderColor = BsBorders.darkColor;

  static const double defaultInputBorderWidth = BsBorders.width;
  static const List<BoxShadow> defaultInputBoxShadow = BsShadows.shadowInset;
  static const double defaultInputBorderRadius = BsBorders.radius;
  static const double defaultInputBorderRadiusSm = BsBorders.radiusSm;
  static const double defaultInputBorderRadiusLg = BsBorders.radiusLg;
  static const Color defaultInputPlaceholderColor = BsBody.secondaryColor;

  static const Color defaultDarkInputPlaceholderColor = BsBody.darkSecondaryColor;

  static const double defaultInputHeightBorder = defaultInputBorderWidth * 2;

  /// Default height of a text input: its line height, vertical padding and border.
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

  static const BorderSide defaultDarkCheckInputBorder = BorderSide(
    color: defaultDarkInputBorderColor,
    width: defaultInputBorderWidth,
  );

  static const double defaultCheckInputBorderRadius = 4;
  static const double defaultCheckRadioBorderRadius = 800;

  static const Color defaultCheckInputCheckedColor = BsColors.white;

  static const double defaultCheckInputDisabledOpacity = 0.5;
  static const double defaultCheckInlineMarginEnd = 16;

  static const double defaultSwitchWidth = 32;

  /// Default color of the unchecked switch thumb.
  static const Color defaultSwitchColor = Color(0x40000000);

  static const Color defaultDarkSwitchColor = Color(0x40FFFFFF);

  static const double defaultSwitchBorderRadius = defaultSwitchWidth;
  static const Duration defaultSwitchTransitionDuration = Duration(
    milliseconds: 150,
  );

  static const EdgeInsets defaultInputGroupAddonPadding = defaultInputPadding;

  static const Color defaultInputGroupAddonColor = defaultInputColor;

  static const Color defaultDarkInputGroupAddonColor = defaultDarkInputColor;

  static const Color defaultInputGroupAddonBackground = BsColors.gray100;

  /// Default input group addon background in dark mode.
  static Color get defaultDarkInputGroupAddonBackground => BsBody.darkTertiaryBackground;

  static const Color defaultSelectIndicatorColor = BsColors.gray800;

  /// Default color of the select's chevron in dark mode.
  static const Color defaultDarkSelectIndicatorColor = BsBody.darkColor;

  static const Size defaultSelectBackgroundSize = Size(16, 12);

  static const double defaultRangeTrackHeight = 8;
  static const Color defaultRangeTrackBackground = BsColors.gray200;

  static const Color defaultDarkRangeTrackBackground = BsBody.darkSecondaryBackground;

  static const double defaultRangeTrackBorderRadius = 16;
  static const double defaultRangeThumbSize = 16;

  static const Color defaultRangeThumbDisabledBackground = BsColors.gray600;

  static const Color defaultDarkRangeThumbDisabledBackground = BsBody.darkSecondaryColor;

  static const double defaultRangeThumbBorderRadius = 16;

  static const List<BoxShadow> defaultRangeThumbBoxShadow = [
    BoxShadow(color: Color(0x1A000000), offset: Offset(0, 1.6), blurRadius: 4),
  ];

  static const Color defaultFileButtonColor = defaultInputColor;

  static const Color defaultDarkFileButtonColor = defaultDarkInputColor;

  static const Color defaultFileButtonBackground = BsColors.gray100;

  /// Default file button background in dark mode.
  static Color get defaultDarkFileButtonBackground => BsBody.darkTertiaryBackground;

  static const Color defaultFileButtonHoverBackground = BsColors.gray200;

  static const Color defaultDarkFileButtonHoverBackground = BsBody.darkSecondaryBackground;

  static const double defaultFloatingHeight = 56 + defaultInputHeightBorder;

  static const double defaultFloatingLineHeight = 1.25;

  static const EdgeInsets defaultFloatingPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 16,
  );

  static const double defaultFloatingInputPaddingTop = 26;

  static const double defaultFloatingInputPaddingBottom = 10;

  static const double defaultFloatingLabelOpacity = 0.65;

  static const Color defaultFloatingLabelDisabledColor = BsColors.gray600;

  /// Default color of the valid state: the success color.
  static Color get defaultValidColor => BsVariant.success.color;

  /// Default color of the valid state in dark mode: a lighter tint of green.
  static Color get defaultDarkValidColor => BsColorUtils.tint(BsVariant.success.color, 0.4);

  /// Default color of the invalid state: the danger color.
  static Color get defaultInvalidColor => BsVariant.danger.color;

  /// Default color of the invalid state in dark mode: a lighter tint of red.
  static Color get defaultDarkInvalidColor => BsColorUtils.tint(BsVariant.danger.color, 0.4);

  static Color get defaultInputFocusBorderColor =>
      _tint(BsVariant.primary.color, 0.5);

  /// Default focus ring of a text input: a ring in the translucent primary color.
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

  /// Dark-mode counterpart of [defaults]: every brightness-sensitive field is swapped. The rest is
  /// identical.
  /// Use it as the base to [merge] a caller's override when the ambient brightness is dark.
  static BsFormStyle get darkDefaults => BsFormStyle(
    textMarginTop: defaultTextMarginTop,
    textFontSize: defaultTextFontSize,
    textColor: defaultDarkTextColor,
    labelMarginBottom: defaultLabelMarginBottom,
    inputPadding: defaultInputPadding,
    inputPaddingSm: defaultInputPaddingSm,
    inputPaddingLg: defaultInputPaddingLg,
    inputFontSize: defaultInputFontSize,
    inputFontSizeSm: defaultInputFontSizeSm,
    inputFontSizeLg: defaultInputFontSizeLg,
    inputFontWeight: defaultInputFontWeight,
    inputLineHeight: defaultInputLineHeight,
    inputColor: defaultDarkInputColor,
    inputBackground: defaultDarkInputBackground,
    inputDisabledBackground: defaultDarkInputDisabledBackground,
    inputBorderColor: defaultDarkInputBorderColor,
    inputBorderWidth: defaultInputBorderWidth,
    inputBorderRadius: defaultInputBorderRadius,
    inputBorderRadiusSm: defaultInputBorderRadiusSm,
    inputBorderRadiusLg: defaultInputBorderRadiusLg,
    inputFocusBorderColor: defaultInputFocusBorderColor,
    inputFocusBoxShadow: defaultInputFocusBoxShadow,
    inputPlaceholderColor: defaultDarkInputPlaceholderColor,
    inputHeight: defaultInputHeight,
    inputHeightSm: defaultInputHeightSm,
    inputHeightLg: defaultInputHeightLg,
    inputTransitionDuration: defaultInputTransitionDuration,
    checkInputSize: defaultCheckInputSize,
    checkPaddingStart: defaultCheckPaddingStart,
    checkMarginBottom: defaultCheckMarginBottom,
    checkInputBorder: defaultDarkCheckInputBorder,
    checkInputBorderRadius: defaultCheckInputBorderRadius,
    checkRadioBorderRadius: defaultCheckRadioBorderRadius,
    checkInputCheckedColor: defaultCheckInputCheckedColor,
    checkInputCheckedBackground: BsVariant.primary.color,
    checkInputDisabledOpacity: defaultCheckInputDisabledOpacity,
    checkInlineMarginEnd: defaultCheckInlineMarginEnd,
    switchWidth: defaultSwitchWidth,
    switchColor: defaultDarkSwitchColor,
    switchBorderRadius: defaultSwitchBorderRadius,
    switchTransitionDuration: defaultSwitchTransitionDuration,
    inputGroupAddonPadding: defaultInputGroupAddonPadding,
    inputGroupAddonColor: defaultDarkInputGroupAddonColor,
    inputGroupAddonBackground: defaultDarkInputGroupAddonBackground,
    selectIndicatorColor: defaultDarkSelectIndicatorColor,
    selectBackgroundSize: defaultSelectBackgroundSize,
    rangeTrackHeight: defaultRangeTrackHeight,
    rangeTrackBackground: defaultDarkRangeTrackBackground,
    rangeTrackBorderRadius: defaultRangeTrackBorderRadius,
    rangeThumbSize: defaultRangeThumbSize,
    rangeThumbBackground: defaultRangeThumbBackground,
    rangeThumbActiveBackground: defaultRangeThumbActiveBackground,
    rangeThumbDisabledBackground: defaultDarkRangeThumbDisabledBackground,
    rangeThumbBorderRadius: defaultRangeThumbBorderRadius,
    fileButtonColor: defaultDarkFileButtonColor,
    fileButtonBackground: defaultDarkFileButtonBackground,
    fileButtonHoverBackground: defaultDarkFileButtonHoverBackground,
    floatingHeight: defaultFloatingHeight,
    floatingLineHeight: defaultFloatingLineHeight,
    floatingPadding: defaultFloatingPadding,
    floatingInputPaddingTop: defaultFloatingInputPaddingTop,
    floatingInputPaddingBottom: defaultFloatingInputPaddingBottom,
    floatingLabelOpacity: defaultFloatingLabelOpacity,
    // The disabled floating label color is the same in both themes.
    floatingLabelDisabledColor: defaultFloatingLabelDisabledColor,
    validColor: defaultDarkValidColor,
    invalidColor: defaultDarkInvalidColor,
  );
}
