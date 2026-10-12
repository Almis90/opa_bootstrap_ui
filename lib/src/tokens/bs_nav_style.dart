import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_colors.dart';
import '../bs_variant.dart';
import 'bs_body.dart';
import 'bs_borders.dart';
import 'bs_focus_ring.dart';
import 'bs_link.dart';

/// Visual variables of a Bootstrap nav.
///
/// Every field is nullable: null falls back to the matching `default…` constant.
/// [merge] layers overrides on top of [defaults] or, in dark mode, [darkDefaults].
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

  final EdgeInsetsGeometry? linkPadding;

  final Color? linkColor;

  final Color? linkHoverColor;

  final Color? linkDisabledColor;

  final Color? linkFocusRingColor;

  final double? linkFocusRingWidth;

  final Color? tabsBorderColor;

  final double? tabsBorderWidth;

  final double? tabsBorderRadius;

  final Color? tabsLinkActiveColor;

  final Color? tabsLinkActiveBackground;

  /// Border color of the active tab, as a single flat color; the bottom edge takes
  /// [tabsLinkActiveBackground].
  final Color? tabsLinkActiveBorderColor;

  final Color? tabsLinkHoverBorderColor;

  final double? pillsBorderRadius;

  final Color? pillsLinkActiveColor;

  final Color? pillsLinkActiveBackground;

  final double? underlineGap;

  final double? underlineBorderWidth;

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

  /// Default link color: the primary color.
  static Color get defaultLinkColor => BsVariant.primary.color;

  /// Default link color in dark mode.
  static Color get defaultDarkLinkColor => BsLink.darkColor;

  static Color get defaultLinkHoverColor => BsLink.hoverColor;
  static Color get defaultDarkLinkHoverColor => BsLink.darkHoverColor;

  static const Color defaultLinkDisabledColor = BsColors.gray600;

  static const Color defaultDarkLinkDisabledColor = BsBody.darkSecondaryColor;

  /// No `-dark` override exists for the focus ring; it's primary-tinted in
  /// both themes.
  static Color get defaultLinkFocusRingColor => BsFocusRing.color();

  static const double defaultLinkFocusRingWidth = BsFocusRing.width;

  static const Color defaultTabsBorderColor = BsBorders.color;

  static const Color defaultDarkTabsBorderColor = BsBorders.darkColor;

  static const double defaultTabsBorderWidth = BsBorders.width;
  static const double defaultTabsBorderRadius = BsBorders.radius;

  static const Color defaultTabsLinkActiveColor = BsColors.black;

  static const Color defaultDarkTabsLinkActiveColor = BsBody.darkEmphasisColor;

  static const Color defaultTabsLinkActiveBackground = BsColors.white;

  static const Color defaultDarkTabsLinkActiveBackground = BsBody.darkBackground;

  static const Color defaultTabsLinkHoverBorderColor = BsColors.gray200;

  static const Color defaultDarkTabsLinkHoverBorderColor = BsBody.darkSecondaryBackground;

  static const double defaultPillsBorderRadius = BsBorders.radius;

  static const Color defaultPillsLinkActiveColor = BsColors.white;

  /// Default background of the active pill: the primary color, the same in both themes.
  static Color get defaultPillsLinkActiveBackground => BsVariant.primary.color;

  static const double defaultUnderlineGap = 16;
  static const double defaultUnderlineBorderWidth = 2;

  static const Color defaultUnderlineLinkActiveColor = BsColors.black;

  static const Color defaultDarkUnderlineLinkActiveColor = BsBody.darkEmphasisColor;

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

  /// Dark-mode counterpart of [defaults]: every brightness-sensitive field is swapped. The rest is
  /// identical.
  /// Use it as the base to [merge] a caller's override when the ambient brightness is dark.
  static BsNavStyle get darkDefaults => BsNavStyle(
    linkPadding: defaultLinkPadding,
    linkColor: defaultDarkLinkColor,
    linkHoverColor: defaultDarkLinkHoverColor,
    linkDisabledColor: defaultDarkLinkDisabledColor,
    linkFocusRingColor: defaultLinkFocusRingColor,
    linkFocusRingWidth: defaultLinkFocusRingWidth,
    tabsBorderColor: defaultDarkTabsBorderColor,
    tabsBorderWidth: defaultTabsBorderWidth,
    tabsBorderRadius: defaultTabsBorderRadius,
    tabsLinkActiveColor: defaultDarkTabsLinkActiveColor,
    tabsLinkActiveBackground: defaultDarkTabsLinkActiveBackground,
    tabsLinkActiveBorderColor: defaultDarkTabsBorderColor,
    tabsLinkHoverBorderColor: defaultDarkTabsLinkHoverBorderColor,
    pillsBorderRadius: defaultPillsBorderRadius,
    pillsLinkActiveColor: defaultPillsLinkActiveColor,
    pillsLinkActiveBackground: defaultPillsLinkActiveBackground,
    underlineGap: defaultUnderlineGap,
    underlineBorderWidth: defaultUnderlineBorderWidth,
    underlineLinkActiveColor: defaultDarkUnderlineLinkActiveColor,
  );
}
