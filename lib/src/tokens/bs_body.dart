import 'package:flutter/widgets.dart';

import '../bs_colors.dart';
import '../bs_theme.dart';

/// Bootstrap's base tokens for the page: the text and background colors many
/// components default to.
///
/// Use the `Of` methods (for example [colorOf]) to resolve against the ambient [BsTheme]
/// instead of reading [color] or [darkColor] directly.
abstract final class BsBody {
  /// Text color.
  static const Color color = BsColors.gray900;

  /// Color.
  static const Color darkColor = BsColors.gray300;

  /// Background color.
  static const Color background = BsColors.white;

  /// Background.
  static const Color darkBackground = BsColors.gray900;

  /// Secondary color.
  static const Color secondaryColor = Color(0xBF212529);

  /// Secondary color.
  static const Color darkSecondaryColor = Color(0xBFDEE2E6);

  /// Secondary background.
  static const Color secondaryBackground = BsColors.gray200;

  /// Secondary background.
  static const Color darkSecondaryBackground = BsColors.gray800;

  /// Tertiary color.
  static const Color tertiaryColor = Color(0x80212529);

  /// Tertiary color.
  static const Color darkTertiaryColor = Color(0x80DEE2E6);

  /// Tertiary background.
  static const Color tertiaryBackground = BsColors.gray100;

  /// Tertiary background in dark mode: halfway between the two darkest grays.
  static Color get darkTertiaryBackground => Color.lerp(BsColors.gray800, BsColors.gray900, 0.5)!;

  /// Emphasis color.
  static const Color emphasisColor = BsColors.black;

  /// Emphasis color.
  static const Color darkEmphasisColor = BsColors.white;

  static Color colorOf(BuildContext context) => _of(context, color, darkColor);
  static Color backgroundOf(BuildContext context) => _of(context, background, darkBackground);
  static Color secondaryColorOf(BuildContext context) => _of(context, secondaryColor, darkSecondaryColor);
  static Color secondaryBackgroundOf(BuildContext context) =>
      _of(context, secondaryBackground, darkSecondaryBackground);
  static Color tertiaryColorOf(BuildContext context) => _of(context, tertiaryColor, darkTertiaryColor);
  static Color tertiaryBackgroundOf(BuildContext context) =>
      BsTheme.of(context) == Brightness.dark ? darkTertiaryBackground : tertiaryBackground;
  static Color emphasisColorOf(BuildContext context) => _of(context, emphasisColor, darkEmphasisColor);

  static Color _of(BuildContext context, Color light, Color dark) =>
      BsTheme.of(context) == Brightness.dark ? dark : light;
}
