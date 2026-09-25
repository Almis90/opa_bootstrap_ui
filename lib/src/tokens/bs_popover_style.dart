import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_colors.dart';
import 'bs_body.dart';
import 'bs_borders.dart';
import 'bs_shadows.dart';

/// A Bootstrap `.popover`'s visual variables.
///
/// Mirrors the `popover-variables` group from Bootstrap's SCSS source
/// (`$popover-*`).
@immutable
class BsPopoverStyle {
  const BsPopoverStyle({
    this.fontSize,
    this.background,
    this.maxWidth,
    this.borderWidth,
    this.borderColor,
    this.borderRadius,
    this.boxShadow,
    this.headerFontSize,
    this.headerBackground,
    this.headerColor,
    this.headerPadding,
    this.bodyColor,
    this.bodyPadding,
    this.arrowWidth,
    this.arrowHeight,
  });

  /// `$popover-font-size` (`$font-size-sm`).
  final double? fontSize;

  /// `$popover-bg` (`var(--bs-body-bg)`).
  final Color? background;

  /// `$popover-max-width` (`276px`).
  final double? maxWidth;

  /// `$popover-border-width` (`var(--bs-border-width)`).
  final double? borderWidth;

  /// `$popover-border-color` (`var(--bs-border-color-translucent)`).
  final Color? borderColor;

  /// `$popover-border-radius` (`var(--bs-border-radius-lg)`).
  final double? borderRadius;

  /// `$popover-box-shadow` (`var(--bs-box-shadow)`).
  final List<BoxShadow>? boxShadow;

  /// `$popover-header-font-size` (`$font-size-base`).
  final double? headerFontSize;

  /// `$popover-header-bg` (`var(--bs-secondary-bg)`).
  final Color? headerBackground;

  /// `$popover-header-color` (`$headings-color`, i.e. `inherit`).
  final Color? headerColor;

  /// `$popover-header-padding-y`/`$popover-header-padding-x` (`.5rem`/`1rem`).
  final EdgeInsetsGeometry? headerPadding;

  /// `$popover-body-color` (`var(--bs-body-color)`).
  final Color? bodyColor;

  /// `$popover-body-padding-y`/`$popover-body-padding-x` (`1rem`).
  final EdgeInsetsGeometry? bodyPadding;

  /// `$popover-arrow-width` (`1rem`).
  final double? arrowWidth;

  /// `$popover-arrow-height` (`.5rem`).
  final double? arrowHeight;

  BsPopoverStyle merge(BsPopoverStyle? other) {
    if (other == null) return this;
    return BsPopoverStyle(
      fontSize: other.fontSize ?? fontSize,
      background: other.background ?? background,
      maxWidth: other.maxWidth ?? maxWidth,
      borderWidth: other.borderWidth ?? borderWidth,
      borderColor: other.borderColor ?? borderColor,
      borderRadius: other.borderRadius ?? borderRadius,
      boxShadow: other.boxShadow ?? boxShadow,
      headerFontSize: other.headerFontSize ?? headerFontSize,
      headerBackground: other.headerBackground ?? headerBackground,
      headerColor: other.headerColor ?? headerColor,
      headerPadding: other.headerPadding ?? headerPadding,
      bodyColor: other.bodyColor ?? bodyColor,
      bodyPadding: other.bodyPadding ?? bodyPadding,
      arrowWidth: other.arrowWidth ?? arrowWidth,
      arrowHeight: other.arrowHeight ?? arrowHeight,
    );
  }

  static const double defaultFontSize = 14;

  /// `$popover-bg: var(--bs-body-bg)`.
  static const Color defaultBackground = BsColors.white;

  /// `$popover-bg` resolved against `--bs-body-bg` in
  /// `[data-bs-theme="dark"]`.
  static const Color defaultDarkBackground = BsBody.darkBackground;

  static const double defaultMaxWidth = 276;
  static const double defaultBorderWidth = BsBorders.width;

  /// `$popover-border-color: var(--bs-border-color-translucent)`.
  static const Color defaultBorderColor = BsBorders.colorTranslucent;

  /// `$popover-border-color` resolved against
  /// `--bs-border-color-translucent` in `[data-bs-theme="dark"]`.
  static const Color defaultDarkBorderColor = BsBorders.darkColorTranslucent;

  static const double defaultBorderRadius = BsBorders.radiusLg;
  static const List<BoxShadow> defaultBoxShadow = BsShadows.shadow;
  static const double defaultHeaderFontSize = 16;

  /// `$popover-header-bg: var(--bs-secondary-bg)`.
  static const Color defaultHeaderBackground = BsColors.gray200;

  /// `$popover-header-bg` resolved against `--bs-secondary-bg` in
  /// `[data-bs-theme="dark"]`.
  static const Color defaultDarkHeaderBackground = BsBody.darkSecondaryBackground;

  static const EdgeInsets defaultHeaderPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 8);

  /// `$popover-body-color: var(--bs-body-color)`.
  static const Color defaultBodyColor = BsColors.gray900;

  /// `$popover-body-color` resolved against `--bs-body-color` in
  /// `[data-bs-theme="dark"]`.
  static const Color defaultDarkBodyColor = BsBody.darkColor;

  static const EdgeInsets defaultBodyPadding = EdgeInsets.all(16);
  static const double defaultArrowWidth = 16;
  static const double defaultArrowHeight = 8;

  static const BsPopoverStyle defaults = BsPopoverStyle(
    fontSize: defaultFontSize,
    background: defaultBackground,
    maxWidth: defaultMaxWidth,
    borderWidth: defaultBorderWidth,
    borderColor: defaultBorderColor,
    borderRadius: defaultBorderRadius,
    boxShadow: defaultBoxShadow,
    headerFontSize: defaultHeaderFontSize,
    headerBackground: defaultHeaderBackground,
    headerPadding: defaultHeaderPadding,
    bodyColor: defaultBodyColor,
    bodyPadding: defaultBodyPadding,
    arrowWidth: defaultArrowWidth,
    arrowHeight: defaultArrowHeight,
  );

  /// [defaults], with [background]/[borderColor]/[headerBackground]/
  /// [bodyColor] swapped for their `[data-bs-theme="dark"]` counterparts.
  /// Pick this as the base to [merge] a caller's [BsPopoverStyle] override
  /// against when `BsTheme.of(context) == Brightness.dark` — every other
  /// field (including [boxShadow], which has no `-dark` override in
  /// Bootstrap's SCSS) is brightness-independent, so it's identical to
  /// [defaults].
  static const BsPopoverStyle darkDefaults = BsPopoverStyle(
    fontSize: defaultFontSize,
    background: defaultDarkBackground,
    maxWidth: defaultMaxWidth,
    borderWidth: defaultBorderWidth,
    borderColor: defaultDarkBorderColor,
    borderRadius: defaultBorderRadius,
    boxShadow: defaultBoxShadow,
    headerFontSize: defaultHeaderFontSize,
    headerBackground: defaultDarkHeaderBackground,
    headerPadding: defaultHeaderPadding,
    bodyColor: defaultDarkBodyColor,
    bodyPadding: defaultBodyPadding,
    arrowWidth: defaultArrowWidth,
    arrowHeight: defaultArrowHeight,
  );
}
