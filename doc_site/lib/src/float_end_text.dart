import 'package:flutter/widgets.dart';

/// A `<p class="float-end mb-1">` [floatText] (a link) and the paragraph that
/// follows it, [text]: the paragraph's lines wrap around the float — while
/// they are level with it (its line, `24px`, and the `mb-1` under it) they are
/// as much narrower as it is wide — and run full width below.
///
/// [floatStyle] and [textStyle] are merged over the ambient text style.
class FloatEndText extends StatelessWidget {
  const FloatEndText({
    super.key,
    required this.floatText,
    required this.text,
    this.floatStyle,
    this.textStyle,
    this.floatMarginBottom = 4,
    this.bottomMargin = 0,
  });

  final String floatText;
  final String text;
  final TextStyle? floatStyle;
  final TextStyle? textStyle;

  /// `mb-1` of the float.
  final double floatMarginBottom;

  /// The paragraph's own `margin-bottom`.
  final double bottomMargin;

  @override
  Widget build(BuildContext context) {
    final base = DefaultTextStyle.of(context).style;
    final floatStyle = base.merge(this.floatStyle);
    final textStyle = base.merge(this.textStyle);
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final floatPainter = TextPainter(
          text: TextSpan(text: floatText, style: floatStyle),
          textDirection: TextDirection.ltr,
        )..layout();
        final floatWidth = floatPainter.width;
        final lineHeight =
            (floatStyle.fontSize ?? 16) * (floatStyle.height ?? 1.5);
        final floatBottom = lineHeight + floatMarginBottom;

        // The lines that start above the float's bottom edge are beside it.
        final narrow = TextPainter(
          text: TextSpan(text: text, style: textStyle),
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: width - floatWidth);
        final lines = narrow.computeLineMetrics();
        var beside = 0;
        var top = 0.0;
        for (final line in lines) {
          if (top < floatBottom) beside++;
          top += line.height;
        }
        var split = 0;
        for (var i = 0; i < beside && split < text.length; i++) {
          var boundary = narrow.getLineBoundary(TextPosition(offset: split));
          // (an offset on the break may still report the line above it)
          if (boundary.end <= split && split + 1 < text.length) {
            boundary = narrow.getLineBoundary(TextPosition(offset: split + 1));
          }
          split = boundary.end;
        }
        final first = text.substring(0, split).trimRight();
        final rest = text.substring(split).trimLeft();

        return Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: bottomMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: floatWidth),
                    child: Text(first, style: textStyle),
                  ),
                  if (rest.isNotEmpty) Text(rest, style: textStyle),
                ],
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Text(floatText, style: floatStyle),
            ),
          ],
        );
      },
    );
  }
}
