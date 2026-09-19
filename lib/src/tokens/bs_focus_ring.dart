import 'package:flutter/painting.dart';

import '../bs_variant.dart';

/// Bootstrap's global focus-ring tokens.
///
/// Mirrors the `focus-ring-variables` group from Bootstrap's SCSS source
/// (`$focus-ring-*`), used by form controls, buttons, and other focusable
/// components.
abstract final class BsFocusRing {
  /// `$focus-ring-width` (`.25rem`).
  static const double width = 4;

  /// `$focus-ring-opacity` (`.25`).
  static const double opacity = 0.25;

  /// `$focus-ring-blur` (`0`).
  static const double blur = 0;

  /// `$focus-ring-color: rgba($primary, $focus-ring-opacity)`.
  static Color color([Color? base]) => (base ?? BsVariant.primary.color).withValues(alpha: opacity);
}
