import 'package:flutter/widgets.dart';

/// The triangle Bootstrap's CSS appends to every `.dropdown-toggle`
/// (`caret-down`): a `.3em` border triangle, filled with `currentColor`
/// unless [color] is given. Lay it out after [marginStart] of margin, as the
/// stylesheet does.
///
/// Browsers snap border widths down to whole device pixels, so `.3em` of 16px
/// (4.8px) paints as 4px at 1x and 4.5px at 2x — an 8x4 (1x) or 9x4.5 (2x)
/// triangle, not 9.6x4.8. The same snapping is applied here.
class DropdownCaret extends StatelessWidget {
  const DropdownCaret({super.key, this.color, this.fontSize = 16});

  /// `.dropdown-toggle::after`'s `margin-left` (`.255em` of 16px).
  static const double marginStart = 4.08;

  final Color? color;

  /// The toggle's font size, which `.3em` is relative to.
  final double fontSize;

  /// The caret's height (its border width) for a toggle of [fontSize].
  static double heightFor(BuildContext context, {double fontSize = 16}) {
    final dpr = MediaQuery.maybeDevicePixelRatioOf(context) ?? 1;
    return (fontSize * 0.3 * dpr).floorToDouble() / dpr;
  }

  @override
  Widget build(BuildContext context) {
    final border = heightFor(context, fontSize: fontSize);
    return CustomPaint(
      size: Size(border * 2, border),
      painter: _CaretPainter(color ?? DefaultTextStyle.of(context).style.color ?? const Color(0xFF000000)),
    );
  }
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
