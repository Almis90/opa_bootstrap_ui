import 'package:flutter/widgets.dart';

import 'tokens/bs_transitions.dart';

/// Which dimension a [BsCollapse] animates.
enum BsCollapseAxis {
  /// `.collapse` (default): animates height, growing/shrinking downward.
  vertical,

  /// `.collapse-horizontal`: animates width instead.
  horizontal,
}

/// Programmatic control of a [BsCollapse] — mirrors Bootstrap's own
/// `bootstrap.Collapse` JS plugin: `expand()`/`collapse()`/`toggle()`
/// (its `show()`/`hide()`/`toggle()`). No `enable`/`disable` — Bootstrap's
/// Collapse plugin doesn't have it either, and unlike
/// [BsTooltip]/[BsPopover]/[BsDropdown], [BsCollapse] doesn't own a trigger
/// of its own to gate (the button that flips it lives outside this widget).
class BsCollapseController extends ChangeNotifier {
  BsCollapseController({bool initiallyExpanded = false}) : _expanded = initiallyExpanded;

  bool _expanded;

  /// Whether [BsCollapse.child] is currently shown (or animating toward
  /// being shown/hidden).
  bool get isExpanded => _expanded;

  void expand() => _setExpanded(true);

  void collapse() => _setExpanded(false);

  /// Expands if currently collapsed, collapses if currently expanded.
  void toggle() => _setExpanded(!_expanded);

  void _setExpanded(bool value) {
    if (value == _expanded) return;
    _expanded = value;
    notifyListeners();
  }
}

/// A Bootstrap collapse (`.collapse`): reveals or hides [child] with an
/// animated height (or, per [axis], width) transition, per
/// `.collapsing`'s `$transition-collapse`.
///
/// Controllable either way Bootstrap's own `data-bs-toggle="collapse"`
/// can be: pass [isExpanded] and flip it from the parent (e.g. a
/// [BsButton]'s `onPressed` calling `setState`), or pass a [controller] and
/// call [BsCollapseController.expand]/[BsCollapseController.collapse]/
/// [BsCollapseController.toggle] from anywhere with access to it. Ignored
/// when [controller] is given — omit it and set [isExpanded] on the
/// internally-owned controller instead. Like Bootstrap's block-level
/// `.collapse`, the vertical axis expects a bounded width from its parent
/// (e.g. a [Column]); the horizontal axis expects a bounded height instead
/// (e.g. a fixed-height [Row]).
class BsCollapse extends StatefulWidget {
  const BsCollapse({
    super.key,
    this.isExpanded,
    required this.child,
    this.axis = BsCollapseAxis.vertical,
    this.duration,
    this.curve,
    this.controller,
    this.onShow,
    this.onShown,
    this.onHide,
    this.onHidden,
  });

  /// Whether [child] is shown. Ignored when [controller] is given; only
  /// meaningful with the internally-owned controller that's used instead.
  final bool? isExpanded;

  /// The content revealed when expanded.
  final Widget child;

  /// Which dimension animates.
  final BsCollapseAxis axis;

  /// `$transition-collapse` duration override.
  final Duration? duration;

  /// `$transition-collapse` easing override.
  final Curve? curve;

  /// Drives expand/collapse instead of [isExpanded]. Defaults to an
  /// internally-owned controller (seeded from [isExpanded]) when null.
  final BsCollapseController? controller;

  /// Called as soon as an expand is triggered, before the size animation
  /// starts. Mirrors Bootstrap's `show.bs.collapse`.
  final VoidCallback? onShow;

  /// Called once the expand animation finishes. Mirrors Bootstrap's
  /// `shown.bs.collapse`.
  final VoidCallback? onShown;

  /// Called as soon as a collapse is triggered, before the size animation
  /// starts. Mirrors Bootstrap's `hide.bs.collapse`.
  final VoidCallback? onHide;

  /// Called once the collapse animation finishes. Mirrors Bootstrap's
  /// `hidden.bs.collapse`.
  final VoidCallback? onHidden;

  @override
  State<BsCollapse> createState() => _BsCollapseState();
}

class _BsCollapseState extends State<BsCollapse> {
  BsCollapseController? _ownedController;
  bool _wasExpanded = false;
  bool? _pendingTransitionTarget;

  BsCollapseController get _controller =>
      widget.controller ?? (_ownedController ??= BsCollapseController(initiallyExpanded: widget.isExpanded ?? false));

  @override
  void initState() {
    super.initState();
    _wasExpanded = _controller.isExpanded;
    _controller.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(covariant BsCollapse oldWidget) {
    super.didUpdateWidget(oldWidget);
    // isExpanded only drives the internally-owned controller — an explicit
    // controller is always the source of truth once given.
    if (widget.controller == null && widget.isExpanded != null && widget.isExpanded != _controller.isExpanded) {
      widget.isExpanded! ? _controller.expand() : _controller.collapse();
    }
  }

  void _handleControllerChanged() {
    setState(() {}); // reflects the new isExpanded in the AnimatedSize below
    final isExpanded = _controller.isExpanded;
    if (isExpanded == _wasExpanded) return;
    _wasExpanded = isExpanded;
    _pendingTransitionTarget = isExpanded;
    if (isExpanded) {
      widget.onShow?.call();
    } else {
      widget.onHide?.call();
    }
  }

  void _handleSizeEnd() {
    // AnimatedSize.onEnd fires for *any* settled size change, not just
    // expand/collapse — e.g. the child's own intrinsic size changing while
    // already expanded. Only treat it as onShown/onHidden when it lines up
    // with a transition _handleControllerChanged actually started.
    if (_pendingTransitionTarget == null || _pendingTransitionTarget != _controller.isExpanded) return;
    _pendingTransitionTarget = null;
    if (_controller.isExpanded) {
      widget.onShown?.call();
    } else {
      widget.onHidden?.call();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);
    _ownedController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final horizontal = widget.axis == BsCollapseAxis.horizontal;
    final isExpanded = _controller.isExpanded;

    return ClipRect(
      child: AnimatedSize(
        duration: widget.duration ?? BsTransitions.collapse,
        curve: widget.curve ?? BsTransitions.collapseCurve,
        alignment: horizontal ? Alignment.centerLeft : Alignment.topCenter,
        onEnd: _handleSizeEnd,
        child: isExpanded
            ? widget.child
            : (horizontal
                  ? const SizedBox(width: 0, height: double.infinity)
                  : const SizedBox(width: double.infinity, height: 0)),
      ),
    );
  }
}
