import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

/// Bootstrap's own `.b-example-divider`: a 3rem gray band with a translucent
/// fill, a 1px top/bottom border, and two inset shadows (`inset 0 .5em 1.5em`
/// at .1 and `inset 0 .125em .5em` at .15) separating stacked examples on the
/// same page — docs-only CSS, not part of Bootstrap itself.
class ExampleDivider extends StatelessWidget {
  const ExampleDivider({super.key}) : vertical = false;

  /// `.b-example-vr`: the same band, `1.5rem` wide and as tall as the row it
  /// stands in (its top and bottom borders close the band at the row's ends).
  const ExampleDivider.vertical({super.key}) : vertical = true;

  final bool vertical;

  @override
  Widget build(BuildContext context) {
    if (vertical) {
      return const SizedBox(
        width: 24,
        child: BsDecoratedBox(decoration: _DividerDecoration()),
      );
    }
    return const SizedBox(
      height: 48,
      width: double.infinity,
      child: BsDecoratedBox(decoration: _DividerDecoration()),
    );
  }
}

/// Flutter's [BoxShadow] has no CSS-style `inset`, so the whole band is a
/// custom [Decoration]: fill, the shadows drawn as the area *outside* the
/// padding box (shifted by the shadow's offset, blurred, clipped back to the
/// padding box) and the borders. It is painted by a [BsDecoratedBox], so it
/// gets the same pixel-snapped rectangle the browser would paint.
class _DividerDecoration extends Decoration {
  const _DividerDecoration();

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) =>
      const _DividerPainter();

  @override
  bool operator ==(Object other) => other is _DividerDecoration;

  @override
  int get hashCode => 0;
}

class _DividerPainter extends BoxPainter {
  const _DividerPainter();

  static const _border = Color(0x26000000);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final rect = offset & configuration.size!;
    canvas.drawRect(rect, Paint()..color = const Color(0x1A000000));

    final inner = Rect.fromLTRB(
      rect.left,
      rect.top + 1,
      rect.right,
      rect.bottom - 1,
    ); // inside the borders
    canvas.save();
    canvas.clipRect(inner);
    // (offset y, blur radius, alpha); CSS draws the first shadow on top.
    for (final (dy, blur, alpha) in const [
      (2.0, 8.0, 0.15),
      (8.0, 24.0, 0.1),
    ]) {
      final outside = Path()
        ..fillType = PathFillType.evenOdd
        ..addRect(inner.inflate(blur * 3 + dy))
        ..addRect(inner.shift(Offset(0, dy)));
      canvas.drawPath(
        outside,
        Paint()
          ..color = Color.fromRGBO(0, 0, 0, alpha)
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur / 2),
      );
    }
    canvas.restore();

    final border = Paint()..color = _border;
    canvas.drawRect(Rect.fromLTWH(rect.left, rect.top, rect.width, 1), border);
    canvas.drawRect(
      Rect.fromLTWH(rect.left, rect.bottom - 1, rect.width, 1),
      border,
    );
  }
}
