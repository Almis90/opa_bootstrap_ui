import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_colors.dart';
import 'bs_borders.dart';

/// A Bootstrap `.navbar`'s visual variables, for one color scheme
/// ([light]/[dark] factories mirror `.navbar-light`/`.navbar-dark`).
///
/// Mirrors the `navbar-variables`, `navbar-dark-variables` (and the
/// `.navbar-light` values embedded in the light group) from Bootstrap's
/// SCSS source (`$navbar-*`).
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
    this.color,
    this.hoverColor,
    this.activeColor,
    this.disabledColor,
    this.togglerBorderColor,
    this.brandColor,
    this.brandHoverColor,
  });

  /// `$navbar-padding-y`/`$navbar-padding-x` (`$spacer * .5`/`null`).
  final EdgeInsetsGeometry? padding;

  /// `$navbar-nav-link-padding-x` (`.5rem`).
  final double? navLinkPaddingX;

  /// `$navbar-brand-font-size` (`$font-size-lg`).
  final double? brandFontSize;

  /// `$navbar-brand-margin-end` (`1rem`).
  final double? brandMarginEnd;

  /// `$navbar-toggler-padding-y`/`$navbar-toggler-padding-x` (`.25rem`/`.75rem`).
  final EdgeInsetsGeometry? togglerPadding;

  /// `$navbar-toggler-font-size` (`$font-size-lg`).
  final double? togglerFontSize;

  /// `$navbar-toggler-border-radius` (`$btn-border-radius`).
  final double? togglerBorderRadius;

  /// `$navbar-light-color`/`$navbar-dark-color`.
  final Color? color;

  /// `$navbar-light-hover-color`/`$navbar-dark-hover-color`.
  final Color? hoverColor;

  /// `$navbar-light-active-color`/`$navbar-dark-active-color`.
  final Color? activeColor;

  /// `$navbar-light-disabled-color`/`$navbar-dark-disabled-color`.
  final Color? disabledColor;

  /// `$navbar-light-toggler-border-color`/`$navbar-dark-toggler-border-color`.
  final Color? togglerBorderColor;

  /// `$navbar-light-brand-color`/`$navbar-dark-brand-color` (`activeColor`).
  final Color? brandColor;

  /// `$navbar-light-brand-hover-color`/`$navbar-dark-brand-hover-color`.
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
      color: other.color ?? color,
      hoverColor: other.hoverColor ?? hoverColor,
      activeColor: other.activeColor ?? activeColor,
      disabledColor: other.disabledColor ?? disabledColor,
      togglerBorderColor: other.togglerBorderColor ?? togglerBorderColor,
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

  /// `$navbar-light-color: rgba($emphasis-color-rgb, .65)`, resolved
  /// against `$gray-900`.
  static const Color lightColor = Color(0xA6212529);
  static const Color lightHoverColor = Color(0xCC212529);
  static const Color lightActiveColor = Color(0xFF212529);
  static const Color lightDisabledColor = Color(0x4D212529);
  static const Color lightTogglerBorderColor = Color(0x26212529);

  static const Color darkColor = Color(0x8CFFFFFF);
  static const Color darkHoverColor = Color(0xBFFFFFFF);
  static const Color darkActiveColor = BsColors.white;
  static const Color darkDisabledColor = Color(0x40FFFFFF);
  static const Color darkTogglerBorderColor = Color(0x1AFFFFFF);

  static const BsNavbarStyle _shared = BsNavbarStyle(
    padding: defaultPadding,
    navLinkPaddingX: defaultNavLinkPaddingX,
    brandFontSize: defaultBrandFontSize,
    brandMarginEnd: defaultBrandMarginEnd,
    togglerPadding: defaultTogglerPadding,
    togglerFontSize: defaultTogglerFontSize,
    togglerBorderRadius: defaultTogglerBorderRadius,
  );

  /// `.navbar-light` defaults.
  static BsNavbarStyle get light => _shared.merge(
    const BsNavbarStyle(
      color: lightColor,
      hoverColor: lightHoverColor,
      activeColor: lightActiveColor,
      disabledColor: lightDisabledColor,
      togglerBorderColor: lightTogglerBorderColor,
      brandColor: lightActiveColor,
      brandHoverColor: lightActiveColor,
    ),
  );

  /// `.navbar-dark` defaults.
  static BsNavbarStyle get dark => _shared.merge(
    const BsNavbarStyle(
      color: darkColor,
      hoverColor: darkHoverColor,
      activeColor: darkActiveColor,
      disabledColor: darkDisabledColor,
      togglerBorderColor: darkTogglerBorderColor,
      brandColor: darkActiveColor,
      brandHoverColor: darkActiveColor,
    ),
  );
}
