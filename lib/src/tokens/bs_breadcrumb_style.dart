import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import 'bs_body.dart';

/// Visual variables of a Bootstrap breadcrumb.
///
/// Every field is nullable: null falls back to the matching `default…` constant.
/// [merge] layers overrides on top of [defaults] or, in dark mode, [darkDefaults].
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

  /// Padding of the breadcrumb.
  final EdgeInsetsGeometry? padding;

  /// Gap before each divider.
  final double? itemSpacing;

  /// Margin bottom.
  final double? marginBottom;

  /// Background color.
  final Color? background;

  /// Divider color.
  final Color? dividerColor;

  /// Active color.
  final Color? activeColor;

  /// Divider.
  final String? divider;

  /// Corner radius.
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
  static const Color defaultDividerColor = BsBody.secondaryColor;

  /// Default divider color in dark mode.
  static const Color defaultDarkDividerColor = BsBody.darkSecondaryColor;

  static const Color defaultActiveColor = BsBody.secondaryColor;

  /// Default active color in dark mode.
  static const Color defaultDarkActiveColor = BsBody.darkSecondaryColor;

  static const String defaultDivider = '/';

  static const BsBreadcrumbStyle defaults = BsBreadcrumbStyle(
    padding: defaultPadding,
    itemSpacing: defaultItemSpacing,
    marginBottom: defaultMarginBottom,
    dividerColor: defaultDividerColor,
    activeColor: defaultActiveColor,
    divider: defaultDivider,
  );

  /// Dark-mode counterpart of [defaults]: [dividerColor] and [activeColor] are swapped, the rest is
  /// identical. Use it as the base to [merge] a caller's override when the ambient brightness is
  /// dark.
  static const BsBreadcrumbStyle darkDefaults = BsBreadcrumbStyle(
    padding: defaultPadding,
    itemSpacing: defaultItemSpacing,
    marginBottom: defaultMarginBottom,
    dividerColor: defaultDarkDividerColor,
    activeColor: defaultDarkActiveColor,
    divider: defaultDivider,
  );
}
