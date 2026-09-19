import 'package:flutter/painting.dart';

/// Bootstrap's global box-shadow tokens.
///
/// Mirrors the `box-shadow-variables` group from Bootstrap's SCSS source
/// (`$box-shadow*`), using [BoxShadow.blurStyle] `inner` to replicate CSS
/// `inset` shadows.
abstract final class BsShadows {
  /// `$box-shadow: 0 .5rem 1rem rgba($black, .15)`.
  static const List<BoxShadow> shadow = [
    BoxShadow(color: Color(0x26000000), offset: Offset(0, 8), blurRadius: 16),
  ];

  /// `$box-shadow-sm: 0 .125rem .25rem rgba($black, .075)`.
  static const List<BoxShadow> shadowSm = [
    BoxShadow(color: Color(0x13000000), offset: Offset(0, 2), blurRadius: 4),
  ];

  /// `$box-shadow-lg: 0 1rem 3rem rgba($black, .175)`.
  static const List<BoxShadow> shadowLg = [
    BoxShadow(color: Color(0x2D000000), offset: Offset(0, 16), blurRadius: 48),
  ];

  /// `$box-shadow-inset: inset 0 1px 2px rgba($black, .075)`.
  static const List<BoxShadow> shadowInset = [
    BoxShadow(color: Color(0x13000000), offset: Offset(0, 1), blurRadius: 2, blurStyle: BlurStyle.inner),
  ];
}
