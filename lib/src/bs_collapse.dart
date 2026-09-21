import 'package:flutter/widgets.dart';

import 'tokens/bs_transitions.dart';

/// Which dimension a [BsCollapse] animates.
enum BsCollapseAxis {
  /// `.collapse` (default): animates height, growing/shrinking downward.
  vertical,

  /// `.collapse-horizontal`: animates width instead.
  horizontal,
}

/// A Bootstrap collapse (`.collapse`): reveals or hides [child] with an
/// animated height (or, per [axis], width) transition, per
/// `.collapsing`'s `$transition-collapse`.
///
/// A controlled widget — toggle [isExpanded] from the parent (e.g. a
/// [BsButton]'s `onPressed`), the same way you'd flip Bootstrap's
/// `data-bs-toggle="collapse"` state. Like Bootstrap's block-level
/// `.collapse`, the vertical axis expects a bounded width from its parent
/// (e.g. a [Column]); the horizontal axis expects a bounded height instead
/// (e.g. a fixed-height [Row]).
class BsCollapse extends StatelessWidget {
  const BsCollapse({
    super.key,
    required this.isExpanded,
    required this.child,
    this.axis = BsCollapseAxis.vertical,
    this.duration,
    this.curve,
  });

  /// Whether [child] is shown.
  final bool isExpanded;

  /// The content revealed when [isExpanded] is true.
  final Widget child;

  /// Which dimension animates.
  final BsCollapseAxis axis;

  /// `$transition-collapse` duration override.
  final Duration? duration;

  /// `$transition-collapse` easing override.
  final Curve? curve;

  @override
  Widget build(BuildContext context) {
    final horizontal = axis == BsCollapseAxis.horizontal;

    return ClipRect(
      child: AnimatedSize(
        duration: duration ?? BsTransitions.collapse,
        curve: curve ?? BsTransitions.collapseCurve,
        alignment: horizontal ? Alignment.centerLeft : Alignment.topCenter,
        child: isExpanded
            ? child
            : (horizontal
                  ? const SizedBox(width: 0, height: double.infinity)
                  : const SizedBox(width: double.infinity, height: 0)),
      ),
    );
  }
}
