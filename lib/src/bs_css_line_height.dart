import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// Gives text the fractional line height that a browser lays out.
///
/// Browsers keep line heights fractional (to 1/64px): a 21.57px font at a 1.5 line height is
/// 32.34px per line, while Flutter rounds a text line to whole pixels (32px). Over a page of
/// such titles the difference adds up to visible drift, so this makes [child] as much taller
/// (or shorter) as its lines should be: the difference of one line, times the number of lines
/// when [perLine] is set (the lines being counted from the child's height, so [child] should
/// be text), or once otherwise (exact for single-line text, and fine for a block whose lines it
/// cannot know). The boxes' edges are snapped to device pixels when painted
/// ([BsDecoratedBox]), so the fractions do not blur borders.
class BsCssLineHeight extends StatelessWidget {
  const BsCssLineHeight({
    super.key,
    required this.fontSize,
    required this.lineHeight,
    this.perLine = false,
    required this.child,
  });

  final double fontSize;

  /// The unitless `line-height` multiplier.
  final double lineHeight;

  final bool perLine;

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    final flutter = (fontSize * lineHeight).roundToDouble();
    final css = (fontSize * lineHeight * dpr * 64).floorToDouble() / 64 / dpr;
    return _LineHeightAdjust(
      delta: css - flutter,
      lineHeight: perLine ? flutter : null,
      child: child,
    );
  }
}

/// Makes [child] [delta] logical pixels taller (per line of [lineHeight] if given), keeping it
/// vertically centered in the extra (half-leading) space.
class _LineHeightAdjust extends SingleChildRenderObjectWidget {
  const _LineHeightAdjust({
    required this.delta,
    required this.lineHeight,
    required super.child,
  });

  final double delta;
  final double? lineHeight;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderLineHeightAdjust(delta, lineHeight);

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderLineHeightAdjust renderObject,
  ) {
    renderObject
      ..delta = delta
      ..lineHeight = lineHeight;
  }
}

class _RenderLineHeightAdjust extends RenderShiftedBox {
  _RenderLineHeightAdjust(this._delta, this._lineHeight) : super(null);

  double _delta;
  set delta(double value) {
    if (_delta != value) {
      _delta = value;
      markNeedsLayout();
    }
  }

  double? _lineHeight;
  set lineHeight(double? value) {
    if (_lineHeight != value) {
      _lineHeight = value;
      markNeedsLayout();
    }
  }

  double _extra(double childHeight) {
    final lh = _lineHeight;
    if (lh == null || lh <= 0) {
      return _delta;
    }
    return _delta * math.max(1, (childHeight / lh).round());
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    final h = child?.getMinIntrinsicHeight(width) ?? 0;
    return h + _extra(h);
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    final h = child?.getMaxIntrinsicHeight(width) ?? 0;
    return h + _extra(h);
  }

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final child = this.child;
    if (child == null) {
      return constraints.smallest;
    }
    final size = child.getDryLayout(constraints);
    return constraints.constrain(
      Size(size.width, size.height + _extra(size.height)),
    );
  }

  @override
  void performLayout() {
    final child = this.child;
    if (child == null) {
      size = constraints.smallest;
      return;
    }
    child.layout(constraints, parentUsesSize: true);
    final extra = _extra(child.size.height);
    size = constraints.constrain(
      Size(child.size.width, child.size.height + extra),
    );
    (child.parentData! as BoxParentData).offset = Offset(0, extra / 2);
  }
}
