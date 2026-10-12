import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';

import 'tokens/bs_carousel_style.dart';
import 'tokens/bs_transitions.dart';

/// How [BsCarousel] transitions between slides.
enum BsCarouselTransition {
  /// Slides horizontally, scrolling and snapping between items (the default).
  slide,

  /// Crossfades between slides instead of sliding.
  fade,
}

/// Programmatic control of a [BsCarousel] — mirrors Bootstrap's own
/// `bootstrap.Carousel` JS plugin: `next()`/`prev()`/`to()`/`pause()`/
/// `cycle()`. Needs [itemCount] up front (the same tradeoff Flutter's own
/// `TabController` makes with `length`) since [next]/[previous] resolve
/// wraparound — keep it (and [wrap]) in sync with [BsCarousel.items].length/
/// [BsCarousel.wrap] via their setters if those can change; [BsCarousel]
/// itself does this automatically for an internally-owned controller.
class BsCarouselController extends ChangeNotifier {
  BsCarouselController({required int itemCount, this.wrap = true, int initialIndex = 0})
    : assert(itemCount > 0, 'BsCarouselController requires at least one item'),
      _itemCount = itemCount,
      _index = initialIndex.clamp(0, itemCount - 1);

  int _itemCount;

  /// How many slides [next]/[previous]/[goTo] resolve wraparound against.
  int get itemCount => _itemCount;
  set itemCount(int value) {
    if (value == _itemCount) return;
    _itemCount = value;
    if (_index >= value) _setIndex(value == 0 ? 0 : value - 1);
  }

  /// Whether [next]/[previous] (and autoplay) cycle past the first/last
  /// slide back around to the other end.
  bool wrap;

  int _index;

  /// The currently active slide index.
  int get index => _index;

  bool _paused = false;

  /// Whether autoplay is currently paused via [pause] — independent of
  /// [BsCarousel.pauseOnHover]'s own automatic pausing.
  bool get isPaused => _paused;

  /// Advances to the next slide, wrapping per [wrap].
  void next() => goTo(_index + 1);

  /// Returns to the previous slide, wrapping per [wrap].
  void previous() => goTo(_index - 1);

  /// Jumps to a specific slide index, wrapping (or clamping, if [wrap] is
  /// false) out-of-range values.
  void goTo(int target) {
    if (_itemCount == 0) return;
    final resolved = wrap ? (target % _itemCount + _itemCount) % _itemCount : target.clamp(0, _itemCount - 1);
    _setIndex(resolved);
  }

  /// Stops autoplay until [cycle] resumes it.
  void pause() => _setPaused(true);

  /// Resumes autoplay after [pause]. ([BsCarousel] already starts cycling on its own per
  /// [BsCarousel.interval].)
  void cycle() => _setPaused(false);

  void _setIndex(int value) {
    if (value == _index) return;
    _index = value;
    notifyListeners();
  }

  void _setPaused(bool value) {
    if (value == _paused) return;
    _paused = value;
    notifyListeners();
  }

  /// Syncs [index] after an organic touch-swipe settles on a new page,
  /// bypassing [next]/[previous]/[goTo] entirely. Called by [BsCarousel]
  /// itself — no need to call this directly.
  void syncIndexFromSwipe(int index) => _setIndex(index);
}

/// A single slide in a [BsCarousel].
class BsCarouselItem {
  const BsCarouselItem({required this.child, this.caption});

  /// Typically an [Image], filling the carousel's bounds.
  final Widget child;

  /// Optional overlay content (for example a title and description), centered near the bottom
  /// of the slide.
  final Widget? caption;
}

/// A Bootstrap carousel: a slideshow of [BsCarouselItem]s with previous and next controls and
/// position indicators, cycling automatically on [interval].
///
/// Needs a bounded size from its parent (for example wrap it in a [SizedBox] or an
/// [AspectRatio]), the same way an [Image] does; the carousel itself does not impose one.
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
    this.controller,
    this.onSlide,
    this.onSlid,
  }) : assert(items.length > 0, 'BsCarousel requires at least one item');

  /// The slides to cycle through.
  final List<BsCarouselItem> items;

  /// The slide shown first.
  final int initialIndex;

  /// How long each slide is shown before automatically advancing to the next. Pass null to
  /// disable autoplay.
  final Duration? interval;

  /// Whether to slide or crossfade between slides.
  final BsCarouselTransition transition;

  /// Whether to show the prev/next arrow controls.
  final bool showControls;

  /// Whether to show the tappable position indicators.
  final bool showIndicators;

  /// Whether hovering the carousel pauses autoplay.
  final bool pauseOnHover;

  /// Whether previous, next and autoplay cycle past the first or last slide back around to the
  /// other end.
  final bool wrap;

  /// Style overrides layered on top of [BsCarouselStyle.defaults].
  final BsCarouselStyle? style;

  /// Called whenever the active slide changes, whether by autoplay, a
  /// control, an indicator, or a swipe.
  final ValueChanged<int>? onIndexChanged;

  /// Drives navigation instead of the built-in controls/indicators/swipe
  /// gesture alone. Defaults to an internally-owned controller (seeded
  /// from [items].length/[wrap]/[initialIndex], kept in sync with the
  /// first two as they change) when null.
  final BsCarouselController? controller;

  /// Called as soon as a transition to a new slide is triggered — by
  /// autoplay, a control, an indicator, [controller], or a swipe — before
  /// it starts animating. Mirrors Bootstrap's `slide.bs.carousel`.
  final VoidCallback? onSlide;

  /// Called once the transition to a new slide finishes. Mirrors
  /// Bootstrap's `slid.bs.carousel`.
  final VoidCallback? onSlid;

  @override
  State<BsCarousel> createState() => _BsCarouselState();
}

