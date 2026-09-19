import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_color_utils.dart';
import '../bs_colors.dart';
import '../bs_variant.dart';
import 'bs_borders.dart';

/// A Bootstrap `.accordion`'s visual variables.
///
/// Mirrors the `accordion-variables` group from Bootstrap's SCSS source
/// (`$accordion-*`).
@immutable
class BsAccordionStyle {
  const BsAccordionStyle({
    this.padding,
    this.color,
    this.background,
    this.borderWidth,
    this.borderColor,
    this.borderRadius,
    this.buttonColor,
    this.buttonBackground,
    this.transitionDuration,
    this.buttonActiveBackground,
    this.buttonActiveColor,
    this.iconWidth,
    this.iconColor,
    this.iconActiveColor,
    this.iconTransitionDuration,
    this.focusRingColor,
    this.focusRingWidth,
  });

  /// `$accordion-padding-y`/`$accordion-padding-x` (`1rem`/`1.25rem`),
  /// shared by the body and the button.
  final EdgeInsetsGeometry? padding;

  /// `$accordion-color` (`var(--bs-body-color)`).
  final Color? color;

  /// `$accordion-bg` (`var(--bs-body-bg)`).
  final Color? background;

  /// `$accordion-border-width` (`var(--bs-border-width)`).
  final double? borderWidth;

  /// `$accordion-border-color` (`var(--bs-border-color)`).
  final Color? borderColor;

  /// `$accordion-border-radius` (`var(--bs-border-radius)`).
  final double? borderRadius;

  /// `$accordion-button-color` (`var(--bs-body-color)`).
  final Color? buttonColor;

  /// `$accordion-button-bg` (`var(--bs-accordion-bg)`).
  final Color? buttonBackground;

  /// `$accordion-transition` (`$btn-transition`, plus a border-radius
  /// transition).
  final Duration? transitionDuration;

  /// `$accordion-button-active-bg` (`var(--bs-primary-bg-subtle)`).
  final Color? buttonActiveBackground;

  /// `$accordion-button-active-color` (`var(--bs-primary-text-emphasis)`).
  final Color? buttonActiveColor;

  /// `$accordion-icon-width` (`1.25rem`).
  final double? iconWidth;

  /// `$accordion-icon-color` (`$body-color`).
  final Color? iconColor;

  /// `$accordion-icon-active-color` (`$primary-text-emphasis`).
  final Color? iconActiveColor;

  /// `$accordion-icon-transition` (`transform .2s ease-in-out`).
  final Duration? iconTransitionDuration;

  /// `$accordion-button-focus-box-shadow` (`$btn-focus-box-shadow`, i.e. a
  /// ring tinted by the primary color).
  final Color? focusRingColor;

  /// The width of the focus ring, per `$btn-focus-width` (`.25rem`, i.e.
  /// `4` at the default `16px` root font size).
  final double? focusRingWidth;

  BsAccordionStyle merge(BsAccordionStyle? other) {
    if (other == null) return this;
    return BsAccordionStyle(
      padding: other.padding ?? padding,
      color: other.color ?? color,
      background: other.background ?? background,
      borderWidth: other.borderWidth ?? borderWidth,
      borderColor: other.borderColor ?? borderColor,
      borderRadius: other.borderRadius ?? borderRadius,
      buttonColor: other.buttonColor ?? buttonColor,
      buttonBackground: other.buttonBackground ?? buttonBackground,
      transitionDuration: other.transitionDuration ?? transitionDuration,
      buttonActiveBackground: other.buttonActiveBackground ?? buttonActiveBackground,
      buttonActiveColor: other.buttonActiveColor ?? buttonActiveColor,
      iconWidth: other.iconWidth ?? iconWidth,
      iconColor: other.iconColor ?? iconColor,
      iconActiveColor: other.iconActiveColor ?? iconActiveColor,
      iconTransitionDuration: other.iconTransitionDuration ?? iconTransitionDuration,
      focusRingColor: other.focusRingColor ?? focusRingColor,
      focusRingWidth: other.focusRingWidth ?? focusRingWidth,
    );
  }

  static const EdgeInsets defaultPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 16);
  static const Color defaultColor = BsColors.gray900;
  static const Color defaultBackground = BsColors.white;
  static const double defaultBorderWidth = BsBorders.width;
  static const Color defaultBorderColor = BsBorders.color;
  static const double defaultBorderRadius = BsBorders.radius;
  static const Duration defaultTransitionDuration = Duration(milliseconds: 150);
  static const double defaultIconWidth = 20;
  static const Color defaultIconColor = BsColors.gray900;
  static const Duration defaultIconTransitionDuration = Duration(milliseconds: 200);
  static Color get defaultButtonActiveBackground => BsColorUtils.tint(BsVariant.primary.color, 0.8);
  static Color get defaultButtonActiveColor => BsColorUtils.shade(BsVariant.primary.color, 0.6);
  static const double defaultFocusRingWidth = 4;
  static Color get defaultFocusRingColor => BsVariant.primary.color;

  static BsAccordionStyle get defaults => BsAccordionStyle(
    padding: defaultPadding,
    color: defaultColor,
    background: defaultBackground,
    borderWidth: defaultBorderWidth,
    borderColor: defaultBorderColor,
    borderRadius: defaultBorderRadius,
    buttonColor: defaultColor,
    buttonBackground: defaultBackground,
    transitionDuration: defaultTransitionDuration,
    buttonActiveBackground: defaultButtonActiveBackground,
    buttonActiveColor: defaultButtonActiveColor,
    iconWidth: defaultIconWidth,
    iconColor: defaultIconColor,
    iconActiveColor: defaultButtonActiveColor,
    iconTransitionDuration: defaultIconTransitionDuration,
    focusRingColor: defaultFocusRingColor,
    focusRingWidth: defaultFocusRingWidth,
  );
}
