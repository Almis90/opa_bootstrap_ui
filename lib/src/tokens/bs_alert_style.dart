import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'bs_borders.dart';
import 'bs_typography.dart';

/// A Bootstrap `.alert`'s visual variables.
///
/// Mirrors the `alert-variables` group from Bootstrap's SCSS source
/// (`$alert-*`). Per-variant colors (background/border/text) are computed
/// by the future `BsAlert` widget from a [BsVariant], the same way
/// Bootstrap's `alert-variant()` mixin derives them from `$theme-colors`.
@immutable
class BsAlertStyle {
  const BsAlertStyle({
    this.padding,
    this.marginBottom,
    this.borderRadius,
    this.borderWidth,
    this.linkFontWeight,
    this.dismissiblePaddingEnd,
  });

  /// `$alert-padding-y`/`$alert-padding-x` (`$spacer`).
  final EdgeInsetsGeometry? padding;

  /// `$alert-margin-bottom` (`1rem`).
  final double? marginBottom;

  /// `$alert-border-radius` (`var(--bs-border-radius)`).
  final double? borderRadius;

  /// `$alert-border-width` (`var(--bs-border-width)`).
  final double? borderWidth;

  /// `$alert-link-font-weight` (`$font-weight-bold`).
  final FontWeight? linkFontWeight;

  /// `$alert-dismissible-padding-r` (`$alert-padding-x * 3`).
  final double? dismissiblePaddingEnd;

  BsAlertStyle merge(BsAlertStyle? other) {
    if (other == null) return this;
    return BsAlertStyle(
      padding: other.padding ?? padding,
      marginBottom: other.marginBottom ?? marginBottom,
      borderRadius: other.borderRadius ?? borderRadius,
      borderWidth: other.borderWidth ?? borderWidth,
      linkFontWeight: other.linkFontWeight ?? linkFontWeight,
      dismissiblePaddingEnd: other.dismissiblePaddingEnd ?? dismissiblePaddingEnd,
    );
  }

  static const double defaultPaddingValue = 16;
  static const EdgeInsets defaultPadding = EdgeInsets.all(defaultPaddingValue);
  static const double defaultMarginBottom = 16;
  static const double defaultBorderRadius = BsBorders.radius;
  static const double defaultBorderWidth = BsBorders.width;
  static const FontWeight defaultLinkFontWeight = BsTypography.fontWeightBold;
  static const double defaultDismissiblePaddingEnd = defaultPaddingValue * 3;

  static const BsAlertStyle defaults = BsAlertStyle(
    padding: defaultPadding,
    marginBottom: defaultMarginBottom,
    borderRadius: defaultBorderRadius,
    borderWidth: defaultBorderWidth,
    linkFontWeight: defaultLinkFontWeight,
    dismissiblePaddingEnd: defaultDismissiblePaddingEnd,
  );
}
