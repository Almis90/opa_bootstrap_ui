import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A negative start margin of [by]: the child overlaps what comes before it, and takes that
/// much less room, in a wrapping line too, where it hangs out over the edge of the line.
class BsPullStart extends SingleChildRenderObjectWidget {
  const BsPullStart({super.key, required this.by, required super.child});

  final double by;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderPullStart(by, Directionality.of(context));

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    (renderObject as _RenderPullStart)
      ..by = by
      ..textDirection = Directionality.of(context);
  }
}

class _RenderPullStart extends RenderShiftedBox {
  _RenderPullStart(this._by, this._textDirection) : super(null);

  double _by;
  set by(double value) {
    if (_by == value) return;
    _by = value;
    markNeedsLayout();
  }

  TextDirection _textDirection;
  set textDirection(TextDirection value) {
    if (_textDirection == value) return;
    _textDirection = value;
    markNeedsLayout();
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final size = child!.getDryLayout(constraints);
    return constraints.constrain(Size(size.width - _by, size.height));
  }

  @override
  void performLayout() {
    child!.layout(constraints, parentUsesSize: true);
    size = constraints.constrain(
      Size(child!.size.width - _by, child!.size.height),
    );
    (child!.parentData! as BoxParentData).offset = Offset(
      _textDirection == TextDirection.ltr ? -_by : 0,
      0,
    );
  }
}
