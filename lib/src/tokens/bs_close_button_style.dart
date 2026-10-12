import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_colors.dart';
import 'bs_focus_ring.dart';

/// Visual variables of a Bootstrap close button.
///
/// Every field is nullable: null falls back to the matching `default…` constant.
/// [merge] layers overrides on top of [defaults] or, in dark mode, [darkDefaults].
@immutable
class BsCloseButtonStyle {
  const BsCloseButtonStyle({
    this.size,
    this.padding,
    this.color,
    this.background,
    this.borderRadius,
    this.opacity,
    this.hoverOpacity,
    this.focusOpacity,
    this.disabledOpacity,
  });

  /// Size of the glyph.
  final double? size;

  /// Padding around the glyph.
  final EdgeInsetsGeometry? padding;

  final Color? color;

  /// Background behind the glyph; none by default. It fades with the button.
  final Color? background;

  /// The background's corner radius.
  final BorderRadiusGeometry? borderRadius;

  final double? opacity;

  final double? hoverOpacity;

  final double? focusOpacity;

  final double? disabledOpacity;

  BsCloseButtonStyle merge(BsCloseButtonStyle? other) {
    if (other == null) return this;
    return BsCloseButtonStyle(
      size: other.size ?? size,
      padding: other.padding ?? padding,
      color: other.color ?? color,
      background: other.background ?? background,
      borderRadius: other.borderRadius ?? borderRadius,
      opacity: other.opacity ?? opacity,
      hoverOpacity: other.hoverOpacity ?? hoverOpacity,
      focusOpacity: other.focusOpacity ?? focusOpacity,
      disabledOpacity: other.disabledOpacity ?? disabledOpacity,
    );
  }

  static const double defaultSize = 16;
  static const EdgeInsets defaultPadding = EdgeInsets.all(4);

  static const Color defaultColor = BsColors.black;

  /// Default glyph color in dark mode: white.
  static const Color defaultDarkColor = BsColors.white;

  static const double defaultOpacity = 0.5;
  static const double defaultHoverOpacity = 0.75;
  static const double defaultFocusOpacity = 1;
  static const double defaultDisabledOpacity = 0.25;

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

  /// Dark-mode counterpart of [defaults]: [color] is swapped, the rest is identical. Use it as the
  /// base to [merge] a caller's override when the ambient brightness is dark.
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
