import 'package:flutter/widgets.dart';

import 'bs_color_utils.dart';
import 'bs_clip_rrect.dart';
import 'bs_theme.dart';
import 'bs_visibility_gate.dart';
import 'bs_variant.dart';
import 'tokens/bs_progress_style.dart';
import 'tokens/bs_transitions.dart';
import 'bs_decorated_box.dart';

/// A Bootstrap progress track: a rounded, height-capped bar that hosts one or more
/// [BsProgressBar] segments.
///
/// Use the default constructor for the common single-bar case, or [BsProgress.stacked] to lay
/// out several [bars] side by side, each sized by its own value.
class BsProgress extends StatelessWidget {
  const BsProgress({
    super.key,
    this.value = 0,
    this.min = 0,
    this.max = 100,
    this.variant,
    this.striped = false,
    this.animated = false,
    this.label,
    this.height,
    this.style,
  }) : bars = null;

  const BsProgress.stacked({
    super.key,
    required this.bars,
    this.height,
    this.style,
  }) : value = 0,
       min = 0,
       max = 100,
       variant = null,
       striped = false,
       animated = false,
       label = null;

  /// The current value, between [min] and [max]. Ignored when [bars] is set.
  final double value;

  /// The value representing an empty bar. Ignored when [bars] is set.
  final double min;

  /// The value representing a full bar. Ignored when [bars] is set.
  final double max;

  /// The bar's color. Ignored when [bars] is set.
  final BsVariant? variant;

  /// Whether to render a diagonal stripe pattern. Ignored when [bars] is set.
  final bool striped;

  /// Whether the stripes scroll (implies [striped]). Ignored when [bars] is set.
  final bool animated;

  /// Content centered on the bar, e.g. a `Text('50%')`. Ignored when [bars]
  /// is set.
  final Widget? label;

  /// For [BsProgress.stacked]: the bars laid out side by side, each
  /// occupying a width proportional to its own value.
  final List<BsProgressBar>? bars;

  /// Defaults to [BsProgressStyle.defaultHeight].
  final double? height;

  /// Style overrides layered on top of [BsProgressStyle.defaults].
  final BsProgressStyle? style;

