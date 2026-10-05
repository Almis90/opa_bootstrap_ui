import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// The Dashboard example's `Chart.js` line chart (`type: 'line'`, one dataset,
/// no legend, a `4px` `#007bff` line with `#007bff` points): drawn the way Chart.js
/// lays it out — a canvas `900:380` in shape, `50.7` px of room on the left for
/// the value labels, `10.2` at the top, `27` at the right (half of the last
/// category label) and `28.4` at the bottom (the category labels), the value
/// scale `12,000`–`26,000` in steps of 2,000 (`10,000`–`26,000` by 5,000 when
/// the chart is too short for that).
class ExampleLineChart extends StatelessWidget {
  const ExampleLineChart({
    super.key,
    required this.labels,
    required this.values,
  });

  final List<String> labels;
  final List<double> values;

  @override
  Widget build(BuildContext context) {
    final style = DefaultTextStyle.of(context).style;
    return LayoutBuilder(
      builder: (context, constraints) {
        // Chart.js: a canvas of 900×380 attributes keeps that ratio, in whole
        // pixels.
        final width = constraints.maxWidth;
        final height = (width.floorToDouble() / (900 / 380)).floorToDouble();
        return CustomPaint(
          size: Size(width, height),
          painter: _ChartPainter(
            labels: labels,
            values: values,
            fontFamily: style.fontFamily,
            fontFamilyFallback: style.fontFamilyFallback,
          ),
        );
      },
    );
  }
}

class _ChartPainter extends CustomPainter {
  _ChartPainter({
    required this.labels,
    required this.values,
    this.fontFamily,
    this.fontFamilyFallback,
  });

  final List<String> labels;
  final List<double> values;
  final String? fontFamily;
  final List<String>? fontFamilyFallback;

  static const _blue = Color(0xFF007BFF);
  static const _grid = Color(0x1A000000);

  TextPainter _text(String text) => TextPainter(
    text: TextSpan(
      text: text,
      style: TextStyle(
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        fontSize: 12,
        height: 1.2,
        color: const Color(0xFF666666),
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout();

  @override
  void paint(Canvas canvas, Size size) {
    final chartWidth = size.width.floorToDouble();
    final left = 50.696;
    final top = 10.2;
    // (room at the right for half of the last label — or, turned, much less)
    var right = chartWidth - 27.006;

    // Category labels that don't fit side by side are turned until they do
    // (`asin((lineHeight + 6) / tickWidth)`, at most 50 degrees).
    final labelPainters = [for (final label in labels) _text(label)];
    final widest = labelPainters.fold<double>(
      0,
      (m, p) => math.max(m, p.width),
    );
    final tickWidth = (right - left) / (labels.length - 1);
    var rotation = 0.0;
    if (widest + 6 > tickWidth) {
      rotation = math.min(
        math.asin(math.min((14.4 + 6) / tickWidth, 1)),
        50 * math.pi / 180,
      );
    }
    if (rotation != 0) right = chartWidth - 8.81;
    // The room under the plot: tick marks, padding and the (turned) labels.
    final labelsHeight = rotation == 0
        ? 14.4
        : widest * math.sin(rotation) + 14.4 * math.cos(rotation) + 3;
    final bottom = size.height - (rotation == 0 ? 28.4 : 11 + labelsHeight);

    // The value scale.
    final short = bottom - top < 120;
    final min = short ? 10000.0 : 12000.0;
    const max = 26000.0;
    final step = short ? 5000.0 : 2000.0;
    double yOf(double v) => bottom - (v - min) / (max - min) * (bottom - top);
    double xOf(int i) => left + i * (right - left) / (labels.length - 1);

    // Chart.js aligns 1px lines to the pixel grid.
    double align(double v) => v.roundToDouble() + 0.5;
    final grid = Paint()
      ..color = _grid
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    // Horizontal grid lines with their tick marks (8px, to the left) and labels.
    for (var v = min; v <= max; v += step) {
      final y = align(yOf(v));
      canvas.drawLine(Offset(left - 8, y), Offset(right, y), grid);
      final label = _text(_format(v));
      label.paint(
        canvas,
        Offset(left - 8 - 3 - label.width, yOf(v) - label.height / 2),
      );
    }
    // Vertical grid lines (and tick marks below) and category labels.
    for (var i = 0; i < labels.length; i++) {
      final x = align(xOf(i));
      canvas.drawLine(Offset(x, top), Offset(x, bottom + 8), grid);
      final label = labelPainters[i];
      if (rotation == 0) {
        label.paint(canvas, Offset(xOf(i) - label.width / 2, bottom + 8 + 3));
      } else {
        // `textAlign: right`, turned about the end of the label under its tick.
        canvas.save();
        canvas.translate(xOf(i), bottom + 8 + 3 + 7.2);
        canvas.rotate(-rotation);
        label.paint(canvas, Offset(-label.width, -label.height / 2));
        canvas.restore();
      }
    }

    // The line and its points.
    final path = Path();
    for (var i = 0; i < values.length; i++) {
      final point = Offset(xOf(i), yOf(values[i]));
      i == 0
          ? path.moveTo(point.dx, point.dy)
          : path.lineTo(point.dx, point.dy);
    }
    canvas.drawPath(
      path,
      Paint()
        ..color = _blue
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeJoin = StrokeJoin.miter,
    );
    for (var i = 0; i < values.length; i++) {
      final point = Offset(xOf(i), yOf(values[i]));
      canvas.drawCircle(point, 3, Paint()..color = _blue);
      canvas.drawCircle(
        point,
        3,
        Paint()
          ..color = _blue
          ..style = PaintingStyle.stroke
          // (the dataset's `borderWidth: 4` is the points' too)
          ..strokeWidth = 4,
      );
    }
  }

  static String _format(double v) {
    final s = v.round().toString();
    return s.length > 3
        ? '${s.substring(0, s.length - 3)},${s.substring(s.length - 3)}'
        : s;
  }

  @override
  bool shouldRepaint(_ChartPainter old) =>
      old.labels != labels || old.values != values;
}
