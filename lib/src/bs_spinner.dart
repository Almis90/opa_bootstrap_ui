import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'bs_visibility_gate.dart';

import 'tokens/bs_spinner_style.dart';
import 'bs_decorated_box.dart';

/// The regular and the small spinner.
enum BsSpinnerSize { normal, small }

/// A Bootstrap border spinner: a partial ring that spins continuously, drawn with a
/// [CustomPainter] arc under a [RotationTransition].
class BsSpinnerBorder extends StatefulWidget {
  const BsSpinnerBorder({
    super.key,
    this.color,
    this.size = BsSpinnerSize.normal,
    this.style,
    this.semanticsLabel = 'Loading...',
  });

  /// Defaults to the ambient [DefaultTextStyle] color.
  final Color? color;

  final BsSpinnerSize size;

  /// Style overrides layered on top of [BsSpinnerStyle.defaults]/
  /// [BsSpinnerStyle.small].
  final BsSpinnerStyle? style;

  /// Announced to screen readers. Pass null to omit it.
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

    final verticalAlign =
        style.verticalAlign ?? BsSpinnerStyle.defaultVerticalAlign;

    // (A repaint boundary: the spinner repaints every frame, forever, and
    // without one that would re-record whatever it shares a layer with, up to
    // a whole page.)
    final spinner = RepaintBoundary(
      child: Transform.translate(
        // // Nudges the spinner down from the baseline it would otherwise sit on next to inline text.
        offset: Offset(0, -verticalAlign),
        child: RotationTransition(
          turns: _controller,
          child: CustomPaint(
            size: Size.square(size),
            painter: _BsSpinnerBorderPainter(
              color: color,
              strokeWidth: borderWidth,
            ),
          ),
        ),
      ),
    );

    // (not spinning while scrolled out of view: see [BsVisibilityGate])
    final gated = BsVisibilityGate(
      onVisibilityChanged: (visible) =>
          visible ? _controller.repeat() : _controller.stop(),
      child: spinner,
    );
    return widget.semanticsLabel == null
        ? gated
        : Semantics(label: widget.semanticsLabel, child: gated);
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
    // // A 3/4 ring (270°), leaving a 90° gap, as in Bootstrap's spinner.
    canvas.drawArc(rect, 0, 1.5 * math.pi, false, paint);
  }

  @override
  bool shouldRepaint(covariant _BsSpinnerBorderPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}

/// A Bootstrap grow spinner: a filled dot that repeatedly scales and fades in from nothing,
/// then holds at full size through the second half of each cycle before resetting.
class BsSpinnerGrow extends StatefulWidget {
  const BsSpinnerGrow({
    super.key,
    this.color,
    this.size = BsSpinnerSize.normal,
    this.style,
    this.semanticsLabel = 'Loading...',
  });

  /// Defaults to the ambient [DefaultTextStyle] color.
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

    final verticalAlign =
        style.verticalAlign ?? BsSpinnerStyle.defaultVerticalAlign;

    // (A repaint boundary: it animates every frame, forever; see the border
    // spinner.)
    final spinner = RepaintBoundary(
      child: Transform.translate(
        // `$spinner-vertical-align` (`-.125em`): nudges the spinner down
        // from the baseline it would otherwise sit on next to inline text.
        offset: Offset(0, -verticalAlign),
        child: ScaleTransition(
          scale: _growth,
          child: FadeTransition(
            opacity: _growth,
            child: BsDecoratedBox(
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: SizedBox.square(dimension: size),
            ),
          ),
        ),
      ),
    );

    // (not spinning while scrolled out of view: see [BsVisibilityGate])
    final gated = BsVisibilityGate(
      onVisibilityChanged: (visible) =>
          visible ? _controller.repeat() : _controller.stop(),
      child: spinner,
    );
    return widget.semanticsLabel == null
        ? gated
        : Semantics(label: widget.semanticsLabel, child: gated);
  }
}
