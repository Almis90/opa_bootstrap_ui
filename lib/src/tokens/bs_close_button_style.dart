import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_colors.dart';
import 'bs_focus_ring.dart';

/// A Bootstrap `.btn-close`'s visual variables.
///
/// Mirrors the `close-variables` group from Bootstrap's SCSS source
/// (`$btn-close-*`), assuming the default `16px` root font size (so `1em`
/// resolves against the base font size).
@immutable
class BsCloseButtonStyle {
  const BsCloseButtonStyle({
    this.size,
    this.padding,
    this.color,
    this.opacity,
    this.hoverOpacity,
    this.focusOpacity,
    this.disabledOpacity,
  });

  /// `$btn-close-width`/`$btn-close-height` (`1em`).
  final double? size;

  /// `$btn-close-padding-x`/`$btn-close-padding-y` (`.25em`).
  final EdgeInsetsGeometry? padding;

  /// `$btn-close-color` (`$black`).
  final Color? color;

  /// `$btn-close-opacity` (`.5`).
  final double? opacity;

  /// `$btn-close-hover-opacity` (`.75`).
  final double? hoverOpacity;

  /// `$btn-close-focus-opacity` (`1`).
  final double? focusOpacity;

  /// `$btn-close-disabled-opacity` (`.25`).
  final double? disabledOpacity;

  BsCloseButtonStyle merge(BsCloseButtonStyle? other) {
    if (other == null) return this;
    return BsCloseButtonStyle(
      size: other.size ?? size,
      padding: other.padding ?? padding,
      color: other.color ?? color,
      opacity: other.opacity ?? opacity,
      hoverOpacity: other.hoverOpacity ?? hoverOpacity,
      focusOpacity: other.focusOpacity ?? focusOpacity,
      disabledOpacity: other.disabledOpacity ?? disabledOpacity,
    );
  }

  static const double defaultSize = 16;
  static const EdgeInsets defaultPadding = EdgeInsets.all(4);

  /// `$btn-close-color` (`$black`).
  static const Color defaultColor = BsColors.black;

  /// `[data-bs-theme="dark"] .btn-close`'s `filter: $btn-close-white-filter`
  /// (`invert(1) grayscale(100%)`) — this port paints the glyph with a
  /// literal color rather than a CSS filter, so the dark-mode equivalent is
  /// simply white.
  static const Color defaultDarkColor = BsColors.white;

  static const double defaultOpacity = 0.5;
  static const double defaultHoverOpacity = 0.75;
  static const double defaultFocusOpacity = 1;
  static const double defaultDisabledOpacity = 0.25;

  /// `$btn-close-focus-shadow` (`$focus-ring-box-shadow`).
  static const double defaultFocusRingWidth = BsFocusRing.width;

  static const BsCloseButtonStyle defaults = BsCloseButtonStyle(
    size: defaultSize,
    padding: defaultPadding,
    color: defaultColor,
    opacity: defaultOpacity,
    hoverOpacity: defaultHoverOpacity,
    focusOpacity: defaultFocusOpacity,
    disabledOpacity: defaultDisabledOpacity,
  );

  /// [defaults], with [color] swapped for its `[data-bs-theme="dark"]`
  /// counterpart. Pick this as the base to [merge] a caller's
  /// [BsCloseButtonStyle] override against when
  /// `BsTheme.of(context) == Brightness.dark`.
  static const BsCloseButtonStyle darkDefaults = BsCloseButtonStyle(
    size: defaultSize,
    padding: defaultPadding,
    color: defaultDarkColor,
    opacity: defaultOpacity,
    hoverOpacity: defaultHoverOpacity,
    focusOpacity: defaultFocusOpacity,
    disabledOpacity: defaultDisabledOpacity,
  );
}
