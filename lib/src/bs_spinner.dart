import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'tokens/bs_spinner_style.dart';

/// `$spinner-width`/`$spinner-height` vs. their `-sm` counterparts.
enum BsSpinnerSize { normal, small }

/// A Bootstrap border spinner (`.spinner-border`): a partial ring that
/// spins continuously, the same shape Material's `CircularProgressIndicator`
/// draws for its indeterminate mode — reimplemented here with a
/// [CustomPainter] arc under a [RotationTransition] rather than importing
/// that Material-only widget, since this package has no Material/Cupertino
/// dependency.
class BsSpinnerBorder extends StatefulWidget {
  const BsSpinnerBorder({
    super.key,
    this.color,
    this.size = BsSpinnerSize.normal,
    this.style,
    this.semanticsLabel = 'Loading...',
  });

  /// Defaults to the ambient [DefaultTextStyle] color, matching
  /// Bootstrap's `border-color: currentColor`.
  final Color? color;

  final BsSpinnerSize size;

  /// Style overrides layered on top of [BsSpinnerStyle.defaults]/
  /// [BsSpinnerStyle.small].
  final BsSpinnerStyle? style;

  /// Announced to screen readers, matching Bootstrap's own recommended
  /// `.visually-hidden` status text. Pass null to omit it.
  final String? semanticsLabel;

  @override
  State<BsSpinnerBorder> createState() => _BsSpinnerBorderState();
}

class _BsSpinnerBorderState extends State<BsSpinnerBorder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration:
        _resolveStyle().animationDuration ??
        BsSpinnerStyle.defaultAnimationDuration,
  )..repeat();

  BsSpinnerStyle _resolveStyle() {
    final base = widget.size == BsSpinnerSize.small
        ? BsSpinnerStyle.small
        : BsSpinnerStyle.defaults;
    return base.merge(widget.style);
  }

  @override
  void didUpdateWidget(covariant BsSpinnerBorder oldWidget) {
    super.didUpdateWidget(oldWidget);
    final duration =
        _resolveStyle().animationDuration ??
        BsSpinnerStyle.defaultAnimationDuration;
    if (_controller.duration != duration) _controller.duration = duration;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = _resolveStyle();
    final size = style.size ?? BsSpinnerStyle.defaultSize;
    final borderWidth = style.borderWidth ?? BsSpinnerStyle.defaultBorderWidth;
    final color =
        widget.color ??
        DefaultTextStyle.of(context).style.color ??
        const Color(0xFF212529);

    final spinner = RotationTransition(
      turns: _controller,
      child: CustomPaint(
        size: Size.square(size),
        painter: _BsSpinnerBorderPainter(
          color: color,
          strokeWidth: borderWidth,
        ),
      ),
    );

    return widget.semanticsLabel == null
        ? spinner
        : Semantics(label: widget.semanticsLabel, child: spinner);
  }
}

class _BsSpinnerBorderPainter extends CustomPainter {
  _BsSpinnerBorderPainter({required this.color, required this.strokeWidth});

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth,
      size.height - strokeWidth,
    );
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    // A 3/4 ring (270°), leaving a 90° gap — the same proportions
    // Bootstrap's `border-right-color: transparent` trick produces.
    canvas.drawArc(rect, 0, 1.5 * math.pi, false, paint);
  }

  @override
  bool shouldRepaint(covariant _BsSpinnerBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}

/// A Bootstrap grow spinner (`.spinner-grow`): a filled dot that repeatedly
/// scales and fades in from nothing, then holds at full size before
/// resetting — matching `@keyframes spinner-grow`'s two keyframes (0% and
/// 50%, with the animation holding the 50% state through the second half
/// of each cycle before jumping back to 0%).
class BsSpinnerGrow extends StatefulWidget {
  const BsSpinnerGrow({
    super.key,
    this.color,
    this.size = BsSpinnerSize.normal,
    this.style,
    this.semanticsLabel = 'Loading...',
  });

  /// Defaults to the ambient [DefaultTextStyle] color, matching
  /// Bootstrap's `background-color: currentColor`.
  final Color? color;

  final BsSpinnerSize size;

  /// Style overrides layered on top of [BsSpinnerStyle.defaults]/
  /// [BsSpinnerStyle.small].
  final BsSpinnerStyle? style;

  /// Announced to screen readers. Pass null to omit it.
  final String? semanticsLabel;

  @override
  State<BsSpinnerGrow> createState() => _BsSpinnerGrowState();
}

class _BsSpinnerGrowState extends State<BsSpinnerGrow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration:
        _resolveStyle().animationDuration ??
        BsSpinnerStyle.defaultAnimationDuration,
  )..repeat();
  late final Animation<double> _growth = TweenSequence<double>([
    TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 50),
    TweenSequenceItem(tween: ConstantTween(1.0), weight: 50),
  ]).animate(_controller);

  BsSpinnerStyle _resolveStyle() {
    final base = widget.size == BsSpinnerSize.small
        ? BsSpinnerStyle.small
        : BsSpinnerStyle.defaults;
    return base.merge(widget.style);
  }

  @override
  void didUpdateWidget(covariant BsSpinnerGrow oldWidget) {
    super.didUpdateWidget(oldWidget);
    final duration =
        _resolveStyle().animationDuration ??
        BsSpinnerStyle.defaultAnimationDuration;
    if (_controller.duration != duration) _controller.duration = duration;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = _resolveStyle();
    final size = style.size ?? BsSpinnerStyle.defaultSize;
    final color =
        widget.color ??
        DefaultTextStyle.of(context).style.color ??
        const Color(0xFF212529);

    final spinner = ScaleTransition(
      scale: _growth,
      child: FadeTransition(
        opacity: _growth,
        child: DecoratedBox(
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: SizedBox.square(dimension: size),
        ),
      ),
    );

    return widget.semanticsLabel == null
        ? spinner
        : Semantics(label: widget.semanticsLabel, child: spinner);
  }
}
