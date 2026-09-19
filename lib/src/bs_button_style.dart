import 'package:flutter/widgets.dart';

import 'bs_color_utils.dart';
import 'bs_size.dart';
import 'bs_variant.dart';

/// A Bootstrap button's visual "variables", mirroring the CSS custom
/// properties Bootstrap sets on `.btn` (`--bs-btn-bg`, `--bs-btn-hover-bg`,
/// `--bs-btn-padding-x`, etc). Every field is nullable so a [BsButtonStyle]
/// can represent a partial override, the same way a custom `.btn-*` class
/// in Bootstrap only reassigns the variables it cares about and inherits
/// the rest from `.btn`/`.btn-primary`/etc.
///
/// See Bootstrap's `button-variant()`, `button-outline-variant()` and
/// `button-size()` Sass mixins, which this class's factories replicate.
@immutable
class BsButtonStyle {
  const BsButtonStyle({
    this.color,
    this.background,
    this.borderColor,
    this.hoverColor,
    this.hoverBackground,
    this.hoverBorderColor,
    this.activeColor,
    this.activeBackground,
    this.activeBorderColor,
    this.padding,
    this.textStyle,
    this.borderRadius,
    this.borderWidth,
    this.disabledOpacity,
    this.boxShadow,
    this.activeShadow,
    this.focusRingColor,
    this.focusRingWidth,
    this.transitionDuration,
    this.transitionCurve,
  });

  // scss-docs-start btn-variables (color/bg/border trio, per state)
  final Color? color;
  final Color? background;
  final Color? borderColor;

  final Color? hoverColor;
  final Color? hoverBackground;
  final Color? hoverBorderColor;

  final Color? activeColor;
  final Color? activeBackground;
  final Color? activeBorderColor;
  // scss-docs-end btn-variables

  /// The button's padding, per `--bs-btn-padding-x`/`--bs-btn-padding-y`.
  final EdgeInsetsGeometry? padding;

  /// Typographic properties, per `--bs-btn-font-family`,
  /// `--bs-btn-font-size`, `--bs-btn-font-weight` and `--bs-btn-line-height`.
  /// Deliberately excludes [Color] — the button's text color is always
  /// state-dependent (see [color]/[hoverColor]/[activeColor]), so any color
  /// set here is overridden when the button is painted.
  final TextStyle? textStyle;

  /// The button's corner rounding, per `--bs-btn-border-radius`. Usually
  /// uniform ([BorderRadius.circular]), but [BsButtonGroup] overrides this
  /// per-corner to square off the sides shared with a neighboring button.
  final BorderRadiusGeometry? borderRadius;

  final double? borderWidth;

  /// Opacity applied to the whole button when disabled, per
  /// `$btn-disabled-opacity`.
  final double? disabledOpacity;

  /// The button's resting shadow, per `$btn-box-shadow`: a subtle top
  /// highlight and bottom shading, using [BoxShadow.blurStyle] `inner` to
  /// replicate Bootstrap's `inset` shadows.
  final List<BoxShadow>? boxShadow;

  /// Replaces [boxShadow] while the button is pressed, per
  /// `$btn-active-box-shadow`.
  final List<BoxShadow>? activeShadow;

  /// The color of the ring shown around a focused button, per
  /// `--bs-btn-focus-shadow-rgb`. Defaults to a mix of [color] and
  /// [borderColor] when unset.
  final Color? focusRingColor;

  /// The width of the focus ring, per `$btn-focus-width` (`.25rem`, i.e.
  /// `4` at the default `16px` root font size).
  final double? focusRingWidth;

  /// The duration of color/shadow transitions, per `$btn-transition`.
  final Duration? transitionDuration;

  /// The curve of color/shadow transitions, approximating the `ease-in-out`
  /// CSS timing function in `$btn-transition`.
  final Curve? transitionCurve;

