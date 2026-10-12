import 'package:flutter/painting.dart';

/// A dashed border (all four sides alike), which Flutter's [Border] has no equivalent of: a
/// dashed stroke along the box's outline, following its rounded corners.
///
/// Dashes are three times the border width long, with gaps of the same length stretched a
/// little so that a whole number of dashes fits the outline, as browsers do.
class BsDashedBorder extends Border {
  BsDashedBorder({required Color color, double width = 1})
    : super.fromBorderSide(BorderSide(color: color, width: width));

  @override
  void paint(
    Canvas canvas,
    Rect rect, {
    TextDirection? textDirection,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius? borderRadius,
  }) {
    final side = top;
    if (side.style == BorderStyle.none || side.width == 0) {
      return;
    }
    final inset = side.width / 2;
    final box = rect.deflate(inset);
    final path = Path();
    switch (shape) {
      case BoxShape.circle:
        path.addOval(box);
      case BoxShape.rectangle:
        if (borderRadius == null || borderRadius == BorderRadius.zero) {
          path.addRect(box);
        } else {
          path.addRRect(borderRadius.toRRect(rect).deflate(inset));
        }
    }

    final dash = side.width * 3;
    final paint = Paint()
      ..color = side.color
      ..style = PaintingStyle.stroke
      ..strokeWidth = side.width;
    for (final metric in path.computeMetrics()) {
      final count = (metric.length / (dash * 2)).round().clamp(1, 1 << 20);
      final period = metric.length / count;
      for (var i = 0; i < count; i++) {
        final start = i * period;
        canvas.drawPath(metric.extractPath(start, start + dash), paint);
      }
    }
  }
}
