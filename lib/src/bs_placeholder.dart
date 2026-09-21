import 'package:flutter/widgets.dart';

import 'bs_colors.dart';
import 'tokens/bs_placeholder_style.dart';

/// Which Bootstrap `.placeholder` animation, if any, a [BsPlaceholder] runs.
enum BsPlaceholderAnimation {
  /// Static, at [BsPlaceholderStyle.opacityMin].
  none,

  /// `.placeholder-glow`: opacity breathes between
  /// [BsPlaceholderStyle.opacityMin] and [BsPlaceholderStyle.opacityMax].
  glow,

  /// `.placeholder-wave`: a light highlight band sweeps across the bar,
  /// the same shimmer technique common Flutter skeleton-loading
  /// implementations use (a translating gradient over the base color) —
  /// there's no Material/Cupertino widget for this to draw from directly.
  wave,
}

/// A Bootstrap placeholder (`.placeholder`): a solid bar standing in for
/// content that hasn't loaded yet.
///
/// Has no intrinsic width by default (fills its parent, like a block-level
/// `.placeholder`) — pass [width] to size it like Bootstrap's `.col-*`/
/// `.w-*` utilities would, or wrap several in a [Wrap]/[Column] to build up
/// a paragraph-shaped skeleton.
class BsPlaceholder extends StatefulWidget {
  const BsPlaceholder({
    super.key,
    this.width,
    this.height = 16,
    this.animation = BsPlaceholderAnimation.none,
    this.color,
    this.borderRadius = 4,
    this.style,
  });

  /// Null fills the available width.
  final double? width;

  final double height;

  final BsPlaceholderAnimation animation;

  /// Defaults to the ambient [DefaultTextStyle] color, matching
  /// Bootstrap's `background-color: currentColor`.
  final Color? color;

  final double borderRadius;

  /// Style overrides layered on top of [BsPlaceholderStyle.defaults].
  final BsPlaceholderStyle? style;

  @override
  State<BsPlaceholder> createState() => _BsPlaceholderState();
}

class _BsPlaceholderState extends State<BsPlaceholder> with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _syncController();
  }

  @override
  void didUpdateWidget(covariant BsPlaceholder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animation != widget.animation) _syncController();
  }

  void _syncController() {
    if (widget.animation == BsPlaceholderAnimation.none) {
      _controller?.dispose();
      _controller = null;
      return;
    }
    _controller ??= AnimationController(vsync: this, duration: const Duration(seconds: 2));
    if (widget.animation == BsPlaceholderAnimation.glow) {
      _controller!.repeat(reverse: true);
    } else {
      _controller!.repeat();
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = BsPlaceholderStyle.defaults.merge(widget.style);
    final minOpacity = style.opacityMin ?? BsPlaceholderStyle.defaultOpacityMin;
    final maxOpacity = style.opacityMax ?? BsPlaceholderStyle.defaultOpacityMax;
    final color = widget.color ?? DefaultTextStyle.of(context).style.color ?? BsColors.gray400;

    Widget bar = ColoredBox(color: color);
    if (widget.animation == BsPlaceholderAnimation.wave) {
      bar = Stack(
        fit: StackFit.expand,
        children: [bar, AnimatedBuilder(animation: _controller!, builder: (context, _) => _BsPlaceholderWave(progress: _controller!.value))],
      );
    }

    bar = ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: SizedBox(width: widget.width ?? double.infinity, height: widget.height, child: bar),
    );

    if (widget.animation == BsPlaceholderAnimation.glow) {
      return AnimatedBuilder(
        animation: _controller!,
        builder: (context, child) =>
            Opacity(opacity: minOpacity + (maxOpacity - minOpacity) * _controller!.value, child: child),
        child: bar,
      );
    }

    return Opacity(opacity: minOpacity, child: bar);
  }
}

/// The translating highlight band behind `.placeholder-wave`. Sized to
/// fill its [Stack] parent (via [StackFit.expand]), so a fractional
/// translation of exactly its own width sweeps it fully off to fully on.
class _BsPlaceholderWave extends StatelessWidget {
  const _BsPlaceholderWave({required this.progress});

  /// 0-1, looping.
  final double progress;

  @override
  Widget build(BuildContext context) {
    return FractionalTranslation(
      translation: Offset(-1 + progress * 2, 0),
      child: const DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Color(0x00FFFFFF), Color(0x4DFFFFFF), Color(0x00FFFFFF)]),
        ),
      ),
    );
  }
}
