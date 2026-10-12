import 'package:flutter/widgets.dart';

/// Bootstrap's generic transition tokens, shared by all components. Transitions
/// specific to one component live on that component's style class instead.
abstract final class BsTransitions {
  static const Duration base = Duration(milliseconds: 200);
  static const Curve baseCurve = Curves.easeInOut;

  static const Duration fade = Duration(milliseconds: 150);
  static const Curve fadeCurve = Curves.linear;

  static const Duration collapse = Duration(milliseconds: 350);
  static const Curve collapseCurve = Curves.ease;

  /// [resolve] collapses a reduced [duration] to this rather than
  /// [Duration.zero] — `AnimatedSize` (used by [BsCollapse]/[BsAccordion]/
  /// [BsAlert]) has a re-entrancy bug where an exact zero duration makes
  /// `RenderAnimatedSize` mutate itself mid-`performLayout`, throwing.
  /// One millisecond is short enough to read as instant while staying
  /// clear of that edge case.
  static const Duration reducedMotionDuration = Duration(milliseconds: 1);

  /// Resolves [duration] against the user's reduced-motion preference: when
  /// [MediaQueryData.disableAnimations] is on, every transition collapses to
  /// [reducedMotionDuration] instead of playing at its normal [duration].
  ///
  /// [BsSpinnerBorder] and [BsSpinnerGrow] deliberately do not call this for their
  /// rotation: freezing a spinner would suggest that a running operation had finished,
  /// so their motion is treated as essential rather than decorative.
  static Duration resolve(BuildContext context, Duration duration) {
    final reduceMotion = MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    return reduceMotion ? reducedMotionDuration : duration;
  }
}
