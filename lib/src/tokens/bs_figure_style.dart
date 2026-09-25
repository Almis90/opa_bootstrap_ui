import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_colors.dart';
import 'bs_body.dart';

/// A Bootstrap `.figure`'s visual variables.
///
/// Mirrors the `figure-variables` group from Bootstrap's SCSS source
/// (`$figure-*`).
@immutable
class BsFigureStyle {
  const BsFigureStyle({this.captionFontSize, this.captionColor});

  /// `$figure-caption-font-size` (`$small-font-size`, i.e. `.875em`).
  final double? captionFontSize;

  /// `$figure-caption-color` (`var(--bs-secondary-color)`).
  final Color? captionColor;

  BsFigureStyle merge(BsFigureStyle? other) {
    if (other == null) return this;
    return BsFigureStyle(
      captionFontSize: other.captionFontSize ?? captionFontSize,
      captionColor: other.captionColor ?? captionColor,
    );
  }

  /// `$small-font-size` (`.875em`, assuming a `16px` root font size).
  static const double defaultCaptionFontSize = 14;

  /// `$figure-caption-color` (`var(--bs-secondary-color)`).
  static const Color defaultCaptionColor = BsColors.gray600;

  /// [defaultCaptionColor] resolved against `--bs-secondary-color` in
  /// `[data-bs-theme="dark"]`.
  static const Color defaultDarkCaptionColor = BsBody.darkSecondaryColor;

  static const BsFigureStyle defaults = BsFigureStyle(
    captionFontSize: defaultCaptionFontSize,
    captionColor: defaultCaptionColor,
  );

  /// [defaults], with [captionColor] swapped for its
  /// `[data-bs-theme="dark"]` counterpart. Pick this as the base to
  /// [merge] a caller's [BsFigureStyle] override against when
  /// `BsTheme.of(context) == Brightness.dark`.
  static const BsFigureStyle darkDefaults = BsFigureStyle(
    captionFontSize: defaultCaptionFontSize,
    captionColor: defaultDarkCaptionColor,
  );
}
