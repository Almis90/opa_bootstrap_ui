import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'bs_focusable.dart';
import 'bs_theme.dart';
import 'tokens/bs_body.dart';
import 'tokens/bs_form_style.dart';
import 'bs_decorated_box.dart';

/// A Bootstrap range slider.
class BsFormRange extends StatefulWidget {
  const BsFormRange({
    super.key,
    required this.value,
    this.min = 0,
    this.max = 100,
    this.step = 1,
    required this.onChanged,
    this.style,
  });

  final double value;
  final double min;
  final double max;

  /// `step` (1 by default): the value is always a multiple of it counted from
  /// [min], so the thumb moves in jumps as it is dragged, and an arrow key moves
  /// it by this much.
  final double step;

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
    // // A native range input mirrors itself in a right-to-left layout (the minimum on the right,
    // // and dragging from the right increases the value), so the pixel math is measured from the
    // // reading-end edge instead of always the left.
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final effectiveDx = isRtl ? width - dx : dx;
    final usable = width - thumbSize;
    final t = usable <= 0
        ? 0.0
        : ((effectiveDx - thumbSize / 2) / usable).clamp(0.0, 1.0);
    _change(widget.min + t * (widget.max - widget.min));
  }

  /// What a native range does with a value: it lands on a multiple of `step`
  /// counted from `min` (the thumb moves in jumps, not smoothly), never past
  /// `max`.
  double _snap(double raw) {
    final step = widget.step;
    var value = raw.clamp(widget.min, widget.max);
    if (step > 0) {
      value = widget.min + ((value - widget.min) / step).round() * step;
      if (value > widget.max) value -= step; // the last multiple that fits
      // (0.1 * 3 is not 0.3: tidy what floating point left behind)
      value = double.parse(
        value.clamp(widget.min, widget.max).toStringAsFixed(10),
      );
    }
    return value;
  }

  void _change(double raw) {
    final value = _snap(raw);
    if (value != widget.value) widget.onChanged?.call(value);
  }

  /// A native range's keys: the arrows move by [BsFormRange.step] (in a
  /// right-to-left page the left arrow is the one that adds), Page Up/Down by a
  /// tenth of the range, Home/End to the ends.
  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is KeyUpEvent) return KeyEventResult.ignored;
    final rtl = Directionality.of(context) == TextDirection.rtl;
    final range = widget.max - widget.min;
    final key = event.logicalKey;
    double? target;
    if (key == LogicalKeyboardKey.arrowUp ||
        key ==
            (rtl
                ? LogicalKeyboardKey.arrowLeft
                : LogicalKeyboardKey.arrowRight)) {
      target = widget.value + widget.step;
    } else if (key == LogicalKeyboardKey.arrowDown ||
        key ==
            (rtl
                ? LogicalKeyboardKey.arrowRight
                : LogicalKeyboardKey.arrowLeft)) {
      target = widget.value - widget.step;
    } else if (key == LogicalKeyboardKey.pageUp) {
      target = widget.value + range / 10;
    } else if (key == LogicalKeyboardKey.pageDown) {
      target = widget.value - range / 10;
    } else if (key == LogicalKeyboardKey.home) {
      target = widget.min;
    } else if (key == LogicalKeyboardKey.end) {
      target = widget.max;
    }
    if (target == null) return KeyEventResult.ignored;
    _change(target);
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = BsTheme.of(context) == Brightness.dark;
    final style = (isDark ? BsFormStyle.darkDefaults : BsFormStyle.defaults)
        .merge(widget.style);
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

    // // A focused range (not only a keyboard-focused one: a clicked range keeps it) gives the
    // // thumb a 1px halo of the page's background and the focus ring. Flutter paints a list of
    // // shadows from first to last, so the halo goes last to be on top of the ring's translucent
    // // fill.
    final focusRing = [
      ...(style.inputFocusBoxShadow ?? BsFormStyle.defaultInputFocusBoxShadow),
      BoxShadow(color: BsBody.backgroundOf(context), spreadRadius: 1),
    ];

    return Focus(
      canRequestFocus: false,
      skipTraversal: true,
      onKeyEvent: enabled ? _onKey : null,
      child: BsFocusableBuilder(
        enabled: enabled,
        builder: (context, focused) => Builder(
          builder: (context) => LayoutBuilder(
            builder: (context, constraints) {
              final width = constraints.maxWidth;
              return GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: enabled
                    ? (details) {
                        Focus.of(context).requestFocus();
                        _updateFromLocalX(
                          details.localPosition.dx,
                          width,
                          thumbSize,
                        );
                      }
                    : null,
                onHorizontalDragStart: enabled
                    ? (_) {
                        Focus.of(context).requestFocus();
                        setState(() => _dragging = true);
                      }
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
                  // // The control is 24 logical pixels tall, with the thumb centered in it.
                  height: thumbSize < 24 ? 24 : thumbSize,
                  width: double.infinity,
                  child: Stack(
                    // (the focus ring reaches past the ends of the track)
                    clipBehavior: Clip.none,
                    alignment: AlignmentDirectional.centerStart,
                    children: [
                      BsDecoratedContainer(
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
                      PositionedDirectional(
                        start: fraction * (width - thumbSize),
                        child: BsDecoratedContainer(
                          width: thumbSize,
                          height: thumbSize,
                          decoration: BoxDecoration(
                            color: thumbColor,
                            borderRadius: BorderRadius.circular(
                              style.rangeThumbBorderRadius ??
                                  BsFormStyle.defaultRangeThumbBorderRadius,
                            ),
                            boxShadow: focused
                                ? focusRing
                                : style.rangeThumbBoxShadow,
                          ),
                        ),
                      ),
                    ],
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
