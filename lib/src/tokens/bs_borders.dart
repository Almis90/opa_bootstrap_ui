import 'package:flutter/painting.dart';

import '../bs_colors.dart';

/// Bootstrap's global border tokens.
///
/// Mirrors the `border-variables` and `border-radius-variables` groups from
/// Bootstrap's SCSS source (`$border-width`, `$border-color*`,
/// `$border-radius*`).
abstract final class BsBorders {
  /// `$border-width` (`1px`).
  static const double width = 1;

  /// `$border-color` (`$gray-300`).
  static const Color color = BsColors.gray300;

  /// `$border-color-translucent` (`rgba($black, .175)`).
  static const Color colorTranslucent = Color(0x2D000000);

  /// `$border-radius-sm` (`.25rem`).
  static const double radiusSm = 4;

  /// `$border-radius` (`.375rem`).
  static const double radius = 6;

  /// `$border-radius-lg` (`.5rem`).
  static const double radiusLg = 8;

  /// `$border-radius-xl` (`1rem`).
  static const double radiusXl = 16;

  /// `$border-radius-xxl` (`2rem`).
  static const double radiusXxl = 32;

  /// `$border-radius-pill` (`50rem`).
  static const double radiusPill = 800;
}
