import 'package:flutter/widgets.dart';

/// A `<p class="float-end mb-1">` [floatText] (a link) and the paragraph that
/// follows it, [text] (or [span], for text with links in it): the paragraph's
/// lines wrap around the float — while they are level with it (its line, and
/// the `mb-1` under it) they are as much narrower as it is wide — and run full
/// width below.
///
/// [floatStyle] and [textStyle] are merged over the ambient text style.
class FloatEndText extends StatelessWidget {
  const FloatEndText({
    super.key,
    required this.floatText,
    this.text = '',
    this.span,
    this.floatStyle,
    this.onFloatTap,
    this.textStyle,
    this.floatMarginBottom = 4,
    this.bottomMargin = 0,
  });

  final String floatText;

  /// The paragraph's text — or [span].
  final String text;
  final InlineSpan? span;
  final TextStyle? floatStyle;

  /// Makes [floatText] a link (the pointing hand, this on a tap).
  final VoidCallback? onFloatTap;
  final TextStyle? textStyle;

  /// `mb-1` of the float.
  final double floatMarginBottom;

  /// The paragraph's own `margin-bottom`.
  final double bottomMargin;

  @override
  Widget build(BuildContext context) {
    final direction = Directionality.of(context);
    final base = DefaultTextStyle.of(context).style;
    final floatStyle = base.merge(this.floatStyle);
    final textStyle = base.merge(this.textStyle);
    final content = span ?? TextSpan(text: text);
    final plain = content.toPlainText();
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final floatPainter = TextPainter(
          text: TextSpan(text: floatText, style: floatStyle),
          textDirection: direction,
        )..layout();
        final floatWidth = floatPainter.width;
        final lineHeight =
            (floatStyle.fontSize ?? 16) * (floatStyle.height ?? 1.5);
        final floatBottom = lineHeight + floatMarginBottom;

        // The lines that start above the float's bottom edge are beside it.
        final narrow = TextPainter(
          text: TextSpan(style: textStyle, children: [content]),
          textDirection: direction,
        )..layout(maxWidth: width - floatWidth);
        var beside = 0;
        var top = 0.0;
        for (final line in narrow.computeLineMetrics()) {
          if (top < floatBottom) beside++;
          top += line.height;
        }
        var split = 0;
        for (var i = 0; i < beside && split < plain.length; i++) {
          var boundary = narrow.getLineBoundary(TextPosition(offset: split));
          // (an offset on the break may still report the line above it)
          if (boundary.end <= split && split + 1 < plain.length) {
            boundary = narrow.getLineBoundary(TextPosition(offset: split + 1));
          }
          split = boundary.end;
        }
        final first = _slice(content, 0, split);
        final rest = _slice(content, split, plain.length);

        return Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(bottom: bottomMargin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.only(end: floatWidth),
                    child: first == null
                        ? const SizedBox.shrink()
                        : Text.rich(first, style: textStyle),
                  ),
                  if (rest != null) Text.rich(rest, style: textStyle),
                ],
              ),
            ),
            PositionedDirectional(
              top: 0,
              end: 0,
              child: onFloatTap == null
                  ? Text(floatText, style: floatStyle)
                  : MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: onFloatTap,
                        child: Text(floatText, style: floatStyle),
                      ),
                    ),
            ),
          ],
        );
      },
    );
  }

  /// The part of [span] between the plain-text offsets [start] and [end], with
  /// its styles; the leading spaces of a continuation are dropped. Null when
  /// that is empty.
  static TextSpan? _slice(InlineSpan span, int start, int end) {
    var offset = 0;
    TextSpan? walk(InlineSpan node) {
      if (node is! TextSpan) {
        offset += 1; // a placeholder
        return null;
      }
      final children = <InlineSpan>[];
      String? text;
      final own = node.text;
      if (own != null) {
        final from = offset;
        offset += own.length;
        final a = (start - from).clamp(0, own.length);
        final b = (end - from).clamp(0, own.length);
        if (b > a) text = own.substring(a, b);
      }
      for (final child in node.children ?? const <InlineSpan>[]) {
        final sliced = walk(child);
        if (sliced != null) children.add(sliced);
      }
      if (text == null && children.isEmpty) return null;
      return TextSpan(
        text: text,
        style: node.style,
        recognizer: node.recognizer,
        mouseCursor: node.mouseCursor,
        children: children,
      );
    }

    final sliced = walk(span);
    if (sliced == null) return null;
    final plain = sliced.toPlainText();
    if (plain.trim().isEmpty) return null;
    return start == 0 ? _trimEnd(sliced) : _trimStart(sliced);
  }

  static TextSpan _trimStart(TextSpan span) {
    var done = false;
    TextSpan go(TextSpan node) {
      var text = node.text;
      if (!done && text != null) {
        text = text.trimLeft();
        if (text.isNotEmpty) done = true;
      }
      final children = <InlineSpan>[];
      for (final child in node.children ?? const <InlineSpan>[]) {
        children.add(child is TextSpan ? go(child) : child);
      }
      return TextSpan(
        text: text,
        style: node.style,
        recognizer: node.recognizer,
        mouseCursor: node.mouseCursor,
        children: children,
      );
    }

    return go(span);
  }

  static TextSpan _trimEnd(TextSpan span) {
    final plain = span.toPlainText();
    final trimmed = plain.trimRight().length;
    var offset = 0;
    TextSpan go(TextSpan node) {
      var text = node.text;
      if (text != null) {
        final keep = (trimmed - offset).clamp(0, text.length);
        offset += text.length;
        text = text.substring(0, keep);
      }
      final children = <InlineSpan>[];
      for (final child in node.children ?? const <InlineSpan>[]) {
        children.add(child is TextSpan ? go(child) : child);
      }
      return TextSpan(
        text: text,
        style: node.style,
        recognizer: node.recognizer,
        mouseCursor: node.mouseCursor,
        children: children,
      );
    }

    return go(span);
  }
}
