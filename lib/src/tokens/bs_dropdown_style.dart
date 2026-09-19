import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_colors.dart';
import '../bs_variant.dart';
import 'bs_borders.dart';
import 'bs_shadows.dart';

/// A Bootstrap `.dropdown-menu`'s visual variables.
///
/// Mirrors the `dropdown-variables` and `dropdown-dark-variables` groups
/// from Bootstrap's SCSS source (`$dropdown-*`).
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
    this.linkHoverBackground,
    this.linkActiveColor,
    this.linkActiveBackground,
    this.linkDisabledColor,
    this.itemPadding,
    this.headerColor,
    this.headerPadding,
  });

  /// `$dropdown-min-width` (`10rem`).
  final double? minWidth;

  /// `$dropdown-padding-y`/`$dropdown-padding-x` (`.5rem`/`0`).
  final EdgeInsetsGeometry? padding;

  /// `$dropdown-spacer` (`.125rem`), the gap between the toggle and the menu.
  final double? spacer;

  /// `$dropdown-font-size` (`$font-size-base`).
  final double? fontSize;

  /// `$dropdown-color` (`var(--bs-body-color)`).
  final Color? color;

  /// `$dropdown-bg` (`var(--bs-body-bg)`).
  final Color? background;

  /// `$dropdown-border-color` (`var(--bs-border-color-translucent)`).
  final Color? borderColor;

  /// `$dropdown-border-radius` (`var(--bs-border-radius)`).
  final double? borderRadius;

  /// `$dropdown-border-width` (`var(--bs-border-width)`).
  final double? borderWidth;

  /// `$dropdown-divider-bg` (`$dropdown-border-color`).
  final Color? dividerColor;

  /// `$dropdown-divider-margin-y` (`$spacer * .5`).
  final double? dividerMarginY;

  /// `$dropdown-box-shadow` (`var(--bs-box-shadow)`).
  final List<BoxShadow>? boxShadow;

  /// `$dropdown-link-color` (`var(--bs-body-color)`).
  final Color? linkColor;

  /// `$dropdown-link-hover-bg` (`var(--bs-tertiary-bg)`).
  final Color? linkHoverBackground;

  /// `$dropdown-link-active-color` (`$component-active-color`).
  final Color? linkActiveColor;

  /// `$dropdown-link-active-bg` (`$component-active-bg`).
  final Color? linkActiveBackground;

  /// `$dropdown-link-disabled-color` (`var(--bs-tertiary-color)`).
  final Color? linkDisabledColor;

  /// `$dropdown-item-padding-y`/`$dropdown-item-padding-x` (`.25rem`/`1rem`).
  final EdgeInsetsGeometry? itemPadding;

  /// `$dropdown-header-color` (`$gray-600`).
  final Color? headerColor;

  /// `$dropdown-header-padding-y`/`$dropdown-header-padding-x`.
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
      linkHoverBackground: other.linkHoverBackground ?? linkHoverBackground,
      linkActiveColor: other.linkActiveColor ?? linkActiveColor,
      linkActiveBackground: other.linkActiveBackground ?? linkActiveBackground,
      linkDisabledColor: other.linkDisabledColor ?? linkDisabledColor,
      itemPadding: other.itemPadding ?? itemPadding,
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
  static const EdgeInsets defaultItemPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 4);
  static const Color defaultHeaderColor = BsColors.gray600;
  static const EdgeInsets defaultHeaderPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 8);

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
    boxShadow: defaultBoxShadow,
    linkColor: defaultColor,
    linkHoverBackground: defaultLinkHoverBackground,
    linkActiveColor: defaultLinkActiveColor,
    linkActiveBackground: defaultLinkActiveBackground,
    linkDisabledColor: defaultLinkDisabledColor,
    itemPadding: defaultItemPadding,
    headerColor: defaultHeaderColor,
    headerPadding: defaultHeaderPadding,
  );

  /// `dropdown-dark-variables`: the palette for `.dropdown-menu-dark`.
  static BsDropdownStyle get dark => BsDropdownStyle(
    color: BsColors.gray300,
    background: BsColors.gray800,
    borderColor: defaultBorderColor,
    linkColor: BsColors.gray300,
    linkHoverBackground: const Color(0x26FFFFFF),
    linkActiveColor: defaultLinkActiveColor,
    linkActiveBackground: defaultLinkActiveBackground,
    linkDisabledColor: BsColors.gray500,
    headerColor: BsColors.gray500,
  );
}
