import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_colors.dart';
import 'bs_borders.dart';
import 'bs_typography.dart';

/// A Bootstrap `.badge`'s visual variables.
///
/// Mirrors the `badge-variables` group from Bootstrap's SCSS source
/// (`$badge-*`).
@immutable
class BsBadgeStyle {
  const BsBadgeStyle({
    this.color,
    this.background,
    this.fontSize,
    this.fontWeight,
    this.padding,
    this.borderRadius,
  });

  /// `--bs-badge-color`. Bootstrap's own `$badge-color` Sass default is a
  /// static `$white`, but real contextual badges in its docs are built with
  /// the `.text-bg-{variant}` helper, which computes actual
  /// `color-contrast()` per background instead — so [BsBadge] leaves this
  /// null by default and derives it from the background, the same way.
  final Color? color;

  /// The badge's background (set per-variant; Bootstrap has no single
  /// `$badge-bg` default).
  final Color? background;

  /// `$badge-font-size` (`.75em`, relative to the parent text).
  final double? fontSize;

  /// `$badge-font-weight` (`$font-weight-bold`).
  final FontWeight? fontWeight;

  /// `$badge-padding-y`/`$badge-padding-x` (`.35em`/`.65em`, relative to
  /// [fontSize]).
  final EdgeInsetsGeometry? padding;

  /// `$badge-border-radius` (`var(--bs-border-radius)`).
  final double? borderRadius;

  BsBadgeStyle merge(BsBadgeStyle? other) {
    if (other == null) return this;
    return BsBadgeStyle(
      color: other.color ?? color,
      background: other.background ?? background,
      fontSize: other.fontSize ?? fontSize,
      fontWeight: other.fontWeight ?? fontWeight,
      padding: other.padding ?? padding,
      borderRadius: other.borderRadius ?? borderRadius,
    );
  }

  /// `$badge-color` — Bootstrap's static fallback, not used by [BsBadge]'s
  /// own defaults (see [color]'s doc comment). Kept for reference/manual use.
  static const Color defaultColor = BsColors.white;

  /// `$badge-font-weight`.
  static const FontWeight defaultFontWeight = BsTypography.fontWeightBold;

  /// `$badge-font-size` (assuming a `16px` root font size: `.75em == 12`).
  static const double defaultFontSize = 12;

  /// `$badge-padding-y`/`$badge-padding-x`, resolved against
  /// [defaultFontSize] (`.35em == 4.2`, `.65em == 7.8`).
  static const EdgeInsets defaultPadding = EdgeInsets.symmetric(horizontal: 7.8, vertical: 4.2);

  /// `$badge-border-radius`.
  static const double defaultBorderRadius = BsBorders.radius;

  static const BsBadgeStyle defaults = BsBadgeStyle(
    fontSize: defaultFontSize,
    fontWeight: defaultFontWeight,
    padding: defaultPadding,
    borderRadius: defaultBorderRadius,
  );
}
