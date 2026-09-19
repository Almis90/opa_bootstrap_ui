import 'package:flutter/painting.dart';

import 'bs_colors.dart';

/// Bootstrap contextual color variants.
///
/// Mirrors the `$theme-colors` map from Bootstrap's SCSS source
/// (primary, secondary, success, info, warning, danger, light, dark).
enum BsVariant {
  primary(BsColors.blue),
  secondary(BsColors.gray600),
  success(BsColors.green),
  info(BsColors.cyan),
  warning(BsColors.yellow),
  danger(BsColors.red),
  light(BsColors.gray100),
  dark(BsColors.gray900);

  const BsVariant(this.color);

  /// The base color this variant resolves to, per Bootstrap's default
  /// `$theme-colors` map.
  final Color color;

  /// The CSS class suffix used by Bootstrap, e.g. `btn-primary`, `text-danger`.
  String get className => name;
}
