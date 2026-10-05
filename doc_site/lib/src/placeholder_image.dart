import 'package:flutter/widgets.dart';

/// Bootstrap's docs `<Placeholder />`: an SVG of [height] px with a flat grey
/// fill and a line of centred text (`.bd-placeholder-img`: `font-size:
/// 1.125rem`, text at `y=50%` with `dy=.3em`), as wide as it is allowed to be.
class PlaceholderImage extends StatelessWidget {
  const PlaceholderImage({
    super.key,
    required this.height,
    required this.text,
    this.background = const Color(0xFF868E96),
    this.color = const Color(0xFFDEE2E6),
  });

  final double height;
  final String text;
  final Color background;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final family = DefaultTextStyle.of(context).style;
    return SizedBox(
      width: double.infinity,
      height: height,
      child: CustomPaint(
        painter: _PlaceholderPainter(
          text: text,
          background: background,
          style: family.copyWith(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.w400,
            height: null,
          ),
        ),
      ),
    );
  }
}

class _PlaceholderPainter extends CustomPainter {
  _PlaceholderPainter({
    required this.text,
    required this.background,
    required this.style,
  });

  final String text;
  final Color background;
  final TextStyle style;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = background);
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
    )..layout();
    final baseline = painter.computeDistanceToActualBaseline(
      TextBaseline.alphabetic,
    );
    // dy=".3em": the baseline sits .3em below the vertical middle.
    final y = size.height / 2 + 0.3 * 18;
    painter.paint(
      canvas,
      Offset((size.width - painter.width) / 2, y - baseline),
    );
  }

  @override
  bool shouldRepaint(_PlaceholderPainter oldDelegate) =>
      oldDelegate.text != text ||
      oldDelegate.background != background ||
      oldDelegate.style != style;
}
