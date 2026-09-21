import 'package:flutter/widgets.dart';

import 'tokens/bs_form_style.dart';

/// A Bootstrap range slider (`.form-range`).
class BsFormRange extends StatefulWidget {
  const BsFormRange({
    super.key,
    required this.value,
    this.min = 0,
    this.max = 100,
    required this.onChanged,
    this.style,
  });

  final double value;
  final double min;
  final double max;

  /// Disables the control (dims the thumb to
  /// [BsFormStyle.rangeThumbDisabledBackground]) when null.
  final ValueChanged<double>? onChanged;

  /// Style overrides layered on top of [BsFormStyle.defaults].
  final BsFormStyle? style;

  @override
  State<BsFormRange> createState() => _BsFormRangeState();
}

class _BsFormRangeState extends State<BsFormRange> {
  bool _dragging = false;

  void _updateFromLocalX(double dx, double width, double thumbSize) {
    final usable = width - thumbSize;
    final t = usable <= 0
        ? 0.0
        : ((dx - thumbSize / 2) / usable).clamp(0.0, 1.0);
    widget.onChanged?.call(widget.min + t * (widget.max - widget.min));
  }

  @override
  Widget build(BuildContext context) {
    final style = BsFormStyle.defaults.merge(widget.style);
    final trackHeight =
        style.rangeTrackHeight ?? BsFormStyle.defaultRangeTrackHeight;
    final thumbSize = style.rangeThumbSize ?? BsFormStyle.defaultRangeThumbSize;
    final enabled = widget.onChanged != null;
    final fraction = widget.max == widget.min
        ? 0.0
        : ((widget.value - widget.min) / (widget.max - widget.min)).clamp(
            0.0,
            1.0,
          );

    final thumbColor = !enabled
        ? (style.rangeThumbDisabledBackground ??
              BsFormStyle.defaultRangeThumbDisabledBackground)
        : _dragging
        ? (style.rangeThumbActiveBackground ??
              BsFormStyle.defaults.rangeThumbActiveBackground!)
        : (style.rangeThumbBackground ??
              BsFormStyle.defaults.rangeThumbBackground!);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: enabled
              ? (details) => _updateFromLocalX(
                  details.localPosition.dx,
                  width,
                  thumbSize,
                )
              : null,
          onHorizontalDragStart: enabled
              ? (_) => setState(() => _dragging = true)
              : null,
          onHorizontalDragUpdate: enabled
              ? (details) => _updateFromLocalX(
                  details.localPosition.dx,
                  width,
                  thumbSize,
                )
              : null,
          onHorizontalDragEnd: enabled
              ? (_) => setState(() => _dragging = false)
              : null,
          child: SizedBox(
            height: thumbSize,
            width: double.infinity,
            child: Stack(
              alignment: Alignment.centerLeft,
              children: [
                Container(
                  height: trackHeight,
                  decoration: BoxDecoration(
                    color:
                        style.rangeTrackBackground ??
                        BsFormStyle.defaultRangeTrackBackground,
                    borderRadius: BorderRadius.circular(
                      style.rangeTrackBorderRadius ??
                          BsFormStyle.defaultRangeTrackBorderRadius,
                    ),
                  ),
                ),
                Positioned(
                  left: fraction * (width - thumbSize),
                  child: Container(
                    width: thumbSize,
                    height: thumbSize,
                    decoration: BoxDecoration(
                      color: thumbColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
