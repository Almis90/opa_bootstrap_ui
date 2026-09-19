import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_colors.dart';
import 'bs_borders.dart';
import 'bs_shadows.dart';

/// A Bootstrap `.img-thumbnail`'s visual variables.
///
/// Mirrors the `thumbnail-variables` group from Bootstrap's SCSS source
/// (`$thumbnail-*`).
@immutable
class BsThumbnailStyle {
  const BsThumbnailStyle({this.padding, this.background, this.borderWidth, this.borderColor, this.borderRadius, this.boxShadow});

  /// `$thumbnail-padding` (`.25rem`).
  final double? padding;

  /// `$thumbnail-bg` (`var(--bs-body-bg)`).
  final Color? background;

  /// `$thumbnail-border-width` (`var(--bs-border-width)`).
  final double? borderWidth;

  /// `$thumbnail-border-color` (`var(--bs-border-color)`).
  final Color? borderColor;

  /// `$thumbnail-border-radius` (`var(--bs-border-radius)`).
  final double? borderRadius;

  /// `$thumbnail-box-shadow` (`var(--bs-box-shadow-sm)`).
  final List<BoxShadow>? boxShadow;

  BsThumbnailStyle merge(BsThumbnailStyle? other) {
    if (other == null) return this;
    return BsThumbnailStyle(
      padding: other.padding ?? padding,
      background: other.background ?? background,
      borderWidth: other.borderWidth ?? borderWidth,
      borderColor: other.borderColor ?? borderColor,
      borderRadius: other.borderRadius ?? borderRadius,
      boxShadow: other.boxShadow ?? boxShadow,
    );
  }

  static const double defaultPadding = 4;
  static const Color defaultBackground = BsColors.white;
  static const double defaultBorderWidth = BsBorders.width;
  static const Color defaultBorderColor = BsBorders.color;
  static const double defaultBorderRadius = BsBorders.radius;
  static const List<BoxShadow> defaultBoxShadow = BsShadows.shadowSm;

  static const BsThumbnailStyle defaults = BsThumbnailStyle(
    padding: defaultPadding,
    background: defaultBackground,
    borderWidth: defaultBorderWidth,
    borderColor: defaultBorderColor,
    borderRadius: defaultBorderRadius,
    boxShadow: defaultBoxShadow,
  );
}
