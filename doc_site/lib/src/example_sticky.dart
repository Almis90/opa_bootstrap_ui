import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// `position: sticky; top: [top]`: [child] scrolls with the page until its top
/// would pass [top] below the top of the enclosing vertical scroll view, then
/// stays there — until the bottom of the box this widget is laid out in (the
/// sticky element's containing block) pushes it back up, as it does in CSS.
///
/// The widget takes the room of its containing block when that is given tight
/// constraints (a flex item stretched to its row), so there is height to
/// travel; otherwise it is as tall as [child] and has nowhere to move.
class ExampleSticky extends StatefulWidget {
  const ExampleSticky({super.key, required this.top, required this.child});

  final double top;
  final Widget child;

  @override
  State<ExampleSticky> createState() => _ExampleStickyState();
}

class _ExampleStickyState extends State<ExampleSticky> {
  ScrollPosition? _position;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _position = Scrollable.maybeOf(context)?.position;
  }

  @override
  Widget build(BuildContext context) =>
      _Sticky(top: widget.top, position: _position, child: widget.child);
}

class _Sticky extends SingleChildRenderObjectWidget {
  const _Sticky({
    required this.top,
    required this.position,
    required super.child,
  });

  final double top;
  final ScrollPosition? position;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderSticky(top, position);

  @override
  void updateRenderObject(BuildContext context, _RenderSticky renderObject) {
    renderObject
      ..top = top
      ..position = position;
  }
}

class _RenderSticky extends RenderShiftedBox {
  _RenderSticky(this._top, this._position) : super(null) {
    _position?.addListener(markNeedsPaint);
  }

  double _top;
  double get top => _top;
  set top(double value) {
    if (value == _top) return;
    _top = value;
    markNeedsPaint();
  }

  ScrollPosition? _position;
  set position(ScrollPosition? value) {
    if (identical(value, _position)) return;
    _position?.removeListener(markNeedsPaint);
    _position = value;
    _position?.addListener(markNeedsPaint);
    markNeedsPaint();
  }

  @override
  void detach() {
    _position?.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _position?.addListener(markNeedsPaint);
  }

  @override
  void performLayout() {
    final child = this.child;
    if (child == null) {
      size = constraints.smallest;
      return;
    }
    child.layout(
      BoxConstraints(
        minWidth: constraints.minWidth,
        maxWidth: constraints.maxWidth,
        maxHeight: double.infinity,
      ),
      parentUsesSize: true,
    );
    size = constraints.constrain(child.size);
  }

  /// How far down [child] is held from its place in the layout.
  double get _shift {
    final child = this.child;
    final viewport = RenderAbstractViewport.maybeOf(this);
    if (child == null || viewport is! RenderBox) return 0;
    final y = getTransformTo(viewport).getTranslation().y;
    return (top - y).clamp(0, math.max(0, size.height - child.size.height));
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final child = this.child;
    if (child != null) context.paintChild(child, offset + Offset(0, _shift));
  }

  @override
  void applyPaintTransform(RenderBox child, Matrix4 transform) {
    transform.translateByDouble(0.0, _shift, 0.0, 1.0);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) {
    final child = this.child;
    if (child == null) return false;
    return result.addWithPaintOffset(
      offset: Offset(0, _shift),
      position: position,
      hitTest: (result, position) => child.hitTest(result, position: position),
    );
  }
}
