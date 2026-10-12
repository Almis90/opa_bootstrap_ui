import 'package:flutter/widgets.dart';

import 'bs_variant.dart';

/// The icon Bootstrap's validation states put at the end of a control: a check mark in the
/// success color or an exclamation circle in the danger color, a little larger than 0.75 times
/// the font size.
class BsValidationIcon extends StatelessWidget {
  const BsValidationIcon({super.key, required this.valid, this.fontSize = 16});

  final bool valid;

  /// The control's font size, which the icon's size is measured against.
  final double fontSize;

  /// The icon's side: 0.75 times the font size plus 6.
  double get size => fontSize * 0.75 + 6;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _ValidationIconPainter(valid: valid),
    );
  }
}

class _ValidationIconPainter extends CustomPainter {
  _ValidationIconPainter({required this.valid});

  final bool valid;

  @override
  void paint(Canvas canvas, Size size) {
    if (valid) {
      // viewBox 0 0 8 8, fill #198754
      canvas.scale(size.width / 8);
      final path = Path()
        ..moveTo(2.3, 6.73)
        ..lineTo(0.6, 4.53)
        ..cubicTo(0.2, 3.49, 1.06, 3.13, 1.7, 3.73)
        ..lineTo(2.8, 5.13)
        ..lineTo(6.2, 1.33)
        ..cubicTo(6.8, 0.7, 7.8, 1.06, 7.4, 2.03)
        ..lineTo(3.4, 6.63)
        ..cubicTo(2.97, 7.13, 2.6, 7.03, 2.3, 6.73)
        ..close();
      canvas.drawPath(path, Paint()..color = BsVariant.success.color);
      return;
    }
    // viewBox 0 0 12 12, stroke #dc3545
    canvas.scale(size.width / 12);
    final color = BsVariant.danger.color;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..strokeJoin = StrokeJoin.round;
    canvas.drawCircle(const Offset(6, 6), 4.5, stroke);
    canvas.drawPath(
      Path()
        ..moveTo(5.8, 3.6)
        ..lineTo(6.2, 3.6)
        ..lineTo(6, 6.5)
        ..close(),
      stroke,
    );
    canvas.drawCircle(const Offset(6, 8.2), 0.6, Paint()..color = color);
  }

  @override
  bool shouldRepaint(_ValidationIconPainter old) => old.valid != valid;
}
