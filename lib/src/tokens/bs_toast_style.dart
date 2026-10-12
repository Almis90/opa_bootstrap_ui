import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_colors.dart';
import 'bs_body.dart';
import 'bs_borders.dart';
import 'bs_shadows.dart';

/// Visual variables of a Bootstrap toast.
///
/// Every field is nullable: null falls back to the matching `default…` constant.
/// [merge] layers overrides on top of [defaults] or, in dark mode, [darkDefaults].
@immutable
class BsToastStyle {
  const BsToastStyle({
    this.maxWidth,
    this.padding,
    this.fontSize,
    this.color,
    this.background,
    this.borderWidth,
    this.borderColor,
    this.borderRadius,
    this.boxShadow,
    this.spacing,
    this.headerColor,
    this.headerBackground,
    this.headerBorderColor,
  });

  /// Maximum width.
  final double? maxWidth;

  /// Padding of the toast and its header.
  final EdgeInsetsGeometry? padding;

  /// Font size.
  final double? fontSize;

  /// Text color.
  final Color? color;

  /// Background color.
  final Color? background;

  /// Border width.
  final double? borderWidth;

  /// Border color.
  final Color? borderColor;

  /// Corner radius.
  final double? borderRadius;

  /// Drop shadow.
  final List<BoxShadow>? boxShadow;

  /// Spacing.
  final double? spacing;

  /// Header color.
  final Color? headerColor;

  /// Header background.
  final Color? headerBackground;

  /// Header border color.
  final Color? headerBorderColor;

  BsToastStyle merge(BsToastStyle? other) {
    if (other == null) return this;
    return BsToastStyle(
      maxWidth: other.maxWidth ?? maxWidth,
      padding: other.padding ?? padding,
      fontSize: other.fontSize ?? fontSize,
      color: other.color ?? color,
      background: other.background ?? background,
      borderWidth: other.borderWidth ?? borderWidth,
      borderColor: other.borderColor ?? borderColor,
      borderRadius: other.borderRadius ?? borderRadius,
      boxShadow: other.boxShadow ?? boxShadow,
      spacing: other.spacing ?? spacing,
      headerColor: other.headerColor ?? headerColor,
      headerBackground: other.headerBackground ?? headerBackground,
      headerBorderColor: other.headerBorderColor ?? headerBorderColor,
    );
  }

  static const double defaultMaxWidth = 350;
  static const EdgeInsets defaultPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 8);
  static const double defaultFontSize = 14;

  /// Default background.
  static const Color defaultBackground = Color(0xD9FFFFFF);

  /// Default background in dark mode.
  static const Color defaultDarkBackground = Color(0xD9212529);

  static const double defaultBorderWidth = BsBorders.width;
  static const Color defaultBorderColor = BsBorders.colorTranslucent;

  /// Default border color in dark mode.
  static const Color defaultDarkBorderColor = BsBorders.darkColorTranslucent;

  static const double defaultBorderRadius = BsBorders.radius;
  static const List<BoxShadow> defaultBoxShadow = BsShadows.shadow;
  static const double defaultSpacing = 24;

  /// Default header color.
  static const Color defaultHeaderColor = BsColors.gray600;

  /// Default header color in dark mode.
  static const Color defaultDarkHeaderColor = BsBody.darkSecondaryColor;

  /// Default header background.
  static const Color defaultHeaderBackground = Color(0xD9FFFFFF);

  /// Default header background in dark mode.
  static const Color defaultDarkHeaderBackground = Color(0xD9212529);

  static const BsToastStyle defaults = BsToastStyle(
    maxWidth: defaultMaxWidth,
    padding: defaultPadding,
    fontSize: defaultFontSize,
    background: defaultBackground,
    borderWidth: defaultBorderWidth,
    borderColor: defaultBorderColor,
    borderRadius: defaultBorderRadius,
    boxShadow: defaultBoxShadow,
    spacing: defaultSpacing,
    headerColor: defaultHeaderColor,
    headerBackground: defaultHeaderBackground,
    headerBorderColor: defaultBorderColor,
  );

  /// Dark-mode counterpart of [defaults]: every brightness-sensitive field is swapped. Use it as
  /// the base to [merge] a caller's override when the ambient brightness is dark.
  static const BsToastStyle darkDefaults = BsToastStyle(
    maxWidth: defaultMaxWidth,
    padding: defaultPadding,
    fontSize: defaultFontSize,
    background: defaultDarkBackground,
    borderWidth: defaultBorderWidth,
    borderColor: defaultDarkBorderColor,
    borderRadius: defaultBorderRadius,
    boxShadow: defaultBoxShadow,
    spacing: defaultSpacing,
    headerColor: defaultDarkHeaderColor,
    headerBackground: defaultDarkHeaderBackground,
    headerBorderColor: defaultDarkBorderColor,
  );
}
