import 'package:flutter/widgets.dart';

import 'bs_box.dart';
import 'tokens/bs_link.dart';

/// A Bootstrap link (`<a>`): [BsLink.color] text with an underline, that
/// shifts to [BsLink.hoverColor] under the pointer and invokes [onTap].
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
    final color =
        widget.linkColor?.of(context) ??
        (_hovered ? BsLink.hoverColor : BsLink.color);
    final decoration = widget.textDecorationNone
        ? TextDecoration.none
        : _hovered
        ? (BsLink.hoverDecoration ?? BsLink.decoration)
        : BsLink.decoration;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: DefaultTextStyle.merge(
          style: TextStyle(
            color: color,
            decoration: decoration,
            decorationColor: color,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
