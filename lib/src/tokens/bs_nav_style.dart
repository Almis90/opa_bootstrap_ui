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

  /// Padding of a link.
  final EdgeInsetsGeometry? linkPadding;

  /// Link color.
  final Color? linkColor;

  /// Link hover color.
  final Color? linkHoverColor;

  /// Link disabled color.
  final Color? linkDisabledColor;

  /// Link focus ring color.
  final Color? linkFocusRingColor;

  /// Width of the focus ring drawn in [linkFocusRingColor].
  final double? linkFocusRingWidth;

  /// Tabs border color.
  final Color? tabsBorderColor;

  /// Tabs border width.
  final double? tabsBorderWidth;

  /// Tabs border radius.
  final double? tabsBorderRadius;

  /// Tabs link active color.
  final Color? tabsLinkActiveColor;

  /// Tabs link active background.
  final Color? tabsLinkActiveBackground;

  /// Border color of the active tab, as a single flat color; the bottom edge takes
  /// [tabsLinkActiveBackground].
  final Color? tabsLinkActiveBorderColor;

  /// Tabs link hover border color.
  final Color? tabsLinkHoverBorderColor;

  /// Pills border radius.
  final double? pillsBorderRadius;

  /// Pills link active color.
  final Color? pillsLinkActiveColor;

  /// Pills link active background.
  final Color? pillsLinkActiveBackground;

  /// Underline gap.
  final double? underlineGap;

  /// Underline border width.
  final double? underlineBorderWidth;

  /// Underline link active color.
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

  /// Default link disabled color.
  static const Color defaultLinkDisabledColor = BsColors.gray600;

  /// Default link disabled color in dark mode.
  static const Color defaultDarkLinkDisabledColor = BsBody.darkSecondaryColor;

  /// No `-dark` override exists for the focus ring; it's primary-tinted in
  /// both themes.
  static Color get defaultLinkFocusRingColor => BsFocusRing.color();

  static const double defaultLinkFocusRingWidth = BsFocusRing.width;

  /// Default tabs border color.
  static const Color defaultTabsBorderColor = BsBorders.color;

  /// Default tabs border color in dark mode.
  static const Color defaultDarkTabsBorderColor = BsBorders.darkColor;

  static const double defaultTabsBorderWidth = BsBorders.width;
  static const double defaultTabsBorderRadius = BsBorders.radius;

  /// Default tabs link active color.
  static const Color defaultTabsLinkActiveColor = BsColors.black;

  /// Default tabs link active color in dark mode.
  static const Color defaultDarkTabsLinkActiveColor = BsBody.darkEmphasisColor;

  /// Default tabs link active background.
  static const Color defaultTabsLinkActiveBackground = BsColors.white;

  /// Default tabs link active background in dark mode.
  static const Color defaultDarkTabsLinkActiveBackground = BsBody.darkBackground;

  /// Default tabs link hover border color.
  static const Color defaultTabsLinkHoverBorderColor = BsColors.gray200;

  /// Default tabs link hover border color in dark mode.
  static const Color defaultDarkTabsLinkHoverBorderColor = BsBody.darkSecondaryBackground;

  static const double defaultPillsBorderRadius = BsBorders.radius;

  /// Default pills link active color.
  static const Color defaultPillsLinkActiveColor = BsColors.white;

  /// Default background of the active pill: the primary color, the same in both themes.
  static Color get defaultPillsLinkActiveBackground => BsVariant.primary.color;

  static const double defaultUnderlineGap = 16;
  static const double defaultUnderlineBorderWidth = 2;

  /// Default underline link active color.
  static const Color defaultUnderlineLinkActiveColor = BsColors.black;

  /// Default underline link active color in dark mode.
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