  @override
  Widget build(BuildContext context) {
    final isDark = BsTheme.of(context) == Brightness.dark;
    final style =
        (isDark ? BsProgressStyle.darkDefaults : BsProgressStyle.defaults)
            .merge(this.style);
    final borderRadius =
        style.borderRadius ?? BsProgressStyle.defaultBorderRadius;
    final bars =
        this.bars ??
        [
          BsProgressBar(
            value: value,
            min: min,
            max: max,
            variant: variant,
            striped: striped,
            animated: animated,
            label: label,
          ),
        ];

    final fractions = [
      for (final bar in bars)
        ((bar.value - bar.min) / (bar.max - bar.min)).clamp(0.0, 1.0),
    ];
    // // Each segment's width eases toward its new value rather than jumping.
    final transitionDuration = BsTransitions.resolve(
      context,
      style.barTransitionDuration ??
          BsProgressStyle.defaultBarTransitionDuration,
    );

    return BsClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BsDecoratedBox(
        decoration: BoxDecoration(
          color: style.background,
          boxShadow: style.boxShadow,
        ),
        child: SizedBox(
          height: height ?? style.height,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final totalWidth = constraints.maxWidth;
              return Row(
                children: [
                  for (var i = 0; i < bars.length; i++)
                    BsAnimatedContainer(
                      duration: transitionDuration,
                      curve: Curves.easeInOut,
                      width: totalWidth * fractions[i],
                      child: fractions[i] == 0
                          ? const SizedBox.shrink()
                          : bars[i],
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// A single Bootstrap progress bar segment, filling the width [BsProgress] allots it based on
/// [value].
class BsProgressBar extends StatefulWidget {
  const BsProgressBar({
    super.key,
    this.value = 0,
    this.min = 0,
    this.max = 100,
    this.variant,
    this.striped = false,
    this.animated = false,
    this.label,
    this.style,
  });

  /// The current value, between [min] and [max].
  final double value;

  /// The value representing an empty bar.
  final double min;

  /// The value representing a full bar.
  final double max;

  /// The bar's color. Defaults to [BsProgressStyle.defaultBarBackground].
  final BsVariant? variant;

  /// Whether to render a diagonal stripe pattern.
  final bool striped;

  /// Whether the stripes scroll; implies [striped].
  final bool animated;

  /// Content centered on the bar, e.g. a `Text('50%')`.
  final Widget? label;

  /// Style overrides layered on top of [BsProgressStyle.defaults].
  final BsProgressStyle? style;

  @override
  State<BsProgressBar> createState() => _BsProgressBarState();
}

class _BsProgressBarState extends State<BsProgressBar>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _syncController();
  }

  @override
  void didUpdateWidget(covariant BsProgressBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animated != widget.animated) _syncController();
  }

  void _syncController() {
    if (!widget.animated) {
      _controller?.dispose();
      _controller = null;
      return;
    }
    final style = BsProgressStyle.defaults.merge(widget.style);
    final duration = BsTransitions.resolve(
      context,
      style.barAnimationDuration ?? BsProgressStyle.defaultBarAnimationDuration,
    );
    if (_controller != null) {
      _controller!.duration = duration;
      return;
    }
    _controller = AnimationController(vsync: this, duration: duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = BsProgressStyle.defaults.merge(widget.style);
    final background =
        widget.variant?.color ??
        style.barBackground ??
        BsProgressStyle.defaultBarBackground;
    // // Light variants (warning, info, light) take dark text; on the others the bar's white is
    // // what is left.
    final color = widget.variant != null
        ? BsColorUtils.contrast(background)
        : style.barColor ?? BsProgressStyle.defaultBarColor;
    final striped = widget.striped || widget.animated;
    final rtl = Directionality.of(context) == TextDirection.rtl;

    final bar = BsDecoratedBox(
      decoration: BoxDecoration(color: background),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (striped)
            _controller == null
                ? CustomPaint(
                    painter: _BsProgressStripePainter(offset: 0, rtl: rtl),
                  )
                // (a repaint boundary: the stripes repaint every frame, forever)
                : RepaintBoundary(
                    child: AnimatedBuilder(
                      animation: _controller!,
                      builder: (context, _) => CustomPaint(
                        painter: _BsProgressStripePainter(
                          offset: _controller!.value,
                          rtl: rtl,
                        ),
                      ),
                    ),
                  ),
          if (widget.label != null)
            Center(
              child: DefaultTextStyle.merge(
                style: TextStyle(
                  color: color,
                  fontSize: style.fontSize,
                  height: 1,
                ),
                child: widget.label!,
              ),
            ),
        ],
      ),
    );
    // (the stripes stop sliding while scrolled out of view: see [BsVisibilityGate])
    final controller = _controller;
    if (controller == null) return bar;
    return BsVisibilityGate(
      onVisibilityChanged: (visible) =>
          visible ? controller.repeat() : controller.stop(),
      child: bar,
    );
  }
}

/// Draws the diagonal stripes of a striped bar: 45° stripes leaning `\`, half a tile wide on a
/// one-tile pitch, in a tile as wide and tall as the bar. The left edge of a stripe on row `y`
/// is at `x = y` (plus a multiple of the tile).
///
/// [offset] (0 to 1, looping) animates the bar: the stripes slide left by one tile (one whole
/// period) per cycle.
class _BsProgressStripePainter extends CustomPainter {
  const _BsProgressStripePainter({required this.offset, this.rtl = false});

  /// 0-1, looping.
  final double offset;

  /// The stripes of a right-to-left page: Bootstrap's RTL stylesheet mirrors
  /// the gradient (`-45deg`), so they lean `/` — with the left edge of the stripe
  /// on row `y` at `x = tile / 2 - y` — but they still slide left.
  final bool rtl;

  static const Color _stripeColor = Color(0x26FFFFFF);

  @override
  void paint(Canvas canvas, Size size) {
    final tile = size.height;
    if (tile <= 0) return;
    final paint = Paint()..color = _stripeColor;
    canvas.save();
    canvas.clipRect(Offset.zero & size);

    final phase = tile * (1 - offset);
    // Every stripe's top-left corner, from far enough left that the lean has
    // brought it into view by the bottom row.
    for (var x = (phase % tile) - 2 * tile; x < size.width; x += tile) {
      final path = rtl
          ? (Path()
              ..moveTo(x + tile / 2, 0)
              ..lineTo(x + tile, 0)
              ..lineTo(x + tile - size.height, size.height)
              ..lineTo(x + tile / 2 - size.height, size.height)
              ..close())
          : (Path()
              ..moveTo(x, 0)
              ..lineTo(x + tile / 2, 0)
              ..lineTo(x + tile / 2 + size.height, size.height)
              ..lineTo(x + size.height, size.height)
              ..close());
      canvas.drawPath(path, paint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BsProgressStripePainter oldDelegate) =>
      oldDelegate.offset != offset || oldDelegate.rtl != rtl;
}
