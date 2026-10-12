import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_colors.dart';
import 'bs_body.dart';
import 'bs_borders.dart';
import 'bs_shadows.dart';

/// Visual variables of a Bootstrap modal.
///
/// Every field is nullable: null falls back to the matching `default…` constant.
/// [merge] layers overrides on top of [defaults] or, in dark mode, [darkDefaults].
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
    this.footerBackground,
    this.footerBorderColor,
    this.footerBorderWidth,
    this.smallSize,
    this.mediumSize,
    this.largeSize,
    this.extraLargeSize,
    this.transitionDuration,
  });

  final double? innerPadding;

  final double? footerMarginBetween;

  final double? dialogMargin;

  final double? titleLineHeight;

  final Color? contentColor;

  final Color? contentBackground;

  final Color? contentBorderColor;

  final double? contentBorderWidth;

  final double? contentBorderRadius;

  /// Drop shadow of the dialog. Null by default (no shadow); pass [defaultContentBoxShadow] to opt
  /// in.
  final List<BoxShadow>? contentBoxShadow;

  final Color? backdropColor;

  final double? backdropOpacity;

  final Color? headerBorderColor;

  final double? headerBorderWidth;

  final Color? footerBackground;

  final Color? footerBorderColor;

  final double? footerBorderWidth;

  final double? smallSize;

  final double? mediumSize;

  final double? largeSize;

  final double? extraLargeSize;

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
      footerBackground: other.footerBackground ?? footerBackground,
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
  static const Color defaultContentColor = BsColors.gray900;

  static const Color defaultDarkContentColor = BsBody.darkColor;

  static const Color defaultContentBackground = BsColors.white;

  static const Color defaultDarkContentBackground = BsBody.darkBackground;

  static const Color defaultContentBorderColor = BsBorders.colorTranslucent;

  static const Color defaultDarkContentBorderColor = BsBorders.darkColorTranslucent;

  static const double defaultContentBorderWidth = BsBorders.width;
  static const double defaultContentBorderRadius = BsBorders.radiusLg;
  static const List<BoxShadow> defaultContentBoxShadow = BsShadows.shadow;

  /// Default backdrop color: black in both themes, since a backdrop is always a dark scrim.
  static const Color defaultBackdropColor = BsColors.black;
  static const double defaultBackdropOpacity = 0.5;

  static const Color defaultHeaderBorderColor = BsBorders.color;

  static const Color defaultDarkHeaderBorderColor = BsBorders.darkColor;
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
    contentColor: defaultContentColor,
    contentBackground: defaultContentBackground,
    contentBorderColor: defaultContentBorderColor,
    contentBorderWidth: defaultContentBorderWidth,
    contentBorderRadius: defaultContentBorderRadius,
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

  /// Dark-mode counterpart of [defaults]: the content, header and footer colors are swapped, the
  /// rest is identical; the backdrop stays the same dark scrim. Use it as the base to [merge] a
  /// caller's override when the ambient brightness is dark.
  static const BsModalStyle darkDefaults = BsModalStyle(
    innerPadding: defaultInnerPadding,
    footerMarginBetween: defaultFooterMarginBetween,
    dialogMargin: defaultDialogMargin,
    titleLineHeight: defaultTitleLineHeight,
    contentColor: defaultDarkContentColor,
    contentBackground: defaultDarkContentBackground,
    contentBorderColor: defaultDarkContentBorderColor,
    contentBorderWidth: defaultContentBorderWidth,
    contentBorderRadius: defaultContentBorderRadius,
    backdropColor: defaultBackdropColor,
    backdropOpacity: defaultBackdropOpacity,
    headerBorderColor: defaultDarkHeaderBorderColor,
    headerBorderWidth: defaultContentBorderWidth,
    footerBorderColor: defaultDarkHeaderBorderColor,
    footerBorderWidth: defaultContentBorderWidth,
    smallSize: defaultSmallSize,
    mediumSize: defaultMediumSize,
    largeSize: defaultLargeSize,
    extraLargeSize: defaultExtraLargeSize,
    transitionDuration: defaultTransitionDuration,
  );
}
