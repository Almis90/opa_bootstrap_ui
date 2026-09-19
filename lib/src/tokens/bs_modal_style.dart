import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_colors.dart';
import 'bs_borders.dart';
import 'bs_shadows.dart';

/// A Bootstrap `.modal`'s visual variables.
///
/// Mirrors the `modal-variables` group from Bootstrap's SCSS source
/// (`$modal-*`).
@immutable
class BsModalStyle {
  const BsModalStyle({
    this.innerPadding,
    this.footerMarginBetween,
    this.dialogMargin,
    this.titleLineHeight,
    this.contentColor,
    this.contentBackground,
    this.contentBorderColor,
    this.contentBorderWidth,
    this.contentBorderRadius,
    this.contentBoxShadow,
    this.backdropColor,
    this.backdropOpacity,
    this.headerBorderColor,
    this.headerBorderWidth,
    this.footerBorderColor,
    this.footerBorderWidth,
    this.smallSize,
    this.mediumSize,
    this.largeSize,
    this.extraLargeSize,
    this.transitionDuration,
  });

  /// `$modal-inner-padding` (`$spacer`).
  final double? innerPadding;

  /// `$modal-footer-margin-between` (`.5rem`).
  final double? footerMarginBetween;

  /// `$modal-dialog-margin` (`.5rem`).
  final double? dialogMargin;

  /// `$modal-title-line-height` (`$line-height-base`).
  final double? titleLineHeight;

  /// `$modal-content-color` (`var(--bs-body-color)`).
  final Color? contentColor;

  /// `$modal-content-bg` (`var(--bs-body-bg)`).
  final Color? contentBackground;

  /// `$modal-content-border-color` (`var(--bs-border-color-translucent)`).
  final Color? contentBorderColor;

  /// `$modal-content-border-width` (`var(--bs-border-width)`).
  final double? contentBorderWidth;

  /// `$modal-content-border-radius` (`var(--bs-border-radius-lg)`).
  final double? contentBorderRadius;

  /// `$modal-content-box-shadow-sm-up` (`var(--bs-box-shadow)`).
  final List<BoxShadow>? contentBoxShadow;

  /// `$modal-backdrop-bg` (`$black`).
  final Color? backdropColor;

  /// `$modal-backdrop-opacity` (`.5`).
  final double? backdropOpacity;

  /// `$modal-header-border-color` (`var(--bs-border-color)`).
  final Color? headerBorderColor;

  /// `$modal-header-border-width` (`$modal-content-border-width`).
  final double? headerBorderWidth;

  /// `$modal-footer-border-color` (`$modal-header-border-color`).
  final Color? footerBorderColor;

  /// `$modal-footer-border-width` (`$modal-header-border-width`).
  final double? footerBorderWidth;

  /// `$modal-sm` (`300px`).
  final double? smallSize;

  /// `$modal-md` (`500px`).
  final double? mediumSize;

  /// `$modal-lg` (`800px`).
  final double? largeSize;

  /// `$modal-xl` (`1140px`).
  final double? extraLargeSize;

  /// `$modal-transition` (`transform .3s ease-out`).
  final Duration? transitionDuration;

  BsModalStyle merge(BsModalStyle? other) {
    if (other == null) return this;
    return BsModalStyle(
      innerPadding: other.innerPadding ?? innerPadding,
      footerMarginBetween: other.footerMarginBetween ?? footerMarginBetween,
      dialogMargin: other.dialogMargin ?? dialogMargin,
      titleLineHeight: other.titleLineHeight ?? titleLineHeight,
      contentColor: other.contentColor ?? contentColor,
      contentBackground: other.contentBackground ?? contentBackground,
      contentBorderColor: other.contentBorderColor ?? contentBorderColor,
      contentBorderWidth: other.contentBorderWidth ?? contentBorderWidth,
      contentBorderRadius: other.contentBorderRadius ?? contentBorderRadius,
      contentBoxShadow: other.contentBoxShadow ?? contentBoxShadow,
      backdropColor: other.backdropColor ?? backdropColor,
      backdropOpacity: other.backdropOpacity ?? backdropOpacity,
      headerBorderColor: other.headerBorderColor ?? headerBorderColor,
      headerBorderWidth: other.headerBorderWidth ?? headerBorderWidth,
      footerBorderColor: other.footerBorderColor ?? footerBorderColor,
      footerBorderWidth: other.footerBorderWidth ?? footerBorderWidth,
      smallSize: other.smallSize ?? smallSize,
      mediumSize: other.mediumSize ?? mediumSize,
      largeSize: other.largeSize ?? largeSize,
      extraLargeSize: other.extraLargeSize ?? extraLargeSize,
      transitionDuration: other.transitionDuration ?? transitionDuration,
    );
  }

  static const double defaultInnerPadding = 16;
  static const double defaultFooterMarginBetween = 8;
  static const double defaultDialogMargin = 8;
  static const double defaultTitleLineHeight = 1.5;
  static const Color defaultContentBackground = BsColors.white;
  static const Color defaultContentBorderColor = BsBorders.colorTranslucent;
  static const double defaultContentBorderWidth = BsBorders.width;
  static const double defaultContentBorderRadius = BsBorders.radiusLg;
  static const List<BoxShadow> defaultContentBoxShadow = BsShadows.shadow;
  static const Color defaultBackdropColor = BsColors.black;
  static const double defaultBackdropOpacity = 0.5;
  static const Color defaultHeaderBorderColor = BsBorders.color;
  static const double defaultSmallSize = 300;
  static const double defaultMediumSize = 500;
  static const double defaultLargeSize = 800;
  static const double defaultExtraLargeSize = 1140;
  static const Duration defaultTransitionDuration = Duration(milliseconds: 300);

  static const BsModalStyle defaults = BsModalStyle(
    innerPadding: defaultInnerPadding,
    footerMarginBetween: defaultFooterMarginBetween,
    dialogMargin: defaultDialogMargin,
    titleLineHeight: defaultTitleLineHeight,
    contentBackground: defaultContentBackground,
    contentBorderColor: defaultContentBorderColor,
    contentBorderWidth: defaultContentBorderWidth,
    contentBorderRadius: defaultContentBorderRadius,
    contentBoxShadow: defaultContentBoxShadow,
    backdropColor: defaultBackdropColor,
    backdropOpacity: defaultBackdropOpacity,
    headerBorderColor: defaultHeaderBorderColor,
    headerBorderWidth: defaultContentBorderWidth,
    footerBorderColor: defaultHeaderBorderColor,
    footerBorderWidth: defaultContentBorderWidth,
    smallSize: defaultSmallSize,
    mediumSize: defaultMediumSize,
    largeSize: defaultLargeSize,
    extraLargeSize: defaultExtraLargeSize,
    transitionDuration: defaultTransitionDuration,
  );
}
