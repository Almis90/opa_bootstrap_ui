import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_colors.dart';
import '../bs_variant.dart';
import 'bs_body.dart';
import 'bs_borders.dart';

/// A Bootstrap `.list-group`'s visual variables.
///
/// Mirrors the `list-group-variables` group from Bootstrap's SCSS source
/// (`$list-group-*`).
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

  /// `$list-group-color` (`var(--bs-body-color)`).
  final Color? color;

  /// `$list-group-bg` (`var(--bs-body-bg)`).
  final Color? background;

  /// `$list-group-border-color` (`var(--bs-border-color)`).
  final Color? borderColor;

  /// `$list-group-border-width` (`var(--bs-border-width)`).
  final double? borderWidth;

  /// `$list-group-border-radius` (`var(--bs-border-radius)`).
  final double? borderRadius;

  /// `$list-group-item-padding-y`/`$list-group-item-padding-x`.
  final EdgeInsetsGeometry? itemPadding;

  /// `$list-group-hover-bg` (`var(--bs-tertiary-bg)`).
  final Color? hoverBackground;

  /// `$list-group-active-color` (`$component-active-color`).
  final Color? activeColor;

  /// `$list-group-active-bg` (`$component-active-bg`).
  final Color? activeBackground;

  /// `$list-group-active-border-color` (`$list-group-active-bg`).
  final Color? activeBorderColor;

  /// `$list-group-disabled-color` (`var(--bs-secondary-color)`).
  final Color? disabledColor;

  /// `$list-group-disabled-bg` (`$list-group-bg`).
  final Color? disabledBackground;

  /// `$list-group-action-color` (`var(--bs-secondary-color)`).
  final Color? actionColor;

  /// `$list-group-action-hover-color` (`var(--bs-emphasis-color)`).
  final Color? actionHoverColor;

  /// `$list-group-action-active-color` (`var(--bs-body-color)`).
  final Color? actionActiveColor;

  /// `$list-group-action-active-bg` (`var(--bs-secondary-bg)`).
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

  /// [defaultBackground] resolved against `--bs-body-bg` in
  /// `[data-bs-theme="dark"]`.
  static const Color defaultDarkBackground = BsBody.darkBackground;

  static const Color defaultBorderColor = BsBorders.color;

  /// [defaultBorderColor] resolved against `--bs-border-color` in
  /// `[data-bs-theme="dark"]`.
  static const Color defaultDarkBorderColor = BsBorders.darkColor;

  static const double defaultBorderWidth = BsBorders.width;
  static const double defaultBorderRadius = BsBorders.radius;
  static const EdgeInsets defaultItemPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 8);

  /// `$list-group-hover-bg` (`var(--bs-tertiary-bg)`).
  static const Color defaultHoverBackground = BsColors.gray100;

  /// [defaultHoverBackground] resolved against `--bs-tertiary-bg` in
  /// `[data-bs-theme="dark"]`.
  static Color get defaultDarkHoverBackground => BsBody.darkTertiaryBackground;

  /// `$list-group-active-color` (`$component-active-color`, i.e. `$white`
  /// — a literal with no `-dark` override, unchanged in both themes).
  static const Color defaultActiveColor = BsColors.white;

  /// `$list-group-active-bg` (`$component-active-bg`, i.e. `$primary` —
  /// also unchanged in both themes, since `$primary` itself isn't
  /// re-themed).
  static Color get defaultActiveBackground => BsVariant.primary.color;

  static Color get defaultDisabledBackground => defaultBackground;
  static Color get defaultDarkDisabledBackground => defaultDarkBackground;
  static const Color defaultActionColor = BsColors.gray600;

  /// `$list-group-action-hover-color` (`var(--bs-emphasis-color)`).
  static const Color defaultActionHoverColor = BsColors.black;

  /// [defaultActionHoverColor] resolved against `--bs-emphasis-color` in
  /// `[data-bs-theme="dark"]`.
  static const Color defaultDarkActionHoverColor = BsBody.darkEmphasisColor;

  /// `$list-group-action-active-bg` (`var(--bs-secondary-bg)`).
  static const Color defaultActionActiveBackground = BsColors.gray200;

  /// [defaultActionActiveBackground] resolved against `--bs-secondary-bg`
  /// in `[data-bs-theme="dark"]`.
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

  /// [defaults], with [background]/[borderColor]/[hoverBackground]/
  /// [disabledBackground]/[actionHoverColor]/[actionActiveBackground]
  /// swapped for their `[data-bs-theme="dark"]` counterparts. Pick this as
  /// the base to [merge] a caller's [BsListGroupStyle] override against
  /// when `BsTheme.of(context) == Brightness.dark`.
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
