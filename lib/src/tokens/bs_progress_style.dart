import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_colors.dart';
import '../bs_variant.dart';
import 'bs_borders.dart';
import 'bs_shadows.dart';

/// A Bootstrap `.progress`'s visual variables.
///
/// Mirrors the `progress-variables` group from Bootstrap's SCSS source
/// (`$progress-*`).
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

  /// `$progress-height` (`1rem`).
  final double? height;

  /// `$progress-font-size` (`$font-size-base * .75`).
  final double? fontSize;

  /// `$progress-bg` (`var(--bs-secondary-bg)`).
  final Color? background;

  /// `$progress-border-radius` (`var(--bs-border-radius)`).
  final double? borderRadius;

  /// `$progress-box-shadow` (`var(--bs-box-shadow-inset)`).
  final List<BoxShadow>? boxShadow;

  /// `$progress-bar-color` (`$white`).
  final Color? barColor;

  /// `$progress-bar-bg` (`$primary`).
  final Color? barBackground;

  /// `$progress-bar-animation-timing` (`1s linear infinite`).
  final Duration? barAnimationDuration;

  /// `$progress-bar-transition` (`width .6s ease`).
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
  static const double defaultBorderRadius = BsBorders.radius;
  static const List<BoxShadow> defaultBoxShadow = BsShadows.shadowInset;
  static const Color defaultBarColor = BsColors.white;
  static Color get defaultBarBackground => BsVariant.primary.color;
  static const Duration defaultBarAnimationDuration = Duration(seconds: 1);
  static const Duration defaultBarTransitionDuration = Duration(milliseconds: 600);

  static BsProgressStyle get defaults => BsProgressStyle(
    height: defaultHeight,
    fontSize: defaultFontSize,
    background: defaultBackground,
    borderRadius: defaultBorderRadius,
    boxShadow: defaultBoxShadow,
    barColor: defaultBarColor,
    barBackground: defaultBarBackground,
    barAnimationDuration: defaultBarAnimationDuration,
    barTransitionDuration: defaultBarTransitionDuration,
  );
}
