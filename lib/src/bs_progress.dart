import 'package:flutter/widgets.dart';

import 'bs_variant.dart';
import 'tokens/bs_progress_style.dart';

/// A Bootstrap progress track (`.progress`): a rounded, height-capped bar
/// that hosts one or more [BsProgressBar] segments.
///
/// Use the default constructor for the common single-bar case, or
/// [BsProgress.stacked] to lay out several [bars] side by side (Bootstrap's
/// "multiple bars" pattern), each sized by its own value.
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

  /// Whether to render `.progress-bar-striped`. Ignored when [bars] is set.
  final bool striped;

  /// Whether to render `.progress-bar-animated` (implies [striped]).
  /// Ignored when [bars] is set.
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
    final style = BsProgressStyle.defaults.merge(this.style);
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
    // `$progress-bar-transition` (`width .6s ease`): each segment's width
    // eases toward its new value rather than jumping, the same as the
    // CSS `transition: width` on `.progress-bar`.
    final transitionDuration =
        style.barTransitionDuration ??
        BsProgressStyle.defaultBarTransitionDuration;

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: DecoratedBox(
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
                    AnimatedContainer(
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

/// A single Bootstrap `.progress-bar` segment, filling the width [BsProgress]
/// allots it based on [value].
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

  /// Whether to render the diagonal `.progress-bar-striped` pattern.
  final bool striped;

  /// Whether the stripes scroll (`.progress-bar-animated`); implies
  /// [striped].
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
  void initState() {
    super.initState();
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
    _controller ??= AnimationController(
      vsync: this,
      duration:
          style.barAnimationDuration ??
          BsProgressStyle.defaultBarAnimationDuration,
    )..repeat();
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
        style.barBackground ??
        widget.variant?.color ??
        BsProgressStyle.defaultBarBackground;
    final color = style.barColor ?? BsProgressStyle.defaultBarColor;
    final striped = widget.striped || widget.animated;

    return DecoratedBox(
      decoration: BoxDecoration(color: background),
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (striped)
            _controller == null
                ? const CustomPaint(
                    painter: _BsProgressStripePainter(offset: 0),
                  )
                : AnimatedBuilder(
                    animation: _controller!,
                    builder: (context, _) => CustomPaint(
                      painter: _BsProgressStripePainter(
                        offset: _controller!.value,
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
  }
}

/// Draws `.progress-bar-striped`'s 45°, 1rem-tiled `rgba(255,255,255,.15)`
/// diagonal stripes. [offset] (0-1, looping) shifts the pattern by one tile
/// for `.progress-bar-animated`.
class _BsProgressStripePainter extends CustomPainter {
  const _BsProgressStripePainter({required this.offset});

  /// 0-1, looping.
  final double offset;

  static const double _tile = 16;
  static const Color _stripeColor = Color(0x26FFFFFF);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = _stripeColor;
    canvas.save();
    canvas.clipRect(Offset.zero & size);

    final span = size.width + size.height;
    final shift = offset * _tile * 2;
    for (var x = -span + shift; x < span; x += _tile * 2) {
      final path = Path()
        ..moveTo(x, size.height)
        ..lineTo(x + size.height, 0)
        ..lineTo(x + size.height + _tile, 0)
        ..lineTo(x + _tile, size.height)
        ..close();
      canvas.drawPath(path, paint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _BsProgressStripePainter oldDelegate) =>
      oldDelegate.offset != offset;
}
