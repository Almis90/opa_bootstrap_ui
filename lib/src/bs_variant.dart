import 'package:flutter/widgets.dart';

import 'bs_color_utils.dart';
import 'bs_colors.dart';
import 'bs_theme.dart';

/// Bootstrap's contextual color variants: primary, secondary, success, info, warning, danger,
/// light and dark.
enum BsVariant {
  primary(BsColors.blue),
  secondary(BsColors.gray600),
  success(BsColors.green),
  info(BsColors.cyan),
  warning(BsColors.yellow),
  danger(BsColors.red),
  light(BsColors.gray100),
  dark(BsColors.gray900);

  const BsVariant(this.color);

  /// The base color of this variant.
  final Color color;

  /// Bootstrap's name for this variant, as used in its utility names.
  String get className => name;

  /// A darkened, higher-contrast version of [color], meant for text on a [bgSubtle] background
  /// (for example in an alert or a badge). The light and dark variants use a fixed gray rather
  /// than the general darkening formula.
  Color get textEmphasis => switch (this) {
    BsVariant.light || BsVariant.dark => BsColors.gray700,
    _ => BsColorUtils.shade(color, 0.6),
  };

  /// A very light tint of [color], meant as a background behind [textEmphasis] text. The light
  /// and dark variants use fixed colors rather than the general tint formula.
  Color get bgSubtle => switch (this) {
    BsVariant.light => BsColorUtils.mix(BsColors.gray100, BsColors.white, 0.5),
    BsVariant.dark => BsColors.gray400,
    _ => BsColorUtils.tint(color, 0.8),
  };

  /// A light tint of [color], meant to border a [bgSubtle] background. The light and dark
  /// variants use fixed colors rather than the general tint formula.
  Color get borderSubtle => switch (this) {
    BsVariant.light => BsColors.gray200,
    BsVariant.dark => BsColors.gray500,
    _ => BsColorUtils.tint(color, 0.6),
  };

  /// Dark-mode counterpart of [textEmphasis]: a tint rather than a shade of [color], since dark
  /// surfaces need lighter text.
  Color get darkTextEmphasis => switch (this) {
    BsVariant.light => BsColors.gray100,
    BsVariant.dark => BsColors.gray300,
    _ => BsColorUtils.tint(color, 0.4),
  };

  /// Dark-mode counterpart of [bgSubtle]: a heavy shade rather than a tint, so that it reads as
  /// a dark surface.
  Color get darkBgSubtle => switch (this) {
    BsVariant.light => BsColors.gray800,
    BsVariant.dark => BsColorUtils.mix(BsColors.gray800, BsColors.black, 0.5),
    _ => BsColorUtils.shade(color, 0.8),
  };

  /// Dark-mode counterpart of [borderSubtle]: a shade rather than a tint.
  Color get darkBorderSubtle => switch (this) {
    BsVariant.light => BsColors.gray700,
    BsVariant.dark => BsColors.gray800,
    _ => BsColorUtils.shade(color, 0.4),
  };

  /// [textEmphasis] in light mode, [darkTextEmphasis] in dark mode.
  Color textEmphasisOf(BuildContext context) =>
      BsTheme.of(context) == Brightness.dark ? darkTextEmphasis : textEmphasis;

  /// [bgSubtle] in light mode, [darkBgSubtle] in dark mode.
  Color bgSubtleOf(BuildContext context) =>
      BsTheme.of(context) == Brightness.dark ? darkBgSubtle : bgSubtle;

  /// [borderSubtle] in light mode, [darkBorderSubtle] in dark mode.
  Color borderSubtleOf(BuildContext context) =>
      BsTheme.of(context) == Brightness.dark ? darkBorderSubtle : borderSubtle;
}
