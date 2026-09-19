import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_colors.dart';

/// A Bootstrap `.breadcrumb`'s visual variables.
///
/// Mirrors the `breadcrumb-variables` group from Bootstrap's SCSS source
/// (`$breadcrumb-*`).
@immutable
class BsBreadcrumbStyle {
  const BsBreadcrumbStyle({
    this.padding,
    this.itemSpacing,
    this.marginBottom,
    this.background,
    this.dividerColor,
    this.activeColor,
    this.divider,
    this.borderRadius,
  });

  /// `$breadcrumb-padding-y`/`$breadcrumb-padding-x` (`0`).
  final EdgeInsetsGeometry? padding;

  /// `$breadcrumb-item-padding-x` (`.5rem`), the gap before each divider.
  final double? itemSpacing;

  /// `$breadcrumb-margin-bottom` (`1rem`).
  final double? marginBottom;

  /// `$breadcrumb-bg` (`null`, transparent).
  final Color? background;

  /// `$breadcrumb-divider-color` (`var(--bs-secondary-color)`).
  final Color? dividerColor;

  /// `$breadcrumb-active-color` (`var(--bs-secondary-color)`).
  final Color? activeColor;

  /// `$breadcrumb-divider` (`"/"`).
  final String? divider;

  /// `$breadcrumb-border-radius` (`null`).
  final double? borderRadius;

  BsBreadcrumbStyle merge(BsBreadcrumbStyle? other) {
    if (other == null) return this;
    return BsBreadcrumbStyle(
      padding: other.padding ?? padding,
      itemSpacing: other.itemSpacing ?? itemSpacing,
      marginBottom: other.marginBottom ?? marginBottom,
      background: other.background ?? background,
      dividerColor: other.dividerColor ?? dividerColor,
      activeColor: other.activeColor ?? activeColor,
      divider: other.divider ?? divider,
      borderRadius: other.borderRadius ?? borderRadius,
    );
  }

  static const EdgeInsets defaultPadding = EdgeInsets.zero;
  static const double defaultItemSpacing = 8;
  static const double defaultMarginBottom = 16;
  static const Color defaultDividerColor = BsColors.gray600;
  static const Color defaultActiveColor = BsColors.gray600;
  static const String defaultDivider = '/';

  static const BsBreadcrumbStyle defaults = BsBreadcrumbStyle(
    padding: defaultPadding,
    itemSpacing: defaultItemSpacing,
    marginBottom: defaultMarginBottom,
    dividerColor: defaultDividerColor,
    activeColor: defaultActiveColor,
    divider: defaultDivider,
  );
}
