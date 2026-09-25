import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_colors.dart';
import 'bs_body.dart';
import 'bs_borders.dart';

/// A Bootstrap `.tooltip`'s visual variables.
///
/// Mirrors the `tooltip-variables` group from Bootstrap's SCSS source
/// (`$tooltip-*`).
@immutable
class BsTooltipStyle {
  const BsTooltipStyle({
    this.fontSize,
    this.maxWidth,
    this.color,
    this.background,
    this.borderRadius,
    this.opacity,
    this.padding,
    this.arrowWidth,
    this.arrowHeight,
  });

  /// `$tooltip-font-size` (`$font-size-sm`).
  final double? fontSize;

  /// `$tooltip-max-width` (`200px`).
  final double? maxWidth;

  /// `$tooltip-color` (`var(--bs-body-bg)`).
  final Color? color;

  /// `$tooltip-bg` (`var(--bs-emphasis-color)`).
  final Color? background;

  /// `$tooltip-border-radius` (`var(--bs-border-radius)`).
  final double? borderRadius;

  /// `$tooltip-opacity` (`.9`).
  final double? opacity;

  /// `$tooltip-padding-y`/`$tooltip-padding-x` (`.25rem`/`.5rem`).
  final EdgeInsetsGeometry? padding;

  /// `$tooltip-arrow-width` (`.8rem`).
  final double? arrowWidth;

  /// `$tooltip-arrow-height` (`.4rem`).
  final double? arrowHeight;

  BsTooltipStyle merge(BsTooltipStyle? other) {
    if (other == null) return this;
    return BsTooltipStyle(
      fontSize: other.fontSize ?? fontSize,
      maxWidth: other.maxWidth ?? maxWidth,
      color: other.color ?? color,
      background: other.background ?? background,
      borderRadius: other.borderRadius ?? borderRadius,
      opacity: other.opacity ?? opacity,
      padding: other.padding ?? padding,
      arrowWidth: other.arrowWidth ?? arrowWidth,
      arrowHeight: other.arrowHeight ?? arrowHeight,
    );
  }

  static const double defaultFontSize = 14;
  static const double defaultMaxWidth = 200;

  /// `$tooltip-color: var(--bs-body-bg)`.
  static const Color defaultColor = BsColors.white;

  /// `$tooltip-color` resolved against `--bs-body-bg` in
  /// `[data-bs-theme="dark"]`.
  static const Color defaultDarkColor = BsBody.darkBackground;

  /// `$tooltip-bg: var(--bs-emphasis-color)`.
  static const Color defaultBackground = BsColors.black;

  /// `$tooltip-bg` resolved against `--bs-emphasis-color` in
  /// `[data-bs-theme="dark"]` — note this *inverts* the tooltip to a
  /// light-on-dark-page chip, since `$body-emphasis-color-dark` is `$white`.
  static const Color defaultDarkBackground = BsBody.darkEmphasisColor;

  static const double defaultBorderRadius = BsBorders.radius;
  static const double defaultOpacity = 0.9;
  static const EdgeInsets defaultPadding = EdgeInsets.symmetric(horizontal: 8, vertical: 4);
  static const double defaultArrowWidth = 12.8;
  static const double defaultArrowHeight = 6.4;

  static const BsTooltipStyle defaults = BsTooltipStyle(
    fontSize: defaultFontSize,
    maxWidth: defaultMaxWidth,
    color: defaultColor,
    background: defaultBackground,
    borderRadius: defaultBorderRadius,
    opacity: defaultOpacity,
    padding: defaultPadding,
    arrowWidth: defaultArrowWidth,
    arrowHeight: defaultArrowHeight,
  );

  /// [defaults], with [color]/[background] swapped for their
  /// `[data-bs-theme="dark"]` counterparts. Pick this as the base to
  /// [merge] a caller's [BsTooltipStyle] override against when
  /// `BsTheme.of(context) == Brightness.dark` — every other field is
  /// brightness-independent, so it's identical to [defaults].
  static const BsTooltipStyle darkDefaults = BsTooltipStyle(
    fontSize: defaultFontSize,
    maxWidth: defaultMaxWidth,
    color: defaultDarkColor,
    background: defaultDarkBackground,
    borderRadius: defaultBorderRadius,
    opacity: defaultOpacity,
    padding: defaultPadding,
    arrowWidth: defaultArrowWidth,
    arrowHeight: defaultArrowHeight,
  );
}
