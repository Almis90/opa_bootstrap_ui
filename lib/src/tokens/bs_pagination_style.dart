import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_colors.dart';
import '../bs_variant.dart';
import 'bs_borders.dart';
import 'bs_focus_ring.dart';

/// A Bootstrap `.pagination`'s visual variables.
///
/// Mirrors the `pagination-variables` group from Bootstrap's SCSS source
/// (`$pagination-*`).
@immutable
class BsPaginationStyle {
  const BsPaginationStyle({
    this.padding,
    this.fontSize,
    this.color,
    this.background,
    this.borderRadius,
    this.borderWidth,
    this.borderColor,
    this.focusColor,
    this.focusBackground,
    this.hoverColor,
    this.hoverBackground,
    this.hoverBorderColor,
    this.activeColor,
    this.activeBackground,
    this.activeBorderColor,
    this.disabledColor,
    this.disabledBackground,
    this.disabledBorderColor,
    this.transitionDuration,
  });

  /// `$pagination-padding-y`/`$pagination-padding-x` (`.375rem`/`.75rem`).
  final EdgeInsetsGeometry? padding;

  /// `$pagination-font-size` (`$font-size-base`).
  final double? fontSize;

  /// `$pagination-color` (`var(--bs-link-color)`).
  final Color? color;

  /// `$pagination-bg` (`var(--bs-body-bg)`).
  final Color? background;

  /// `$pagination-border-radius` (`var(--bs-border-radius)`).
  final double? borderRadius;

  /// `$pagination-border-width` (`var(--bs-border-width)`).
  final double? borderWidth;

  /// `$pagination-border-color` (`var(--bs-border-color)`).
  final Color? borderColor;

  /// `$pagination-focus-color` (`var(--bs-link-hover-color)`).
  final Color? focusColor;

  /// `$pagination-focus-bg` (`var(--bs-secondary-bg)`).
  final Color? focusBackground;

  /// `$pagination-hover-color` (`var(--bs-link-hover-color)`).
  final Color? hoverColor;

  /// `$pagination-hover-bg` (`var(--bs-tertiary-bg)`).
  final Color? hoverBackground;

  /// `$pagination-hover-border-color` (`var(--bs-border-color)`).
  final Color? hoverBorderColor;

  /// `$pagination-active-color` (`$component-active-color`).
  final Color? activeColor;

  /// `$pagination-active-bg` (`$component-active-bg`).
  final Color? activeBackground;

  /// `$pagination-active-border-color` (`$component-active-bg`).
  final Color? activeBorderColor;

  /// `$pagination-disabled-color` (`var(--bs-secondary-color)`).
  final Color? disabledColor;

  /// `$pagination-disabled-bg` (`var(--bs-secondary-bg)`).
  final Color? disabledBackground;

  /// `$pagination-disabled-border-color` (`var(--bs-border-color)`).
  final Color? disabledBorderColor;

  /// `$pagination-transition` (color/bg/border/shadow, `.15s ease-in-out`).
  final Duration? transitionDuration;

  BsPaginationStyle merge(BsPaginationStyle? other) {
    if (other == null) return this;
    return BsPaginationStyle(
      padding: other.padding ?? padding,
      fontSize: other.fontSize ?? fontSize,
      color: other.color ?? color,
      background: other.background ?? background,
      borderRadius: other.borderRadius ?? borderRadius,
      borderWidth: other.borderWidth ?? borderWidth,
      borderColor: other.borderColor ?? borderColor,
      focusColor: other.focusColor ?? focusColor,
      focusBackground: other.focusBackground ?? focusBackground,
      hoverColor: other.hoverColor ?? hoverColor,
      hoverBackground: other.hoverBackground ?? hoverBackground,
      hoverBorderColor: other.hoverBorderColor ?? hoverBorderColor,
      activeColor: other.activeColor ?? activeColor,
      activeBackground: other.activeBackground ?? activeBackground,
      activeBorderColor: other.activeBorderColor ?? activeBorderColor,
      disabledColor: other.disabledColor ?? disabledColor,
      disabledBackground: other.disabledBackground ?? disabledBackground,
      disabledBorderColor: other.disabledBorderColor ?? disabledBorderColor,
      transitionDuration: other.transitionDuration ?? transitionDuration,
    );
  }

  static const EdgeInsets defaultPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 6);
  static const double defaultFontSize = 16;
  static Color get defaultColor => BsVariant.primary.color;
  static const Color defaultBackground = BsColors.white;
  static const double defaultBorderRadius = BsBorders.radius;
  static const double defaultBorderWidth = BsBorders.width;
  static const Color defaultBorderColor = BsBorders.color;
  static const Color defaultFocusBackground = BsColors.gray200;
  static const Color defaultHoverBackground = BsColors.gray100;
  static const Color defaultActiveColor = BsColors.white;
  static Color get defaultActiveBackground => BsVariant.primary.color;
  static const Color defaultDisabledColor = BsColors.gray600;
  static const Color defaultDisabledBackground = BsColors.gray200;
  static const Duration defaultTransitionDuration = Duration(milliseconds: 150);

  /// `$pagination-focus-box-shadow` (`$focus-ring-box-shadow`).
  static const double defaultFocusRingWidth = BsFocusRing.width;

  static BsPaginationStyle get defaults => BsPaginationStyle(
    padding: defaultPadding,
    fontSize: defaultFontSize,
    color: defaultColor,
    background: defaultBackground,
    borderRadius: defaultBorderRadius,
    borderWidth: defaultBorderWidth,
    borderColor: defaultBorderColor,
    focusColor: defaultColor,
    focusBackground: defaultFocusBackground,
    hoverColor: defaultColor,
    hoverBackground: defaultHoverBackground,
    hoverBorderColor: defaultBorderColor,
    activeColor: defaultActiveColor,
    activeBackground: defaultActiveBackground,
    activeBorderColor: defaultActiveBackground,
    disabledColor: defaultDisabledColor,
    disabledBackground: defaultDisabledBackground,
    disabledBorderColor: defaultBorderColor,
    transitionDuration: defaultTransitionDuration,
  );
}
