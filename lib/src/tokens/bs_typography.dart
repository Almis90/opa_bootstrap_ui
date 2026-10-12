import 'package:flutter/painting.dart';

/// Bootstrap's global typography tokens: font stacks, font sizes, heading and display
/// styles and line heights, assuming the default 16 logical pixel base font size.
abstract final class BsTypography {
  /// Cross-platform fallback stack for sans-serif text.
  static const List<String> fontFamilySansSerif = [
    'system-ui',
    '-apple-system',
    'Segoe UI',
    'Roboto',
    'Helvetica Neue',
    'Arial',
    'sans-serif',
  ];

  /// Cross-platform fallback stack for monospace text.
  static const List<String> fontFamilyMonospace = ['Menlo', 'Monaco', 'Consolas', 'Courier New', 'monospace'];

  static const double fontSizeSm = 14;

  static const double fontSizeBase = 16;

  static const double fontSizeLg = 20;

  static const FontWeight fontWeightLighter = FontWeight.w200;
  static const FontWeight fontWeightLight = FontWeight.w300;
  static const FontWeight fontWeightNormal = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemibold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;
  static const FontWeight fontWeightBolder = FontWeight.w800;

  static const FontWeight fontWeightBase = fontWeightNormal;

  static const double lineHeightBase = 1.5;

  static const double lineHeightSm = 1.25;

  static const double lineHeightLg = 2;

  static const double h1FontSize = 40;

  static const double h2FontSize = 32;

  static const double h3FontSize = 28;

  static const double h4FontSize = 24;

  static const double h5FontSize = 20;

  static const double h6FontSize = 16;

  static const double headingsMarginBottom = 8;

  static const FontWeight headingsFontWeight = fontWeightMedium;

  static const double headingsLineHeight = 1.2;

  /// Font sizes of the display headings, from the largest (1) to the smallest (6).
  static const double displayFontSize1 = 80;
  static const double displayFontSize2 = 72;
  static const double displayFontSize3 = 64;
  static const double displayFontSize4 = 56;
  static const double displayFontSize5 = 48;
  static const double displayFontSize6 = 40;

  static const FontWeight displayFontWeight = fontWeightLight;

  static const double displayLineHeight = headingsLineHeight;

  static const double leadFontSize = 20;

  static const FontWeight leadFontWeight = fontWeightLight;

  static const double smallFontSizeMultiplier = 0.875;

  static const double subSupFontSizeMultiplier = 0.75;

  static const double blockquoteFontSize = 20;

  static const double hrOpacity = 0.25;

  static const double paragraphMarginBottom = 16;

  static const double blockquoteMarginY = 16;

  static const Color blockquoteFooterColor = Color(0xFF6C757D);

  static const double blockquoteFooterFontSize = fontSizeSm;

  /// Padding of highlighted text, applied on all sides.
  static const double markPadding = 3;
}
