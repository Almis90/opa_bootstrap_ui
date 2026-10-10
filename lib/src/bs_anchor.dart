import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import 'bs_box.dart';
import 'tokens/bs_link.dart';

/// The color and decoration of a link: [BsLink]'s color (the dark theme's
/// tint in dark mode), shifting to its hover color under the pointer, or the
/// fixed [linkColor] (`link-secondary`, `link-body-emphasis`…); underlined
/// unless [textDecorationNone].
({Color color, TextDecoration decoration}) _anchorStyle(
  BuildContext context, {
  required bool hovered,
  required bool textDecorationNone,
  BsTextColor? linkColor,
}) {
  final color =
      linkColor?.of(context) ??
      (hovered ? BsLink.hoverColorOf(context) : BsLink.colorOf(context));
  final decoration = textDecorationNone
      ? TextDecoration.none
      : hovered
      ? (BsLink.hoverDecoration ?? BsLink.decoration)
      : BsLink.decoration;
  return (color: color, decoration: decoration);
}

/// A Bootstrap link (`<a>`): [BsLink.color] text with an underline, that
/// shifts to [BsLink.hoverColor] under the pointer and invokes [onTap].
///
/// For a link inside a sentence, see [BsInlineAnchors].
///
/// Named `BsAnchor` rather than `BsLink` because the latter already names
/// this package's raw link color/decoration tokens (`tokens/bs_link.dart`).
class BsAnchor extends StatefulWidget {
  const BsAnchor({
    super.key,
    required this.child,
    this.onTap,
    this.textDecorationNone = false,
    this.linkColor,
  });

  /// Typically a [Text].
  final Widget child;

  final VoidCallback? onTap;

  /// `text-decoration-none`: no underline, even on hover.
  final bool textDecorationNone;

  /// `link-body-emphasis`, `link-secondary`…: a fixed link color instead of
  /// [BsLink.color] (which shifts to [BsLink.hoverColor] on hover).
  final BsTextColor? linkColor;

  @override
  State<BsAnchor> createState() => _BsAnchorState();
}

class _BsAnchorState extends State<BsAnchor> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final style = _anchorStyle(
      context,
      hovered: _hovered,
      textDecorationNone: widget.textDecorationNone,
      linkColor: widget.linkColor,
    );

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: DefaultTextStyle.merge(
          style: TextStyle(
            color: style.color,
            decoration: style.decoration,
            decorationColor: style.color,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

/// Makes the [TextSpan] of one link in running text; see [BsInlineAnchors].
typedef BsAnchorSpanBuilder =
    TextSpan Function(
      String text, {
      VoidCallback? onTap,
      bool textDecorationNone,
      BsTextColor? linkColor,
    });

/// Links inside a sentence: what [BsAnchor] is for a link of its own.
///
/// A link in a paragraph can't be a widget without changing how the lines
/// break, so each is a [TextSpan] (the pointing hand, a tap recognizer, hover
/// colors) that [builder] puts in its [Text.rich] by calling the `anchor` it
/// is given. The widget owns the recognizers and the hover state, and calls
/// [builder] again when a link is entered or left:
///
/// ```dart
/// BsInlineAnchors(
///   builder: (context, anchor) => Text.rich(
///     TextSpan(children: [
///       const TextSpan(text: 'See the '),
///       anchor('docs', onTap: openDocs),
///       const TextSpan(text: '.'),
///     ]),
///   ),
/// )
/// ```
class BsInlineAnchors extends StatefulWidget {
  const BsInlineAnchors({super.key, required this.builder});

  final Widget Function(BuildContext context, BsAnchorSpanBuilder anchor)
  builder;

  @override
  State<BsInlineAnchors> createState() => _BsInlineAnchorsState();
}

class _BsInlineAnchorsState extends State<BsInlineAnchors> {
  final _recognizers = <TapGestureRecognizer>[];

  /// The link under the pointer, by the order [BsAnchorSpanBuilder] was called
  /// in during the build.
  int? _hovered;

  @override
  void dispose() {
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var next = 0;
    TextSpan anchor(
      String text, {
      VoidCallback? onTap,
      bool textDecorationNone = false,
      BsTextColor? linkColor,
    }) {
      final index = next++;
      while (_recognizers.length <= index) {
        _recognizers.add(TapGestureRecognizer());
      }
      final style = _anchorStyle(
        context,
        hovered: _hovered == index,
        textDecorationNone: textDecorationNone,
        linkColor: linkColor,
      );
      return TextSpan(
        text: text,
        style: TextStyle(
          color: style.color,
          decoration: style.decoration,
          decorationColor: style.color,
        ),
        recognizer: _recognizers[index]..onTap = onTap,
        mouseCursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = index),
        onExit: (_) => setState(() {
          if (_hovered == index) _hovered = null;
        }),
      );
    }

    return widget.builder(context, anchor);
  }
}
