import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_color_utils.dart';
import '../bs_colors.dart';
import '../bs_variant.dart';
import 'bs_body.dart';
import 'bs_borders.dart';

/// A Bootstrap `.accordion`'s visual variables.
///
/// Mirrors the `accordion-variables` group from Bootstrap's SCSS source
/// (`$accordion-*`).
@immutable
class BsAccordionStyle {
  const BsAccordionStyle({
    this.padding,
    this.bodyPadding,
    this.color,
    this.background,
    this.borderWidth,
    this.borderColor,
    this.borderRadius,
    this.innerBorderRadius,
    this.buttonColor,
    this.buttonBackground,
    this.transitionDuration,
    this.buttonActiveBackground,
    this.buttonActiveColor,
    this.iconWidth,
    this.iconColor,
    this.iconActiveColor,
    this.iconTransitionDuration,
    this.iconRotationTurns,
    this.focusRingColor,
    this.focusRingWidth,
  });

  /// `$accordion-button-padding-y`/`$accordion-button-padding-x`
  /// (`1rem`/`1.25rem`), the header button's own padding.
  final EdgeInsetsGeometry? padding;

  /// `$accordion-body-padding-y`/`$accordion-body-padding-x`
  /// (`1rem`/`1.25rem` by default, but independently overridable from
  /// [padding]).
  final EdgeInsetsGeometry? bodyPadding;

  /// `$accordion-color` (`var(--bs-body-color)`).
  final Color? color;

  /// `$accordion-bg` (`var(--bs-body-bg)`).
  final Color? background;

  /// `$accordion-border-width` (`var(--bs-border-width)`).
  final double? borderWidth;

  /// `$accordion-border-color` (`var(--bs-border-color)`).
  final Color? borderColor;

  /// `$accordion-border-radius` (`var(--bs-border-radius)`).
  final double? borderRadius;

  /// `$accordion-inner-border-radius` (`subtract($accordion-border-radius,
  /// $accordion-border-width)`) — the slightly smaller radius applied to the
  /// button/body fill so it nests inside the item's outer border curve.
  final double? innerBorderRadius;

  /// `$accordion-button-color` (`var(--bs-body-color)`).
  final Color? buttonColor;

  /// `$accordion-button-bg` (`var(--bs-accordion-bg)`).
  final Color? buttonBackground;

  /// `$accordion-transition` (`$btn-transition`, plus a border-radius
  /// transition).
  final Duration? transitionDuration;

  /// `$accordion-button-active-bg` (`var(--bs-primary-bg-subtle)`).
  final Color? buttonActiveBackground;

  /// `$accordion-button-active-color` (`var(--bs-primary-text-emphasis)`).
  final Color? buttonActiveColor;

  /// `$accordion-icon-width` (`1.25rem`).
  final double? iconWidth;

  /// `$accordion-icon-color` (`$body-color`).
  final Color? iconColor;

  /// `$accordion-icon-active-color` (`$primary-text-emphasis`).
  final Color? iconActiveColor;

  /// `$accordion-icon-transition` (`transform .2s ease-in-out`).
  final Duration? iconTransitionDuration;

  /// `$accordion-icon-transform` (`rotate(-180deg)`), expressed as
  /// [AnimatedRotation] turns (a full turn is `1.0`).
  final double? iconRotationTurns;

  /// `$accordion-button-focus-box-shadow` (`$btn-focus-box-shadow`, i.e. a
  /// ring tinted by the primary color).
  final Color? focusRingColor;

  /// The width of the focus ring, per `$btn-focus-width` (`.25rem`, i.e.
  /// `4` at the default `16px` root font size).
  final double? focusRingWidth;

  BsAccordionStyle merge(BsAccordionStyle? other) {
    if (other == null) return this;
    return BsAccordionStyle(
      padding: other.padding ?? padding,
      bodyPadding: other.bodyPadding ?? bodyPadding,
      color: other.color ?? color,
      background: other.background ?? background,
      borderWidth: other.borderWidth ?? borderWidth,
      borderColor: other.borderColor ?? borderColor,
      borderRadius: other.borderRadius ?? borderRadius,
      innerBorderRadius: other.innerBorderRadius ?? innerBorderRadius,
      buttonColor: other.buttonColor ?? buttonColor,
      buttonBackground: other.buttonBackground ?? buttonBackground,
      transitionDuration: other.transitionDuration ?? transitionDuration,
      buttonActiveBackground: other.buttonActiveBackground ?? buttonActiveBackground,
      buttonActiveColor: other.buttonActiveColor ?? buttonActiveColor,
      iconWidth: other.iconWidth ?? iconWidth,
      iconColor: other.iconColor ?? iconColor,
      iconActiveColor: other.iconActiveColor ?? iconActiveColor,
      iconTransitionDuration: other.iconTransitionDuration ?? iconTransitionDuration,
      iconRotationTurns: other.iconRotationTurns ?? iconRotationTurns,
      focusRingColor: other.focusRingColor ?? focusRingColor,
      focusRingWidth: other.focusRingWidth ?? focusRingWidth,
    );
  }

