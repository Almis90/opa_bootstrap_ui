import 'package:flutter/widgets.dart';

/// The triangle Bootstrap's CSS appends to every `.dropdown-toggle`
/// (`caret-down`): a `.3em` border triangle, so `.6em` wide and `.3em`
/// tall, filled with `currentColor` unless [color] is given. Lay it out
/// after `.255em` of margin, as the stylesheet does.
class DropdownCaret extends StatelessWidget {
  const DropdownCaret({super.key, this.color});

  /// `.dropdown-toggle::after`'s `margin-left`.
  static const double marginStart = 4.08;

  final Color? color;

  @override
  Widget build(BuildContext context) => CustomPaint(
    size: const Size(9.6, 4.8),
    painter: _CaretPainter(color ?? DefaultTextStyle.of(context).style.color ?? const Color(0xFF000000)),
  );
}

class _CaretPainter extends CustomPainter {
  _CaretPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      Path()
        ..moveTo(0, 0)
        ..lineTo(size.width, 0)
        ..lineTo(size.width / 2, size.height)
        ..close(),
      Paint()..color = color,
    );
  }

  @override
  bool shouldRepaint(covariant _CaretPainter oldDelegate) => oldDelegate.color != color;
}
