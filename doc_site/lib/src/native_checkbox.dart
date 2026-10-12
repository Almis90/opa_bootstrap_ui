import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

/// An unstyled `<input type="checkbox">`, as Chrome draws one: 13px, a 1px
/// border and 2px radius, filled blue (light blue in a dark page) with a check
/// mark when checked. For pages that use the bare element rather than
/// Bootstrap's `.form-check` (the Heroes example's `.checkbox` row).
class NativeCheckbox extends StatelessWidget {
  const NativeCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool> onChanged;

  static const double size = 13;

  @override
  Widget build(BuildContext context) {
    final dark = BsTheme.of(context) == Brightness.dark;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onChanged(!value),
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _CheckboxPainter(value: value, dark: dark),
        ),
      ),
    );
  }
}

class _CheckboxPainter extends CustomPainter {
  const _CheckboxPainter({required this.value, required this.dark});

  final bool value;
  final bool dark;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(2));
    if (value) {
      canvas.drawRRect(
        rrect,
        Paint()
          ..color = dark ? const Color(0xFF99C8FF) : const Color(0xFF0075FF),
      );
      final mark = Path()
        ..moveTo(2.9, 6.6)
        ..lineTo(5.2, 9.0)
        ..lineTo(10.2, 3.1);
      canvas.drawPath(
        mark,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.butt
          ..strokeJoin = StrokeJoin.miter
          ..color = dark ? const Color(0xFF3B3B3B) : const Color(0xFFFFFFFF),
      );
    } else {
      canvas.drawRRect(
        rrect,
        Paint()
          ..color = dark ? const Color(0xFF858585) : const Color(0xFF767676),
      );
      canvas.drawRRect(
        rrect.deflate(1),
        Paint()
          ..color = dark ? const Color(0xFF3B3B3B) : const Color(0xFFFFFFFF),
      );
    }
  }

  @override
  bool shouldRepaint(_CheckboxPainter old) =>
      old.value != value || old.dark != dark;
}
