import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'bs_borders.dart';
import 'bs_typography.dart';

/// A Bootstrap `.alert`'s visual variables.
///
/// Mirrors the `alert-variables` group from Bootstrap's SCSS source
/// (`$alert-*`) plus the `--bs-alert-*` custom properties the
/// `.alert-{variant}` loop sets. [BsAlert] defaults [color]/[background]/
/// [borderColor]/[linkColor] from its `variant` (the same way Bootstrap's
/// loop derives them from `$theme-colors`), but each can be overridden here
/// independently, the same way a custom `.alert-*` class in Bootstrap would
/// reassign just the CSS variables it needs.
@immutable
class BsAlertStyle {
  const BsAlertStyle({
    this.color,
    this.background,
    this.borderColor,
    this.linkColor,
    this.padding,
    this.marginBottom,
    this.borderRadius,
    this.borderWidth,
    this.linkFontWeight,
    this.dismissiblePaddingEnd,
  });

  /// `--bs-alert-color`, per `.alert-{variant}` (`var(--bs-{variant}-text-emphasis)`).
  /// Null means "derive from [BsAlert.variant]" via [BsVariant.textEmphasis].
  final Color? color;

  /// `--bs-alert-bg`, per `.alert-{variant}` (`var(--bs-{variant}-bg-subtle)`).
  /// Null means "derive from [BsAlert.variant]" via [BsVariant.bgSubtle].
  final Color? background;

  /// `--bs-alert-border-color`, per `.alert-{variant}`
  /// (`var(--bs-{variant}-border-subtle)`). Null means "derive from
  /// [BsAlert.variant]" via [BsVariant.borderSubtle].
  final Color? borderColor;

  /// `--bs-alert-link-color`, per `.alert-{variant}` — the same value as
  /// [color] in current Bootstrap (the older `shade-color($color, 20%)`
  /// formula from `alert-variant()` was deprecated in v5.3.0). Null means
  /// "use [color]".
  final Color? linkColor;

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
      color: other.color ?? color,
      background: other.background ?? background,
      borderColor: other.borderColor ?? borderColor,
      linkColor: other.linkColor ?? linkColor,
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
