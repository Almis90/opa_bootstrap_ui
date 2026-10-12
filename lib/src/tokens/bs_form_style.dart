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

  /// Text margin top.
  final double? textMarginTop;

  /// Text font size.
  final double? textFontSize;

  /// Text color.
  final Color? textColor;

  /// Label margin bottom.
  final double? labelMarginBottom;

  /// Padding of a text input.
  final EdgeInsetsGeometry? inputPadding;

  /// Padding of a small text input.
  final EdgeInsetsGeometry? inputPaddingSm;

  /// Padding of a large text input.
  final EdgeInsetsGeometry? inputPaddingLg;

  /// Input font size.
  final double? inputFontSize;

  /// Input font size sm.
  final double? inputFontSizeSm;

  /// Input font size lg.
  final double? inputFontSizeLg;

  /// Input font weight.
  final FontWeight? inputFontWeight;

  /// Input line height.
  final double? inputLineHeight;

  /// Input color.
  final Color? inputColor;

  /// Input background.
  final Color? inputBackground;

  /// Input disabled background.
  final Color? inputDisabledBackground;

  /// Input border color.
  final Color? inputBorderColor;

  /// Input border width.
  final double? inputBorderWidth;

  /// Inset shadow of a text input. Null by default (no shadow); pass [defaultInputBoxShadow] to opt
  /// in. The focus ring, [inputFocusBoxShadow], is always shown.
  final List<BoxShadow>? inputBoxShadow;

  /// Input border radius.
  final double? inputBorderRadius;

  /// Input border radius sm.
  final double? inputBorderRadiusSm;

  /// Input border radius lg.
  final double? inputBorderRadiusLg;

  /// Input focus border color.
  final Color? inputFocusBorderColor;

  /// Input focus box shadow.
  final List<BoxShadow>? inputFocusBoxShadow;

  /// Input placeholder color.
  final Color? inputPlaceholderColor;

  /// Input height.
  final double? inputHeight;

  /// Input height sm.
  final double? inputHeightSm;

  /// Input height lg.
  final double? inputHeightLg;

  /// Input transition duration.
  final Duration? inputTransitionDuration;

  /// Check input size.
  final double? checkInputSize;

  /// Check padding start.
  final double? checkPaddingStart;

  /// Check margin bottom.
  final double? checkMarginBottom;

  /// Check input border.
  final BorderSide? checkInputBorder;

  /// Check input border radius.
  final double? checkInputBorderRadius;

  /// Check radio border radius.
  final double? checkRadioBorderRadius;

  /// Check input checked color.
  final Color? checkInputCheckedColor;

  /// Check input checked background.
  final Color? checkInputCheckedBackground;

  /// Check input disabled opacity.
  final double? checkInputDisabledOpacity;

  /// Check inline margin end.
  final double? checkInlineMarginEnd;

  /// Switch width.
  final double? switchWidth;

  /// Color of the unchecked switch thumb.
  final Color? switchColor;

  /// Switch border radius.
  final double? switchBorderRadius;

  /// Switch transition duration.
  final Duration? switchTransitionDuration;

  /// Padding of an input group addon.
  final EdgeInsetsGeometry? inputGroupAddonPadding;

  /// Input group addon color.
  final Color? inputGroupAddonColor;

  /// Input group addon background.
  final Color? inputGroupAddonBackground;

  /// Select indicator color.
  final Color? selectIndicatorColor;

  /// Select background size.
  final Size? selectBackgroundSize;

  /// Range track height.
  final double? rangeTrackHeight;

  /// Range track background.
  final Color? rangeTrackBackground;

  /// Range track border radius.
  final double? rangeTrackBorderRadius;

  /// Size of the range thumb.
  final double? rangeThumbSize;

  /// Range thumb background.
  final Color? rangeThumbBackground;

  /// Range thumb active background.
  final Color? rangeThumbActiveBackground;

  /// Range thumb disabled background.
  final Color? rangeThumbDisabledBackground;

  /// Range thumb border radius.
  final double? rangeThumbBorderRadius;

  /// Shadow of the range thumb. Null by default (no shadow); pass [defaultRangeThumbBoxShadow] to
  /// opt in.
  final List<BoxShadow>? rangeThumbBoxShadow;

  /// File button color.
  final Color? fileButtonColor;

  /// File button background.
  final Color? fileButtonBackground;

  /// File button hover background.
  final Color? fileButtonHoverBackground;

  /// Floating height.
  final double? floatingHeight;

  /// Line height of the control wrapped by a floating label, in place of [inputLineHeight].
  final double? floatingLineHeight;

  /// Padding of a floating-label field.
  final EdgeInsetsGeometry? floatingPadding;

  /// Top padding of the wrapped control, which makes room for the floated label above the text.
  final double? floatingInputPaddingTop;

  /// Bottom padding of the wrapped control.
  final double? floatingInputPaddingBottom;

  /// Floating label opacity.
  final double? floatingLabelOpacity;

  /// Floating label disabled color.
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

  /// Default text color.
  static const Color defaultTextColor = BsColors.gray600;

  /// Default text color in dark mode.
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

  /// Default input color in dark mode.
  static const Color defaultDarkInputColor = BsBody.darkColor;

  static const Color defaultInputBackground = BsColors.white;

  /// Default input background in dark mode.
  static const Color defaultDarkInputBackground = BsBody.darkBackground;

  static const Color defaultInputDisabledBackground = BsColors.gray200;

  /// Default input disabled background in dark mode.
  static const Color defaultDarkInputDisabledBackground = BsBody.darkSecondaryBackground;

  static const Color defaultInputBorderColor = BsBorders.color;

  /// Default input border color in dark mode.
  static const Color defaultDarkInputBorderColor = BsBorders.darkColor;

  static const double defaultInputBorderWidth = BsBorders.width;
  static const List<BoxShadow> defaultInputBoxShadow = BsShadows.shadowInset;
  static const double defaultInputBorderRadius = BsBorders.radius;
  static const double defaultInputBorderRadiusSm = BsBorders.radiusSm;
  static const double defaultInputBorderRadiusLg = BsBorders.radiusLg;
  static const Color defaultInputPlaceholderColor = BsBody.secondaryColor;

  /// Default input placeholder color in dark mode.
  static const Color defaultDarkInputPlaceholderColor = BsBody.darkSecondaryColor;

  /// Default input height border.
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

  /// Default check input border in dark mode.
  static const BorderSide defaultDarkCheckInputBorder = BorderSide(
    color: defaultDarkInputBorderColor,
    width: defaultInputBorderWidth,
  );

  static const double defaultCheckInputBorderRadius = 4;
  static const double defaultCheckRadioBorderRadius = 800;

  /// Default check input checked color.
  static const Color defaultCheckInputCheckedColor = BsColors.white;

  static const double defaultCheckInputDisabledOpacity = 0.5;
  static const double defaultCheckInlineMarginEnd = 16;

  static const double defaultSwitchWidth = 32;

  /// Default color of the unchecked switch thumb.
  static const Color defaultSwitchColor = Color(0x40000000);

  /// Default switch color in dark mode.
  static const Color defaultDarkSwitchColor = Color(0x40FFFFFF);

  static const double defaultSwitchBorderRadius = defaultSwitchWidth;
  static const Duration defaultSwitchTransitionDuration = Duration(
    milliseconds: 150,
  );

  static const EdgeInsets defaultInputGroupAddonPadding = defaultInputPadding;

  /// Default input group addon color.
  static const Color defaultInputGroupAddonColor = defaultInputColor;

  /// Default input group addon color in dark mode.
  static const Color defaultDarkInputGroupAddonColor = defaultDarkInputColor;

  static const Color defaultInputGroupAddonBackground = BsColors.gray100;

  /// Default input group addon background in dark mode.
  static Color get defaultDarkInputGroupAddonBackground => BsBody.darkTertiaryBackground;

  /// Default select indicator color.
  static const Color defaultSelectIndicatorColor = BsColors.gray800;

  /// Default color of the select's chevron in dark mode.
  static const Color defaultDarkSelectIndicatorColor = BsBody.darkColor;

  static const Size defaultSelectBackgroundSize = Size(16, 12);

  static const double defaultRangeTrackHeight = 8;
  static const Color defaultRangeTrackBackground = BsColors.gray200;

  /// Default range track background in dark mode.
  static const Color defaultDarkRangeTrackBackground = BsBody.darkSecondaryBackground;

  static const double defaultRangeTrackBorderRadius = 16;
  static const double defaultRangeThumbSize = 16;

  /// Default range thumb disabled background.
  static const Color defaultRangeThumbDisabledBackground = BsColors.gray600;

  /// Default range thumb disabled background in dark mode.
  static const Color defaultDarkRangeThumbDisabledBackground = BsBody.darkSecondaryColor;

  /// Default range thumb border radius.
  static const double defaultRangeThumbBorderRadius = 16;

  /// Default range thumb box shadow.
  static const List<BoxShadow> defaultRangeThumbBoxShadow = [
    BoxShadow(color: Color(0x1A000000), offset: Offset(0, 1.6), blurRadius: 4),
  ];

  static const Color defaultFileButtonColor = defaultInputColor;

  /// Default file button color in dark mode.
  static const Color defaultDarkFileButtonColor = defaultDarkInputColor;

  static const Color defaultFileButtonBackground = BsColors.gray100;

  /// Default file button background in dark mode.
  static Color get defaultDarkFileButtonBackground => BsBody.darkTertiaryBackground;

  static const Color defaultFileButtonHoverBackground = BsColors.gray200;

  /// Default file button hover background in dark mode.
  static const Color defaultDarkFileButtonHoverBackground = BsBody.darkSecondaryBackground;

  /// Default floating height.
  static const double defaultFloatingHeight = 56 + defaultInputHeightBorder;

  /// Default floating line height.
  static const double defaultFloatingLineHeight = 1.25;

  static const EdgeInsets defaultFloatingPadding = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 16,
  );

  /// Default floating input padding top.
  static const double defaultFloatingInputPaddingTop = 26;

  /// Default floating input padding bottom.
  static const double defaultFloatingInputPaddingBottom = 10;

  static const double defaultFloatingLabelOpacity = 0.65;

  /// Default floating label disabled color.
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
