import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_colors.dart';

/// `code`/`kbd`/`pre` visual variables.
///
/// Mirrors the (unmarked) `Code` section of Bootstrap's SCSS source
/// (`$code-*`, `$kbd-*`, `$pre-*`), assuming the default `16px` root font
/// size.
@immutable
class BsCodeStyle {
  const BsCodeStyle({
    this.codeFontSize,
    this.codeColor,
    this.kbdPadding,
    this.kbdFontSize,
    this.kbdColor,
    this.kbdBackground,
    this.preColor,
  });

  /// `$code-font-size` (`$small-font-size`, i.e. `.875em`).
  final double? codeFontSize;

  /// `$code-color` (`$pink`).
  final Color? codeColor;

  /// `$kbd-padding-y`/`$kbd-padding-x` (`.1875rem`/`.375rem`).
  final EdgeInsetsGeometry? kbdPadding;

  /// `$kbd-font-size` (`$code-font-size`).
  final double? kbdFontSize;

  /// `$kbd-color` (`var(--bs-body-bg)`).
  final Color? kbdColor;

  /// `$kbd-bg` (`var(--bs-body-color)`).
  final Color? kbdBackground;

  /// `$pre-color` (`null`, inherits the surrounding text color).
  final Color? preColor;

  BsCodeStyle merge(BsCodeStyle? other) {
    if (other == null) return this;
    return BsCodeStyle(
      codeFontSize: other.codeFontSize ?? codeFontSize,
      codeColor: other.codeColor ?? codeColor,
      kbdPadding: other.kbdPadding ?? kbdPadding,
      kbdFontSize: other.kbdFontSize ?? kbdFontSize,
      kbdColor: other.kbdColor ?? kbdColor,
      kbdBackground: other.kbdBackground ?? kbdBackground,
      preColor: other.preColor ?? preColor,
    );
  }

  /// `$small-font-size` (`.875em`, assuming a `16px` root font size).
  static const double defaultCodeFontSize = 14;
  static const Color defaultCodeColor = BsColors.pink;
  static const EdgeInsets defaultKbdPadding = EdgeInsets.symmetric(horizontal: 6, vertical: 3);
  static const double defaultKbdFontSize = defaultCodeFontSize;
  static const Color defaultKbdColor = BsColors.white;
  static const Color defaultKbdBackground = BsColors.gray900;

  static const BsCodeStyle defaults = BsCodeStyle(
    codeFontSize: defaultCodeFontSize,
    codeColor: defaultCodeColor,
    kbdPadding: defaultKbdPadding,
    kbdFontSize: defaultKbdFontSize,
    kbdColor: defaultKbdColor,
    kbdBackground: defaultKbdBackground,
  );
}
