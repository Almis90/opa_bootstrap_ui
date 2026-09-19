import 'package:flutter/foundation.dart';

/// A Bootstrap `.placeholder` (loading skeleton)'s visual variables.
///
/// Mirrors the `placeholders` group from Bootstrap's SCSS source
/// (`$placeholder-*`). Bootstrap animates opacity between these two values
/// via the `placeholder-glow`/`placeholder-wave` classes.
@immutable
class BsPlaceholderStyle {
  const BsPlaceholderStyle({this.opacityMax, this.opacityMin});

  /// `$placeholder-opacity-max` (`.5`).
  final double? opacityMax;

  /// `$placeholder-opacity-min` (`.2`).
  final double? opacityMin;

  BsPlaceholderStyle merge(BsPlaceholderStyle? other) {
    if (other == null) return this;
    return BsPlaceholderStyle(
      opacityMax: other.opacityMax ?? opacityMax,
      opacityMin: other.opacityMin ?? opacityMin,
    );
  }

  static const double defaultOpacityMax = 0.5;
  static const double defaultOpacityMin = 0.2;

  static const BsPlaceholderStyle defaults = BsPlaceholderStyle(
    opacityMax: defaultOpacityMax,
    opacityMin: defaultOpacityMin,
  );
}
