import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_colors.dart';

/// A Bootstrap `.carousel`'s visual variables.
///
/// Mirrors the `carousel-variables` group from Bootstrap's SCSS source
/// (`$carousel-*`).
@immutable
class BsCarouselStyle {
  const BsCarouselStyle({
    this.controlColor,
    this.controlWidthFraction,
    this.controlOpacity,
    this.controlHoverOpacity,
    this.controlTransitionDuration,
    this.controlIconSize,
    this.indicatorWidth,
    this.indicatorHeight,
    this.indicatorHitAreaHeight,
    this.indicatorSpacer,
    this.indicatorOpacity,
    this.indicatorActiveBackground,
    this.indicatorActiveOpacity,
    this.indicatorTransitionDuration,
    this.captionWidthFraction,
    this.captionColor,
    this.captionPaddingY,
    this.captionSpacer,
    this.transitionDuration,
  });

  /// `$carousel-control-color` (`$white`).
  final Color? controlColor;

  /// `$carousel-control-width` (`15%`, as a 0-1 fraction).
  final double? controlWidthFraction;

  /// `$carousel-control-opacity` (`.5`).
  final double? controlOpacity;

  /// `$carousel-control-hover-opacity` (`.9`).
  final double? controlHoverOpacity;

  /// `$carousel-control-transition` (`opacity .15s ease`).
  final Duration? controlTransitionDuration;

  /// `$carousel-control-icon-width` (`2rem`).
  final double? controlIconSize;

  /// `$carousel-indicator-width` (`30px`).
  final double? indicatorWidth;

  /// `$carousel-indicator-height` (`3px`).
  final double? indicatorHeight;

  /// `$carousel-indicator-hit-area-height` (`10px`).
  final double? indicatorHitAreaHeight;

  /// `$carousel-indicator-spacer` (`3px`).
  final double? indicatorSpacer;

  /// `$carousel-indicator-opacity` (`.5`).
  final double? indicatorOpacity;

  /// `$carousel-indicator-active-bg` (`$white`).
  final Color? indicatorActiveBackground;

  /// `$carousel-indicator-active-opacity` (`1`).
  final double? indicatorActiveOpacity;

  /// `$carousel-indicator-transition` (`opacity .6s ease`).
  final Duration? indicatorTransitionDuration;

  /// `$carousel-caption-width` (`70%`, as a 0-1 fraction).
  final double? captionWidthFraction;

  /// `$carousel-caption-color` (`$white`).
  final Color? captionColor;

  /// `$carousel-caption-padding-y` (`1.25rem`).
  final double? captionPaddingY;

  /// `$carousel-caption-spacer` (`1.25rem`).
  final double? captionSpacer;

  /// `$carousel-transition-duration` (`.6s`).
  final Duration? transitionDuration;

  BsCarouselStyle merge(BsCarouselStyle? other) {
    if (other == null) return this;
    return BsCarouselStyle(
      controlColor: other.controlColor ?? controlColor,
      controlWidthFraction: other.controlWidthFraction ?? controlWidthFraction,
      controlOpacity: other.controlOpacity ?? controlOpacity,
      controlHoverOpacity: other.controlHoverOpacity ?? controlHoverOpacity,
      controlTransitionDuration: other.controlTransitionDuration ?? controlTransitionDuration,
      controlIconSize: other.controlIconSize ?? controlIconSize,
      indicatorWidth: other.indicatorWidth ?? indicatorWidth,
      indicatorHeight: other.indicatorHeight ?? indicatorHeight,
      indicatorHitAreaHeight: other.indicatorHitAreaHeight ?? indicatorHitAreaHeight,
      indicatorSpacer: other.indicatorSpacer ?? indicatorSpacer,
      indicatorOpacity: other.indicatorOpacity ?? indicatorOpacity,
      indicatorActiveBackground: other.indicatorActiveBackground ?? indicatorActiveBackground,
      indicatorActiveOpacity: other.indicatorActiveOpacity ?? indicatorActiveOpacity,
      indicatorTransitionDuration: other.indicatorTransitionDuration ?? indicatorTransitionDuration,
      captionWidthFraction: other.captionWidthFraction ?? captionWidthFraction,
      captionColor: other.captionColor ?? captionColor,
      captionPaddingY: other.captionPaddingY ?? captionPaddingY,
      captionSpacer: other.captionSpacer ?? captionSpacer,
      transitionDuration: other.transitionDuration ?? transitionDuration,
    );
  }

  static const Color defaultControlColor = BsColors.white;
  static const double defaultControlWidthFraction = 0.15;
  static const double defaultControlOpacity = 0.5;
  static const double defaultControlHoverOpacity = 0.9;
  static const Duration defaultControlTransitionDuration = Duration(milliseconds: 150);
  static const double defaultControlIconSize = 32;
  static const double defaultIndicatorWidth = 30;
  static const double defaultIndicatorHeight = 3;
  static const double defaultIndicatorHitAreaHeight = 10;
  static const double defaultIndicatorSpacer = 3;
  static const double defaultIndicatorOpacity = 0.5;
  static const Color defaultIndicatorActiveBackground = BsColors.white;
  static const double defaultIndicatorActiveOpacity = 1;
  static const Duration defaultIndicatorTransitionDuration = Duration(milliseconds: 600);
  static const double defaultCaptionWidthFraction = 0.7;
  static const Color defaultCaptionColor = BsColors.white;
  static const double defaultCaptionPaddingY = 20;
  static const double defaultCaptionSpacer = 20;
  static const Duration defaultTransitionDuration = Duration(milliseconds: 600);

  static const BsCarouselStyle defaults = BsCarouselStyle(
    controlColor: defaultControlColor,
    controlWidthFraction: defaultControlWidthFraction,
    controlOpacity: defaultControlOpacity,
    controlHoverOpacity: defaultControlHoverOpacity,
    controlTransitionDuration: defaultControlTransitionDuration,
    controlIconSize: defaultControlIconSize,
    indicatorWidth: defaultIndicatorWidth,
    indicatorHeight: defaultIndicatorHeight,
    indicatorHitAreaHeight: defaultIndicatorHitAreaHeight,
    indicatorSpacer: defaultIndicatorSpacer,
    indicatorOpacity: defaultIndicatorOpacity,
    indicatorActiveBackground: defaultIndicatorActiveBackground,
    indicatorActiveOpacity: defaultIndicatorActiveOpacity,
    indicatorTransitionDuration: defaultIndicatorTransitionDuration,
    captionWidthFraction: defaultCaptionWidthFraction,
    captionColor: defaultCaptionColor,
    captionPaddingY: defaultCaptionPaddingY,
    captionSpacer: defaultCaptionSpacer,
    transitionDuration: defaultTransitionDuration,
  );
}
