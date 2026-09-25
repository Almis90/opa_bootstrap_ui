import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';

import '../bs_colors.dart';
import 'bs_borders.dart';
import 'bs_shadows.dart';

/// A Bootstrap `.offcanvas`'s visual variables.
///
/// Mirrors the `offcanvas-variables` group from Bootstrap's SCSS source
/// (`$offcanvas-*`).
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

  /// `$offcanvas-padding-y`/`$offcanvas-padding-x` (`$modal-inner-padding`).
  final EdgeInsetsGeometry? padding;

  /// `$offcanvas-horizontal-width` (`400px`).
  final double? horizontalWidth;

  /// `$offcanvas-vertical-height` (`30vh`, as a 0-1 fraction of the viewport).
  final double? verticalHeightFraction;

  /// `$offcanvas-transition-duration` (`.3s`).
  final Duration? transitionDuration;

  /// `$offcanvas-border-color` (`$modal-content-border-color`).
  final Color? borderColor;

  /// `$offcanvas-border-width` (`$modal-content-border-width`).
  final double? borderWidth;

  /// `$offcanvas-title-line-height` (`$modal-title-line-height`).
  final double? titleLineHeight;

  /// `$offcanvas-bg-color` (`var(--bs-body-bg)`).
  final Color? background;

  /// `$offcanvas-color` (`var(--bs-body-color)`).
  final Color? color;

  /// `$offcanvas-box-shadow` (`$modal-content-box-shadow-xs`).
  final List<BoxShadow>? boxShadow;

  /// `$offcanvas-backdrop-bg` (`$modal-backdrop-bg`, i.e. `$black`).
  final Color? backdropColor;

  /// `$offcanvas-backdrop-opacity` (`.5`).
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
  static const double defaultBorderWidth = BsBorders.width;
  static const double defaultTitleLineHeight = 1.5;
  static const Color defaultBackground = BsColors.white;
  static const Color defaultColor = BsColors.gray900;
  static const List<BoxShadow> defaultBoxShadow = BsShadows.shadowSm;
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
    boxShadow: defaultBoxShadow,
    backdropColor: defaultBackdropColor,
    backdropOpacity: defaultBackdropOpacity,
  );
}
