import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_colors.dart';
import 'bs_borders.dart';
import 'bs_typography.dart';

/// Visual variables of a Bootstrap badge.
///
/// Every field is nullable: null falls back to the matching `default…` constant.
/// [merge] layers overrides on top of [defaults] or, in dark mode, [darkDefaults].
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

  /// Text color. Null derives it from the background, choosing the color with the better contrast.
  final Color? color;

  /// Background color, set per variant; there is no single default.
  final Color? background;

  final double? fontSize;

  final FontWeight? fontWeight;

  /// Padding, relative to [fontSize].
  final EdgeInsetsGeometry? padding;

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

  /// Static fallback text color (white). [BsBadge] derives its color from the background instead;
  /// see [color].
  static const Color defaultColor = BsColors.white;

  static const FontWeight defaultFontWeight = BsTypography.fontWeightBold;

  static const double defaultFontSize = 12;

  /// Default padding, resolved against [defaultFontSize].
  static const EdgeInsets defaultPadding = EdgeInsets.symmetric(horizontal: 7.8, vertical: 4.2);

  static const double defaultBorderRadius = BsBorders.radius;

  static const BsBadgeStyle defaults = BsBadgeStyle(
    fontSize: defaultFontSize,
    fontWeight: defaultFontWeight,
    padding: defaultPadding,
    borderRadius: defaultBorderRadius,
  );
}
