import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_colors.dart';
import '../bs_variant.dart';
import 'bs_body.dart';
import 'bs_borders.dart';
import 'bs_shadows.dart';

/// Visual variables of a Bootstrap dropdown.
///
/// Every field is nullable: null falls back to the matching `default…` constant.
/// [merge] layers overrides on top of [defaults] or, in dark mode, [darkDefaults].
@immutable
class BsDropdownStyle {
  const BsDropdownStyle({
    this.minWidth,
    this.padding,
    this.spacer,
    this.fontSize,
    this.color,
    this.background,
    this.borderColor,
    this.borderRadius,
    this.borderWidth,
    this.dividerColor,
    this.dividerMarginY,
    this.boxShadow,
    this.linkColor,
    this.linkHoverColor,
    this.linkHoverBackground,
    this.linkActiveColor,
    this.linkActiveBackground,
    this.linkDisabledColor,
    this.itemPadding,
    this.itemBorderRadius,
    this.itemSpacing,
    this.headerColor,
    this.headerPadding,
  });

  /// Minimum width.
  final double? minWidth;

  /// Padding of the menu.
  final EdgeInsetsGeometry? padding;

  /// Gap between the toggle and the menu.
  final double? spacer;

  /// Font size.
  final double? fontSize;

  /// Text color.
  final Color? color;

  /// Background color.
  final Color? background;

  /// Border color.
  final Color? borderColor;

  /// Corner radius.
  final double? borderRadius;

  /// Border width.
  final double? borderWidth;

  /// Divider color.
  final Color? dividerColor;

  /// Divider margin y.
  final double? dividerMarginY;

  /// Drop shadow of the menu. Null by default (no shadow); pass [defaultBoxShadow] to opt in.
  final List<BoxShadow>? boxShadow;

  /// Link color.
  final Color? linkColor;

  /// Link hover color.
  final Color? linkHoverColor;

  /// Link hover background.
  final Color? linkHoverBackground;

  /// Link active color.
  final Color? linkActiveColor;

  /// Link active background.
  final Color? linkActiveBackground;

  /// Link disabled color.
  final Color? linkDisabledColor;

  /// Padding of an item.
  final EdgeInsetsGeometry? itemPadding;

  /// Corner radius of an item's hover and active background. Square by default.
  final double? itemBorderRadius;

  /// Gap between consecutive entries; none by default.
  final double? itemSpacing;

  /// Header color.
  final Color? headerColor;

  /// Padding of a header.
  final EdgeInsetsGeometry? headerPadding;

  BsDropdownStyle merge(BsDropdownStyle? other) {
    if (other == null) return this;
    return BsDropdownStyle(
      minWidth: other.minWidth ?? minWidth,
      padding: other.padding ?? padding,
      spacer: other.spacer ?? spacer,
      fontSize: other.fontSize ?? fontSize,
      color: other.color ?? color,
      background: other.background ?? background,
      borderColor: other.borderColor ?? borderColor,
      borderRadius: other.borderRadius ?? borderRadius,
      borderWidth: other.borderWidth ?? borderWidth,
      dividerColor: other.dividerColor ?? dividerColor,
      dividerMarginY: other.dividerMarginY ?? dividerMarginY,
      boxShadow: other.boxShadow ?? boxShadow,
      linkColor: other.linkColor ?? linkColor,
      linkHoverColor: other.linkHoverColor ?? linkHoverColor,
      linkHoverBackground: other.linkHoverBackground ?? linkHoverBackground,
      linkActiveColor: other.linkActiveColor ?? linkActiveColor,
      linkActiveBackground: other.linkActiveBackground ?? linkActiveBackground,
      linkDisabledColor: other.linkDisabledColor ?? linkDisabledColor,
      itemPadding: other.itemPadding ?? itemPadding,
      itemBorderRadius: other.itemBorderRadius ?? itemBorderRadius,
      itemSpacing: other.itemSpacing ?? itemSpacing,
      headerColor: other.headerColor ?? headerColor,
      headerPadding: other.headerPadding ?? headerPadding,
    );
  }

