import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_colors.dart';
import 'bs_body.dart';
import 'bs_borders.dart';
import 'bs_shadows.dart';

/// Visual variables of a Bootstrap thumbnail.
///
/// Every field is nullable: null falls back to the matching `default…` constant.
/// [merge] layers overrides on top of [defaults] or, in dark mode, [darkDefaults].
@immutable
class BsThumbnailStyle {
  const BsThumbnailStyle({this.padding, this.background, this.borderWidth, this.borderColor, this.borderRadius, this.boxShadow});

  final double? padding;

  final Color? background;

  final double? borderWidth;

  final Color? borderColor;

  final double? borderRadius;

  /// Drop shadow of the thumbnail. Null by default (no shadow); pass [defaultBoxShadow] to opt in.
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

  static const Color defaultDarkBackground = BsBody.darkBackground;

  static const Color defaultDarkBorderColor = BsBorders.darkColor;

  static const BsThumbnailStyle defaults = BsThumbnailStyle(
    padding: defaultPadding,
    background: defaultBackground,
    borderWidth: defaultBorderWidth,
    borderColor: defaultBorderColor,
    borderRadius: defaultBorderRadius,
  );

  /// Dark-mode counterpart of [defaults]: [background] and [borderColor] are swapped, the rest is
  /// identical. Use it as the base to [merge] a caller's override when the ambient brightness is
  /// dark.
  static const BsThumbnailStyle darkDefaults = BsThumbnailStyle(
    padding: defaultPadding,
    background: defaultDarkBackground,
    borderWidth: defaultBorderWidth,
    borderColor: defaultDarkBorderColor,
    borderRadius: defaultBorderRadius,
  );
}
