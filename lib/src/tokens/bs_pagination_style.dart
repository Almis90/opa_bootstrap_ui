import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_colors.dart';
import '../bs_variant.dart';
import 'bs_body.dart';
import 'bs_borders.dart';
import 'bs_focus_ring.dart';

/// Visual variables of a Bootstrap pagination.
///
/// Every field is nullable: null falls back to the matching `default…` constant.
/// [merge] layers overrides on top of [defaults] or, in dark mode, [darkDefaults].
@immutable
class BsPaginationStyle {
  const BsPaginationStyle({
    this.padding,
    this.fontSize,
    this.color,
    this.background,
    this.borderRadius,
    this.borderWidth,
    this.borderColor,
    this.focusColor,
    this.focusBackground,
    this.focusRingColor,
    this.focusRingWidth,
    this.hoverColor,
    this.hoverBackground,
    this.hoverBorderColor,
    this.activeColor,
    this.activeBackground,
    this.activeBorderColor,
    this.disabledColor,
    this.disabledBackground,
    this.disabledBorderColor,
    this.transitionDuration,
  });

  /// Padding of a page link.
  final EdgeInsetsGeometry? padding;

  /// Font size.
  final double? fontSize;

  /// Text color.
  final Color? color;

  /// Background color.
  final Color? background;

  /// Corner radius.
  final double? borderRadius;

  /// Border width.
  final double? borderWidth;

  /// Border color.
  final Color? borderColor;

  /// Focus color.
  final Color? focusColor;

  /// Focus background.
  final Color? focusBackground;

  /// Color of the focus ring.
  final Color? focusRingColor;

  /// Width of the focus ring drawn in [focusRingColor].
  final double? focusRingWidth;

  /// Hover color.
  final Color? hoverColor;

  /// Hover background.
  final Color? hoverBackground;

  /// Hover border color.
  final Color? hoverBorderColor;

  /// Active color.
  final Color? activeColor;

  /// Active background.
  final Color? activeBackground;

  /// Active border color.
  final Color? activeBorderColor;

  /// Disabled color.
  final Color? disabledColor;

  /// Disabled background.
  final Color? disabledBackground;

  /// Disabled border color.
  final Color? disabledBorderColor;

  /// Transition duration.
  final Duration? transitionDuration;

  BsPaginationStyle merge(BsPaginationStyle? other) {
    if (other == null) return this;
    return BsPaginationStyle(
      padding: other.padding ?? padding,
      fontSize: other.fontSize ?? fontSize,
      color: other.color ?? color,
      background: other.background ?? background,
      borderRadius: other.borderRadius ?? borderRadius,
      borderWidth: other.borderWidth ?? borderWidth,
      borderColor: other.borderColor ?? borderColor,
      focusColor: other.focusColor ?? focusColor,
      focusBackground: other.focusBackground ?? focusBackground,
      focusRingColor: other.focusRingColor ?? focusRingColor,
      focusRingWidth: other.focusRingWidth ?? focusRingWidth,
      hoverColor: other.hoverColor ?? hoverColor,
      hoverBackground: other.hoverBackground ?? hoverBackground,
      hoverBorderColor: other.hoverBorderColor ?? hoverBorderColor,
      activeColor: other.activeColor ?? activeColor,
      activeBackground: other.activeBackground ?? activeBackground,
      activeBorderColor: other.activeBorderColor ?? activeBorderColor,
      disabledColor: other.disabledColor ?? disabledColor,
      disabledBackground: other.disabledBackground ?? disabledBackground,
      disabledBorderColor: other.disabledBorderColor ?? disabledBorderColor,
      transitionDuration: other.transitionDuration ?? transitionDuration,
    );
  }

  static const EdgeInsets defaultPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 6);
  static const double defaultFontSize = 16;
  static Color get defaultColor => BsVariant.primary.color;
  static const Color defaultBackground = BsColors.white;

  /// Default background in dark mode.
  static const Color defaultDarkBackground = BsBody.darkBackground;

  static const double defaultBorderRadius = BsBorders.radius;
  static const double defaultBorderWidth = BsBorders.width;
  static const Color defaultBorderColor = BsBorders.color;

  /// Default border color in dark mode.
  static const Color defaultDarkBorderColor = BsBorders.darkColor;

  static const Color defaultFocusBackground = BsColors.gray200;

  /// Default focus background in dark mode.
  static const Color defaultDarkFocusBackground = BsBody.darkSecondaryBackground;

  static const Color defaultHoverBackground = BsColors.gray100;

  /// Default hover background in dark mode.
  static Color get defaultDarkHoverBackground => BsBody.darkTertiaryBackground;

  static const Color defaultActiveColor = BsColors.white;
  static Color get defaultActiveBackground => BsVariant.primary.color;
  static const Color defaultDisabledColor = BsColors.gray600;

  /// Default disabled color in dark mode.
  static const Color defaultDarkDisabledColor = BsBody.darkSecondaryColor;

  static const Color defaultDisabledBackground = BsColors.gray200;

  /// Default disabled background in dark mode.
  static const Color defaultDarkDisabledBackground = BsBody.darkSecondaryBackground;

  static const Duration defaultTransitionDuration = Duration(milliseconds: 150);

  /// Default focus ring width.
  static const double defaultFocusRingWidth = BsFocusRing.width;
  static Color get defaultFocusRingColor => BsFocusRing.color();

  static BsPaginationStyle get defaults => BsPaginationStyle(
    padding: defaultPadding,
    fontSize: defaultFontSize,
    color: defaultColor,
    background: defaultBackground,
    borderRadius: defaultBorderRadius,
    borderWidth: defaultBorderWidth,
    borderColor: defaultBorderColor,
    focusColor: defaultColor,
    focusBackground: defaultFocusBackground,
    focusRingColor: defaultFocusRingColor,
    focusRingWidth: defaultFocusRingWidth,
    hoverColor: defaultColor,
    hoverBackground: defaultHoverBackground,
    hoverBorderColor: defaultBorderColor,
    activeColor: defaultActiveColor,
    activeBackground: defaultActiveBackground,
    activeBorderColor: defaultActiveBackground,
    disabledColor: defaultDisabledColor,
    disabledBackground: defaultDisabledBackground,
    disabledBorderColor: defaultBorderColor,
    transitionDuration: defaultTransitionDuration,
  );

  /// Dark-mode counterpart of [defaults]: every brightness-sensitive field is swapped.
  /// [color], [focusColor], [hoverColor], [focusRingColor], [activeColor] and [activeBackground]
  /// are the same in both themes. Use it as the base to [merge] a caller's override when the
  /// ambient brightness is dark.
  static BsPaginationStyle get darkDefaults => BsPaginationStyle(
    padding: defaultPadding,
    fontSize: defaultFontSize,
    color: defaultColor,
    background: defaultDarkBackground,
    borderRadius: defaultBorderRadius,
    borderWidth: defaultBorderWidth,
    borderColor: defaultDarkBorderColor,
    focusColor: defaultColor,
    focusBackground: defaultDarkFocusBackground,
    focusRingColor: defaultFocusRingColor,
    focusRingWidth: defaultFocusRingWidth,
    hoverColor: defaultColor,
    hoverBackground: defaultDarkHoverBackground,
    hoverBorderColor: defaultDarkBorderColor,
    activeColor: defaultActiveColor,
    activeBackground: defaultActiveBackground,
    activeBorderColor: defaultActiveBackground,
    disabledColor: defaultDarkDisabledColor,
    disabledBackground: defaultDarkDisabledBackground,
    disabledBorderColor: defaultDarkBorderColor,
    transitionDuration: defaultTransitionDuration,
  );
}
