import 'package:flutter/foundation.dart';

/// Visual variables of a Bootstrap placeholder.
///
/// Every field is nullable: null falls back to the matching `default…` constant.
/// [merge] layers overrides on top of [defaults] or, in dark mode, [darkDefaults].
@immutable
class BsPlaceholderStyle {
  const BsPlaceholderStyle({this.opacityMax, this.opacityMin});

  /// Opacity max.
  final double? opacityMax;

  /// Opacity min.
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
