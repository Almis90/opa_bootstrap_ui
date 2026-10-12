import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_colors.dart';
import 'bs_borders.dart';
import 'bs_focus_ring.dart';

/// Visual variables of a Bootstrap navbar.
///
/// Every field is nullable: null falls back to the matching `default…` constant.
/// [merge] layers overrides on top of [defaults] or, in dark mode, [darkDefaults].
@immutable
class BsNavbarStyle {
  const BsNavbarStyle({
    this.padding,
    this.navLinkPaddingX,
    this.brandFontSize,
    this.brandMarginEnd,
    this.togglerPadding,
    this.togglerFontSize,
    this.togglerBorderRadius,
    this.togglerFocusRingWidth,
    this.togglerFocusRingColor,
    this.togglerTransitionDuration,
    this.color,
    this.hoverColor,
    this.activeColor,
    this.disabledColor,
    this.togglerBorderColor,
    this.iconColor,
    this.brandColor,
    this.brandHoverColor,
  });

  /// Padding of the navbar.
  final EdgeInsetsGeometry? padding;

  /// Nav link padding x.
  final double? navLinkPaddingX;

  /// Brand font size.
  final double? brandFontSize;

  /// Brand margin end.
  final double? brandMarginEnd;

  /// Padding of the toggler button.
  final EdgeInsetsGeometry? togglerPadding;

  /// Toggler font size.
  final double? togglerFontSize;

  /// Toggler border radius.
  final double? togglerBorderRadius;

  /// Spread of the toggler's focus ring.
  final double? togglerFocusRingWidth;

  /// Color of the toggler's focus ring.
  final Color? togglerFocusRingColor;

  /// Toggler transition duration.
  final Duration? togglerTransitionDuration;

  /// Color of the nav links.
  final Color? color;

  /// Color of a nav link under the pointer.
  final Color? hoverColor;

  /// Color of the active nav link.
  final Color? activeColor;

  /// Color of a disabled nav link.
  final Color? disabledColor;

  /// Border color of the toggler button.
  final Color? togglerBorderColor;

  /// Color of the toggler's menu icon, independent of [color], which tints the nav links.
  final Color? iconColor;

  /// Color of the brand.
  final Color? brandColor;

  /// Color of the brand under the pointer.
  final Color? brandHoverColor;

  BsNavbarStyle merge(BsNavbarStyle? other) {
    if (other == null) return this;
    return BsNavbarStyle(
      padding: other.padding ?? padding,
      navLinkPaddingX: other.navLinkPaddingX ?? navLinkPaddingX,
      brandFontSize: other.brandFontSize ?? brandFontSize,
      brandMarginEnd: other.brandMarginEnd ?? brandMarginEnd,
      togglerPadding: other.togglerPadding ?? togglerPadding,
      togglerFontSize: other.togglerFontSize ?? togglerFontSize,
      togglerBorderRadius: other.togglerBorderRadius ?? togglerBorderRadius,
      togglerFocusRingWidth: other.togglerFocusRingWidth ?? togglerFocusRingWidth,
      togglerFocusRingColor: other.togglerFocusRingColor ?? togglerFocusRingColor,
      togglerTransitionDuration: other.togglerTransitionDuration ?? togglerTransitionDuration,
      color: other.color ?? color,
      hoverColor: other.hoverColor ?? hoverColor,
      activeColor: other.activeColor ?? activeColor,
      disabledColor: other.disabledColor ?? disabledColor,
      togglerBorderColor: other.togglerBorderColor ?? togglerBorderColor,
      iconColor: other.iconColor ?? iconColor,
      brandColor: other.brandColor ?? brandColor,
      brandHoverColor: other.brandHoverColor ?? brandHoverColor,
    );
  }

  static const EdgeInsets defaultPadding = EdgeInsets.symmetric(vertical: 8);
  static const double defaultNavLinkPaddingX = 8;
  static const double defaultBrandFontSize = 20;
  static const double defaultBrandMarginEnd = 16;
  static const EdgeInsets defaultTogglerPadding = EdgeInsets.symmetric(horizontal: 12, vertical: 4);
  static const double defaultTogglerFontSize = 20;
  static const double defaultTogglerBorderRadius = BsBorders.radius;

  /// Default toggler focus ring width.
  static const double defaultTogglerFocusRingWidth = BsFocusRing.width;

  /// Default toggler transition duration.
  static const Duration defaultTogglerTransitionDuration = Duration(milliseconds: 150);

  /// Light color.
  static const Color lightColor = Color(0xA6212529);
  static const Color lightHoverColor = Color(0xCC212529);
  static const Color lightActiveColor = Color(0xFF212529);
  static const Color lightDisabledColor = Color(0x4D212529);
  static const Color lightTogglerBorderColor = Color(0x26212529);

  /// Default color of the toggler icon on a light navbar: the default text color at 75% opacity.
  static const Color lightIconColor = Color(0xBF212529);

  static const Color darkColor = Color(0x8CFFFFFF);
  static const Color darkHoverColor = Color(0xBFFFFFFF);
  static const Color darkActiveColor = BsColors.white;
  static const Color darkDisabledColor = Color(0x40FFFFFF);
  static const Color darkTogglerBorderColor = Color(0x1AFFFFFF);

  /// Icon color.
  static const Color darkIconColor = darkColor;

  static BsNavbarStyle get _shared => BsNavbarStyle(
    padding: defaultPadding,
    navLinkPaddingX: defaultNavLinkPaddingX,
    brandFontSize: defaultBrandFontSize,
    brandMarginEnd: defaultBrandMarginEnd,
    togglerPadding: defaultTogglerPadding,
    togglerFontSize: defaultTogglerFontSize,
    togglerBorderRadius: defaultTogglerBorderRadius,
    togglerFocusRingWidth: defaultTogglerFocusRingWidth,
    togglerFocusRingColor: BsFocusRing.color(),
    togglerTransitionDuration: defaultTogglerTransitionDuration,
  );

  /// Defaults of a navbar on a light background.
  static BsNavbarStyle get light => _shared.merge(
    const BsNavbarStyle(
      color: lightColor,
      hoverColor: lightHoverColor,
      activeColor: lightActiveColor,
      disabledColor: lightDisabledColor,
      togglerBorderColor: lightTogglerBorderColor,
      iconColor: lightIconColor,
      brandColor: lightActiveColor,
      brandHoverColor: lightActiveColor,
    ),
  );

  /// Defaults of a navbar on a dark background.
  static BsNavbarStyle get dark => _shared.merge(
    const BsNavbarStyle(
      color: darkColor,
      hoverColor: darkHoverColor,
      activeColor: darkActiveColor,
      disabledColor: darkDisabledColor,
      togglerBorderColor: darkTogglerBorderColor,
      iconColor: darkIconColor,
      brandColor: darkActiveColor,
      brandHoverColor: darkActiveColor,
    ),
  );
}
