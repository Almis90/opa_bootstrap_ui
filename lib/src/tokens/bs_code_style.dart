import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_color_utils.dart';
import '../bs_colors.dart';
import 'bs_body.dart';

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

  /// `$code-color` (`$pink`).
  static const Color defaultCodeColor = BsColors.pink;

  /// `$code-color-dark` (`tint-color($code-color, 40%)`).
  static Color get defaultDarkCodeColor => BsColorUtils.tint(defaultCodeColor, 0.4);

  static const EdgeInsets defaultKbdPadding = EdgeInsets.symmetric(horizontal: 6, vertical: 3);
  static const double defaultKbdFontSize = defaultCodeFontSize;

  /// `$kbd-color` (`var(--bs-body-bg)`).
  static const Color defaultKbdColor = BsColors.white;

  /// [defaultKbdColor] resolved against `--bs-body-bg` in
  /// `[data-bs-theme="dark"]`.
  static const Color defaultDarkKbdColor = BsBody.darkBackground;

  /// `$kbd-bg` (`var(--bs-body-color)`).
  static const Color defaultKbdBackground = BsColors.gray900;

  /// [defaultKbdBackground] resolved against `--bs-body-color` in
  /// `[data-bs-theme="dark"]`.
  static const Color defaultDarkKbdBackground = BsBody.darkColor;

  static const BsCodeStyle defaults = BsCodeStyle(
    codeFontSize: defaultCodeFontSize,
    codeColor: defaultCodeColor,
    kbdPadding: defaultKbdPadding,
    kbdFontSize: defaultKbdFontSize,
    kbdColor: defaultKbdColor,
    kbdBackground: defaultKbdBackground,
  );

  /// [defaults], with every brightness-sensitive field swapped for its
  /// `[data-bs-theme="dark"]` counterpart. Pick this as the base to
  /// [merge] a caller's [BsCodeStyle] override against when
  /// `BsTheme.of(context) == Brightness.dark`.
  static BsCodeStyle get darkDefaults => BsCodeStyle(
    codeFontSize: defaultCodeFontSize,
    codeColor: defaultDarkCodeColor,
    kbdPadding: defaultKbdPadding,
    kbdFontSize: defaultKbdFontSize,
    kbdColor: defaultDarkKbdColor,
    kbdBackground: defaultDarkKbdBackground,
  );
}
