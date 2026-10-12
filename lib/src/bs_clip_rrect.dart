// ignore_for_file: prefer_initializing_formals

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A [ClipRRect] whose rectangle is snapped to whole device pixels, as [BsDecoratedBox] snaps
/// what it paints.
///
/// A browser clips a box at its snapped edges. Flutter clips at the fractional ones, so a 1px
/// border that [BsDecoratedBox] has painted exactly on such an edge is half cut away by the
/// anti-aliased clip and fades out, whenever the box sits at a fractional offset, as in any
/// fractional layout (grid columns, percentages).
class BsClipRRect extends SingleChildRenderObjectWidget {
  const BsClipRRect({
    super.key,
    this.borderRadius = BorderRadius.zero,
    this.clipBehavior = Clip.antiAlias,
    super.child,
  });

  final BorderRadiusGeometry borderRadius;
  final Clip clipBehavior;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderBsClipRRect(
    borderRadius: borderRadius,
    clipBehavior: clipBehavior,
    textDirection: Directionality.maybeOf(context),
    devicePixelRatio: MediaQuery.maybeDevicePixelRatioOf(context) ?? 1,
  );

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) {
    (renderObject as _RenderBsClipRRect)
      ..borderRadius = borderRadius
      ..clipBehavior = clipBehavior
      ..textDirection = Directionality.maybeOf(context)
      ..devicePixelRatio = MediaQuery.maybeDevicePixelRatioOf(context) ?? 1;
  }
}

class _RenderBsClipRRect extends RenderProxyBox {
  _RenderBsClipRRect({
    required BorderRadiusGeometry borderRadius,
    required Clip clipBehavior,
    required TextDirection? textDirection,
    required double devicePixelRatio,
  }) : _borderRadius = borderRadius,
       _clipBehavior = clipBehavior,
       _textDirection = textDirection,
       _devicePixelRatio = devicePixelRatio;

  BorderRadiusGeometry _borderRadius;
  set borderRadius(BorderRadiusGeometry value) {
    if (_borderRadius == value) return;
    _borderRadius = value;
    markNeedsPaint();
  }

  Clip _clipBehavior;
  set clipBehavior(Clip value) {
    if (_clipBehavior == value) return;
    _clipBehavior = value;
    markNeedsPaint();
  }

  TextDirection? _textDirection;
  set textDirection(TextDirection? value) {
    if (_textDirection == value) return;
    _textDirection = value;
    markNeedsPaint();
  }

  double _devicePixelRatio;
  set devicePixelRatio(double value) {
    if (_devicePixelRatio == value) return;
    _devicePixelRatio = value;
    markNeedsPaint();
  }

  /// This box's rectangle (local coordinates) with every edge rounded to a
  /// device pixel, from where it is on screen.
  Rect _snapped() {
    final transform = getTransformTo(null).storage;
    if (transform[0] != 1 ||
        transform[5] != 1 ||
        transform[1] != 0 ||
        transform[4] != 0) {
      return Offset.zero & size;
    }
    double snap(double v) => (v * _devicePixelRatio).round() / _devicePixelRatio;
    final x = transform[12];
    final y = transform[13];
    return Rect.fromLTRB(
      snap(x) - x,
      snap(y) - y,
      snap(x + size.width) - x,
      snap(y + size.height) - y,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final child = this.child;
    if (child == null) return;
    if (_clipBehavior == Clip.none) {
      context.paintChild(child, offset);
      return;
    }
    final rect = _snapped();
    final rrect = _borderRadius
        .resolve(_textDirection ?? TextDirection.ltr)
        .toRRect(rect);
    layer = context.pushClipRRect(
      needsCompositing,
      offset,
      rect,
      rrect,
      super.paint,
      clipBehavior: _clipBehavior,
      oldLayer: layer as ClipRRectLayer?,
    );
  }

  @override
  void dispose() {
    layer = null;
    super.dispose();
  }
}
