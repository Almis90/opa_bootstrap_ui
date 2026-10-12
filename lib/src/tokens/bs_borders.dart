import 'package:flutter/widgets.dart';

import '../bs_colors.dart';
import '../bs_theme.dart';

/// Bootstrap's global border tokens: widths, colors and corner radii, with their
/// dark-mode counterparts.
///
/// Use [colorOf] and [colorTranslucentOf] to resolve against the ambient [BsTheme]
/// instead of reading [color] or [darkColor] directly.
abstract final class BsBorders {
  /// Width.
  static const double width = 1;

  /// Text color.
  static const Color color = BsColors.gray300;

  /// Color.
  static const Color darkColor = BsColors.gray700;

  /// Color translucent.
  static const Color colorTranslucent = Color(0x2D000000);

  /// Color translucent.
  static const Color darkColorTranslucent = Color(0x26FFFFFF);

  /// Radius sm.
  static const double radiusSm = 4;

  /// Radius.
  static const double radius = 6;

  /// Radius lg.
  static const double radiusLg = 8;

  /// Radius xl.
  static const double radiusXl = 16;

  /// Radius xxl.
  static const double radiusXxl = 32;

  /// Radius pill.
  static const double radiusPill = 800;

  static Color colorOf(BuildContext context) =>
      BsTheme.of(context) == Brightness.dark ? darkColor : color;

  static Color colorTranslucentOf(BuildContext context) =>
      BsTheme.of(context) == Brightness.dark ? darkColorTranslucent : colorTranslucent;
}
