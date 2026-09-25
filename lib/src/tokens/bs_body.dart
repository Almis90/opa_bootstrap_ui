import 'package:flutter/widgets.dart';

import '../bs_colors.dart';
import '../bs_theme.dart';

/// Bootstrap's `<body>` tokens — the base text/background colors many
/// components default to (e.g. `$modal-content-bg: var(--bs-body-bg)`).
///
/// Mirrors the `body-variables` group from Bootstrap's SCSS source, plus
/// the `-dark` counterparts from `_variables-dark.scss` that Bootstrap's
/// `[data-bs-theme="dark"]` swaps `var(--bs-body-*)` to. Use the `Of`
/// methods (e.g. [colorOf]) to resolve against the ambient [BsTheme]
/// instead of reading [color]/[darkColor] etc. directly.
abstract final class BsBody {
  /// `$body-color` (`$gray-900`).
  static const Color color = BsColors.gray900;

  /// `$body-color-dark` (`$gray-300`).
  static const Color darkColor = BsColors.gray300;

  /// `$body-bg` (`$white`).
  static const Color background = BsColors.white;

  /// `$body-bg-dark` (`$gray-900`).
  static const Color darkBackground = BsColors.gray900;

  /// `$body-secondary-color` (`rgba($body-color, .75)`).
  static const Color secondaryColor = Color(0xBF212529);

  /// `$body-secondary-color-dark` (`rgba($body-color-dark, .75)`).
  static const Color darkSecondaryColor = Color(0xBFDEE2E6);

  /// `$body-secondary-bg` (`$gray-200`).
  static const Color secondaryBackground = BsColors.gray200;

  /// `$body-secondary-bg-dark` (`$gray-800`).
  static const Color darkSecondaryBackground = BsColors.gray800;

  /// `$body-tertiary-color` (`rgba($body-color, .5)`).
  static const Color tertiaryColor = Color(0x80212529);

  /// `$body-tertiary-color-dark` (`rgba($body-color-dark, .5)`).
  static const Color darkTertiaryColor = Color(0x80DEE2E6);

  /// `$body-tertiary-bg` (`$gray-100`).
  static const Color tertiaryBackground = BsColors.gray100;

  /// `$body-tertiary-bg-dark` (`mix($gray-800, $gray-900, 50%)`).
  static Color get darkTertiaryBackground => Color.lerp(BsColors.gray800, BsColors.gray900, 0.5)!;

  /// `$body-emphasis-color` (`$black`).
  static const Color emphasisColor = BsColors.black;

  /// `$body-emphasis-color-dark` (`$white`).
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
