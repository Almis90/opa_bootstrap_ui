import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_colors.dart';
import '../bs_variant.dart';
import 'bs_body.dart';
import 'bs_borders.dart';

/// Visual variables of a Bootstrap list group.
///
/// Every field is nullable: null falls back to the matching `default…` constant.
/// [merge] layers overrides on top of [defaults] or, in dark mode, [darkDefaults].
@immutable
class BsListGroupStyle {
  const BsListGroupStyle({
    this.color,
    this.background,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.itemPadding,
    this.hoverBackground,
    this.activeColor,
    this.activeBackground,
    this.activeBorderColor,
    this.disabledColor,
    this.disabledBackground,
    this.actionColor,
    this.actionHoverColor,
    this.actionActiveColor,
    this.actionActiveBackground,
  });

  final Color? color;

  final Color? background;

  final Color? borderColor;

  final double? borderWidth;

  final double? borderRadius;

  final EdgeInsetsGeometry? itemPadding;

  final Color? hoverBackground;

  final Color? activeColor;

  final Color? activeBackground;

  final Color? activeBorderColor;

  final Color? disabledColor;

  final Color? disabledBackground;

  final Color? actionColor;

  final Color? actionHoverColor;

  final Color? actionActiveColor;

  final Color? actionActiveBackground;

  BsListGroupStyle merge(BsListGroupStyle? other) {
    if (other == null) return this;
    return BsListGroupStyle(
      color: other.color ?? color,
      background: other.background ?? background,
      borderColor: other.borderColor ?? borderColor,
      borderWidth: other.borderWidth ?? borderWidth,
      borderRadius: other.borderRadius ?? borderRadius,
      itemPadding: other.itemPadding ?? itemPadding,
      hoverBackground: other.hoverBackground ?? hoverBackground,
      activeColor: other.activeColor ?? activeColor,
      activeBackground: other.activeBackground ?? activeBackground,
      activeBorderColor: other.activeBorderColor ?? activeBorderColor,
      disabledColor: other.disabledColor ?? disabledColor,
      disabledBackground: other.disabledBackground ?? disabledBackground,
      actionColor: other.actionColor ?? actionColor,
      actionHoverColor: other.actionHoverColor ?? actionHoverColor,
      actionActiveColor: other.actionActiveColor ?? actionActiveColor,
      actionActiveBackground: other.actionActiveBackground ?? actionActiveBackground,
    );
  }

  static const Color defaultBackground = BsColors.white;

  static const Color defaultDarkBackground = BsBody.darkBackground;

  static const Color defaultBorderColor = BsBorders.color;

  static const Color defaultDarkBorderColor = BsBorders.darkColor;

  static const double defaultBorderWidth = BsBorders.width;
  static const double defaultBorderRadius = BsBorders.radius;
  static const EdgeInsets defaultItemPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 8);

  static const Color defaultHoverBackground = BsColors.gray100;

  /// Default hover background in dark mode.
  static Color get defaultDarkHoverBackground => BsBody.darkTertiaryBackground;

  static const Color defaultActiveColor = BsColors.white;

  /// Default background of the active item: the primary color, the same in both themes.
  static Color get defaultActiveBackground => BsVariant.primary.color;

  static Color get defaultDisabledBackground => defaultBackground;
  static Color get defaultDarkDisabledBackground => defaultDarkBackground;
  static const Color defaultActionColor = BsColors.gray600;

  static const Color defaultActionHoverColor = BsColors.black;

  static const Color defaultDarkActionHoverColor = BsBody.darkEmphasisColor;

  static const Color defaultActionActiveBackground = BsColors.gray200;

  static const Color defaultDarkActionActiveBackground = BsBody.darkSecondaryBackground;

  static BsListGroupStyle get defaults => BsListGroupStyle(
    background: defaultBackground,
    borderColor: defaultBorderColor,
    borderWidth: defaultBorderWidth,
    borderRadius: defaultBorderRadius,
    itemPadding: defaultItemPadding,
    hoverBackground: defaultHoverBackground,
    activeColor: defaultActiveColor,
    activeBackground: defaultActiveBackground,
    activeBorderColor: defaultActiveBackground,
    disabledBackground: defaultDisabledBackground,
    actionColor: defaultActionColor,
    actionHoverColor: defaultActionHoverColor,
    actionActiveBackground: defaultActionActiveBackground,
  );

  /// Dark-mode counterpart of [defaults]: [background], [borderColor], [hoverBackground],
  /// [disabledBackground], [actionHoverColor] and [actionActiveBackground] are swapped. The rest is
  /// identical.
  /// Use it as the base to [merge] a caller's override when the ambient brightness is dark.
  static BsListGroupStyle get darkDefaults => BsListGroupStyle(
    background: defaultDarkBackground,
    borderColor: defaultDarkBorderColor,
    borderWidth: defaultBorderWidth,
    borderRadius: defaultBorderRadius,
    itemPadding: defaultItemPadding,
    hoverBackground: defaultDarkHoverBackground,
    activeColor: defaultActiveColor,
    activeBackground: defaultActiveBackground,
    activeBorderColor: defaultActiveBackground,
    disabledBackground: defaultDarkDisabledBackground,
    actionColor: defaultActionColor,
    actionHoverColor: defaultDarkActionHoverColor,
    actionActiveBackground: defaultDarkActionActiveBackground,
  );
}
