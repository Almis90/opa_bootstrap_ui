import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_colors.dart';
import 'bs_body.dart';
import 'bs_borders.dart';
import 'bs_shadows.dart';

/// A Bootstrap `.toast`'s visual variables.
///
/// Mirrors the `toast-variables` group from Bootstrap's SCSS source
/// (`$toast-*`).
@immutable
class BsToastStyle {
  const BsToastStyle({
    this.maxWidth,
    this.padding,
    this.fontSize,
    this.color,
    this.background,
    this.borderWidth,
    this.borderColor,
    this.borderRadius,
    this.boxShadow,
    this.spacing,
    this.headerColor,
    this.headerBackground,
    this.headerBorderColor,
  });

  /// `$toast-max-width` (`350px`).
  final double? maxWidth;

  /// `$toast-padding-x`/`$toast-padding-y` (`.75rem`/`.5rem`).
  final EdgeInsetsGeometry? padding;

  /// `$toast-font-size` (`.875rem`).
  final double? fontSize;

  /// `$toast-color` (`null`, inherits the surrounding text color).
  final Color? color;

  /// `$toast-background-color` (`rgba(var(--bs-body-bg-rgb), .85)`).
  final Color? background;

  /// `$toast-border-width` (`var(--bs-border-width)`).
  final double? borderWidth;

  /// `$toast-border-color` (`var(--bs-border-color-translucent)`).
  final Color? borderColor;

  /// `$toast-border-radius` (`var(--bs-border-radius)`).
  final double? borderRadius;

  /// `$toast-box-shadow` (`var(--bs-box-shadow)`).
  final List<BoxShadow>? boxShadow;

  /// `$toast-spacing` (`$container-padding-x`, i.e. `$grid-gutter-width`).
  final double? spacing;

  /// `$toast-header-color` (`var(--bs-secondary-color)`).
  final Color? headerColor;

  /// `$toast-header-background-color` (`rgba(var(--bs-body-bg-rgb), .85)`).
  final Color? headerBackground;

  /// `$toast-header-border-color` (`$toast-border-color`).
  final Color? headerBorderColor;

  BsToastStyle merge(BsToastStyle? other) {
    if (other == null) return this;
    return BsToastStyle(
      maxWidth: other.maxWidth ?? maxWidth,
      padding: other.padding ?? padding,
      fontSize: other.fontSize ?? fontSize,
      color: other.color ?? color,
      background: other.background ?? background,
      borderWidth: other.borderWidth ?? borderWidth,
      borderColor: other.borderColor ?? borderColor,
      borderRadius: other.borderRadius ?? borderRadius,
      boxShadow: other.boxShadow ?? boxShadow,
      spacing: other.spacing ?? spacing,
      headerColor: other.headerColor ?? headerColor,
      headerBackground: other.headerBackground ?? headerBackground,
      headerBorderColor: other.headerBorderColor ?? headerBorderColor,
    );
  }

  static const double defaultMaxWidth = 350;
  static const EdgeInsets defaultPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 8);
  static const double defaultFontSize = 14;

  /// `$toast-background-color: rgba(var(--bs-body-bg-rgb), .85)`.
  static const Color defaultBackground = Color(0xD9FFFFFF);

  /// [defaultBackground] resolved against `--bs-body-bg-rgb` in
  /// `[data-bs-theme="dark"]`.
  static const Color defaultDarkBackground = Color(0xD9212529);

  static const double defaultBorderWidth = BsBorders.width;
  static const Color defaultBorderColor = BsBorders.colorTranslucent;

  /// [defaultBorderColor] resolved against `--bs-border-color-translucent`
  /// in `[data-bs-theme="dark"]`.
  static const Color defaultDarkBorderColor = BsBorders.darkColorTranslucent;

  static const double defaultBorderRadius = BsBorders.radius;
  static const List<BoxShadow> defaultBoxShadow = BsShadows.shadow;
  static const double defaultSpacing = 24;

  /// `$toast-header-color` (`var(--bs-secondary-color)`).
  static const Color defaultHeaderColor = BsColors.gray600;

  /// [defaultHeaderColor] resolved against `--bs-secondary-color` in
  /// `[data-bs-theme="dark"]`.
  static const Color defaultDarkHeaderColor = BsBody.darkSecondaryColor;

  /// `$toast-header-background-color: rgba(var(--bs-body-bg-rgb), .85)`
  /// (same formula as [defaultBackground]).
  static const Color defaultHeaderBackground = Color(0xD9FFFFFF);

  /// [defaultHeaderBackground] resolved against `--bs-body-bg-rgb` in
  /// `[data-bs-theme="dark"]`.
  static const Color defaultDarkHeaderBackground = Color(0xD9212529);

  static const BsToastStyle defaults = BsToastStyle(
    maxWidth: defaultMaxWidth,
    padding: defaultPadding,
    fontSize: defaultFontSize,
    background: defaultBackground,
    borderWidth: defaultBorderWidth,
    borderColor: defaultBorderColor,
    borderRadius: defaultBorderRadius,
    boxShadow: defaultBoxShadow,
    spacing: defaultSpacing,
    headerColor: defaultHeaderColor,
    headerBackground: defaultHeaderBackground,
    headerBorderColor: defaultBorderColor,
  );

  /// [defaults], with every brightness-sensitive field swapped for its
  /// `[data-bs-theme="dark"]` counterpart. Pick this as the base to
  /// [merge] a caller's [BsToastStyle] override against when
  /// `BsTheme.of(context) == Brightness.dark`.
  static const BsToastStyle darkDefaults = BsToastStyle(
    maxWidth: defaultMaxWidth,
    padding: defaultPadding,
    fontSize: defaultFontSize,
    background: defaultDarkBackground,
    borderWidth: defaultBorderWidth,
    borderColor: defaultDarkBorderColor,
    borderRadius: defaultBorderRadius,
    boxShadow: defaultBoxShadow,
    spacing: defaultSpacing,
    headerColor: defaultDarkHeaderColor,
    headerBackground: defaultDarkHeaderBackground,
    headerBorderColor: defaultDarkBorderColor,
  );
}
