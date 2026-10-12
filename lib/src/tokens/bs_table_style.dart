import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_colors.dart';
import 'bs_body.dart';
import 'bs_borders.dart';

/// Visual variables of a Bootstrap table.
///
/// Every field is nullable: null falls back to the matching `default…` constant.
/// [merge] layers overrides on top of [defaults] or, in dark mode, [darkDefaults].
@immutable
class BsTableStyle {
  const BsTableStyle({
    this.cellPadding,
    this.cellPaddingSm,
    this.color,
    this.background,
    this.accentBackground,
    this.stripedColor,
    this.stripedBackgroundOpacity,
    this.activeColor,
    this.activeBackgroundOpacity,
    this.hoverColor,
    this.hoverBackgroundOpacity,
    this.borderWidth,
    this.borderColor,
    this.captionColor,
  });

  final EdgeInsetsGeometry? cellPadding;

  /// Padding of a cell in a compact table.
  final EdgeInsetsGeometry? cellPaddingSm;

  final Color? color;

  final Color? background;

  final Color? accentBackground;

  final Color? stripedColor;

  /// Opacity with which [stripedColor] tints a striped row's background over [background].
  final double? stripedBackgroundOpacity;

  final Color? activeColor;

  final double? activeBackgroundOpacity;

  final Color? hoverColor;

  final double? hoverBackgroundOpacity;

  final double? borderWidth;

  final Color? borderColor;

  final Color? captionColor;

  BsTableStyle merge(BsTableStyle? other) {
    if (other == null) return this;
    return BsTableStyle(
      cellPadding: other.cellPadding ?? cellPadding,
      cellPaddingSm: other.cellPaddingSm ?? cellPaddingSm,
      color: other.color ?? color,
      background: other.background ?? background,
      accentBackground: other.accentBackground ?? accentBackground,
      stripedColor: other.stripedColor ?? stripedColor,
      stripedBackgroundOpacity: other.stripedBackgroundOpacity ?? stripedBackgroundOpacity,
      activeColor: other.activeColor ?? activeColor,
      activeBackgroundOpacity: other.activeBackgroundOpacity ?? activeBackgroundOpacity,
      hoverColor: other.hoverColor ?? hoverColor,
      hoverBackgroundOpacity: other.hoverBackgroundOpacity ?? hoverBackgroundOpacity,
      borderWidth: other.borderWidth ?? borderWidth,
      borderColor: other.borderColor ?? borderColor,
      captionColor: other.captionColor ?? captionColor,
    );
  }

  static const EdgeInsets defaultCellPadding = EdgeInsets.all(8);
  static const EdgeInsets defaultCellPaddingSm = EdgeInsets.all(4);

  static const Color defaultColor = BsColors.black;

  static const Color defaultDarkColor = BsBody.darkEmphasisColor;

  static const Color defaultBackground = BsColors.white;

  static const Color defaultDarkBackground = BsBody.darkBackground;

  static const Color defaultAccentBackground = Color(0x00000000);
  static const double defaultStripedBackgroundOpacity = 0.05;
  static const double defaultActiveBackgroundOpacity = 0.1;
  static const double defaultHoverBackgroundOpacity = 0.075;
  static const double defaultBorderWidth = BsBorders.width;

  static const Color defaultBorderColor = BsBorders.color;

  static const Color defaultDarkBorderColor = BsBorders.darkColor;

  static const Color defaultCaptionColor = BsColors.gray600;

  static const Color defaultDarkCaptionColor = BsBody.darkSecondaryColor;

  static const BsTableStyle defaults = BsTableStyle(
    cellPadding: defaultCellPadding,
    cellPaddingSm: defaultCellPaddingSm,
    color: defaultColor,
    background: defaultBackground,
    accentBackground: defaultAccentBackground,
    stripedColor: defaultColor,
    stripedBackgroundOpacity: defaultStripedBackgroundOpacity,
    activeColor: defaultColor,
    activeBackgroundOpacity: defaultActiveBackgroundOpacity,
    hoverColor: defaultColor,
    hoverBackgroundOpacity: defaultHoverBackgroundOpacity,
    borderWidth: defaultBorderWidth,
    borderColor: defaultBorderColor,
    captionColor: defaultCaptionColor,
  );

  /// Dark-mode counterpart of [defaults]: every brightness-sensitive field is swapped. Use it as
  /// the base to [merge] a caller's override when the ambient brightness is dark.
  static const BsTableStyle darkDefaults = BsTableStyle(
    cellPadding: defaultCellPadding,
    cellPaddingSm: defaultCellPaddingSm,
    color: defaultDarkColor,
    background: defaultDarkBackground,
    accentBackground: defaultAccentBackground,
    stripedColor: defaultDarkColor,
    stripedBackgroundOpacity: defaultStripedBackgroundOpacity,
    activeColor: defaultDarkColor,
    activeBackgroundOpacity: defaultActiveBackgroundOpacity,
    hoverColor: defaultDarkColor,
    hoverBackgroundOpacity: defaultHoverBackgroundOpacity,
    borderWidth: defaultBorderWidth,
    borderColor: defaultDarkBorderColor,
    captionColor: defaultDarkCaptionColor,
  );
}
