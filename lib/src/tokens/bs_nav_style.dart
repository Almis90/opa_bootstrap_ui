import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_colors.dart';
import '../bs_variant.dart';
import 'bs_borders.dart';
import 'bs_focus_ring.dart';
import 'bs_link.dart';

/// A Bootstrap `.nav`'s visual variables (plain nav, tabs, pills, and
/// underline variants).
///
/// Mirrors the `nav-variables` group from Bootstrap's SCSS source
/// (`$nav-*`).
@immutable
class BsNavStyle {
  const BsNavStyle({
    this.linkPadding,
    this.linkColor,
    this.linkHoverColor,
    this.linkDisabledColor,
    this.linkFocusRingColor,
    this.linkFocusRingWidth,
    this.tabsBorderColor,
    this.tabsBorderWidth,
    this.tabsBorderRadius,
    this.tabsLinkActiveColor,
    this.tabsLinkActiveBackground,
    this.tabsLinkActiveBorderColor,
    this.tabsLinkHoverBorderColor,
    this.pillsBorderRadius,
    this.pillsLinkActiveColor,
    this.pillsLinkActiveBackground,
    this.underlineGap,
    this.underlineBorderWidth,
    this.underlineLinkActiveColor,
  });

  /// `$nav-link-padding-y`/`$nav-link-padding-x` (`.5rem`/`1rem`).
  final EdgeInsetsGeometry? linkPadding;

  /// `$nav-link-color` (`var(--bs-link-color)`).
  final Color? linkColor;

  /// `$nav-link-hover-color` (`var(--bs-link-hover-color)`).
  final Color? linkHoverColor;

  /// `$nav-link-disabled-color` (`var(--bs-secondary-color)`).
  final Color? linkDisabledColor;

  /// `$nav-link-focus-box-shadow` (a focus ring, tinted by [linkFocusRingColor]).
  final Color? linkFocusRingColor;

  /// The width of [linkFocusRingColor]'s ring, per `$focus-ring-width`
  /// (`.25rem`, i.e. `4` at the default `16px` root font size).
  final double? linkFocusRingWidth;

  /// `$nav-tabs-border-color` (`var(--bs-border-color)`).
  final Color? tabsBorderColor;

  /// `$nav-tabs-border-width` (`var(--bs-border-width)`).
  final double? tabsBorderWidth;

  /// `$nav-tabs-border-radius` (`var(--bs-border-radius)`).
  final double? tabsBorderRadius;

  /// `$nav-tabs-link-active-color` (`var(--bs-emphasis-color)`).
  final Color? tabsLinkActiveColor;

  /// `$nav-tabs-link-active-bg` (`var(--bs-body-bg)`).
  final Color? tabsLinkActiveBackground;

  /// `$nav-tabs-link-active-border-color`, resolved to a flat border color
  /// (the sides use `$nav-tabs-link-active-bg`, the bottom uses
  /// [tabsLinkActiveBackground]).
  final Color? tabsLinkActiveBorderColor;

  /// `$nav-tabs-link-hover-border-color` (`var(--bs-secondary-bg) var(--bs-secondary-bg) $nav-tabs-border-color`),
  /// resolved to a flat border color for the non-active hover state (see
  /// [tabsLinkActiveBorderColor] for why this collapses a 3-value shorthand).
  final Color? tabsLinkHoverBorderColor;

  /// `$nav-pills-border-radius` (`var(--bs-border-radius)`).
  final double? pillsBorderRadius;

  /// `$nav-pills-link-active-color` (`$component-active-color`).
  final Color? pillsLinkActiveColor;

  /// `$nav-pills-link-active-bg` (`$component-active-bg`).
  final Color? pillsLinkActiveBackground;

  /// `$nav-underline-gap` (`1rem`).
  final double? underlineGap;

  /// `$nav-underline-border-width` (`.125rem`).
  final double? underlineBorderWidth;

  /// `$nav-underline-link-active-color` (`var(--bs-emphasis-color)`).
  final Color? underlineLinkActiveColor;

