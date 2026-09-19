import 'package:flutter/painting.dart';

/// Bootstrap's base color palette.
///
/// Mirrors the `$grays` and `$colors` maps from Bootstrap's SCSS source.
abstract final class BsColors {
  // scss-docs-start gray-color-variables
  static const Color white = Color(0xFFFFFFFF);
  static const Color gray100 = Color(0xFFF8F9FA);
  static const Color gray200 = Color(0xFFE9ECEF);
  static const Color gray300 = Color(0xFFDEE2E6);
  static const Color gray400 = Color(0xFFCED4DA);
  static const Color gray500 = Color(0xFFADB5BD);
  static const Color gray600 = Color(0xFF6C757D);
  static const Color gray700 = Color(0xFF495057);
  static const Color gray800 = Color(0xFF343A40);
  static const Color gray900 = Color(0xFF212529);
  static const Color black = Color(0xFF000000);
  // scss-docs-end gray-color-variables

  // scss-docs-start color-variables
  static const Color blue = Color(0xFF0D6EFD);
  static const Color indigo = Color(0xFF6610F2);
  static const Color purple = Color(0xFF6F42C1);
  static const Color pink = Color(0xFFD63384);
  static const Color red = Color(0xFFDC3545);
  static const Color orange = Color(0xFFFD7E14);
  static const Color yellow = Color(0xFFFFC107);
  static const Color green = Color(0xFF198754);
  static const Color teal = Color(0xFF20C997);
  static const Color cyan = Color(0xFF0DCAF0);
  // scss-docs-end color-variables
}
