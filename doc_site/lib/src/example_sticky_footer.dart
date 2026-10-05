import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// `html.h-100 > body.d-flex.flex-column.h-100`: [main] at the top and [footer]
/// (`.footer.mt-auto`) pinned to the bottom of the viewport — or just below
/// [main] once that is taller.
///
/// With [fillParent] it is the parent's (tight) height instead of the viewport's
/// that [footer] is pinned to the bottom of (a card's `h-100` content with a
/// `mt-auto` row last).
class ExampleStickyFooter extends MultiChildRenderObjectWidget {
  ExampleStickyFooter({
    super.key,
    required Widget main,
    required Widget footer,
    this.fillParent = false,
  }) : super(children: [main, footer]);

  final bool fillParent;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderStickyFooter(
    fillParent ? null : MediaQuery.sizeOf(context).height,
  );

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    (renderObject as _RenderStickyFooter).minHeight = fillParent
        ? null
        : MediaQuery.sizeOf(context).height;
  }
}

class _ParentData extends ContainerBoxParentData<RenderBox> {}

class _RenderStickyFooter extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _ParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _ParentData> {
  _RenderStickyFooter(this._minHeight);

  double? _minHeight;
  set minHeight(double? v) {
    if (v != _minHeight) {
      _minHeight = v;
      markNeedsLayout();
    }
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _ParentData) child.parentData = _ParentData();
  }

  RenderBox get _main => firstChild!;
  RenderBox get _footer => lastChild!;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final tight = BoxConstraints.tightFor(width: constraints.maxWidth);
    final height =
        _main.getDryLayout(tight.copyWith(minHeight: 0)).height +
        _footer.getDryLayout(tight.copyWith(minHeight: 0)).height;
    return constraints.constrain(
      Size(
        constraints.maxWidth,
        math.max(height, _minHeight ?? constraints.minHeight),
      ),
    );
  }

  @override
  void performLayout() {
    final loose = BoxConstraints(
      minWidth: constraints.maxWidth,
      maxWidth: constraints.maxWidth,
    );
    _main.layout(loose, parentUsesSize: true);
    _footer.layout(loose, parentUsesSize: true);
    final height = math.max(
      _main.size.height + _footer.size.height,
      _minHeight ?? constraints.minHeight,
    );
    size = constraints.constrain(Size(constraints.maxWidth, height));
    (_main.parentData! as _ParentData).offset = Offset.zero;
    (_footer.parentData! as _ParentData).offset = Offset(
      0,
      size.height - _footer.size.height,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) =>
      defaultPaint(context, offset);

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);
}
