import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_colors.dart';
import 'bs_borders.dart';

/// A Bootstrap `.table`'s visual variables.
///
/// Mirrors the `table-variables` group from Bootstrap's SCSS source
/// (`$table-*`).
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
  });

  /// `$table-cell-padding-y`/`$table-cell-padding-x` (`.5rem`).
  final EdgeInsetsGeometry? cellPadding;

  /// `$table-cell-padding-y-sm`/`$table-cell-padding-x-sm` (`.25rem`).
  final EdgeInsetsGeometry? cellPaddingSm;

  /// `$table-color` (`var(--bs-emphasis-color)`).
  final Color? color;

  /// `$table-bg` (`var(--bs-body-bg)`).
  final Color? background;

  /// `$table-accent-bg` (`transparent`).
  final Color? accentBackground;

  /// `$table-striped-color` (`$table-color`).
  final Color? stripedColor;

  /// `$table-striped-bg-factor` (`.05`), the opacity used to tint
  /// [stripedColor]'s row background over [background].
  final double? stripedBackgroundOpacity;

  /// `$table-active-color` (`$table-color`).
  final Color? activeColor;

  /// `$table-active-bg-factor` (`.1`).
  final double? activeBackgroundOpacity;

  /// `$table-hover-color` (`$table-color`).
  final Color? hoverColor;

  /// `$table-hover-bg-factor` (`.075`).
  final double? hoverBackgroundOpacity;

  /// `$table-border-width` (`var(--bs-border-width)`).
  final double? borderWidth;

  /// `$table-border-color` (`var(--bs-border-color)`).
  final Color? borderColor;

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
    );
  }

  static const EdgeInsets defaultCellPadding = EdgeInsets.all(8);
  static const EdgeInsets defaultCellPaddingSm = EdgeInsets.all(4);
  static const Color defaultColor = BsColors.black;
  static const Color defaultBackground = BsColors.white;
  static const Color defaultAccentBackground = Color(0x00000000);
  static const double defaultStripedBackgroundOpacity = 0.05;
  static const double defaultActiveBackgroundOpacity = 0.1;
  static const double defaultHoverBackgroundOpacity = 0.075;
  static const double defaultBorderWidth = BsBorders.width;
  static const Color defaultBorderColor = BsBorders.color;

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
  );
}
