import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import 'bs_box.dart';
import 'tokens/bs_borders.dart';

/// An `<img>`, with `.img-fluid` when [fluid]: [width] is the `width`
/// attribute — the width of the whole box, border included — the image's own
/// aspect ratio gives the height (`height: auto`), and with [fluid] it never
/// grows wider than its container (`max-width: 100%`).
///
/// An `<img>` is inline content, so it's placed by the surrounding `text-*`
/// alignment (centred in a `text-center` block); [block] is `d-block`.
/// [border], [rounded] and [shadow] are the utilities of the same names on the
/// image itself; for margins and the rest wrap it in a [BsBox]. See
/// [BsThumbnail] for `.img-thumbnail`.
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

  /// `img-fluid`: `max-width: 100%; height: auto`.
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
    final image = LayoutBuilder(
      builder: (context, constraints) {
        var w = width;
        if (fluid && constraints.hasBoundedWidth) {
          // (The border box may take the container's whole width, so the room
          // for the image itself is that much more than what's left inside it.)
          final room = constraints.maxWidth + frame;
          w = w == null ? room : w.clamp(0, room);
        }
        final img = Image(
          image: this.image,
          width: w == null ? null : w - frame,
          fit: BoxFit.fitWidth,
          filterQuality: FilterQuality.medium,
          semanticLabel: alt,
          excludeFromSemantics: alt == null || alt!.isEmpty,
        );
        // A plain <img width=…> keeps that width even where its container is
        // narrower (it overflows, to be clipped by `overflow-hidden`); and a
        // block-level image is its own width, not its container's.
        return Align(
          alignment: AlignmentDirectional.topStart,
          widthFactor: 1,
          heightFactor: 1,
          child: !fluid && w != null
              ? _Overflowing(width: w - frame, child: img)
              : img,
        );
      },
    );
    return BsBox(
      border: border,
      rounded: rounded,
      shadow: shadow,
      overflowHidden: rounded != null,
      inlineBlock: !block,
      child: image,
    );
  }
}

/// Lays [child] out at exactly [width] whatever the constraints, and reports
/// the constrained size — so a parent that clips (an `overflow-hidden` box)
/// cuts the excess off, and nothing complains about the overflow.
class _Overflowing extends SingleChildRenderObjectWidget {
  const _Overflowing({required this.width, required super.child});

  final double width;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderOverflowing(width);

  @override
  void updateRenderObject(BuildContext context, _RenderOverflowing renderObject) {
    renderObject.width = width;
  }
}

class _RenderOverflowing extends RenderShiftedBox {
  _RenderOverflowing(this._width) : super(null);

  double _width;
  set width(double v) {
    if (v != _width) {
      _width = v;
      markNeedsLayout();
    }
  }

  BoxConstraints _inner(BoxConstraints c) => BoxConstraints(
    minWidth: _width,
    maxWidth: _width,
    maxHeight: c.maxHeight,
  );

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
  }
}
