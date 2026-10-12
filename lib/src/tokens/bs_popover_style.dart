import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_colors.dart';
import 'bs_body.dart';
import 'bs_borders.dart';
import 'bs_shadows.dart';

/// Visual variables of a Bootstrap popover.
///
/// Every field is nullable: null falls back to the matching `default…` constant.
/// [merge] layers overrides on top of [defaults] or, in dark mode, [darkDefaults].
@immutable
class BsPopoverStyle {
  const BsPopoverStyle({
    this.fontSize,
    this.background,
    this.maxWidth,
    this.borderWidth,
    this.borderColor,
    this.borderRadius,
    this.boxShadow,
    this.headerFontSize,
    this.headerBackground,
    this.headerColor,
    this.headerPadding,
    this.bodyColor,
    this.bodyPadding,
    this.arrowWidth,
    this.arrowHeight,
  });

  final double? fontSize;

  final Color? background;

  final double? maxWidth;

  final double? borderWidth;

  final Color? borderColor;

  final double? borderRadius;

  /// Drop shadow of the popover. Null by default (no shadow); pass [defaultBoxShadow] to opt in.
  final List<BoxShadow>? boxShadow;

  final double? headerFontSize;

  final Color? headerBackground;

  final Color? headerColor;

  final EdgeInsetsGeometry? headerPadding;

  final Color? bodyColor;

  final EdgeInsetsGeometry? bodyPadding;

  final double? arrowWidth;

  final double? arrowHeight;

  BsPopoverStyle merge(BsPopoverStyle? other) {
    if (other == null) return this;
    return BsPopoverStyle(
      fontSize: other.fontSize ?? fontSize,
      background: other.background ?? background,
      maxWidth: other.maxWidth ?? maxWidth,
      borderWidth: other.borderWidth ?? borderWidth,
      borderColor: other.borderColor ?? borderColor,
      borderRadius: other.borderRadius ?? borderRadius,
      boxShadow: other.boxShadow ?? boxShadow,
      headerFontSize: other.headerFontSize ?? headerFontSize,
      headerBackground: other.headerBackground ?? headerBackground,
      headerColor: other.headerColor ?? headerColor,
      headerPadding: other.headerPadding ?? headerPadding,
      bodyColor: other.bodyColor ?? bodyColor,
      bodyPadding: other.bodyPadding ?? bodyPadding,
      arrowWidth: other.arrowWidth ?? arrowWidth,
      arrowHeight: other.arrowHeight ?? arrowHeight,
    );
  }

  static const double defaultFontSize = 14;

  static const Color defaultBackground = BsColors.white;

  static const Color defaultDarkBackground = BsBody.darkBackground;

  static const double defaultMaxWidth = 276;
  static const double defaultBorderWidth = BsBorders.width;

  static const Color defaultBorderColor = BsBorders.colorTranslucent;

  /// Default border color in dark mode: translucent white.
  static const Color defaultDarkBorderColor = BsBorders.darkColorTranslucent;

  static const double defaultBorderRadius = BsBorders.radiusLg;
  static const List<BoxShadow> defaultBoxShadow = BsShadows.shadow;
  static const double defaultHeaderFontSize = 16;

  static const Color defaultHeaderBackground = BsColors.gray200;

  static const Color defaultDarkHeaderBackground = BsBody.darkSecondaryBackground;

  static const EdgeInsets defaultHeaderPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 8);

  static const Color defaultBodyColor = BsColors.gray900;

  static const Color defaultDarkBodyColor = BsBody.darkColor;

  static const EdgeInsets defaultBodyPadding = EdgeInsets.all(16);
  static const double defaultArrowWidth = 16;
  static const double defaultArrowHeight = 8;

  static const BsPopoverStyle defaults = BsPopoverStyle(
    fontSize: defaultFontSize,
    background: defaultBackground,
    maxWidth: defaultMaxWidth,
    borderWidth: defaultBorderWidth,
    borderColor: defaultBorderColor,
    borderRadius: defaultBorderRadius,
    headerFontSize: defaultHeaderFontSize,
    headerBackground: defaultHeaderBackground,
    headerPadding: defaultHeaderPadding,
    bodyColor: defaultBodyColor,
    bodyPadding: defaultBodyPadding,
    arrowWidth: defaultArrowWidth,
    arrowHeight: defaultArrowHeight,
  );

  /// Dark-mode counterpart of [defaults]: [background], [borderColor], [headerBackground] and
  /// [bodyColor] are swapped, the rest is identical. Use it as the base to [merge] a caller's
  /// override when the ambient brightness is dark.
  static const BsPopoverStyle darkDefaults = BsPopoverStyle(
    fontSize: defaultFontSize,
    background: defaultDarkBackground,
    maxWidth: defaultMaxWidth,
    borderWidth: defaultBorderWidth,
    borderColor: defaultDarkBorderColor,
    borderRadius: defaultBorderRadius,
    headerFontSize: defaultHeaderFontSize,
    headerBackground: defaultDarkHeaderBackground,
    headerPadding: defaultHeaderPadding,
    bodyColor: defaultDarkBodyColor,
    bodyPadding: defaultBodyPadding,
    arrowWidth: defaultArrowWidth,
    arrowHeight: defaultArrowHeight,
  );
}
