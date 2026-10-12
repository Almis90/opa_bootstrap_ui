import 'package:flutter/widgets.dart';

import '../bs_colors.dart';
import '../bs_theme.dart';

/// Bootstrap's base tokens for the page: the text and background colors many
/// components default to.
///
/// Use the `Of` methods (for example [colorOf]) to resolve against the ambient [BsTheme]
/// instead of reading [color] or [darkColor] directly.
abstract final class BsBody {
  static const Color color = BsColors.gray900;

  static const Color darkColor = BsColors.gray300;

  static const Color background = BsColors.white;

  static const Color darkBackground = BsColors.gray900;

  static const Color secondaryColor = Color(0xBF212529);

  static const Color darkSecondaryColor = Color(0xBFDEE2E6);

  static const Color secondaryBackground = BsColors.gray200;

  static const Color darkSecondaryBackground = BsColors.gray800;

  static const Color tertiaryColor = Color(0x80212529);

  static const Color darkTertiaryColor = Color(0x80DEE2E6);

  static const Color tertiaryBackground = BsColors.gray100;

  /// Tertiary background in dark mode: halfway between the two darkest grays.
  static Color get darkTertiaryBackground => Color.lerp(BsColors.gray800, BsColors.gray900, 0.5)!;

  static const Color emphasisColor = BsColors.black;

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
