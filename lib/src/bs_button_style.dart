import 'package:flutter/widgets.dart';

import 'bs_color_utils.dart';
import 'bs_size.dart';
import 'bs_variant.dart';

/// Visual variables of a Bootstrap button: colors, padding, typography, border, shadows and
/// transitions.
///
/// Every field is nullable so that a [BsButtonStyle] can represent a partial override: an
/// override only reassigns the fields it cares about and inherits the rest from the variant.
/// The factories ([BsButtonStyle.solid], [BsButtonStyle.outline], [BsButtonStyle.link],
/// [BsButtonStyle.size]) build the styles of Bootstrap's button variants and sizes.
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

  final Color? color;
  final Color? background;
  final Color? borderColor;

  final Color? hoverColor;
  final Color? hoverBackground;
  final Color? hoverBorderColor;

  final Color? activeColor;
  final Color? activeBackground;
  final Color? activeBorderColor;

  final EdgeInsetsGeometry? padding;

  /// Typographic properties: font family, size, weight and line height.
  /// Deliberately excludes the color: the button's text color is always state-dependent
  /// (see [color], [hoverColor] and [activeColor]), so any color set here is overridden when
  /// the button is painted.
  final TextStyle? textStyle;

  /// The button's corner rounding. Usually uniform ([BorderRadius.circular]), but
  /// [BsButtonGroup] overrides it per corner to square off the sides shared with a
  /// neighboring button.
  final BorderRadiusGeometry? borderRadius;

  final double? borderWidth;

  final double? disabledOpacity;

  /// The button's resting shadow. Null by default (no shadow); pass [defaultBoxShadow] to opt in.
  ///
  /// A transparent (outline) button shows a drop shadow through its fill, so opting in
  /// tints it gray.
  final List<BoxShadow>? boxShadow;

  /// Replaces [boxShadow] while the button is pressed. Null by default for the same
  /// reason as [boxShadow]; pass [defaultActiveShadow] to opt in.
  final List<BoxShadow>? activeShadow;

  /// The color of the ring shown around a focused button. Defaults to a mix of [color]
  /// and [borderColor] when unset.
  final Color? focusRingColor;

  final double? focusRingWidth;

  final Duration? transitionDuration;

  final Curve? transitionCurve;

  /// Layers [other]'s non-null fields over this style's, leaving the rest inherited.
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

  /// The shadow of a raised button, using [BoxShadow.blurStyle] `inner` for its inset
  /// highlight. Not applied unless [boxShadow] is set to it.
  static const List<BoxShadow> defaultBoxShadow = [
    BoxShadow(
      color: Color(0x26FFFFFF),
      offset: Offset(0, 1),
      blurStyle: BlurStyle.inner,
    ),
    BoxShadow(color: Color(0x13000000), offset: Offset(0, 1), blurRadius: 1),
  ];

  /// The inset shadow of a pressed button. Not applied unless [activeShadow] is set to it.
  static const List<BoxShadow> defaultActiveShadow = [
    BoxShadow(
      color: Color(0x20000000),
      offset: Offset(0, 3),
      blurRadius: 5,
      blurStyle: BlurStyle.inner,
    ),
  ];

  static const TextStyle defaultTextStyle = TextStyle(
    fontWeight: FontWeight.normal,
    height: 1.5,
    leadingDistribution: TextLeadingDistribution.even,
  );

  static const double defaultBorderWidth = 1;

  static const double defaultDisabledOpacity = 0.65;

  static const double defaultFocusRingWidth = 4;

  static const Duration defaultTransitionDuration = Duration(milliseconds: 150);

  static const Curve defaultTransitionCurve = Curves.easeInOut;

  // The shade and tint weights used to compute hover and active colors in
  // [BsButtonStyle.solid].
  static const double hoverBgShadeAmount = 0.15;
  static const double hoverBgTintAmount = 0.15;
  static const double hoverBorderShadeAmount = 0.20;
  static const double hoverBorderTintAmount = 0.10;
  static const double activeBgShadeAmount = 0.20;
  static const double activeBgTintAmount = 0.20;
  static const double activeBorderShadeAmount = 0.25;
  static const double activeBorderTintAmount = 0.10;

  /// Font sizes of the small, regular and large button, in logical pixels.
  static const double fontSizeSm = 14;
  static const double fontSizeBase = 16;
  static const double fontSizeLg = 20;

  /// Horizontal padding of the small, regular and large button.
  static const double paddingXSm = 8;
  static const double paddingXBase = 12;
  static const double paddingXLg = 16;

  /// Vertical padding of the small, regular and large button.
  static const double paddingYSm = 4;
  static const double paddingYBase = 6;
  static const double paddingYLg = 8;

  /// Corner radius of the small, regular and large button.
  static const double borderRadiusSm = 4;
  static const double borderRadiusBase = 6;
  static const double borderRadiusLg = 8;

  /// A solid, filled button in [background], with hover and active shades computed from
  /// [BsColorUtils.shade] or [BsColorUtils.tint] depending on whether [background] needs light
  /// or dark text.
  ///
  /// The light and dark variants force the opposite of that automatic choice, so that the
  /// light button still visibly darkens on hover and the dark one still visibly lightens;
  /// pass [forceTint] to reproduce that.
  factory BsButtonStyle.solid(
    Color background, {
    Color? borderColor,
    bool? forceTint,
  }) {
    final border = borderColor ?? background;
    final color = BsColorUtils.contrast(background);
    // Bootstrap's default: dark (light-text) buttons shade on hover/active,
    // light (dark-text) buttons tint. `forceTint` overrides this, as
    // Bootstrap does for the `light`/`dark` theme colors specifically.
    final tint = forceTint ?? (color != const Color(0xFFFFFFFF));

    Color mix(Color c, double weight) =>
        tint ? BsColorUtils.tint(c, weight) : BsColorUtils.shade(c, weight);

    final hoverBackground = mix(
      background,
      tint ? hoverBgTintAmount : hoverBgShadeAmount,
    );
    final hoverBorderColor = mix(
      border,
      tint ? hoverBorderTintAmount : hoverBorderShadeAmount,
    );
    final activeBackground = mix(
      background,
      tint ? activeBgTintAmount : activeBgShadeAmount,
    );
    final activeBorderColor = mix(
      border,
      tint ? activeBorderTintAmount : activeBorderShadeAmount,
    );

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
      focusRingColor: BsColorUtils.mix(color, border, 0.15),
      textStyle: defaultTextStyle,
      borderWidth: defaultBorderWidth,
      disabledOpacity: defaultDisabledOpacity,
      focusRingWidth: defaultFocusRingWidth,
      transitionDuration: defaultTransitionDuration,
      transitionCurve: defaultTransitionCurve,
    );
  }

  /// A transparent button with a colored border and text that fills solid with [color] on
  /// hover and while pressed.
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
      focusRingColor: color,
      textStyle: defaultTextStyle,
      borderWidth: defaultBorderWidth,
      disabledOpacity: defaultDisabledOpacity,
      focusRingWidth: defaultFocusRingWidth,
      transitionDuration: defaultTransitionDuration,
      transitionCurve: defaultTransitionCurve,
    );
  }

  /// A link-colored, underlined button with no background or border, whose text takes the link
  /// hover color on hover and while pressed.
  factory BsButtonStyle.link({
    required Color color,
    required Color hoverColor,
  }) {
    const transparent = Color(0x00000000);
    return BsButtonStyle(
      color: color,
      background: transparent,
      borderColor: transparent,
      hoverColor: hoverColor,
      hoverBackground: transparent,
      hoverBorderColor: transparent,
      activeColor: hoverColor,
      activeBackground: transparent,
      activeBorderColor: transparent,
      focusRingColor: color,
      textStyle: defaultTextStyle.copyWith(decoration: TextDecoration.underline),
      borderWidth: defaultBorderWidth,
      disabledOpacity: defaultDisabledOpacity,
      focusRingWidth: defaultFocusRingWidth,
      transitionDuration: defaultTransitionDuration,
      transitionCurve: defaultTransitionCurve,
    );
  }

  /// Padding, font size and corner radius of a button of [size] (assuming a 16 logical pixel
  /// base font size).
  factory BsButtonStyle.size(BsSize size) {
    switch (size) {
      case BsSize.sm:
        return const BsButtonStyle(
          padding: EdgeInsets.symmetric(
            horizontal: paddingXSm,
            vertical: paddingYSm,
          ),
          textStyle: TextStyle(fontSize: fontSizeSm),
          borderRadius: BorderRadius.all(Radius.circular(borderRadiusSm)),
        );
      case BsSize.normal:
        return const BsButtonStyle(
          padding: EdgeInsets.symmetric(
            horizontal: paddingXBase,
            vertical: paddingYBase,
          ),
          textStyle: TextStyle(fontSize: fontSizeBase),
          borderRadius: BorderRadius.all(Radius.circular(borderRadiusBase)),
        );
      case BsSize.lg:
        return const BsButtonStyle(
          padding: EdgeInsets.symmetric(
            horizontal: paddingXLg,
            vertical: paddingYLg,
          ),
          textStyle: TextStyle(fontSize: fontSizeLg),
          borderRadius: BorderRadius.all(Radius.circular(borderRadiusLg)),
        );
    }
  }

  /// The default style of a button of [variant] at [size], solid or outline, including the
  /// light and dark variants' hover overrides.
  factory BsButtonStyle.forVariant(
    BsVariant variant, {
    bool outline = false,
    BsSize size = BsSize.normal,
  }) {
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