  static const double defaultMinWidth = 160;
  static const EdgeInsets defaultPadding = EdgeInsets.symmetric(vertical: 8);
  static const double defaultSpacer = 2;
  static const double defaultFontSize = 16;
  static const Color defaultColor = BsColors.gray900;
  static const Color defaultBackground = BsColors.white;
  static const Color defaultBorderColor = BsBorders.colorTranslucent;
  static const double defaultBorderRadius = BsBorders.radius;
  static const double defaultBorderWidth = BsBorders.width;
  static const double defaultDividerMarginY = 8;
  static const List<BoxShadow> defaultBoxShadow = BsShadows.shadow;
  static const Color defaultLinkHoverBackground = BsColors.gray100;
  static const Color defaultLinkActiveColor = BsColors.white;
  static Color get defaultLinkActiveBackground => BsVariant.primary.color;
  static const Color defaultLinkDisabledColor = BsColors.gray400;
  static const EdgeInsets defaultItemPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 4,
  );
  static const Color defaultHeaderColor = BsColors.gray600;
  static const EdgeInsets defaultHeaderPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 8,
  );

  static BsDropdownStyle get defaults => BsDropdownStyle(
    minWidth: defaultMinWidth,
    padding: defaultPadding,
    spacer: defaultSpacer,
    fontSize: defaultFontSize,
    color: defaultColor,
    background: defaultBackground,
    borderColor: defaultBorderColor,
    borderRadius: defaultBorderRadius,
    borderWidth: defaultBorderWidth,
    dividerColor: defaultBorderColor,
    dividerMarginY: defaultDividerMarginY,
    linkColor: defaultColor,
    linkHoverColor: defaultColor,
    linkHoverBackground: defaultLinkHoverBackground,
    linkActiveColor: defaultLinkActiveColor,
    linkActiveBackground: defaultLinkActiveBackground,
    linkDisabledColor: defaultLinkDisabledColor,
    itemPadding: defaultItemPadding,
    headerColor: defaultHeaderColor,
    headerPadding: defaultHeaderPadding,
  );

  /// Dark-mode counterpart of [defaults], for a dropdown that follows the ambient theme.
  /// Not the same as [dark], which is a separate palette for a menu that should be dark
  /// regardless of the page's theme. Use this as the base to [merge] a caller's override
  /// when the ambient brightness is dark.
  static BsDropdownStyle get darkDefaults => BsDropdownStyle(
    minWidth: defaultMinWidth,
    padding: defaultPadding,
    spacer: defaultSpacer,
    fontSize: defaultFontSize,
    color: BsBody.darkColor,
    background: BsBody.darkBackground,
    borderColor: BsBorders.darkColorTranslucent,
    borderRadius: defaultBorderRadius,
    borderWidth: defaultBorderWidth,
    dividerColor: BsBorders.darkColorTranslucent,
    dividerMarginY: defaultDividerMarginY,
    linkColor: BsBody.darkColor,
    linkHoverColor: BsBody.darkColor,
    linkHoverBackground: BsBody.darkTertiaryBackground,
    linkActiveColor: defaultLinkActiveColor,
    linkActiveBackground: defaultLinkActiveBackground,
    linkDisabledColor: BsBody.darkTertiaryColor,
    itemPadding: defaultItemPadding,
    headerColor: defaultHeaderColor,
    headerPadding: defaultHeaderPadding,
  );

  /// Palette of a menu that is dark regardless of the page's theme.
  static BsDropdownStyle get dark => BsDropdownStyle(
    color: BsColors.gray300,
    background: BsColors.gray800,
    borderColor: defaultBorderColor,
    linkColor: BsColors.gray300,
    linkHoverColor: BsColors.white,
    linkHoverBackground: const Color(0x26FFFFFF),
    linkActiveColor: defaultLinkActiveColor,
    linkActiveBackground: defaultLinkActiveBackground,
    linkDisabledColor: BsColors.gray500,
    headerColor: BsColors.gray500,
  );
}
