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

  /// Title spacer y.
  final double? titleSpacerY;

  /// Title color.
  final Color? titleColor;

  /// Subtitle color.
  final Color? subtitleColor;

  /// Border width.
  final double? borderWidth;

  /// Border color.
  final Color? borderColor;

  /// Corner radius.
  final double? borderRadius;

  /// Inner border radius.
  final double? innerBorderRadius;

  /// Padding of the card's header and footer.
  final EdgeInsetsGeometry? capPadding;

  /// Cap background.
  final Color? capBackground;

  /// Cap color.
  final Color? capColor;

  /// Text color.
  final Color? color;

  /// Background color.
  final Color? background;

  /// Drop shadow.
  final List<BoxShadow>? boxShadow;

  /// Img overlay padding.
  final double? imgOverlayPadding;

  /// Group margin.
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

  /// Spacer.
  static const double spacer = 16;

  /// Default padding of the card's body.
  static const EdgeInsets defaultSpacing = EdgeInsets.all(spacer);

  /// Default title spacer y.
  static const double defaultTitleSpacerY = spacer * 0.5;

  /// Default border width.
  static const double defaultBorderWidth = BsBorders.width;

  /// Default border color.
  static const Color defaultBorderColor = BsBorders.colorTranslucent;

  /// Default border radius.
  static const double defaultBorderRadius = BsBorders.radius;

  /// Default inner border radius.
  static const double defaultInnerBorderRadius = defaultBorderRadius - defaultBorderWidth;

  /// Default padding of the card's header and footer.
  static const EdgeInsets defaultCapPadding = EdgeInsets.symmetric(horizontal: spacer, vertical: spacer * 0.5);

  /// Default cap background.
  static const Color defaultCapBackground = Color(0x08212529);

  /// Default header and footer background in dark mode: a faint tint of the dark theme's text
  /// color.
  static const Color defaultDarkCapBackground = Color(0x08DEE2E6);

  /// Default background.
  static const Color defaultBackground = BsColors.white;

  /// Default background in dark mode.
  static const Color defaultDarkBackground = BsColors.gray900;

  /// Default border color in dark mode: translucent white.
  static const Color defaultDarkBorderColor = BsBorders.darkColorTranslucent;

  /// Default img overlay padding.
  static const double defaultImgOverlayPadding = spacer;

  /// Default group margin.
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
