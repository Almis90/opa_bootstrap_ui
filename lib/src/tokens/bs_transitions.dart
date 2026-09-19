import 'package:flutter/animation.dart';

/// Bootstrap's generic, cross-component transition tokens.
///
/// Mirrors the base `$transition-*` variables from Bootstrap's SCSS source
/// (component-specific transitions, like a button's, live on that
/// component's own style class instead).
abstract final class BsTransitions {
  /// `$transition-base: all .2s ease-in-out`.
  static const Duration base = Duration(milliseconds: 200);
  static const Curve baseCurve = Curves.easeInOut;

  /// `$transition-fade: opacity .15s linear`.
  static const Duration fade = Duration(milliseconds: 150);
  static const Curve fadeCurve = Curves.linear;

  /// `$transition-collapse: height .35s ease`.
  static const Duration collapse = Duration(milliseconds: 350);
  static const Curve collapseCurve = Curves.ease;
}
