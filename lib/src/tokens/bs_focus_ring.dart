import 'package:flutter/painting.dart';

import '../bs_variant.dart';

/// Bootstrap's global focus-ring tokens, used by form controls, buttons and other
/// focusable components.
abstract final class BsFocusRing {
  /// Width.
  static const double width = 4;

  /// Opacity.
  static const double opacity = 0.25;

  /// Blur.
  static const double blur = 0;

  /// Default focus ring color: the primary color at the ring's opacity.
  static Color color([Color? base]) => (base ?? BsVariant.primary.color).withValues(alpha: opacity);
}
