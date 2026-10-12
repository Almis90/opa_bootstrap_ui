import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'bs_box.dart';
import 'tokens/bs_borders.dart';

/// An image whose [width] is the width of the whole box, border included. The image's own
/// aspect ratio gives the height, and with [fluid] it never grows wider than its container.
///
/// An image is inline content, so it is placed by the surrounding text alignment (centered in
/// a centered block); [block] makes it a block instead. [border], [rounded] and [shadow] are the
/// utilities of the same names on the image itself; for margins and the rest wrap it in a
/// [BsBox]. See [BsThumbnail] for a framed image.
class BsImage extends StatelessWidget {
  const BsImage({
    super.key,
    required this.image,
    this.width,
    this.fluid = false,
    this.block = false,
    this.border = false,
    this.rounded,
    this.shadow,
    this.alt,
  });

  /// What to draw, e.g. `AssetImage('assets/photo.png')`.
  final ImageProvider image;

  /// The `width` attribute; the image's natural width if null.
  final double? width;

  /// Caps the width at the container's, keeping the aspect ratio.
  final bool fluid;

  /// `d-block`: a block of its own, at its start, instead of inline content.
  final bool block;

  /// `border`.
  final bool border;

  /// `rounded-*`: the corners of the border box, which clip the image.
  final BsRounded? rounded;

  /// `shadow`, `shadow-sm`, `shadow-lg`.
  final BsShadow? shadow;

  /// The `alt` text (an empty one, as in `alt=""`, marks the image decorative).
  final String? alt;

  @override
  Widget build(BuildContext context) {
    final frame = border ? 2 * BsBorders.width : 0.0;
    final img = Image(
      image: image,
      fit: BoxFit.fitWidth,
      filterQuality: FilterQuality.medium,
      semanticLabel: alt,
      excludeFromSemantics: alt == null || alt!.isEmpty,
      // A broken image is an empty box, not an error.
      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
    );
    return BsBox(
      border: border,
      rounded: rounded,
      shadow: shadow,
      overflowHidden: rounded != null,
      inlineBlock: !block,
      child: _ImageWidth(
        width: width,
        frame: frame,
        fluid: fluid,
        textDirection: Directionality.of(context),
        child: img,
      ),
    );
  }
}

/// Sizes an image: [width] is the border box's (so [frame], the borders, comes off it), [fluid]
/// caps that at the container's width, and the height follows from the aspect ratio. A plain
/// fixed-width image keeps its width even where its container is narrower (it overflows, to be
/// clipped by an overflow-hiding ancestor), and an image is its own width, at the start, not
/// its container's.
class _ImageWidth extends SingleChildRenderObjectWidget {
  const _ImageWidth({
    required this.width,
    required this.frame,
    required this.fluid,
    required this.textDirection,
    required super.child,
  });

  final double? width;
  final double frame;
  final bool fluid;
  final TextDirection textDirection;

  @override
  RenderObject createRenderObject(BuildContext context) => _RenderImageWidth(
    width: width,
    frame: frame,
    fluid: fluid,
    textDirection: textDirection,
  );

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderImageWidth renderObject,
  ) {
    renderObject
      ..width = width
      ..frame = frame
      ..fluid = fluid
      ..textDirection = textDirection;
  }
}

// The private fields can't be named constructor parameters.
// ignore_for_file: prefer_initializing_formals
class _RenderImageWidth extends RenderAligningShiftedBox {
  _RenderImageWidth({
    required double? width,
    required double frame,
    required bool fluid,
    required TextDirection textDirection,
  }) : _width = width,
       _frame = frame,
       _fluid = fluid,
       super(
         alignment: AlignmentDirectional.topStart,
         textDirection: textDirection,
       );

  double? _width;
  set width(double? v) {
    if (v != _width) {
      _width = v;
      markNeedsLayout();
    }
  }

  double _frame;
  set frame(double v) {
    if (v != _frame) {
      _frame = v;
      markNeedsLayout();
    }
  }

  bool _fluid;
  set fluid(bool v) {
    if (v != _fluid) {
      _fluid = v;
      markNeedsLayout();
    }
  }

  BoxConstraints _inner(BoxConstraints c) {
    final room = c.hasBoundedWidth ? c.maxWidth + _frame : double.infinity;
    final box = _width == null
        ? null
        : (_fluid ? math.min(_width!, room) : _width!);
    if (box == null) {
      // The image's natural width (capped by the container if it is fluid).
      return BoxConstraints(
        maxWidth: _fluid && c.hasBoundedWidth ? c.maxWidth : double.infinity,
      );
    }
    final content = math.max(0.0, box - _frame);
    return BoxConstraints(minWidth: content, maxWidth: content);
  }

  @override
  double computeMinIntrinsicWidth(double height) =>
      _fluid || _width == null ? 0 : _width! - _frame;

  @override
  double computeMaxIntrinsicWidth(double height) => _width == null
      ? (child?.getMaxIntrinsicWidth(height) ?? 0)
      : _width! - _frame;

  @override
  Size computeDryLayout(BoxConstraints constraints) {
    final size = child?.getDryLayout(_inner(constraints)) ?? Size.zero;
    return constraints.constrain(size);
  }

  @override
  void performLayout() {
    final child = this.child;
    if (child == null) {
      size = constraints.smallest;
      return;
    }
    child.layout(_inner(constraints), parentUsesSize: true);
    size = constraints.constrain(child.size);
    alignChild();
  }
}
