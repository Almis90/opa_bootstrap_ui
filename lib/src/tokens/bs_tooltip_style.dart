import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_colors.dart';
import 'bs_body.dart';
import 'bs_borders.dart';

/// Visual variables of a Bootstrap tooltip.
///
/// Every field is nullable: null falls back to the matching `default…` constant.
/// [merge] layers overrides on top of [defaults] or, in dark mode, [darkDefaults].
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

  /// Font size.
  final double? fontSize;

  /// Maximum width.
  final double? maxWidth;

  /// Text color.
  final Color? color;

  /// Background color.
  final Color? background;

  /// Corner radius.
  final double? borderRadius;

  /// Opacity.
  final double? opacity;

  /// Padding of the tooltip.
  final EdgeInsetsGeometry? padding;

  /// Arrow width.
  final double? arrowWidth;

  /// Arrow height.
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

  /// Default color.
  static const Color defaultColor = BsColors.white;

  /// Default text color in dark mode.
  static const Color defaultDarkColor = BsBody.darkBackground;

  /// Default background.
  static const Color defaultBackground = BsColors.black;

  /// Default background in dark mode: the tooltip inverts to a light chip on the dark page.
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

  /// Dark-mode counterpart of [defaults]: [color] and [background] are swapped, the rest is
  /// identical. Use it as the base to [merge] a caller's override when the ambient brightness is
  /// dark.
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
