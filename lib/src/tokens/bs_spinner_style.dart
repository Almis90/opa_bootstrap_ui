import 'package:flutter/foundation.dart';

/// A Bootstrap `.spinner-border`/`.spinner-grow`'s visual variables.
///
/// Mirrors the `spinner-variables` group from Bootstrap's SCSS source
/// (`$spinner-*`), assuming the default `16px` root font size.
@immutable
class BsSpinnerStyle {
  const BsSpinnerStyle({this.size, this.borderWidth, this.animationDuration});

  /// `$spinner-width`/`$spinner-height` (`2rem`).
  final double? size;

  /// `$spinner-border-width` (`.25em`).
  final double? borderWidth;

  /// `$spinner-animation-speed` (`.75s`).
  final Duration? animationDuration;

  BsSpinnerStyle merge(BsSpinnerStyle? other) {
    if (other == null) return this;
    return BsSpinnerStyle(
      size: other.size ?? size,
      borderWidth: other.borderWidth ?? borderWidth,
      animationDuration: other.animationDuration ?? animationDuration,
    );
  }

  static const double defaultSize = 32;
  static const double defaultBorderWidth = 4;
  static const Duration defaultAnimationDuration = Duration(milliseconds: 750);

  /// `$spinner-width-sm`/`$spinner-height-sm` (`1rem`).
  static const double defaultSizeSm = 16;

  /// `$spinner-border-width-sm` (`.2em`).
  static const double defaultBorderWidthSm = 3.2;

  static const BsSpinnerStyle defaults = BsSpinnerStyle(
    size: defaultSize,
    borderWidth: defaultBorderWidth,
    animationDuration: defaultAnimationDuration,
  );

  static const BsSpinnerStyle small = BsSpinnerStyle(
    size: defaultSizeSm,
    borderWidth: defaultBorderWidthSm,
    animationDuration: defaultAnimationDuration,
  );
}
