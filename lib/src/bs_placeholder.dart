import 'package:flutter/widgets.dart';

import 'bs_clip_rrect.dart';
import 'bs_colors.dart';
import 'bs_visibility_gate.dart';
import 'tokens/bs_placeholder_style.dart';
import 'tokens/bs_transitions.dart';
import 'bs_decorated_box.dart';

/// Which animation, if any, a [BsPlaceholder] runs.
enum BsPlaceholderAnimation {
  /// Static, at [BsPlaceholderStyle.opacityMax].
  none,

  /// Opacity breathes between [BsPlaceholderStyle.opacityMin] and
  /// [BsPlaceholderStyle.opacityMax].
  glow,

  /// A light highlight band sweeps across the bar: a translating gradient over the base color.
  wave,
}

/// A Bootstrap placeholder: a solid bar standing in for content that has not loaded yet.
///
/// Fills its parent's width by default; pass [width] to size it, or wrap several in a [Wrap]
/// or a [Column] to build up a paragraph-shaped skeleton.
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

  /// Defaults to the ambient [DefaultTextStyle] color.
  final Color? color;

  final double borderRadius;

  /// Style overrides layered on top of [BsPlaceholderStyle.defaults].
  final BsPlaceholderStyle? style;

  @override
  State<BsPlaceholder> createState() => _BsPlaceholderState();
}

class _BsPlaceholderState extends State<BsPlaceholder>
    with SingleTickerProviderStateMixin {
  static const _baseDuration = Duration(seconds: 2);

  AnimationController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
    final duration = BsTransitions.resolve(context, _baseDuration);
    if (_controller == null) {
      _controller = AnimationController(vsync: this, duration: duration);
    } else {
      _controller!.duration = duration;
    }
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

  /// Stops the glow or wave while the placeholder is scrolled out of view (see
  /// [BsVisibilityGate]) and starts it again when it is back.
  Widget _gated(Widget child) {
    final controller = _controller;
    if (controller == null) return child;
    return BsVisibilityGate(
      onVisibilityChanged: (visible) {
        if (!visible) {
          controller.stop();
        } else if (widget.animation == BsPlaceholderAnimation.glow) {
          controller.repeat(reverse: true);
        } else {
          controller.repeat();
        }
      },
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = BsPlaceholderStyle.defaults.merge(widget.style);
    final minOpacity = style.opacityMin ?? BsPlaceholderStyle.defaultOpacityMin;
    final maxOpacity = style.opacityMax ?? BsPlaceholderStyle.defaultOpacityMax;
    final color =
        widget.color ??
        DefaultTextStyle.of(context).style.color ??
        BsColors.gray400;

    Widget bar = ColoredBox(color: color);
    if (widget.animation == BsPlaceholderAnimation.wave) {
      bar = Stack(
        fit: StackFit.expand,
        children: [
          bar,
          AnimatedBuilder(
            animation: _controller!,
            builder: (context, _) =>
                _BsPlaceholderWave(progress: _controller!.value),
          ),
        ],
      );
    }

    bar = BsClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: SizedBox(
        width: widget.width ?? double.infinity,
        height: widget.height,
        child: bar,
      ),
    );

    // (A repaint boundary round what animates forever, so a tick doesn't
    // re-record the page around it.)
    if (widget.animation == BsPlaceholderAnimation.glow) {
      return _gated(
        RepaintBoundary(
          child: AnimatedBuilder(
            animation: _controller!,
            builder: (context, child) => Opacity(
              opacity:
                  minOpacity + (maxOpacity - minOpacity) * _controller!.value,
              child: child,
            ),
            child: bar,
          ),
        ),
      );
    }

    // Only the glow variant dips down to the minimum opacity (via its animation). The static and
    // wave variants rest at the maximum opacity.
    return widget.animation == BsPlaceholderAnimation.wave
        ? _gated(
            RepaintBoundary(
              child: Opacity(opacity: maxOpacity, child: bar),
            ),
          )
        : Opacity(opacity: maxOpacity, child: bar);
  }
}

/// The translating highlight band behind the wave animation. Sized to fill its [Stack] parent
/// (via [StackFit.expand]), so a fractional translation of exactly its own width sweeps it
/// fully off to fully on.
class _BsPlaceholderWave extends StatelessWidget {
  const _BsPlaceholderWave({required this.progress});

  /// 0-1, looping.
  final double progress;

  @override
  Widget build(BuildContext context) {
    return FractionalTranslation(
      translation: Offset(-1 + progress * 2, 0),
      child: const BsDecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0x00FFFFFF), Color(0x4DFFFFFF), Color(0x00FFFFFF)],
          ),
        ),
      ),
    );
  }
}
