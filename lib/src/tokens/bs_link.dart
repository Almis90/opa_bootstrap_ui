import 'package:flutter/widgets.dart';

import '../bs_color_utils.dart';
import '../bs_colors.dart';
import '../bs_theme.dart';

/// Bootstrap's link tokens: the link color, its hover color and the shared
/// shade percentage, with dark-mode counterparts.
///
/// Use [colorOf] and [hoverColorOf] to resolve against the ambient [BsTheme]
/// instead of reading [color] or [darkColor] directly.
abstract final class BsLink {
  /// Text color.
  static const Color color = BsColors.blue;

  /// Link color in dark mode: a lighter tint of the primary color.
  static Color get darkColor => BsColorUtils.tint(BsColors.blue, 0.4);

  /// Decoration.
  static const TextDecoration decoration = TextDecoration.underline;

  /// How much darker the hover color is than [color], as a percentage; also used to compute
  /// [hoverColor] and [darkHoverColor].
  static const double shadePercentage = 0.20;

  /// Link color under the pointer: [color] darkened by [shadePercentage].
  static Color get hoverColor => BsColorUtils.shade(color, shadePercentage);

  /// Link color under the pointer in dark mode: [darkColor] lightened by [shadePercentage].
  static Color get darkHoverColor => BsColorUtils.tint(darkColor, shadePercentage);

  /// Hover decoration.
  static const TextDecoration? hoverDecoration = null;

  static Color colorOf(BuildContext context) =>
      BsTheme.of(context) == Brightness.dark ? darkColor : color;

  static Color hoverColorOf(BuildContext context) =>
      BsTheme.of(context) == Brightness.dark ? darkHoverColor : hoverColor;
}
