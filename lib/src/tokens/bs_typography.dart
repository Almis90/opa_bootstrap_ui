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

  /// Font size sm.
  static const double fontSizeSm = 14;

  /// Font size base.
  static const double fontSizeBase = 16;

  /// Font size lg.
  static const double fontSizeLg = 20;

  static const FontWeight fontWeightLighter = FontWeight.w200;
  static const FontWeight fontWeightLight = FontWeight.w300;
  static const FontWeight fontWeightNormal = FontWeight.w400;
  static const FontWeight fontWeightMedium = FontWeight.w500;
  static const FontWeight fontWeightSemibold = FontWeight.w600;
  static const FontWeight fontWeightBold = FontWeight.w700;
  static const FontWeight fontWeightBolder = FontWeight.w800;

  /// Font weight base.
  static const FontWeight fontWeightBase = fontWeightNormal;

  /// Line height base.
  static const double lineHeightBase = 1.5;

  /// Line height sm.
  static const double lineHeightSm = 1.25;

  /// Line height lg.
  static const double lineHeightLg = 2;

  /// H1 font size.
  static const double h1FontSize = 40;

  /// H2 font size.
  static const double h2FontSize = 32;

  /// H3 font size.
  static const double h3FontSize = 28;

  /// H4 font size.
  static const double h4FontSize = 24;

  /// H5 font size.
  static const double h5FontSize = 20;

  /// H6 font size.
  static const double h6FontSize = 16;

  /// Headings margin bottom.
  static const double headingsMarginBottom = 8;

  /// Headings font weight.
  static const FontWeight headingsFontWeight = fontWeightMedium;

  /// Headings line height.
  static const double headingsLineHeight = 1.2;

  /// Font sizes of the display headings, from the largest (1) to the smallest (6).
  static const double displayFontSize1 = 80;
  static const double displayFontSize2 = 72;
  static const double displayFontSize3 = 64;
  static const double displayFontSize4 = 56;
  static const double displayFontSize5 = 48;
  static const double displayFontSize6 = 40;

  /// Display font weight.
  static const FontWeight displayFontWeight = fontWeightLight;

  /// Display line height.
  static const double displayLineHeight = headingsLineHeight;

  /// Lead font size.
  static const double leadFontSize = 20;

  /// Lead font weight.
  static const FontWeight leadFontWeight = fontWeightLight;

  /// Small font size multiplier.
  static const double smallFontSizeMultiplier = 0.875;

  /// Sub sup font size multiplier.
  static const double subSupFontSizeMultiplier = 0.75;

  /// Blockquote font size.
  static const double blockquoteFontSize = 20;

  /// Hr opacity.
  static const double hrOpacity = 0.25;

  /// Paragraph margin bottom.
  static const double paragraphMarginBottom = 16;

  /// Blockquote margin y.
  static const double blockquoteMarginY = 16;

  /// Blockquote footer color.
  static const Color blockquoteFooterColor = Color(0xFF6C757D);

  /// Blockquote footer font size.
  static const double blockquoteFooterFontSize = fontSizeSm;

  /// Padding of highlighted text, applied on all sides.
  static const double markPadding = 3;
}
