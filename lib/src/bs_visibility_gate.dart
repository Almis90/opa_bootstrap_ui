import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Tells [onVisibilityChanged] when [child] scrolls into, or out of, the view
/// of the scroll views it is in.
///
/// An animation that repeats forever (a spinner, animated stripes, a
/// placeholder's glow) keeps Flutter producing a frame every 16ms, and every
/// frame redraws the whole scene; on a long page of one scroll view, which
/// builds everything (nothing is "off screen" to the framework), that is the
/// whole page redrawn 60 times a second for something nobody can see. Such a
/// widget stops its animation while it is not visible and starts it again when
/// it is.
///
/// Visibility is re-checked as any enclosing scroll view scrolls, and once after
/// the first frame; a widget outside any scroll view is always visible. (It is
/// not re-checked when layout shifts it without a scroll.)
class BsVisibilityGate extends StatefulWidget {
  const BsVisibilityGate({
    super.key,
    required this.onVisibilityChanged,
    required this.child,
  });

  /// Called with the new state whenever it changes, and once after the first
  /// frame if it is not visible then.
  final ValueChanged<bool> onVisibilityChanged;

  final Widget child;

  @override
  State<BsVisibilityGate> createState() => _BsVisibilityGateState();
}

class _BsVisibilityGateState extends State<BsVisibilityGate> {
  final _positions = <ScrollPosition>[];
  bool _visible = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    for (final position in _positions) {
      position.removeListener(_check);
    }
    _positions.clear();
    // Every scroll view above: a spinner in a horizontal scroller in a page
    // scrolls out of view with the page, too.
    context.visitAncestorElements((element) {
      final widget = element.widget;
      if (widget is Scrollable && element is StatefulElement) {
        final position = (element.state as ScrollableState).position;
        position.addListener(_check);
        _positions.add(position);
      }
      return true;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  @override
  void dispose() {
    for (final position in _positions) {
      position.removeListener(_check);
    }
    super.dispose();
  }

  void _check() {
    if (!mounted) return;
    final visible = _isVisible();
    if (visible == _visible) return;
    _visible = visible;
    widget.onVisibilityChanged(visible);
  }

  bool _isVisible() {
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.attached || !box.hasSize) return true;
    // The nearest viewport and each one above it: hidden in any of them is hidden.
    RenderObject? from = box;
    while (from != null) {
      final viewport = RenderAbstractViewport.maybeOf(from);
      if (viewport == null) return true;
      final RenderObject object = viewport;
      if (object is RenderBox && object.hasSize) {
        final rect = MatrixUtils.transformRect(
          box.getTransformTo(object),
          Offset.zero & box.size,
        );
        if (!rect.overlaps(Offset.zero & object.size)) return false;
      }
      from = object.parent;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
