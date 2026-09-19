import 'package:flutter/painting.dart';

/// Color math mirroring Bootstrap's Sass color functions
/// (`shift-color`, `shade-color`, `tint-color`, `color-contrast`).
abstract final class BsColorUtils {
  /// Mirrors Sass `mix($color1, $color2, $weight)`: blends [color1] into
  /// [color2] by [weight] (0-1), where `1.0` returns pure [color1].
  static Color mix(Color color1, Color color2, double weight) {
    return Color.lerp(color2, color1, weight)!;
  }

  /// Mirrors Sass `shade-color($color, $weight)`: mixes [color] with black,
  /// darkening it. [weight] is 0-1 (Bootstrap's default button hover/active
  /// shades use .15/.20).
  static Color shade(Color color, double weight) {
    return mix(const Color(0xFF000000), color, weight);
  }

  /// Mirrors Sass `tint-color($color, $weight)`: mixes [color] with white,
  /// lightening it.
  static Color tint(Color color, double weight) {
    return mix(const Color(0xFFFFFFFF), color, weight);
  }

  /// Mirrors Sass `color-contrast($background)`: prefers white text, falling
  /// back to black when white doesn't meet [minContrastRatio] (Bootstrap's
  /// `$min-contrast-ratio: 4.5`) against [background], and otherwise
  /// whichever of the two contrasts more.
  static Color contrast(Color background, {double minContrastRatio = 4.5}) {
    const black = Color(0xFF000000);
    const white = Color(0xFFFFFFFF);
    final whiteContrast = _contrastRatio(background, white);
    if (whiteContrast >= minContrastRatio) return white;

    final blackContrast = _contrastRatio(background, black);
    if (blackContrast >= minContrastRatio) return black;

    return blackContrast >= whiteContrast ? black : white;
  }

  static double _contrastRatio(Color a, Color b) {
    final lumA = a.computeLuminance();
    final lumB = b.computeLuminance();
    final brightest = lumA > lumB ? lumA : lumB;
    final darkest = lumA > lumB ? lumB : lumA;
    return (brightest + 0.05) / (darkest + 0.05);
  }
}
