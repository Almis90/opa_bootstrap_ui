import 'package:flutter/painting.dart';

/// Bootstrap's global typography tokens.
///
/// Mirrors the `font-variables`, `font-sizes`, `headings-variables`,
/// `display-headings`, and `type-variables` groups from Bootstrap's SCSS
/// source, assuming the default `16px` root font size.
abstract final class BsTypography {
  /// `$font-family-sans-serif`'s cross-platform fallback stack.
  static const List<String> fontFamilySansSerif = [
    '-apple-system',
    'Segoe UI',
    'Roboto',
    'Helvetica Neue',
    'Arial',
    'sans-serif',
  ];

  /// `$font-family-monospace`'s cross-platform fallback stack.
  static const List<String> fontFamilyMonospace = ['Menlo', 'Monaco', 'Consolas', 'Courier New', 'monospace'];

  /// `$font-size-sm` (`$font-size-base * .875`).
  static const double fontSizeSm = 14;

  /// `$font-size-base` (`1rem`).
  static const double fontSizeBase = 16;

  /// `$font-size-lg` (`$font-size-base * 1.25`).
  static const double fontSizeLg = 20;

  static const FontWeight fontWeightLighter = FontWeight.w200;
  static const FontWeight fontWeightLight = FontWeight.w300;
  static const FontWeight fontWeightNormal = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemibold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;
  static const FontWeight fontWeightBolder = FontWeight.w800;

  /// `$font-weight-base` (`$font-weight-normal`).
  static const FontWeight fontWeightBase = fontWeightNormal;

  /// `$line-height-base` (`1.5`).
  static const double lineHeightBase = 1.5;

  /// `$line-height-sm` (`1.25`).
  static const double lineHeightSm = 1.25;

  /// `$line-height-lg` (`2`).
  static const double lineHeightLg = 2;

  /// `$h1-font-size` (`$font-size-base * 2.5`).
  static const double h1FontSize = 40;

  /// `$h2-font-size` (`$font-size-base * 2`).
  static const double h2FontSize = 32;

  /// `$h3-font-size` (`$font-size-base * 1.75`).
  static const double h3FontSize = 28;

  /// `$h4-font-size` (`$font-size-base * 1.5`).
  static const double h4FontSize = 24;

  /// `$h5-font-size` (`$font-size-base * 1.25`).
  static const double h5FontSize = 20;

  /// `$h6-font-size` (`$font-size-base`).
  static const double h6FontSize = 16;

  /// `$headings-margin-bottom` (`$spacer * .5`).
  static const double headingsMarginBottom = 8;

  /// `$headings-font-weight` (`500`).
  static const FontWeight headingsFontWeight = fontWeightMedium;

  /// `$headings-line-height` (`1.2`).
  static const double headingsLineHeight = 1.2;

  /// `$display-font-sizes` map (1-6).
  static const double displayFontSize1 = 80;
  static const double displayFontSize2 = 72;
  static const double displayFontSize3 = 64;
  static const double displayFontSize4 = 56;
  static const double displayFontSize5 = 48;
  static const double displayFontSize6 = 40;

  /// `$display-font-weight` (`300`).
  static const FontWeight displayFontWeight = fontWeightLight;

  /// `$display-line-height` (`$headings-line-height`).
  static const double displayLineHeight = headingsLineHeight;

  /// `$lead-font-size` (`$font-size-base * 1.25`).
  static const double leadFontSize = 20;

  /// `$lead-font-weight` (`300`).
  static const FontWeight leadFontWeight = fontWeightLight;

  /// `$small-font-size` (`.875em`, relative to the surrounding text).
  static const double smallFontSizeMultiplier = 0.875;

  /// `$sub-sup-font-size` (`.75em`, relative to the surrounding text).
  static const double subSupFontSizeMultiplier = 0.75;

  /// `$blockquote-font-size` (`$font-size-base * 1.25`).
  static const double blockquoteFontSize = 20;

  /// `$hr-opacity` (`.25`).
  static const double hrOpacity = 0.25;

  /// `$paragraph-margin-bottom` (`1rem`).
  static const double paragraphMarginBottom = 16;
}
