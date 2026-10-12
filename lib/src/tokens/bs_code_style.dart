import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_color_utils.dart';
import '../bs_colors.dart';
import 'bs_body.dart';

/// Visual variables of a Bootstrap code.
///
/// Every field is nullable: null falls back to the matching `default…` constant.
/// [merge] layers overrides on top of [defaults] or, in dark mode, [darkDefaults].
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

  /// Code font size.
  final double? codeFontSize;

  /// Code color.
  final Color? codeColor;

  /// Padding of keyboard input.
  final EdgeInsetsGeometry? kbdPadding;

  /// Kbd font size.
  final double? kbdFontSize;

  /// Kbd color.
  final Color? kbdColor;

  /// Kbd background.
  final Color? kbdBackground;

  /// Pre color.
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

  /// Default code font size.
  static const double defaultCodeFontSize = 14;

  /// Default code color.
  static const Color defaultCodeColor = BsColors.pink;

  /// Default code color in dark mode: a lighter tint of [defaultCodeColor].
  static Color get defaultDarkCodeColor => BsColorUtils.tint(defaultCodeColor, 0.4);

  static const EdgeInsets defaultKbdPadding = EdgeInsets.symmetric(horizontal: 6, vertical: 3);
  static const double defaultKbdFontSize = defaultCodeFontSize;

  /// Default kbd color.
  static const Color defaultKbdColor = BsColors.white;

  /// Default kbd color in dark mode.
  static const Color defaultDarkKbdColor = BsBody.darkBackground;

  /// Default kbd background.
  static const Color defaultKbdBackground = BsColors.gray900;

  /// Default kbd background in dark mode.
  static const Color defaultDarkKbdBackground = BsBody.darkColor;

  static const BsCodeStyle defaults = BsCodeStyle(
    codeFontSize: defaultCodeFontSize,
    codeColor: defaultCodeColor,
    kbdPadding: defaultKbdPadding,
    kbdFontSize: defaultKbdFontSize,
    kbdColor: defaultKbdColor,
    kbdBackground: defaultKbdBackground,
  );

  /// Dark-mode counterpart of [defaults]: every brightness-sensitive field is swapped. The rest is
  /// identical.
  /// Use it as the base to [merge] a caller's override when the ambient brightness is dark.
  static BsCodeStyle get darkDefaults => BsCodeStyle(
    codeFontSize: defaultCodeFontSize,
    codeColor: defaultDarkCodeColor,
    kbdPadding: defaultKbdPadding,
    kbdFontSize: defaultKbdFontSize,
    kbdColor: defaultDarkKbdColor,
    kbdBackground: defaultDarkKbdBackground,
  );
}
