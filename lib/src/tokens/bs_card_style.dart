import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_colors.dart';
import 'bs_borders.dart';

/// A Bootstrap `.card`'s visual variables.
///
/// Mirrors the `card-variables` group from Bootstrap's SCSS source
/// (`$card-*`), assuming the default `16px` root font size.
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
    this.imgOverlayPadding,
    this.groupMargin,
  });

  /// `$card-spacer-y`/`$card-spacer-x` (`$spacer`, i.e. `16`).
  final EdgeInsetsGeometry? spacing;

  /// `$card-title-spacer-y` (`$spacer * .5`).
  final double? titleSpacerY;

  /// `$card-title-color` (`null`, inherits [color]).
  final Color? titleColor;

  /// `$card-subtitle-color` (`null`, inherits [color]).
  final Color? subtitleColor;

  /// `$card-border-width` (`var(--bs-border-width)`).
  final double? borderWidth;

  /// `$card-border-color` (`var(--bs-border-color-translucent)`).
  final Color? borderColor;

  /// `$card-border-radius` (`var(--bs-border-radius)`).
  final double? borderRadius;

  /// `$card-inner-border-radius` (`subtract($card-border-radius, $card-border-width)`).
  final double? innerBorderRadius;

  /// `$card-cap-padding-y`/`$card-cap-padding-x`.
  final EdgeInsetsGeometry? capPadding;

  /// `$card-cap-bg` (`rgba($body-color, .03)`).
  final Color? capBackground;

  /// `$card-cap-color` (`null`, inherits [color]).
  final Color? capColor;

  /// `$card-color` (`null`, inherits the surrounding text color).
  final Color? color;

  /// `$card-bg` (`var(--bs-body-bg)`).
  final Color? background;

  /// `$card-img-overlay-padding` (`$spacer`).
  final double? imgOverlayPadding;

  /// `$card-group-margin` (`$grid-gutter-width * .5`).
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
      imgOverlayPadding: other.imgOverlayPadding ?? imgOverlayPadding,
      groupMargin: other.groupMargin ?? groupMargin,
    );
  }

  /// `$spacer` (`1rem`).
  static const double spacer = 16;

  /// `$card-spacer-y`/`$card-spacer-x`.
  static const EdgeInsets defaultSpacing = EdgeInsets.all(spacer);

  /// `$card-title-spacer-y`.
  static const double defaultTitleSpacerY = spacer * 0.5;

  /// `$card-border-width`.
  static const double defaultBorderWidth = BsBorders.width;

  /// `$card-border-color`.
  static const Color defaultBorderColor = BsBorders.colorTranslucent;

  /// `$card-border-radius`.
  static const double defaultBorderRadius = BsBorders.radius;

  /// `$card-inner-border-radius`.
  static const double defaultInnerBorderRadius = defaultBorderRadius - defaultBorderWidth;

  /// `$card-cap-padding-y`/`$card-cap-padding-x`.
  static const EdgeInsets defaultCapPadding = EdgeInsets.symmetric(horizontal: spacer, vertical: spacer * 0.5);

  /// `$card-cap-bg: rgba($body-color, .03)`, resolved against
  /// `$body-color: $gray-900`.
  static const Color defaultCapBackground = Color(0x08212529);

  /// `$card-bg` (`var(--bs-body-bg)`).
  static const Color defaultBackground = BsColors.white;

  /// `$card-img-overlay-padding`.
  static const double defaultImgOverlayPadding = spacer;

  /// `$card-group-margin` (`$grid-gutter-width * .5`, `$grid-gutter-width: 1.5rem`).
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
}