  BsNavStyle merge(BsNavStyle? other) {
    if (other == null) return this;
    return BsNavStyle(
      linkPadding: other.linkPadding ?? linkPadding,
      linkColor: other.linkColor ?? linkColor,
      linkHoverColor: other.linkHoverColor ?? linkHoverColor,
      linkDisabledColor: other.linkDisabledColor ?? linkDisabledColor,
      linkFocusRingColor: other.linkFocusRingColor ?? linkFocusRingColor,
      linkFocusRingWidth: other.linkFocusRingWidth ?? linkFocusRingWidth,
      tabsBorderColor: other.tabsBorderColor ?? tabsBorderColor,
      tabsBorderWidth: other.tabsBorderWidth ?? tabsBorderWidth,
      tabsBorderRadius: other.tabsBorderRadius ?? tabsBorderRadius,
      tabsLinkActiveColor: other.tabsLinkActiveColor ?? tabsLinkActiveColor,
      tabsLinkActiveBackground: other.tabsLinkActiveBackground ?? tabsLinkActiveBackground,
      tabsLinkActiveBorderColor: other.tabsLinkActiveBorderColor ?? tabsLinkActiveBorderColor,
      tabsLinkHoverBorderColor: other.tabsLinkHoverBorderColor ?? tabsLinkHoverBorderColor,
      pillsBorderRadius: other.pillsBorderRadius ?? pillsBorderRadius,
      pillsLinkActiveColor: other.pillsLinkActiveColor ?? pillsLinkActiveColor,
      pillsLinkActiveBackground: other.pillsLinkActiveBackground ?? pillsLinkActiveBackground,
      underlineGap: other.underlineGap ?? underlineGap,
      underlineBorderWidth: other.underlineBorderWidth ?? underlineBorderWidth,
      underlineLinkActiveColor: other.underlineLinkActiveColor ?? underlineLinkActiveColor,
    );
  }

  static const EdgeInsets defaultLinkPadding = EdgeInsets.symmetric(horizontal: 16, vertical: 8);
  static Color get defaultLinkColor => BsVariant.primary.color;
  static Color get defaultLinkHoverColor => BsLink.hoverColor;
  static const Color defaultLinkDisabledColor = BsColors.gray600;
  static Color get defaultLinkFocusRingColor => BsFocusRing.color();
  static const double defaultLinkFocusRingWidth = BsFocusRing.width;
  static const Color defaultTabsBorderColor = BsBorders.color;
  static const double defaultTabsBorderWidth = BsBorders.width;
  static const double defaultTabsBorderRadius = BsBorders.radius;
  static const Color defaultTabsLinkActiveColor = BsColors.black;
  static const Color defaultTabsLinkActiveBackground = BsColors.white;
  static const Color defaultTabsLinkHoverBorderColor = BsColors.gray200;
  static const double defaultPillsBorderRadius = BsBorders.radius;
  static const Color defaultPillsLinkActiveColor = BsColors.white;
  static Color get defaultPillsLinkActiveBackground => BsVariant.primary.color;
  static const double defaultUnderlineGap = 16;
  static const double defaultUnderlineBorderWidth = 2;
  static const Color defaultUnderlineLinkActiveColor = BsColors.black;

  static BsNavStyle get defaults => BsNavStyle(
    linkPadding: defaultLinkPadding,
    linkColor: defaultLinkColor,
    linkHoverColor: defaultLinkHoverColor,
    linkDisabledColor: defaultLinkDisabledColor,
    linkFocusRingColor: defaultLinkFocusRingColor,
    linkFocusRingWidth: defaultLinkFocusRingWidth,
    tabsBorderColor: defaultTabsBorderColor,
    tabsBorderWidth: defaultTabsBorderWidth,
    tabsBorderRadius: defaultTabsBorderRadius,
    tabsLinkActiveColor: defaultTabsLinkActiveColor,
    tabsLinkActiveBackground: defaultTabsLinkActiveBackground,
    tabsLinkActiveBorderColor: defaultTabsBorderColor,
    tabsLinkHoverBorderColor: defaultTabsLinkHoverBorderColor,
    pillsBorderRadius: defaultPillsBorderRadius,
    pillsLinkActiveColor: defaultPillsLinkActiveColor,
    pillsLinkActiveBackground: defaultPillsLinkActiveBackground,
    underlineGap: defaultUnderlineGap,
    underlineBorderWidth: defaultUnderlineBorderWidth,
    underlineLinkActiveColor: defaultUnderlineLinkActiveColor,
  );
}
