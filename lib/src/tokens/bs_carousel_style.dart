import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_colors.dart';

/// Visual variables of a Bootstrap carousel.
///
/// Every field is nullable: null falls back to the matching `default…` constant.
/// [merge] layers overrides on top of [defaults] or, in dark mode, [darkDefaults].
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
    this.indicatorMarginBottom,
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

  final Color? controlColor;

  final double? controlWidthFraction;

  final double? controlOpacity;

  final double? controlHoverOpacity;

  final Duration? controlTransitionDuration;

  final double? controlIconSize;

  final double? indicatorWidth;

  final double? indicatorHeight;

  final double? indicatorHitAreaHeight;

  final double? indicatorSpacer;

  /// Space below the indicators.
  final double? indicatorMarginBottom;

  final double? indicatorOpacity;

  final Color? indicatorActiveBackground;

  final double? indicatorActiveOpacity;

  final Duration? indicatorTransitionDuration;

  final double? captionWidthFraction;

  final Color? captionColor;

  final double? captionPaddingY;

  final double? captionSpacer;

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
      indicatorMarginBottom: other.indicatorMarginBottom ?? indicatorMarginBottom,
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
  static const double defaultIndicatorHitAreaHeight = 23;
  static const double defaultIndicatorSpacer = 3;
  static const double defaultIndicatorMarginBottom = 16;
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
    indicatorMarginBottom: defaultIndicatorMarginBottom,
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
