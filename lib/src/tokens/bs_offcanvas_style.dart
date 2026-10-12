import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_colors.dart';
import 'bs_body.dart';
import 'bs_borders.dart';
import 'bs_shadows.dart';

/// Visual variables of a Bootstrap offcanvas.
///
/// Every field is nullable: null falls back to the matching `default…` constant.
/// [merge] layers overrides on top of [defaults] or, in dark mode, [darkDefaults].
@immutable
class BsOffcanvasStyle {
  const BsOffcanvasStyle({
    this.padding,
    this.horizontalWidth,
    this.verticalHeightFraction,
    this.transitionDuration,
    this.borderColor,
    this.borderWidth,
    this.titleLineHeight,
    this.background,
    this.color,
    this.boxShadow,
    this.backdropColor,
    this.backdropOpacity,
  });

  /// Padding of the header and body.
  final EdgeInsetsGeometry? padding;

  /// Horizontal width.
  final double? horizontalWidth;

  /// Vertical height fraction.
  final double? verticalHeightFraction;

  /// Transition duration.
  final Duration? transitionDuration;

  /// Border color.
  final Color? borderColor;

  /// Border width.
  final double? borderWidth;

  /// Title line height.
  final double? titleLineHeight;

  /// Background color.
  final Color? background;

  /// Text color.
  final Color? color;

  /// Drop shadow of the panel. Null by default (no shadow); pass [defaultBoxShadow] to opt in.
  final List<BoxShadow>? boxShadow;

  /// Backdrop color.
  final Color? backdropColor;

  /// Backdrop opacity.
  final double? backdropOpacity;

  BsOffcanvasStyle merge(BsOffcanvasStyle? other) {
    if (other == null) return this;
    return BsOffcanvasStyle(
      padding: other.padding ?? padding,
      horizontalWidth: other.horizontalWidth ?? horizontalWidth,
      verticalHeightFraction: other.verticalHeightFraction ?? verticalHeightFraction,
      transitionDuration: other.transitionDuration ?? transitionDuration,
      borderColor: other.borderColor ?? borderColor,
      borderWidth: other.borderWidth ?? borderWidth,
      titleLineHeight: other.titleLineHeight ?? titleLineHeight,
      background: other.background ?? background,
      color: other.color ?? color,
      boxShadow: other.boxShadow ?? boxShadow,
      backdropColor: other.backdropColor ?? backdropColor,
      backdropOpacity: other.backdropOpacity ?? backdropOpacity,
    );
  }

  static const EdgeInsets defaultPadding = EdgeInsets.all(16);
  static const double defaultHorizontalWidth = 400;
  static const double defaultVerticalHeightFraction = 0.3;
  static const Duration defaultTransitionDuration = Duration(milliseconds: 300);
  static const Color defaultBorderColor = BsBorders.colorTranslucent;

  /// Default border color in dark mode: translucent white.
  static const Color defaultDarkBorderColor = BsBorders.darkColorTranslucent;

  static const double defaultBorderWidth = BsBorders.width;
  static const double defaultTitleLineHeight = 1.5;
  static const Color defaultBackground = BsColors.white;

  /// Default background in dark mode.
  static const Color defaultDarkBackground = BsBody.darkBackground;

  static const Color defaultColor = BsColors.gray900;

  /// Default color in dark mode.
  static const Color defaultDarkColor = BsBody.darkColor;

  static const List<BoxShadow> defaultBoxShadow = BsShadows.shadowSm;

  /// Default backdrop color: black in both themes.
  static const Color defaultBackdropColor = BsColors.black;
  static const double defaultBackdropOpacity = 0.5;

  static const BsOffcanvasStyle defaults = BsOffcanvasStyle(
    padding: defaultPadding,
    horizontalWidth: defaultHorizontalWidth,
    verticalHeightFraction: defaultVerticalHeightFraction,
    transitionDuration: defaultTransitionDuration,
    borderColor: defaultBorderColor,
    borderWidth: defaultBorderWidth,
    titleLineHeight: defaultTitleLineHeight,
    background: defaultBackground,
    color: defaultColor,
    backdropColor: defaultBackdropColor,
    backdropOpacity: defaultBackdropOpacity,
  );

  /// Dark-mode counterpart of [defaults]: [borderColor], [background] and [color] are swapped, the
  /// rest is identical. Use it as the base to [merge] a caller's override when the ambient
  /// brightness is dark.
  static const BsOffcanvasStyle darkDefaults = BsOffcanvasStyle(
    padding: defaultPadding,
    horizontalWidth: defaultHorizontalWidth,
    verticalHeightFraction: defaultVerticalHeightFraction,
    transitionDuration: defaultTransitionDuration,
    borderColor: defaultDarkBorderColor,
    borderWidth: defaultBorderWidth,
    titleLineHeight: defaultTitleLineHeight,
    background: defaultDarkBackground,
    color: defaultDarkColor,
    backdropColor: defaultBackdropColor,
    backdropOpacity: defaultBackdropOpacity,
  );
}
