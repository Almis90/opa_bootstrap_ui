import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'tokens/bs_carousel_style.dart';

/// How [BsCarousel] transitions between slides.
enum BsCarouselTransition {
  /// `.carousel` (default): slides horizontally, mirroring how Material's
  /// `CarouselView` scrolls and snaps between items.
  slide,

  /// `.carousel-fade`: crossfades between slides instead of sliding.
  fade,
}

/// A single slide in a [BsCarousel].
class BsCarouselItem {
  const BsCarouselItem({required this.child, this.caption});

  /// Typically an [Image], filling the carousel's bounds.
  final Widget child;

  /// `.carousel-caption`: optional overlay content (e.g. a title and
  /// description), centered near the bottom of the slide.
  final Widget? caption;
}

/// A Bootstrap carousel (`.carousel`): a slideshow of [BsCarouselItem]s with
/// prev/next controls and position indicators, cycling automatically on
/// [interval].
///
/// Needs a bounded size from its parent (e.g. wrap it in a [SizedBox] or
/// [AspectRatio]), the same way [Image]s need bounds — the carousel itself
/// doesn't impose one.
class BsCarousel extends StatefulWidget {
  const BsCarousel({
    super.key,
    required this.items,
    this.initialIndex = 0,
    this.interval = const Duration(seconds: 5),
    this.transition = BsCarouselTransition.slide,
    this.showControls = true,
    this.showIndicators = true,
    this.pauseOnHover = true,
    this.wrap = true,
    this.style,
    this.onIndexChanged,
  }) : assert(items.length > 0, 'BsCarousel requires at least one item');

  /// The slides to cycle through.
  final List<BsCarouselItem> items;

  /// The slide shown first.
  final int initialIndex;

  /// How long each slide is shown before automatically advancing to the
  /// next. Pass null to disable autoplay (`data-bs-interval="false"`).
  final Duration? interval;

  /// Whether to slide or crossfade between slides.
  final BsCarouselTransition transition;

  /// Whether to show the prev/next arrow controls.
  final bool showControls;

  /// Whether to show the tappable position indicators.
  final bool showIndicators;

  /// Whether hovering the carousel pauses autoplay.
  final bool pauseOnHover;

  /// Whether prev/next and autoplay cycle past the first/last slide back
  /// around to the other end (`data-bs-wrap`).
  final bool wrap;

  /// Style overrides layered on top of [BsCarouselStyle.defaults].
  final BsCarouselStyle? style;

  /// Called whenever the active slide changes, whether by autoplay, a
  /// control, an indicator, or a swipe.
  final ValueChanged<int>? onIndexChanged;

  @override
  State<BsCarousel> createState() => _BsCarouselState();
}

class _BsCarouselState extends State<BsCarousel> {
  // A large virtual page count lets the PageView wrap seamlessly in either
  // direction; the real slide index is just the virtual page modulo the
  // item count.
  static const int _virtualMultiplier = 100000;

  late int _index = widget.initialIndex;
  late final PageController _pageController = PageController(initialPage: _virtualInitialPage);
  Timer? _timer;
  bool _hovering = false;

  bool get _loops => widget.wrap && widget.items.length > 1;

  int get _virtualInitialPage =>
      _loops ? widget.items.length * (_virtualMultiplier ~/ 2) + widget.initialIndex : widget.initialIndex;

  @override
  void initState() {
    super.initState();
    _scheduleAutoplay();
  }