class _BsCarouselState extends State<BsCarousel> {
  // A virtual page count lets the PageView wrap seamlessly in either
  // direction; the real slide index is just the virtual page modulo the
  // item count. It stays small, and is re-centred whenever the carousel
  // settles near an end: a PageView of fractional-width pages asserts (in
  // debug) once its scroll extent is large enough to lose precision.
  static const int _virtualMultiplier = 40;
  static const int _recenterMargin = 5;

  BsCarouselController? _ownedController;
  late final PageController _pageController = PageController(initialPage: _virtualInitialPage);
  Timer? _timer;
  bool _hovering = false;

  /// True while a wheel / trackpad scroll event is being dispatched to the
  /// slide under it (see [_swallowWheel]).
  bool _wheelBlocked = false;

  /// A carousel swipes by touch only: a mouse wheel or a trackpad's two-finger scroll does
  /// nothing to it. Flutter's [PageView] would take them (on the web a two-finger swipe is a
  /// stream of horizontal wheel events, and one the engine sees consumed is kept from the
  /// browser, which would otherwise use it to go back). A slide hears the event before the
  /// [Scrollable] around it does, and the physics refuse it while this is set.
  void _swallowWheel(PointerSignalEvent event) {
    if (event is! PointerScrollEvent) return;
    _wheelBlocked = true;
    scheduleMicrotask(() => _wheelBlocked = false);
  }

  BsCarouselController get _controller =>
      widget.controller ??
      (_ownedController ??= BsCarouselController(
        itemCount: widget.items.length,
        wrap: widget.wrap,
        initialIndex: widget.initialIndex,
      ));

  bool get _loops => widget.wrap && widget.items.length > 1;

