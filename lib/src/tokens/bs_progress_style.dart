import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_colors.dart';
import '../bs_variant.dart';
import 'bs_body.dart';
import 'bs_borders.dart';
import 'bs_shadows.dart';

/// Visual variables of a Bootstrap progress.
///
/// Every field is nullable: null falls back to the matching `default…` constant.
/// [merge] layers overrides on top of [defaults] or, in dark mode, [darkDefaults].
@immutable
class BsProgressStyle {
  const BsProgressStyle({
    this.height,
    this.fontSize,
    this.background,
    this.borderRadius,
    this.boxShadow,
    this.barColor,
    this.barBackground,
    this.barAnimationDuration,
    this.barTransitionDuration,
  });

  /// Height.
  final double? height;

  /// Font size.
  final double? fontSize;

  /// Background color.
  final Color? background;

  /// Corner radius.
  final double? borderRadius;

  /// Inset shadow of the track. Null by default (no shadow); pass [defaultBoxShadow] to opt in.
  final List<BoxShadow>? boxShadow;

  /// Bar color.
  final Color? barColor;

  /// Bar background.
  final Color? barBackground;

  /// Bar animation duration.
  final Duration? barAnimationDuration;

  /// Bar transition duration.
  final Duration? barTransitionDuration;

  BsProgressStyle merge(BsProgressStyle? other) {
    if (other == null) return this;
    return BsProgressStyle(
      height: other.height ?? height,
      fontSize: other.fontSize ?? fontSize,
      background: other.background ?? background,
      borderRadius: other.borderRadius ?? borderRadius,
      boxShadow: other.boxShadow ?? boxShadow,
      barColor: other.barColor ?? barColor,
      barBackground: other.barBackground ?? barBackground,
      barAnimationDuration: other.barAnimationDuration ?? barAnimationDuration,
      barTransitionDuration: other.barTransitionDuration ?? barTransitionDuration,
    );
  }

  static const double defaultHeight = 16;
  static const double defaultFontSize = 12;
  static const Color defaultBackground = BsColors.gray200;

  /// Default background in dark mode.
  static const Color defaultDarkBackground = BsBody.darkSecondaryBackground;

  static const double defaultBorderRadius = BsBorders.radius;
  static const List<BoxShadow> defaultBoxShadow = BsShadows.shadowInset;

  /// Default bar text color: white in both themes.
  static const Color defaultBarColor = BsColors.white;

  /// Default bar color: the primary color, the same in both themes.
  static Color get defaultBarBackground => BsVariant.primary.color;

  static const Duration defaultBarAnimationDuration = Duration(seconds: 1);
  static const Duration defaultBarTransitionDuration = Duration(milliseconds: 600);

  static BsProgressStyle get defaults => BsProgressStyle(
    height: defaultHeight,
    fontSize: defaultFontSize,
    background: defaultBackground,
    borderRadius: defaultBorderRadius,
    barColor: defaultBarColor,
    barBackground: defaultBarBackground,
    barAnimationDuration: defaultBarAnimationDuration,
    barTransitionDuration: defaultBarTransitionDuration,
  );

  /// Dark-mode counterpart of [defaults]: [background] is swapped. The rest is identical.
  /// Use it as the base to [merge] a caller's override when the ambient brightness is dark.
  static BsProgressStyle get darkDefaults => BsProgressStyle(
    height: defaultHeight,
    fontSize: defaultFontSize,
    background: defaultDarkBackground,
    borderRadius: defaultBorderRadius,
    barColor: defaultBarColor,
    barBackground: defaultBarBackground,
    barAnimationDuration: defaultBarAnimationDuration,
    barTransitionDuration: defaultBarTransitionDuration,
  );
}
