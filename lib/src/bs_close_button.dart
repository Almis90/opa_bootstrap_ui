import 'package:flutter/widgets.dart';

import 'bs_focusable.dart';
import 'bs_theme.dart';
import 'tokens/bs_close_button_style.dart';
import 'tokens/bs_focus_ring.dart';
import 'tokens/bs_transitions.dart';
import 'bs_decorated_box.dart';

/// A Bootstrap close button: a small "×" glyph used to dismiss alerts, modals, toasts and
/// offcanvas panels.
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

  @override
  Widget build(BuildContext context) {
    final isDark = BsTheme.of(context) == Brightness.dark;
    final style = (isDark ? BsCloseButtonStyle.darkDefaults : BsCloseButtonStyle.defaults).merge(widget.style);
    final enabled = widget.onPressed != null;

    // // The button is a fixed square that never stretches. A plain SizedBox cannot guarantee
    // // that on its own: a parent that hands down tight constraints (for example a Container with
    // // an infinite width wrapping this directly, with no Center, Align or Row of its own) still
    // // clamps the SizedBox's requested size to the tight value. UnconstrainedBox breaks out of
    // // that by giving its child loose constraints regardless of what the parent forces, so the
    // // button always renders at its natural size.
    final glyphSize = style.size ?? BsCloseButtonStyle.defaultSize;
    final padding = style.padding ?? BsCloseButtonStyle.defaultPadding;
    final resolvedPadding = padding.resolve(Directionality.of(context));

    return UnconstrainedBox(
      child: SizedBox(
        width: glyphSize + resolvedPadding.horizontal,
        height: glyphSize + resolvedPadding.vertical,
        child: MouseRegion(
          cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
          onEnter: enabled ? (_) => setState(() => _hovered = true) : null,
          onExit: enabled ? (_) => setState(() => _hovered = false) : null,
          child: BsFocusableBuilder(
            builder: (context, focused) {
              final double opacity;
              if (!enabled) {
                opacity = style.disabledOpacity ?? BsCloseButtonStyle.defaultDisabledOpacity;
              } else if (focused) {
                opacity = style.focusOpacity ?? BsCloseButtonStyle.defaultFocusOpacity;
              } else if (_hovered) {
                opacity = style.hoverOpacity ?? BsCloseButtonStyle.defaultHoverOpacity;
              } else {
                opacity = style.opacity ?? BsCloseButtonStyle.defaultOpacity;
              }

              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: widget.onPressed,
                child: AnimatedOpacity(
                  duration: BsTransitions.resolve(context, const Duration(milliseconds: 150)),
                  opacity: opacity,
                  child: BsAnimatedContainer(
                    duration: BsTransitions.resolve(context, const Duration(milliseconds: 150)),
                    decoration: BoxDecoration(
                      color: style.background,
                      borderRadius: style.borderRadius,
                      boxShadow: [
                        if (focused)
                          BoxShadow(color: BsFocusRing.color(), spreadRadius: BsCloseButtonStyle.defaultFocusRingWidth),
                      ],
                    ),
                    child: Padding(
                      padding: padding,
                      child: CustomPaint(
                        size: Size.square(glyphSize),
                        painter: _BsCloseGlyphPainter(style.color ?? BsCloseButtonStyle.defaultColor),
                      ),
                    ),
                  ),
                ),
              );
            },
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
    // // Two strokes 2 units wide with round ends, from (1, 1) to (15, 15) of a 16-unit square,
    // // so that the glyph fills the square.
    final unit = size.width / 16;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2 * unit
      ..strokeCap = StrokeCap.round;
    final inset = unit;
    canvas
      ..drawLine(Offset(inset, inset), Offset(size.width - inset, size.height - inset), paint)
      ..drawLine(Offset(size.width - inset, inset), Offset(inset, size.height - inset), paint);
  }

  @override
  bool shouldRepaint(covariant _BsCloseGlyphPainter oldDelegate) => oldDelegate.color != color;
}

/// A close button for a modal or offcanvas header: its padding is half of the header's
/// [headerPadding] and its margin the negative of it, so the glyph sits where the header's
/// padding ends and the button's box reaches out into that padding without taking room.
class BsHeaderCloseButton extends StatelessWidget {
  const BsHeaderCloseButton({super.key, required this.onPressed, this.headerPadding = 16});

  final VoidCallback? onPressed;
  final double headerPadding;

  @override
  Widget build(BuildContext context) {
    final half = headerPadding / 2;
    const glyph = BsCloseButtonStyle.defaultSize;
    return SizedBox(
      width: glyph,
      height: glyph,
      child: OverflowBox(
        minWidth: glyph + 2 * half,
        maxWidth: glyph + 2 * half,
        minHeight: glyph + 2 * half,
        maxHeight: glyph + 2 * half,
        child: BsCloseButton(onPressed: onPressed, style: BsCloseButtonStyle(padding: EdgeInsets.all(half))),
      ),
    );
  }
}