  int get _virtualInitialPage =>
      _loops ? widget.items.length * (_virtualMultiplier ~/ 2) + _controller.index : _controller.index;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleControllerChanged);
    _scheduleAutoplay();
  }

  @override
  void didUpdateWidget(covariant BsCarousel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // items.length/wrap only drive the internally-owned controller — an
    // explicit controller is always the source of truth once given.
    if (widget.controller == null) {
      _controller.itemCount = widget.items.length;
      _controller.wrap = widget.wrap;
    }
    if (oldWidget.interval != widget.interval || oldWidget.items.length != widget.items.length) {
      _scheduleAutoplay();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);
    _ownedController?.dispose();
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _scheduleAutoplay() {
    _timer?.cancel();
    final interval = widget.interval;
    if (interval == null || widget.items.length < 2) return;
    _timer = Timer.periodic(interval, (_) {
      if (!_hovering && !_controller.isPaused) _controller.next();
    });
  }

  void _handleControllerChanged() {
    widget.onIndexChanged?.call(_controller.index);
    widget.onSlide?.call();
    // (the indicators show the controller's index: slide mode, which only
    // animates the PageView below, must rebuild them itself)
    setState(() {});

    final duration = BsTransitions.resolve(
      context,
      _resolvedStyle.transitionDuration ?? BsCarouselStyle.defaultTransitionDuration,
    );
    if (widget.transition == BsCarouselTransition.slide) {
      final count = widget.items.length;
      final currentPage = _pageController.page?.round() ?? _pageController.initialPage;
      final currentIndex = _loops ? currentPage % count : currentPage;
      var delta = _controller.index - currentIndex;
      if (_loops) {
        delta %= count;
        if (delta > count ~/ 2) delta -= count;
      }
      // delta == 0 means the PageView is already showing this index (e.g.
      // syncIndexFromSwipe after an organic swipe already got it there) —
      // nothing to animate; onSlid already fires from _handlePageChanged,
      // which is what triggered this sync in the first place.
      if (delta != 0) {
        _pageController.animateToPage(currentPage + delta, duration: duration, curve: Curves.easeInOut);
      }
    } else {
      // (the setState above has AnimatedSwitcher/KeyedSubtree pick up the new index)
      // AnimatedSwitcher has no onEnd of its own to hook onSlid off of, so
      // this approximates it — swiping isn't possible in fade mode, so
      // there's no organic-completion signal to unify with instead.
      Future.delayed(duration, () {
        if (mounted) widget.onSlid?.call();
      });
    }
  }

  void _handlePageChanged(int page) {
    final count = widget.items.length;
    final resolved = _loops ? page % count : page;
    // A no-op (idempotent) call when this confirms a transition the
    // controller already initiated; syncs it when it's an organic swipe
    // instead, which _handleControllerChanged above then recognizes as a
    // delta of 0 needing no further animation.
    _controller.syncIndexFromSwipe(resolved);
    widget.onSlid?.call();
    if (_loops &&
        (page < count * _recenterMargin ||
            page >= count * (_virtualMultiplier - _recenterMargin))) {
      // The same slide, in the middle of the virtual range again.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || !_pageController.hasClients) return;
        _pageController.jumpToPage(count * (_virtualMultiplier ~/ 2) + resolved);
      });
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
        duration: BsTransitions.resolve(context, style.transitionDuration ?? BsCarouselStyle.defaultTransitionDuration),
        child: KeyedSubtree(
          key: ValueKey(_controller.index),
          child: _buildSlide(widget.items[_controller.index], style),
        ),
      );
    } else {
      slides = PageView.builder(
        controller: _pageController,
        physics: count > 1 ? _BsCarouselPhysics(() => _wheelBlocked) : const NeverScrollableScrollPhysics(),
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
            final controlWidth =
                constraints.maxWidth * (style.controlWidthFraction ?? BsCarouselStyle.defaultControlWidthFraction);

            return Stack(
              fit: StackFit.expand,
              children: [
                slides,
                // PositionedDirectional so "previous" stays on the
                // reading-start side (left in LTR, right in RTL) instead
                // of always physical left, matching Bootstrap's own
                // RTL-flipped .carousel-control-prev/-next.
                if (widget.showControls && count > 1) ...[
                  PositionedDirectional(
                    start: 0,
                    top: 0,
                    bottom: 0,
                    width: controlWidth,
                    child: _BsCarouselControl(direction: -1, style: style, onPressed: _controller.previous),
                  ),
                  PositionedDirectional(
                    end: 0,
                    top: 0,
                    bottom: 0,
                    width: controlWidth,
                    child: _BsCarouselControl(direction: 1, style: style, onPressed: _controller.next),
                  ),
                ],
                if (widget.showIndicators && count > 1)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: style.indicatorMarginBottom ?? BsCarouselStyle.defaultIndicatorMarginBottom,
                    child: _BsCarouselIndicators(
                      count: count,
                      activeIndex: _controller.index,
                      style: style,
                      onTap: _controller.goTo,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSlide(BsCarouselItem item, BsCarouselStyle style) {
    return Listener(
      behavior: HitTestBehavior.translucent,
      onPointerSignal: _swallowWheel,
      child: _buildSlideContent(item, style),
    );
  }

  Widget _buildSlideContent(BsCarouselItem item, BsCarouselStyle style) {
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

/// A previous or next arrow hotspot, spanning a strip of the carousel's edge and fading its
/// chevron in on hover.
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
          duration: BsTransitions.resolve(
            context,
            style.controlTransitionDuration ?? BsCarouselStyle.defaultControlTransitionDuration,
          ),
          opacity: opacity,
          child: Center(
            child: Transform.rotate(
              // The chevron should still visually point toward the
              // reading-backward/-forward direction once PositionedDirectional
              // flips this control's physical side under RTL, not always left
              // for prev/right for next.
              angle: (Directionality.of(context) == TextDirection.rtl ? widget.direction > 0 : widget.direction < 0)
                  ? math.pi
                  : 0,
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

  /// The chevron: a stroke 1 unit wide (of 16) with round ends, from (5, 2) to (11, 8) to (5, 14).
  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.width / 16;
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = unit
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path()
      ..moveTo(5 * unit, 2 * unit)
      ..lineTo(11 * unit, 8 * unit)
      ..lineTo(5 * unit, 14 * unit);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _BsCarouselChevronPainter oldDelegate) => oldDelegate.color != color;
}

/// The row of tappable indicator dots.
class _BsCarouselIndicators extends StatelessWidget {
  const _BsCarouselIndicators({
    required this.count,
    required this.activeIndex,
    required this.style,
    required this.onTap,
  });

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
            // The spacing on each side of an indicator.
            padding: EdgeInsets.symmetric(horizontal: spacer),
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
            duration: BsTransitions.resolve(
              context,
              style.indicatorTransitionDuration ?? BsCarouselStyle.defaultIndicatorTransitionDuration,
            ),
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

/// [PageScrollPhysics] that decline user scrolling while [blocked] says a
/// wheel event is being handled (drags and swipes are unaffected).
class _BsCarouselPhysics extends PageScrollPhysics {
  const _BsCarouselPhysics(this.blocked, {super.parent});

  final bool Function() blocked;

  @override
  _BsCarouselPhysics applyTo(ScrollPhysics? ancestor) => _BsCarouselPhysics(blocked, parent: buildParent(ancestor));

  @override
  bool shouldAcceptUserOffset(ScrollMetrics position) => !blocked() && super.shouldAcceptUserOffset(position);
}