  @override
  void didUpdateWidget(covariant BsCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.interval != widget.interval || oldWidget.items.length != widget.items.length) {
      _scheduleAutoplay();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _scheduleAutoplay() {
    _timer?.cancel();
    final interval = widget.interval;
    if (interval == null || widget.items.length < 2) return;
    _timer = Timer.periodic(interval, (_) {
      if (!_hovering) _step(1);
    });
  }

  void _setIndex(int index) {
    if (index == _index) return;
    setState(() => _index = index);
    widget.onIndexChanged?.call(index);
  }

  void _handlePageChanged(int page) {
    final count = widget.items.length;
    _setIndex(_loops ? page % count : page);
  }

  void _step(int delta) {
    final count = widget.items.length;
    if (count < 2) return;
    final duration = _resolvedStyle.transitionDuration ?? BsCarouselStyle.defaultTransitionDuration;

    if (widget.transition == BsCarouselTransition.slide) {
      final next = _index + delta;
      if (!widget.wrap && (next < 0 || next >= count)) return;
      final currentPage = _pageController.page?.round() ?? _pageController.initialPage;
      _pageController.animateToPage(currentPage + delta, duration: duration, curve: Curves.easeInOut);
    } else {
      final next = widget.wrap ? (_index + delta) % count : (_index + delta).clamp(0, count - 1);
      _setIndex(next);
    }
  }

  void _goTo(int target) {
    final count = widget.items.length;
    if (target == _index) return;
    final duration = _resolvedStyle.transitionDuration ?? BsCarouselStyle.defaultTransitionDuration;

    if (widget.transition == BsCarouselTransition.slide) {
      final currentPage = _pageController.page?.round() ?? _pageController.initialPage;
      var delta = target - _index;
      if (_loops) {
        delta %= count;
        if (delta > count ~/ 2) delta -= count;
      }
      _pageController.animateToPage(currentPage + delta, duration: duration, curve: Curves.easeInOut);
    } else {
      _setIndex(target);
    }
  }

  BsCarouselStyle get _resolvedStyle => BsCarouselStyle.defaults.merge(widget.style);

  @override
  Widget build(BuildContext context) {
    final style = _resolvedStyle;
    final count = widget.items.length;

    final Widget slides;
    if (widget.transition == BsCarouselTransition.fade) {
      slides = AnimatedSwitcher(
        duration: style.transitionDuration ?? BsCarouselStyle.defaultTransitionDuration,
        child: KeyedSubtree(key: ValueKey(_index), child: _buildSlide(widget.items[_index], style)),
      );
    } else {
      slides = PageView.builder(
        controller: _pageController,
        physics: count > 1 ? const PageScrollPhysics() : const NeverScrollableScrollPhysics(),
        onPageChanged: _handlePageChanged,
        itemCount: _loops ? count * _virtualMultiplier : count,
        itemBuilder: (context, i) => _buildSlide(widget.items[_loops ? i % count : i], style),
      );
    }

    return MouseRegion(
      onEnter: widget.pauseOnHover ? (_) => _hovering = true : null,
      onExit: widget.pauseOnHover ? (_) => _hovering = false : null,
      child: ClipRect(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final controlWidth = constraints.maxWidth * (style.controlWidthFraction ?? BsCarouselStyle.defaultControlWidthFraction);

            return Stack(
              fit: StackFit.expand,
              children: [
                slides,
                if (widget.showControls && count > 1) ...[
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    width: controlWidth,
                    child: _BsCarouselControl(direction: -1, style: style, onPressed: () => _step(-1)),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    width: controlWidth,
                    child: _BsCarouselControl(direction: 1, style: style, onPressed: () => _step(1)),
                  ),
                ],
                if (widget.showIndicators && count > 1)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: _BsCarouselIndicators(count: count, activeIndex: _index, style: style, onTap: _goTo),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSlide(BsCarouselItem item, BsCarouselStyle style) {
    return Stack(
      fit: StackFit.expand,
      children: [
        item.child,
        if (item.caption != null)
          Positioned(
            left: 0,
            right: 0,
            bottom: style.captionSpacer ?? BsCarouselStyle.defaultCaptionSpacer,
            child: Center(
              child: FractionallySizedBox(
                widthFactor: style.captionWidthFraction ?? BsCarouselStyle.defaultCaptionWidthFraction,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: style.captionPaddingY ?? BsCarouselStyle.defaultCaptionPaddingY,
                  ),
                  child: DefaultTextStyle.merge(
                    style: TextStyle(color: style.captionColor ?? BsCarouselStyle.defaultCaptionColor),
                    textAlign: TextAlign.center,
                    child: item.caption!,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// A prev/next arrow hotspot, spanning `$carousel-control-width` of the
/// carousel's edge and fading its chevron in on hover.
class _BsCarouselControl extends StatefulWidget {
  const _BsCarouselControl({required this.direction, required this.style, required this.onPressed});

  /// -1 for the leading (prev) control, 1 for the trailing (next) control.
  final int direction;

  final BsCarouselStyle style;
  final VoidCallback onPressed;

  @override
  State<_BsCarouselControl> createState() => _BsCarouselControlState();
}

class _BsCarouselControlState extends State<_BsCarouselControl> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final style = widget.style;
    final opacity = _hovered
        ? style.controlHoverOpacity ?? BsCarouselStyle.defaultControlHoverOpacity
        : style.controlOpacity ?? BsCarouselStyle.defaultControlOpacity;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onPressed,
        child: AnimatedOpacity(
          duration: style.controlTransitionDuration ?? BsCarouselStyle.defaultControlTransitionDuration,
          opacity: opacity,
          child: Center(
            child: Transform.rotate(
              angle: widget.direction < 0 ? math.pi : 0,
              child: CustomPaint(
                size: Size.square(style.controlIconSize ?? BsCarouselStyle.defaultControlIconSize),
                painter: _BsCarouselChevronPainter(style.controlColor ?? BsCarouselStyle.defaultControlColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BsCarouselChevronPainter extends CustomPainter {
  _BsCarouselChevronPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.12
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(size.width * 0.35, size.height * 0.2)
      ..lineTo(size.width * 0.65, size.height * 0.5)
      ..lineTo(size.width * 0.35, size.height * 0.8);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BsCarouselChevronPainter oldDelegate) => oldDelegate.color != color;
}

/// The row of tappable `.carousel-indicators` dots.
class _BsCarouselIndicators extends StatelessWidget {
  const _BsCarouselIndicators({required this.count, required this.activeIndex, required this.style, required this.onTap});

  final int count;
  final int activeIndex;
  final BsCarouselStyle style;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final spacer = style.indicatorSpacer ?? BsCarouselStyle.defaultIndicatorSpacer;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (var i = 0; i < count; i++)
          Padding(
            padding: EdgeInsets.symmetric(horizontal: spacer / 2),
            child: _BsCarouselIndicatorDot(active: i == activeIndex, style: style, onTap: () => onTap(i)),
          ),
      ],
    );
  }
}

class _BsCarouselIndicatorDot extends StatelessWidget {
  const _BsCarouselIndicatorDot({required this.active, required this.style, required this.onTap});

  final bool active;
  final BsCarouselStyle style;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final width = style.indicatorWidth ?? BsCarouselStyle.defaultIndicatorWidth;
    final height = style.indicatorHeight ?? BsCarouselStyle.defaultIndicatorHeight;
    final opacity = active
        ? style.indicatorActiveOpacity ?? BsCarouselStyle.defaultIndicatorActiveOpacity
        : style.indicatorOpacity ?? BsCarouselStyle.defaultIndicatorOpacity;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: SizedBox(
        width: width,
        height: style.indicatorHitAreaHeight ?? BsCarouselStyle.defaultIndicatorHitAreaHeight,
        child: Center(
          child: AnimatedOpacity(
            duration: style.indicatorTransitionDuration ?? BsCarouselStyle.defaultIndicatorTransitionDuration,
            opacity: opacity,
            child: ColoredBox(
              color: style.indicatorActiveBackground ?? BsCarouselStyle.defaultIndicatorActiveBackground,
              child: SizedBox(width: width, height: height),
            ),
          ),
        ),
      ),
    );
  }
}
