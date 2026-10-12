import 'package:flutter/painting.dart';

/// Bootstrap's global shadow tokens: the regular, small, large and inset shadows.
///
/// Inset shadows use [BoxShadow.blurStyle] `inner`.
///
/// Flutter sizes a blur differently from the web: a web blur radius `B` is a Gaussian of standard
/// deviation `B / 2`, while Flutter turns a [BoxShadow.blurRadius] `r` into `r * 0.57735 + 0.5`.
/// The blur radii below are `(B / 2 - 0.5) / 0.57735` for the web radius `B` (16, 4, 48 and 2
/// respectively), so that the shadows fall off as they do on the web.
abstract final class BsShadows {
  /// The default shadow, for elevated surfaces.
  static const List<BoxShadow> shadow = [
    BoxShadow(color: Color(0x26000000), offset: Offset(0, 8), blurRadius: 12.99),
  ];

  /// A small, tight shadow.
  static const List<BoxShadow> shadowSm = [
    BoxShadow(color: Color(0x13000000), offset: Offset(0, 2), blurRadius: 2.6),
  ];

  /// A large, soft shadow.
  static const List<BoxShadow> shadowLg = [
    BoxShadow(color: Color(0x2D000000), offset: Offset(0, 16), blurRadius: 40.7),
  ];

  /// A subtle inset shadow, for recessed surfaces.
  static const List<BoxShadow> shadowInset = [
    BoxShadow(color: Color(0x13000000), offset: Offset(0, 1), blurRadius: 0.87, blurStyle: BlurStyle.inner),
  ];
}
