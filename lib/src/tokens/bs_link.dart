import 'package:flutter/widgets.dart';

import '../bs_color_utils.dart';
import '../bs_colors.dart';
import '../bs_theme.dart';

/// Bootstrap's anchor/link tokens.
///
/// Mirrors the `Links` group from Bootstrap's SCSS source (`$link-*`), plus
/// the `-dark` counterparts from `_variables-dark.scss`. Use
/// [colorOf]/[hoverColorOf] to resolve against the ambient [BsTheme]
/// instead of reading [color]/[darkColor] etc. directly.
abstract final class BsLink {
  /// `$link-color` (`$primary`, i.e. [BsColors.blue]).
  static const Color color = BsColors.blue;

  /// `$link-color-dark` (`tint-color($primary, 40%)`).
  static Color get darkColor => BsColorUtils.tint(BsColors.blue, 0.4);

  /// `$link-decoration` (`underline`).
  static const TextDecoration decoration = TextDecoration.underline;

  /// `$link-shade-percentage` (`20%`), used to compute [hoverColor]/
  /// [darkHoverColor].
  static const double shadePercentage = 0.20;

  /// `$link-hover-color` (`shift-color($link-color, $link-shade-percentage)`).
  static Color get hoverColor => BsColorUtils.shade(color, shadePercentage);

  /// `$link-hover-color-dark`
  /// (`shift-color($link-color-dark, -$link-shade-percentage)` — a
  /// *negative* shift, i.e. a tint rather than a shade).
  static Color get darkHoverColor => BsColorUtils.tint(darkColor, shadePercentage);

  /// `$link-hover-decoration` (`null`, i.e. same as [decoration]).
  static const TextDecoration? hoverDecoration = null;

  static Color colorOf(BuildContext context) =>
      BsTheme.of(context) == Brightness.dark ? darkColor : color;

  static Color hoverColorOf(BuildContext context) =>
      BsTheme.of(context) == Brightness.dark ? darkHoverColor : hoverColor;
}
