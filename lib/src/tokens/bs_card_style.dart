import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_colors.dart';
import 'bs_borders.dart';

/// Visual variables of a Bootstrap card.
///
/// Every field is nullable: null falls back to the matching `default…` constant.
/// [merge] layers overrides on top of [defaults] or, in dark mode, [darkDefaults].
@immutable
class BsCardStyle {
  const BsCardStyle({
    this.spacing,
    this.titleSpacerY,
    this.titleColor,
    this.subtitleColor,
    this.borderWidth,
    this.borderColor,
    this.borderRadius,
    this.innerBorderRadius,
    this.capPadding,
    this.capBackground,
    this.capColor,
    this.color,
    this.background,
    this.boxShadow,
    this.imgOverlayPadding,
    this.groupMargin,
  });

  /// Padding of the card's body.
  final EdgeInsetsGeometry? spacing;

  final double? titleSpacerY;

  final Color? titleColor;

  final Color? subtitleColor;

  final double? borderWidth;

  final Color? borderColor;

  final double? borderRadius;

  final double? innerBorderRadius;

  /// Padding of the card's header and footer.
  final EdgeInsetsGeometry? capPadding;

  final Color? capBackground;

  final Color? capColor;

  final Color? color;

  final Color? background;

  final List<BoxShadow>? boxShadow;

  final double? imgOverlayPadding;

  final double? groupMargin;

  BsCardStyle merge(BsCardStyle? other) {
    if (other == null) return this;
    return BsCardStyle(
      spacing: other.spacing ?? spacing,
      titleSpacerY: other.titleSpacerY ?? titleSpacerY,
      titleColor: other.titleColor ?? titleColor,
      subtitleColor: other.subtitleColor ?? subtitleColor,
      borderWidth: other.borderWidth ?? borderWidth,
      borderColor: other.borderColor ?? borderColor,
      borderRadius: other.borderRadius ?? borderRadius,
      innerBorderRadius: other.innerBorderRadius ?? innerBorderRadius,
      capPadding: other.capPadding ?? capPadding,
      capBackground: other.capBackground ?? capBackground,
      capColor: other.capColor ?? capColor,
      color: other.color ?? color,
      background: other.background ?? background,
      boxShadow: other.boxShadow ?? boxShadow,
      imgOverlayPadding: other.imgOverlayPadding ?? imgOverlayPadding,
      groupMargin: other.groupMargin ?? groupMargin,
    );
  }

  static const double spacer = 16;

  /// Default padding of the card's body.
  static const EdgeInsets defaultSpacing = EdgeInsets.all(spacer);

  static const double defaultTitleSpacerY = spacer * 0.5;

  static const double defaultBorderWidth = BsBorders.width;

  static const Color defaultBorderColor = BsBorders.colorTranslucent;

  static const double defaultBorderRadius = BsBorders.radius;

  static const double defaultInnerBorderRadius = defaultBorderRadius - defaultBorderWidth;

  /// Default padding of the card's header and footer.
  static const EdgeInsets defaultCapPadding = EdgeInsets.symmetric(horizontal: spacer, vertical: spacer * 0.5);

  static const Color defaultCapBackground = Color(0x08212529);

  /// Default header and footer background in dark mode: a faint tint of the dark theme's text
  /// color.
  static const Color defaultDarkCapBackground = Color(0x08DEE2E6);

  static const Color defaultBackground = BsColors.white;

  static const Color defaultDarkBackground = BsColors.gray900;

  /// Default border color in dark mode: translucent white.
  static const Color defaultDarkBorderColor = BsBorders.darkColorTranslucent;

  static const double defaultImgOverlayPadding = spacer;

  static const double defaultGroupMargin = 12;

  static const BsCardStyle defaults = BsCardStyle(
    spacing: defaultSpacing,
    titleSpacerY: defaultTitleSpacerY,
    borderWidth: defaultBorderWidth,
    borderColor: defaultBorderColor,
    borderRadius: defaultBorderRadius,
    innerBorderRadius: defaultInnerBorderRadius,
    capPadding: defaultCapPadding,
    capBackground: defaultCapBackground,
    background: defaultBackground,
    imgOverlayPadding: defaultImgOverlayPadding,
    groupMargin: defaultGroupMargin,
  );

  /// Dark-mode counterpart of [defaults]: [background], [borderColor] and [capBackground] are
  /// swapped, the rest is identical. Use it as the base to [merge] a caller's override when the
  /// ambient brightness is dark.
  static const BsCardStyle darkDefaults = BsCardStyle(
    spacing: defaultSpacing,
    titleSpacerY: defaultTitleSpacerY,
    borderWidth: defaultBorderWidth,
    borderColor: defaultDarkBorderColor,
    borderRadius: defaultBorderRadius,
    innerBorderRadius: defaultInnerBorderRadius,
    capPadding: defaultCapPadding,
    capBackground: defaultDarkCapBackground,
    background: defaultDarkBackground,
    imgOverlayPadding: defaultImgOverlayPadding,
    groupMargin: defaultGroupMargin,
  );
}
