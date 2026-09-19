import 'package:flutter/painting.dart';

import '../bs_color_utils.dart';
import '../bs_colors.dart';

/// Bootstrap's anchor/link tokens.
///
/// Mirrors the `Links` group from Bootstrap's SCSS source (`$link-*`).
abstract final class BsLink {
  /// `$link-color` (`$primary`, i.e. [BsColors.blue]).
  static const Color color = BsColors.blue;

  /// `$link-decoration` (`underline`).
  static const TextDecoration decoration = TextDecoration.underline;

  /// `$link-shade-percentage` (`20%`), used to compute [hoverColor].
  static const double shadePercentage = 0.20;

  /// `$link-hover-color` (`shift-color($link-color, $link-shade-percentage)`).
  static Color get hoverColor => BsColorUtils.shade(color, shadePercentage);

  /// `$link-hover-decoration` (`null`, i.e. same as [decoration]).
  static const TextDecoration? hoverDecoration = null;
}