  /// Layers [other]'s non-null fields over this style's, the same way a
  /// custom `.btn-*` class reassigns only the CSS variables it needs and
  /// leaves the rest inherited.
  BsButtonStyle merge(BsButtonStyle? other) {
    if (other == null) return this;
    return BsButtonStyle(
      color: other.color ?? color,
      background: other.background ?? background,
      borderColor: other.borderColor ?? borderColor,
      hoverColor: other.hoverColor ?? hoverColor,
      hoverBackground: other.hoverBackground ?? hoverBackground,
      hoverBorderColor: other.hoverBorderColor ?? hoverBorderColor,
      activeColor: other.activeColor ?? activeColor,
      activeBackground: other.activeBackground ?? activeBackground,
      activeBorderColor: other.activeBorderColor ?? activeBorderColor,
      padding: other.padding ?? padding,
      textStyle: textStyle?.merge(other.textStyle) ?? other.textStyle,
      borderRadius: other.borderRadius ?? borderRadius,
      borderWidth: other.borderWidth ?? borderWidth,
      disabledOpacity: other.disabledOpacity ?? disabledOpacity,
      boxShadow: other.boxShadow ?? boxShadow,
      activeShadow: other.activeShadow ?? activeShadow,
      focusRingColor: other.focusRingColor ?? focusRingColor,
      focusRingWidth: other.focusRingWidth ?? focusRingWidth,
      transitionDuration: other.transitionDuration ?? transitionDuration,
      transitionCurve: other.transitionCurve ?? transitionCurve,
    );
  }

  /// The button's default resting shadow, per `$btn-box-shadow: inset 0 1px
  /// 0 rgba($white, .15), 0 1px 1px rgba($black, .075)`.
  static const List<BoxShadow> defaultBoxShadow = [
    BoxShadow(color: Color(0x26FFFFFF), offset: Offset(0, 1), blurStyle: BlurStyle.inner),
    BoxShadow(color: Color(0x13000000), offset: Offset(0, 1), blurRadius: 1),
  ];

  /// The button's pressed-state shadow, per `$btn-active-box-shadow: inset
  /// 0 3px 5px rgba($black, .125)`.
  static const List<BoxShadow> defaultActiveShadow = [
    BoxShadow(color: Color(0x20000000), offset: Offset(0, 3), blurRadius: 5, blurStyle: BlurStyle.inner),
  ];

  /// The default `.btn` typography, per `$btn-font-weight`/`$btn-line-height`.
  static const TextStyle defaultTextStyle = TextStyle(fontWeight: FontWeight.normal, height: 1.5);

  /// `$btn-border-width` / `$border-width` (assuming the default `16px` root
  /// font size).
  static const double defaultBorderWidth = 1;

  /// `$btn-disabled-opacity`.
  static const double defaultDisabledOpacity = 0.65;

  /// `$btn-focus-width` / `$focus-ring-width` (`.25rem`).
  static const double defaultFocusRingWidth = 4;

  /// `$btn-transition`'s duration (`.15s`).
  static const Duration defaultTransitionDuration = Duration(milliseconds: 150);

  /// `$btn-transition`'s timing function approximated as a Flutter [Curve].
  static const Curve defaultTransitionCurve = Curves.easeInOut;

  // scss-docs-start btn-hover-active-amounts — the shade/tint weights used
  // to compute hover/active colors in [solid], matching Bootstrap's
  // `$btn-hover-*-amount`/`$btn-active-*-amount` variables exactly.
  static const double hoverBgShadeAmount = 0.15;
  static const double hoverBgTintAmount = 0.15;
  static const double hoverBorderShadeAmount = 0.20;
  static const double hoverBorderTintAmount = 0.10;
  static const double activeBgShadeAmount = 0.20;
  static const double activeBgTintAmount = 0.20;
  static const double activeBorderShadeAmount = 0.25;
  static const double activeBorderTintAmount = 0.10;
  // scss-docs-end btn-hover-active-amounts

  /// `$font-size-sm`/`$font-size-base`/`$font-size-lg`, at the default
  /// `16px` root font size.
  static const double fontSizeSm = 14;
  static const double fontSizeBase = 16;
  static const double fontSizeLg = 20;

  /// `$border-radius-sm`/`$border-radius`/`$border-radius-lg`, at the
  /// default `16px` root font size.
  static const double borderRadiusSm = 4;
  static const double borderRadiusBase = 6;
  static const double borderRadiusLg = 8;