  static const EdgeInsets defaultPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 16);

  /// `$accordion-color`/`$accordion-button-color` (`var(--bs-body-color)`).
  static const Color defaultColor = BsColors.gray900;

  /// [defaultColor] resolved against `--bs-body-color` in
  /// `[data-bs-theme="dark"]`.
  static const Color defaultDarkColor = BsBody.darkColor;

  /// `$accordion-bg`/`$accordion-button-bg` (`var(--bs-body-bg)`).
  static const Color defaultBackground = BsColors.white;

  /// [defaultBackground] resolved against `--bs-body-bg` in
  /// `[data-bs-theme="dark"]`.
  static const Color defaultDarkBackground = BsBody.darkBackground;

  static const double defaultBorderWidth = BsBorders.width;

  /// `$accordion-border-color` (`var(--bs-border-color)`).
  static const Color defaultBorderColor = BsBorders.color;

  /// [defaultBorderColor] resolved against `--bs-border-color` in
  /// `[data-bs-theme="dark"]`.
  static const Color defaultDarkBorderColor = BsBorders.darkColor;

  static const double defaultBorderRadius = BsBorders.radius;
  static const double defaultInnerBorderRadius = BsBorders.radius - BsBorders.width;
  static const Duration defaultTransitionDuration = Duration(milliseconds: 150);
  static const double defaultIconWidth = 20;

  /// `$accordion-icon-color` (`$body-color`).
  static const Color defaultIconColor = BsColors.gray900;

  /// `$accordion-icon-color-dark` (`$primary-text-emphasis-dark`) — note
  /// this is *not* simply `$body-color-dark`; Bootstrap explicitly tints
  /// the dark-mode chevron with the primary color (matching
  /// [defaultDarkButtonActiveColor]) so it stays visible/on-brand rather
  /// than fading to plain gray text.
  static Color get defaultDarkIconColor => BsVariant.primary.darkTextEmphasis;

  static const Duration defaultIconTransitionDuration = Duration(milliseconds: 200);
  static const double defaultIconRotationTurns = 0.5;
  static Color get defaultButtonActiveBackground => BsColorUtils.tint(BsVariant.primary.color, 0.8);

  /// `$accordion-button-active-bg-dark` has no explicit SCSS override, but
  /// it reads `var(--bs-primary-bg-subtle)`, which the dark-mode cascade
  /// does swap.
  static Color get defaultDarkButtonActiveBackground => BsVariant.primary.darkBgSubtle;

  static Color get defaultButtonActiveColor => BsColorUtils.shade(BsVariant.primary.color, 0.6);

  /// `$accordion-button-active-color-dark`: reads
  /// `var(--bs-primary-text-emphasis)`, swapped by the dark-mode cascade —
  /// same value Bootstrap uses for [defaultDarkIconColor].
  static Color get defaultDarkButtonActiveColor => BsVariant.primary.darkTextEmphasis;

  static const double defaultFocusRingWidth = 4;
  // Matches button-variant's `--bs-btn-focus-shadow-rgb: mix($color,
  // $border, 15%)`, where $color is primary's contrast text (white) and
  // $border is primary itself. No `-dark` override exists for this in
  // Bootstrap's SCSS, so it's the same in both themes.
  static Color get defaultFocusRingColor => BsColorUtils.mix(BsColors.white, BsVariant.primary.color, 0.15);

  static BsAccordionStyle get defaults => BsAccordionStyle(
    padding: defaultPadding,
    bodyPadding: defaultPadding,
    color: defaultColor,
    background: defaultBackground,
    borderWidth: defaultBorderWidth,
    borderColor: defaultBorderColor,
    borderRadius: defaultBorderRadius,
    innerBorderRadius: defaultInnerBorderRadius,
    buttonColor: defaultColor,
    buttonBackground: defaultBackground,
    transitionDuration: defaultTransitionDuration,
    buttonActiveBackground: defaultButtonActiveBackground,
    buttonActiveColor: defaultButtonActiveColor,
    iconWidth: defaultIconWidth,
    iconColor: defaultIconColor,
    iconActiveColor: defaultButtonActiveColor,
    iconTransitionDuration: defaultIconTransitionDuration,
    iconRotationTurns: defaultIconRotationTurns,
    focusRingColor: defaultFocusRingColor,
    focusRingWidth: defaultFocusRingWidth,
  );

  /// [defaults], with every brightness-sensitive field ([color],
  /// [buttonColor], [background], [buttonBackground], [borderColor],
  /// [iconColor], [buttonActiveBackground], [buttonActiveColor],
  /// [iconActiveColor]) swapped for its `[data-bs-theme="dark"]`
  /// counterpart. Pick this as the base to [merge] a caller's
  /// [BsAccordionStyle] override against when
  /// `BsTheme.of(context) == Brightness.dark`.
  static BsAccordionStyle get darkDefaults => BsAccordionStyle(
    padding: defaultPadding,
    bodyPadding: defaultPadding,
    color: defaultDarkColor,
    background: defaultDarkBackground,
    borderWidth: defaultBorderWidth,
    borderColor: defaultDarkBorderColor,
    borderRadius: defaultBorderRadius,
    innerBorderRadius: defaultInnerBorderRadius,
    buttonColor: defaultDarkColor,
    buttonBackground: defaultDarkBackground,
    transitionDuration: defaultTransitionDuration,
    buttonActiveBackground: defaultDarkButtonActiveBackground,
    buttonActiveColor: defaultDarkButtonActiveColor,
    iconWidth: defaultIconWidth,
    iconColor: defaultDarkIconColor,
    iconActiveColor: defaultDarkButtonActiveColor,
    iconTransitionDuration: defaultIconTransitionDuration,
    iconRotationTurns: defaultIconRotationTurns,
    focusRingColor: defaultFocusRingColor,
    focusRingWidth: defaultFocusRingWidth,
  );
}
