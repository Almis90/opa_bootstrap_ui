import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// A [DecoratedBox] that paints like a browser does: its edges (background,
/// border, shadow) are snapped to whole device pixels.
///
/// CSS layout is fractional — a header below a 32.34px title starts at
/// y=185.34 — but browsers snap every box's edges to the pixel grid when they
/// paint, so a 1px border is always one crisp row. Flutter paints at the
/// fractional position instead and the border blurs over two rows. This box
/// rounds its left/top/right/bottom (in device pixels, from its position on
/// screen, as Chrome does) before painting the decoration; layout and the
/// child are untouched.
class BsDecoratedBox extends DecoratedBox {
  const BsDecoratedBox({
    super.key,
    required super.decoration,
    super.position,
    super.child,
  });

  @override
  RenderDecoratedBox createRenderObject(BuildContext context) =>
      _RenderBsDecoratedBox(
        decoration: decoration,
        position: position,
        configuration: createLocalImageConfiguration(context),
      );
}

class _RenderBsDecoratedBox extends RenderDecoratedBox {
  _RenderBsDecoratedBox({
    required super.decoration,
    required super.position,
    required super.configuration,
  });

  BoxPainter? _painter;
  Decoration? _painterDecoration;

  BoxPainter _painterFor(Decoration decoration) {
    if (_painter == null || _painterDecoration != decoration) {
      _painter?.dispose();
      _painter = decoration.createBoxPainter(markNeedsPaint);
      _painterDecoration = decoration;
    }
    return _painter!;
  }

  @override
  void detach() {
    _painter?.dispose();
    _painter = null;
    super.detach();
    markNeedsPaint();
  }

  @override
  void dispose() {
    _painter?.dispose();
    _painter = null;
    super.dispose();
  }

  /// The decoration's rectangle with every edge rounded to a device pixel.
  Rect _snappedRect(Offset offset) {
    final transform = getTransformTo(null).storage;
    // Only translations are snapped (a rotated or scaled box has no pixel grid
    // to align to).
    if (transform[0] != 1 ||
        transform[5] != 1 ||
        transform[1] != 0 ||
        transform[4] != 0) {
      return offset & size;
    }
    final dpr = configuration.devicePixelRatio ?? 1.0;
    double snap(double v) => (v * dpr).round() / dpr;
    final x = transform[12];
    final y = transform[13];
    final left = snap(x);
    final top = snap(y);
    final right = snap(x + size.width);
    final bottom = snap(y + size.height);
    return Rect.fromLTRB(
      offset.dx + left - x,
      offset.dy + top - y,
      offset.dx + right - x,
      offset.dy + bottom - y,
    );
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final painter = _painterFor(decoration);
    final rect = _snappedRect(offset);
    final snapped = configuration.copyWith(size: rect.size);
    if (position == DecorationPosition.background) {
      painter.paint(context.canvas, rect.topLeft, snapped);
      if (decoration.isComplex) {
        context.setIsComplexHint();
      }
    }
    final child = this.child;
    if (child != null) {
      context.paintChild(child, offset);
    }
    if (position == DecorationPosition.foreground) {
      painter.paint(context.canvas, rect.topLeft, snapped);
      if (decoration.isComplex) {
        context.setIsComplexHint();
      }
    }
  }
}

/// A [Container] whose decoration is a [BsDecoratedBox] (pixel-snapped).
///
/// Same layering as [Container] — the decoration's border is added to the
/// padding, so it adds to the box's size like a CSS border.
class BsDecoratedContainer extends StatelessWidget {
  const BsDecoratedContainer({
    super.key,
    this.alignment,
    this.padding,
    this.decoration,
    this.width,
    this.height,
    this.constraints,
    this.margin,
    this.child,
  });

  final AlignmentGeometry? alignment;
  final EdgeInsetsGeometry? padding;
  final Decoration? decoration;
  final double? width;
  final double? height;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry? margin;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    Widget? current = child;
    final tight = width != null || height != null
        ? (constraints?.tighten(width: width, height: height) ??
              BoxConstraints.tightFor(width: width, height: height))
        : constraints;

    if (child == null && (tight == null || !tight.isTight)) {
      current = LimitedBox(
        maxWidth: 0,
        maxHeight: 0,
        child: ConstrainedBox(constraints: const BoxConstraints.expand()),
      );
    } else if (alignment != null) {
      current = Align(alignment: alignment!, child: current);
    }

    final decorationPadding = decoration?.padding;
    final effectivePadding = padding == null
        ? decorationPadding
        : (decorationPadding == null
              ? padding
              : padding!.add(decorationPadding));
    if (effectivePadding != null) {
      current = Padding(padding: effectivePadding, child: current);
    }
    if (decoration != null) {
      current = BsDecoratedBox(decoration: decoration!, child: current);
    }
    if (tight != null) {
      current = ConstrainedBox(constraints: tight, child: current);
    }
    if (margin != null) {
      current = Padding(padding: margin!, child: current);
    }
    return current!;
  }
}

/// An [AnimatedContainer] whose decoration is pixel-snapped (see
/// [BsDecoratedBox]): animates [padding], [decoration] and the size.
class BsAnimatedContainer extends ImplicitlyAnimatedWidget {
  const BsAnimatedContainer({
    super.key,
    required super.duration,
    super.curve,
    this.padding,
    this.decoration,
    this.width,
    this.height,
    this.child,
  });

  final EdgeInsetsGeometry? padding;
  final Decoration? decoration;
  final double? width;
  final double? height;
  final Widget? child;

  @override
  AnimatedWidgetBaseState<BsAnimatedContainer> createState() =>
      _BsAnimatedContainerState();
}

class _BsAnimatedContainerState
    extends AnimatedWidgetBaseState<BsAnimatedContainer> {
  EdgeInsetsGeometryTween? _padding;
  DecorationTween? _decoration;
  BoxConstraintsTween? _constraints;

  @override
  void forEachTween(TweenVisitor<dynamic> visitor) {
    _padding =
        visitor(
              _padding,
              widget.padding,
              (value) =>
                  EdgeInsetsGeometryTween(begin: value as EdgeInsetsGeometry),
            )
            as EdgeInsetsGeometryTween?;
    _decoration =
        visitor(
              _decoration,
              widget.decoration,
              (value) => DecorationTween(begin: value as Decoration),
            )
            as DecorationTween?;
    final constraints = widget.width != null || widget.height != null
        ? BoxConstraints.tightFor(width: widget.width, height: widget.height)
        : null;
    _constraints =
        visitor(
              _constraints,
              constraints,
              (value) => BoxConstraintsTween(begin: value as BoxConstraints),
            )
            as BoxConstraintsTween?;
  }

  @override
  Widget build(BuildContext context) {
    final animation = this.animation;
    return BsDecoratedContainer(
      padding: _padding?.evaluate(animation),
      decoration: _decoration?.evaluate(animation),
      constraints: _constraints?.evaluate(animation),
      child: widget.child,
    );
  }
}