  /// Replicates Bootstrap's `button-variant($background, $border)` mixin:
  /// a solid, filled button in [background], with hover/active shades
  /// computed from [BsColorUtils.shade]/[BsColorUtils.tint] depending on
  /// whether [background] needs light or dark text.
  ///
  /// Bootstrap's `$theme-colors` loop explicitly forces the *opposite* of
  /// the automatic light/dark choice for the `light` and `dark` variants
  /// (so `light` still visibly darkens on hover, and `dark` still visibly
  /// lightens); pass [forceTint] to replicate that override.
  factory BsButtonStyle.solid(Color background, {Color? borderColor, bool? forceTint}) {
    final border = borderColor ?? background;
    final color = BsColorUtils.contrast(background);
    // Bootstrap's default: dark (light-text) buttons shade on hover/active,
    // light (dark-text) buttons tint. `forceTint` overrides this, as
    // Bootstrap does for the `light`/`dark` theme colors specifically.
    final tint = forceTint ?? (color != const Color(0xFFFFFFFF));

    Color mix(Color c, double weight) => tint ? BsColorUtils.tint(c, weight) : BsColorUtils.shade(c, weight);

    final hoverBackground = mix(background, tint ? hoverBgTintAmount : hoverBgShadeAmount);
    final hoverBorderColor = mix(border, tint ? hoverBorderTintAmount : hoverBorderShadeAmount);
    final activeBackground = mix(background, tint ? activeBgTintAmount : activeBgShadeAmount);
    final activeBorderColor = mix(border, tint ? activeBorderTintAmount : activeBorderShadeAmount);

    return BsButtonStyle(
      color: color,
      background: background,
      borderColor: border,
      hoverColor: BsColorUtils.contrast(hoverBackground),
      hoverBackground: hoverBackground,
      hoverBorderColor: hoverBorderColor,
      activeColor: BsColorUtils.contrast(activeBackground),
      activeBackground: activeBackground,
      activeBorderColor: activeBorderColor,
      boxShadow: defaultBoxShadow,
      activeShadow: defaultActiveShadow,
      focusRingColor: BsColorUtils.mix(color, border, 0.15),
      textStyle: defaultTextStyle,
      borderWidth: defaultBorderWidth,
      disabledOpacity: defaultDisabledOpacity,
      focusRingWidth: defaultFocusRingWidth,
      transitionDuration: defaultTransitionDuration,
      transitionCurve: defaultTransitionCurve,
    );
  }

  /// Replicates Bootstrap's `button-outline-variant($color)` mixin: a
  /// transparent button with a colored border/text that fills solid with
  /// [color] on hover/active.
  factory BsButtonStyle.outline(Color color) {
    return BsButtonStyle(
      color: color,
      background: const Color(0x00000000),
      borderColor: color,
      hoverColor: BsColorUtils.contrast(color),
      hoverBackground: color,
      hoverBorderColor: color,
      activeColor: BsColorUtils.contrast(color),
      activeBackground: color,
      activeBorderColor: color,
      boxShadow: defaultBoxShadow,
      activeShadow: defaultActiveShadow,
      focusRingColor: color,
      textStyle: defaultTextStyle,
      borderWidth: defaultBorderWidth,
      disabledOpacity: defaultDisabledOpacity,
      focusRingWidth: defaultFocusRingWidth,
      transitionDuration: defaultTransitionDuration,
      transitionCurve: defaultTransitionCurve,
    );
  }

  /// Replicates Bootstrap's `button-size()` mixin, using the
  /// `$btn-padding-*`/`$btn-font-size-*`/`$btn-border-radius-*` values
  /// (assuming the default `1rem == 16px` root font size).
  factory BsButtonStyle.size(BsSize size) {
    switch (size) {
      case BsSize.sm:
        return const BsButtonStyle(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          textStyle: TextStyle(fontSize: fontSizeSm),
          borderRadius: BorderRadius.all(Radius.circular(borderRadiusSm)),
        );
      case BsSize.normal:
        return const BsButtonStyle(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          textStyle: TextStyle(fontSize: fontSizeBase),
          borderRadius: BorderRadius.all(Radius.circular(borderRadiusBase)),
        );
      case BsSize.lg:
        return const BsButtonStyle(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          textStyle: TextStyle(fontSize: fontSizeLg),
          borderRadius: BorderRadius.all(Radius.circular(borderRadiusLg)),
        );
    }
  }

  /// The default `.btn-{variant}`/`.btn-outline-{variant}` style for
  /// [variant] at [size], replicating Bootstrap's `$theme-colors` Sass loop
  /// (`scss/_buttons.scss`), including its explicit light/dark overrides.
  factory BsButtonStyle.forVariant(BsVariant variant, {bool outline = false, BsSize size = BsSize.normal}) {
    final BsButtonStyle colors;
    if (outline) {
      colors = BsButtonStyle.outline(variant.color);
    } else {
      final forceTint = switch (variant) {
        BsVariant.light => false,
        BsVariant.dark => true,
        _ => null,
      };
      colors = BsButtonStyle.solid(variant.color, forceTint: forceTint);
    }
    return colors.merge(BsButtonStyle.size(size));
  }
}
