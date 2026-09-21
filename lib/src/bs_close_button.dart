import 'package:flutter/widgets.dart';

import 'tokens/bs_close_button_style.dart';
import 'tokens/bs_focus_ring.dart';

/// A Bootstrap close button (`.btn-close`): a small "×" glyph used to
/// dismiss alerts, modals, toasts, and offcanvas panels.
class BsCloseButton extends StatefulWidget {
  const BsCloseButton({super.key, required this.onPressed, this.style});

  /// Called when tapped. The button is rendered disabled when this is null.
  final VoidCallback? onPressed;

  /// Style overrides layered on top of [BsCloseButtonStyle.defaults].
  final BsCloseButtonStyle? style;

  @override
  State<BsCloseButton> createState() => _BsCloseButtonState();
}

class _BsCloseButtonState extends State<BsCloseButton> {
  bool _hovered = false;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final style = BsCloseButtonStyle.defaults.merge(widget.style);
    final enabled = widget.onPressed != null;

    final double opacity;
    if (!enabled) {
      opacity = style.disabledOpacity ?? BsCloseButtonStyle.defaultDisabledOpacity;
    } else if (_focused) {
      opacity = style.focusOpacity ?? BsCloseButtonStyle.defaultFocusOpacity;
    } else if (_hovered) {
      opacity = style.hoverOpacity ?? BsCloseButtonStyle.defaultHoverOpacity;
    } else {
      opacity = style.opacity ?? BsCloseButtonStyle.defaultOpacity;
    }

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: enabled ? (_) => setState(() => _hovered = true) : null,
      onExit: enabled ? (_) => setState(() => _hovered = false) : null,
      child: Focus(
        onFocusChange: (focused) => setState(() => _focused = focused),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onPressed,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 150),
            opacity: opacity,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              decoration: BoxDecoration(
                boxShadow: [
                  if (_focused)
                    BoxShadow(color: BsFocusRing.color(), spreadRadius: BsCloseButtonStyle.defaultFocusRingWidth),
                ],
              ),
              child: Padding(
                padding: style.padding ?? BsCloseButtonStyle.defaultPadding,
                child: CustomPaint(
                  size: Size.square(style.size ?? BsCloseButtonStyle.defaultSize),
                  painter: _BsCloseGlyphPainter(style.color ?? BsCloseButtonStyle.defaultColor),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BsCloseGlyphPainter extends CustomPainter {
  _BsCloseGlyphPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.width * 0.12
      ..strokeCap = StrokeCap.round;
    final inset = size.width * 0.15;
    canvas
      ..drawLine(Offset(inset, inset), Offset(size.width - inset, size.height - inset), paint)
      ..drawLine(Offset(size.width - inset, inset), Offset(inset, size.height - inset), paint);
  }

  @override
  bool shouldRepaint(covariant _BsCloseGlyphPainter oldDelegate) => oldDelegate.color != color;
}
