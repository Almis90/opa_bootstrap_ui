import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'bs_borders.dart';
import 'bs_typography.dart';

/// Visual variables of a Bootstrap alert.
///
/// Every field is nullable: null falls back to the matching `default…` constant.
/// [merge] layers overrides on top of [defaults] or, in dark mode, [darkDefaults].
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

  /// Text color. Null derives it from [BsAlert.variant] via [BsVariant.textEmphasis].
  final Color? color;

  /// Background color. Null derives it from [BsAlert.variant] via [BsVariant.bgSubtle].
  final Color? background;

  /// Border color. Null derives it from [BsAlert.variant] via [BsVariant.borderSubtle].
  final Color? borderColor;

  /// Color of links inside the alert. Null uses [color].
  final Color? linkColor;

  /// Padding.
  final EdgeInsetsGeometry? padding;

  /// Margin bottom.
  final double? marginBottom;

  /// Corner radius.
  final double? borderRadius;

  /// Border width.
  final double? borderWidth;

  /// Link font weight.
  final FontWeight? linkFontWeight;

  /// Dismissible padding end.
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
