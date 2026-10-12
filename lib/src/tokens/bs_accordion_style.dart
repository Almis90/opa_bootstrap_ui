import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_color_utils.dart';
import '../bs_colors.dart';
import '../bs_variant.dart';
import 'bs_body.dart';
import 'bs_borders.dart';

/// Visual variables of a Bootstrap accordion.
///
/// Every field is nullable: null falls back to the matching `default…` constant.
/// [merge] layers overrides on top of [defaults] or, in dark mode, [darkDefaults].
@immutable
class BsAccordionStyle {
  const BsAccordionStyle({
    this.padding,
    this.bodyPadding,
    this.color,
    this.background,
    this.borderWidth,
    this.borderColor,
    this.borderRadius,
    this.innerBorderRadius,
    this.buttonColor,
    this.buttonBackground,
    this.transitionDuration,
    this.buttonActiveBackground,
    this.buttonActiveColor,
    this.iconWidth,
    this.iconColor,
    this.iconActiveColor,
    this.iconTransitionDuration,
    this.iconRotationTurns,
    this.focusRingColor,
    this.focusRingWidth,
  });

  /// Padding of the header button.
  final EdgeInsetsGeometry? padding;

  /// Padding of the body. Defaults to the same values as the header button's [padding], but can be
  /// overridden independently.
  final EdgeInsetsGeometry? bodyPadding;

  final Color? color;

  final Color? background;

  final double? borderWidth;

  final Color? borderColor;

  final double? borderRadius;

  /// Corner radius of the header and body fills: slightly smaller than the item's outer radius so
  /// that they nest inside its border.
  final double? innerBorderRadius;

  final Color? buttonColor;

  final Color? buttonBackground;

  final Duration? transitionDuration;

  final Color? buttonActiveBackground;

  final Color? buttonActiveColor;

  final double? iconWidth;

  final Color? iconColor;

  final Color? iconActiveColor;

  final Duration? iconTransitionDuration;

  final double? iconRotationTurns;

  final Color? focusRingColor;

  final double? focusRingWidth;

  BsAccordionStyle merge(BsAccordionStyle? other) {
    if (other == null) return this;
    return BsAccordionStyle(
      padding: other.padding ?? padding,
      bodyPadding: other.bodyPadding ?? bodyPadding,
      color: other.color ?? color,
      background: other.background ?? background,
      borderWidth: other.borderWidth ?? borderWidth,
      borderColor: other.borderColor ?? borderColor,
      borderRadius: other.borderRadius ?? borderRadius,
      innerBorderRadius: other.innerBorderRadius ?? innerBorderRadius,
      buttonColor: other.buttonColor ?? buttonColor,
      buttonBackground: other.buttonBackground ?? buttonBackground,
      transitionDuration: other.transitionDuration ?? transitionDuration,
      buttonActiveBackground: other.buttonActiveBackground ?? buttonActiveBackground,
      buttonActiveColor: other.buttonActiveColor ?? buttonActiveColor,
      iconWidth: other.iconWidth ?? iconWidth,
      iconColor: other.iconColor ?? iconColor,
      iconActiveColor: other.iconActiveColor ?? iconActiveColor,
      iconTransitionDuration: other.iconTransitionDuration ?? iconTransitionDuration,
      iconRotationTurns: other.iconRotationTurns ?? iconRotationTurns,
      focusRingColor: other.focusRingColor ?? focusRingColor,
      focusRingWidth: other.focusRingWidth ?? focusRingWidth,
    );
  }

