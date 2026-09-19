import 'package:flutter/painting.dart';

import 'bs_color_utils.dart';
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

  /// `$#{variant}-text-emphasis`: a darkened, higher-contrast version of
  /// [color] meant for text on a [bgSubtle] background (e.g. `.alert-*`,
  /// `.badge-*`). `light`/`dark` are special-cased to `$gray-700` rather
  /// than the general `shade-color($color, 60%)` formula, per Bootstrap.
  Color get textEmphasis => switch (this) {
    BsVariant.light || BsVariant.dark => BsColors.gray700,
    _ => BsColorUtils.shade(color, 0.6),
  };

  /// `$#{variant}-bg-subtle`: a very light tint of [color] meant as a
  /// background behind [textEmphasis] text. `light`/`dark` are
  /// special-cased rather than the general `tint-color($color, 80%)`
  /// formula, per Bootstrap.
  Color get bgSubtle => switch (this) {
    BsVariant.light => BsColorUtils.mix(BsColors.gray100, BsColors.white, 0.5),
    BsVariant.dark => BsColors.gray400,
    _ => BsColorUtils.tint(color, 0.8),
  };

  /// `$#{variant}-border-subtle`: a light tint of [color] meant to border a
  /// [bgSubtle] background. `light`/`dark` are special-cased rather than
  /// the general `tint-color($color, 60%)` formula, per Bootstrap.
  Color get borderSubtle => switch (this) {
    BsVariant.light => BsColors.gray200,
    BsVariant.dark => BsColors.gray500,
    _ => BsColorUtils.tint(color, 0.6),
  };
}
