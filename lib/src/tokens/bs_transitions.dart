import 'package:flutter/widgets.dart';

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

  /// [resolve] collapses a reduced [duration] to this rather than
  /// [Duration.zero] — `AnimatedSize` (used by [BsCollapse]/[BsAccordion]/
  /// [BsAlert]) has a re-entrancy bug where an exact zero duration makes
  /// `RenderAnimatedSize` mutate itself mid-`performLayout`, throwing.
  /// One millisecond is short enough to read as instant while staying
  /// clear of that edge case.
  static const Duration reducedMotionDuration = Duration(milliseconds: 1);

  /// Resolves [duration] against the user's reduced-motion accessibility
  /// preference, mirroring Bootstrap's `$enable-reduced-motion` wrapping
  /// nearly every `transition`/`animation` in a
  /// `@media (prefers-reduced-motion: reduce)` query: when
  /// [MediaQueryData.disableAnimations] is on, every transition/animation
  /// collapses to [reducedMotionDuration] instead of playing at its normal
  /// [duration].
  ///
  /// [BsSpinnerBorder]/[BsSpinnerGrow] deliberately don't call this for
  /// their own rotation — per Bootstrap's own accessibility guidance,
  /// freezing a spinner would misleadingly suggest a still-running
  /// operation had finished, so their motion is treated as essential
  /// rather than decorative.
  static Duration resolve(BuildContext context, Duration duration) {
    final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    return reduceMotion ? reducedMotionDuration : duration;
  }
}