  static const EdgeInsets defaultPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 16);

  /// Default text color, for the item and its header button.
  static const Color defaultColor = BsColors.gray900;

  static const Color defaultDarkColor = BsBody.darkColor;

  /// Default background color, for the item and its header button.
  static const Color defaultBackground = BsColors.white;

  static const Color defaultDarkBackground = BsBody.darkBackground;

  static const double defaultBorderWidth = BsBorders.width;

  static const Color defaultBorderColor = BsBorders.color;

  static const Color defaultDarkBorderColor = BsBorders.darkColor;

  static const double defaultBorderRadius = BsBorders.radius;
  static const double defaultInnerBorderRadius = BsBorders.radius - BsBorders.width;
  static const Duration defaultTransitionDuration = Duration(milliseconds: 150);
  static const double defaultIconWidth = 20;

  static const Color defaultIconColor = BsColors.gray900;

  /// Default chevron color in dark mode: the primary color's emphasis tone, matching
  /// [defaultDarkButtonActiveColor], so the chevron stays visible rather than fading to plain gray.
  static Color get defaultDarkIconColor => BsVariant.primary.darkTextEmphasis;

  static const Duration defaultIconTransitionDuration = Duration(milliseconds: 200);
  /// Default rotation of the chevron when open: half a turn counter-clockwise.
  static const double defaultIconRotationTurns = -0.5;
  static Color get defaultButtonActiveBackground => BsColorUtils.tint(BsVariant.primary.color, 0.8);

  /// Default background of the open header button in dark mode.
  static Color get defaultDarkButtonActiveBackground => BsVariant.primary.darkBgSubtle;

  static Color get defaultButtonActiveColor => BsColorUtils.shade(BsVariant.primary.color, 0.6);

  /// Default text color of the open header button in dark mode; the same value as
  /// [defaultDarkIconColor].
  static Color get defaultDarkButtonActiveColor => BsVariant.primary.darkTextEmphasis;

  static const double defaultFocusRingWidth = 4;
  // The same focus ring tint as a primary button: white mixed 15% into the primary color.
  // It is identical in both themes.
  static Color get defaultFocusRingColor => BsColorUtils.mix(BsColors.white, BsVariant.primary.color, 0.15);

  static BsAccordionStyle get defaults => BsAccordionStyle(
    padding: defaultPadding,
    bodyPadding: defaultPadding,
    color: defaultColor,
    background: defaultBackground,
    borderWidth: defaultBorderWidth,
    borderColor: defaultBorderColor,
    borderRadius: defaultBorderRadius,
    innerBorderRadius: defaultInnerBorderRadius,
    buttonColor: defaultColor,
    buttonBackground: defaultBackground,
    transitionDuration: defaultTransitionDuration,
    buttonActiveBackground: defaultButtonActiveBackground,
    buttonActiveColor: defaultButtonActiveColor,
    iconWidth: defaultIconWidth,
    iconColor: defaultIconColor,
    iconActiveColor: defaultButtonActiveColor,
    iconTransitionDuration: defaultIconTransitionDuration,
    iconRotationTurns: defaultIconRotationTurns,
    focusRingColor: defaultFocusRingColor,
    focusRingWidth: defaultFocusRingWidth,
  );

  /// Dark-mode counterpart of [defaults]: every brightness-sensitive field is swapped. The rest is
  /// identical.
  /// Use it as the base to [merge] a caller's override when the ambient brightness is dark.
  static BsAccordionStyle get darkDefaults => BsAccordionStyle(
    padding: defaultPadding,
    bodyPadding: defaultPadding,
    color: defaultDarkColor,
    background: defaultDarkBackground,
    borderWidth: defaultBorderWidth,
    borderColor: defaultDarkBorderColor,
    borderRadius: defaultBorderRadius,
    innerBorderRadius: defaultInnerBorderRadius,
    buttonColor: defaultDarkColor,
    buttonBackground: defaultDarkBackground,
    transitionDuration: defaultTransitionDuration,
    buttonActiveBackground: defaultDarkButtonActiveBackground,
    buttonActiveColor: defaultDarkButtonActiveColor,
    iconWidth: defaultIconWidth,
    iconColor: defaultDarkIconColor,
    iconActiveColor: defaultDarkButtonActiveColor,
    iconTransitionDuration: defaultIconTransitionDuration,
    iconRotationTurns: defaultIconRotationTurns,
    focusRingColor: defaultFocusRingColor,
    focusRingWidth: defaultFocusRingWidth,
  );
}
