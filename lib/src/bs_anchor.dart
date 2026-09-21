import 'package:flutter/widgets.dart';

import 'tokens/bs_link.dart';

/// A Bootstrap link (`<a>`): [BsLink.color] text with an underline, that
/// shifts to [BsLink.hoverColor] under the pointer and invokes [onTap].
///
/// Named `BsAnchor` rather than `BsLink` because the latter already names
/// this package's raw link color/decoration tokens (`tokens/bs_link.dart`).
class BsAnchor extends StatefulWidget {
  const BsAnchor({super.key, required this.child, this.onTap});

  /// Typically a [Text].
  final Widget child;

  final VoidCallback? onTap;

  @override
  State<BsAnchor> createState() => _BsAnchorState();
}

class _BsAnchorState extends State<BsAnchor> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final color = _hovered ? BsLink.hoverColor : BsLink.color;
    final decoration = _hovered
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
