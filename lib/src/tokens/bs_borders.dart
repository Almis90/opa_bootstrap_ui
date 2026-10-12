import 'package:flutter/widgets.dart';

import '../bs_colors.dart';
import '../bs_theme.dart';

/// Bootstrap's global border tokens: widths, colors and corner radii, with their
/// dark-mode counterparts.
///
/// Use [colorOf] and [colorTranslucentOf] to resolve against the ambient [BsTheme]
/// instead of reading [color] or [darkColor] directly.
abstract final class BsBorders {
  static const double width = 1;

  static const Color color = BsColors.gray300;

  static const Color darkColor = BsColors.gray700;

  static const Color colorTranslucent = Color(0x2D000000);

  static const Color darkColorTranslucent = Color(0x26FFFFFF);

  static const double radiusSm = 4;

  static const double radius = 6;

  static const double radiusLg = 8;

  static const double radiusXl = 16;

  static const double radiusXxl = 32;

  static const double radiusPill = 800;

  static Color colorOf(BuildContext context) =>
      BsTheme.of(context) == Brightness.dark ? darkColor : color;

  static Color colorTranslucentOf(BuildContext context) =>
      BsTheme.of(context) == Brightness.dark ? darkColorTranslucent : colorTranslucent;
}
