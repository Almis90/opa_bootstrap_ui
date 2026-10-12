import 'package:flutter/foundation.dart';

/// Visual variables of a Bootstrap spinner.
///
/// Every field is nullable: null falls back to the matching `default…` constant.
/// [merge] layers overrides on top of [defaults] or, in dark mode, [darkDefaults].
@immutable
class BsSpinnerStyle {
  const BsSpinnerStyle({
    this.size,
    this.borderWidth,
    this.animationDuration,
    this.verticalAlign,
  });

  final double? size;

  final double? borderWidth;

  final Duration? animationDuration;

  final double? verticalAlign;

  BsSpinnerStyle merge(BsSpinnerStyle? other) {
    if (other == null) return this;
    return BsSpinnerStyle(
      size: other.size ?? size,
      borderWidth: other.borderWidth ?? borderWidth,
      animationDuration: other.animationDuration ?? animationDuration,
      verticalAlign: other.verticalAlign ?? verticalAlign,
    );
  }

  static const double defaultSize = 32;
  static const double defaultBorderWidth = 4;
  static const Duration defaultAnimationDuration = Duration(milliseconds: 750);

  static const double defaultVerticalAlign = -2;

  static const double defaultSizeSm = 16;

  static const double defaultBorderWidthSm = 3.2;

  static const BsSpinnerStyle defaults = BsSpinnerStyle(
    size: defaultSize,
    borderWidth: defaultBorderWidth,
    animationDuration: defaultAnimationDuration,
    verticalAlign: defaultVerticalAlign,
  );

  static const BsSpinnerStyle small = BsSpinnerStyle(
    size: defaultSizeSm,
    borderWidth: defaultBorderWidthSm,
    verticalAlign: defaultVerticalAlign,
    animationDuration: defaultAnimationDuration,
  );
}
