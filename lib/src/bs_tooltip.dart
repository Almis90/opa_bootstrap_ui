import 'dart:async';

import 'package:flutter/widgets.dart';

import 'bs_theme.dart';
import 'tokens/bs_tooltip_style.dart';
import 'tokens/bs_transitions.dart';

/// Which side of [BsTooltip.child] the bubble opens on, with its arrow
/// pointing back at it.
enum BsTooltipPlacement { top, bottom, start, end }

/// Programmatic control of a [BsTooltip], independent of its hover/
/// long-press triggers — mirrors Bootstrap's own `tooltip.enable()`/
/// `.disable()`/`.toggleEnabled()`, `.show()`/`.hide()`/`.toggle()`, and
/// `.setContent()` API, plus a `setPlacement` with no Bootstrap equivalent
/// (Popper.js has no notion of a controller to expose one through).
class BsTooltipController extends ChangeNotifier {
  BsTooltipController({bool enabled = true}) {
    _enabled = enabled;
  }

  late bool _enabled;
  bool _shown = false;
  Widget? _content;
  BsTooltipPlacement? _placement;

  /// Whether the tooltip currently responds to hover/long-press.
  bool get enabled => _enabled;

  void enable() => _setEnabled(true);

  void disable() => _setEnabled(false);

  /// Flips [enabled], or sets it to [value] if given.
  void toggleEnabled([bool? value]) => _setEnabled(value ?? !_enabled);

  void _setEnabled(bool value) {
    if (value == _enabled) return;
    _enabled = value;
    if (!value) _shown = false;
    notifyListeners();
  }

  /// Whether the tooltip bubble is currently visible.
  bool get isShown => _shown;

  /// Shows the tooltip bubble immediately, bypassing [BsTooltip.waitDuration].
  /// Does nothing while [enabled] is false.
  void show() {
    if (!_enabled) return;
    _setShown(true);
  }

  /// Hides the tooltip bubble immediately, bypassing [BsTooltip.showDuration].
  void hide() => _setShown(false);

  /// Shows the tooltip if it's hidden, hides it if it's shown.
  void toggle() => _shown ? hide() : show();

  void _setShown(bool value) {
    if (value == _shown) return;
    _shown = value;
    notifyListeners();
  }

  /// Overrides [BsTooltip.message]. Null (the default) falls back to it.
  Widget? get content => _content;

  /// Replaces the displayed message, e.g. to update a tooltip already on
  /// screen without rebuilding the [BsTooltip] itself. Pass null to fall
  /// back to [BsTooltip.message] again.
  void setContent(Widget? content) {
    _content = content;
    notifyListeners();
  }

  /// Overrides [BsTooltip.placement]. Null (the default) falls back to it.
  BsTooltipPlacement? get placement => _placement;

  /// Moves the bubble to a different side of the target, e.g. to flip it
  /// away from a screen edge without rebuilding the [BsTooltip] itself.
  /// Pass null to fall back to [BsTooltip.placement] again.
  void setPlacement(BsTooltipPlacement? placement) {
    _placement = placement;
    notifyListeners();
  }
}

/// A Bootstrap tooltip (`.tooltip`): a small, non-interactive text bubble
/// revealed on hover (or long-press, on touch devices) — the same
/// hover/long-press dual trigger Flutter's own Material `Tooltip` uses,
/// reimplemented on [CompositedTransformTarget]/[CompositedTransformFollower]
/// plus an [OverlayPortal] (the anchoring approach this package already
/// built for [BsDropdown]/[BsPopover]) since `Tooltip` itself lives in the
/// Material library.
///
/// Unlike [BsPopover], the bubble ignores pointer events entirely (it
/// can't be clicked) and there's no outside-tap dismissal — it just
/// disappears when the pointer leaves, or after [showDuration] when
/// triggered by long-press.
class BsTooltip extends StatefulWidget {
  const BsTooltip({
    super.key,
    required this.message,
    required this.child,
    this.placement = BsTooltipPlacement.top,
    this.waitDuration = Duration.zero,
    this.showDuration = const Duration(seconds: 2),
    this.style,
    this.controller,
    this.onShow,
    this.onShown,
    this.onHide,
    this.onHidden,
  });

  /// Typically a [Text].
  final Widget message;

  /// The widget the tooltip is anchored to and revealed by hovering/
  /// long-pressing.
  final Widget child;

  final BsTooltipPlacement placement;

  /// Programmatic enable/disable and show/hide. Defaults to an
  /// internally-owned controller (always enabled, initially hidden) when
  /// null.
  final BsTooltipController? controller;

  /// How long the pointer must hover before the tooltip appears.
  final Duration waitDuration;

  /// How long the tooltip stays up after a long-press trigger (hover
  /// dismisses immediately on pointer-exit instead).
  final Duration showDuration;

  /// Style overrides layered on top of [BsTooltipStyle.defaults].
  final BsTooltipStyle? style;

  /// Called as soon as the tooltip is triggered to show, before the
  /// fade-in animation starts. Mirrors Bootstrap's `show.bs.tooltip`.
  final VoidCallback? onShow;

  /// Called once the tooltip has finished fading in and is fully visible.
  /// Mirrors Bootstrap's `shown.bs.tooltip`.
  final VoidCallback? onShown;

  /// Called as soon as the tooltip is triggered to hide, before the
  /// fade-out animation starts. Mirrors Bootstrap's `hide.bs.tooltip`.
  final VoidCallback? onHide;

  /// Called once the tooltip has finished fading out and is fully hidden.
  /// Mirrors Bootstrap's `hidden.bs.tooltip`.
  final VoidCallback? onHidden;

  @override
  State<BsTooltip> createState() => _BsTooltipState();
}

class _BsTooltipState extends State<BsTooltip> with SingleTickerProviderStateMixin {
  final _link = LayerLink();
  final _overlayController = OverlayPortalController();
  static const _baseFadeDuration = Duration(milliseconds: 150);

  late final AnimationController _fadeController = AnimationController(vsync: this, duration: _baseFadeDuration);
  Timer? _waitTimer;
  Timer? _autoHideTimer;
  BsTooltipController? _ownedController;
  bool _wasShown = false;

  BsTooltipController get _controller => widget.controller ?? (_ownedController ??= BsTooltipController());

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleControllerChanged);
  }

  void _handleControllerChanged() {
    _waitTimer?.cancel();
    setState(() {}); // picks up content/placement changes even while already shown
    final isShown = _controller.isShown;
    // A setContent()/setPlacement() call while already shown (or hidden)
    // notifies too, but that's not a show/hide transition — nothing to
    // fire or (re-)animate.
    if (isShown == _wasShown) return;
    _wasShown = isShown;
    if (isShown) {
      if (!_overlayController.isShowing) _overlayController.show();
      widget.onShow?.call();
      _fadeIn();
    } else {
      widget.onHide?.call();
      _fadeOut();
    }
  }

  Future<void> _fadeIn() async {
    await _fadeController.forward();
    if (mounted && _controller.isShown) widget.onShown?.call();
  }

  /// [BsTooltip.message], unless overridden by [BsTooltipController.setContent].
  Widget get _effectiveMessage => _controller.content ?? widget.message;

  /// [BsTooltip.placement], unless overridden by [BsTooltipController.setPlacement].
  BsTooltipPlacement get _effectivePlacement => _controller.placement ?? widget.placement;

  /// Mirrors Bootstrap's own behavior of never initializing a tooltip whose
  /// `title` is empty: an empty/whitespace-only [Text] (the overwhelmingly
  /// common [BsTooltip.message]) is treated the same way.
  bool get _hasContent {
    final message = _effectiveMessage;
    if (message is Text) {
      final data = message.data;
      if (data != null) return data.trim().isNotEmpty;
      return message.textSpan?.toPlainText().trim().isNotEmpty ?? false;
    }
    return true;
  }

  // CompositedTransformFollower's anchors are plain Alignment, not
  // AlignmentGeometry, so start/end need a manual resolve() against the
  // ambient Directionality instead of just handing it AlignmentDirectional.
  Alignment get _targetAnchor => switch (_effectivePlacement) {
    BsTooltipPlacement.top => Alignment.topCenter,
    BsTooltipPlacement.bottom => Alignment.bottomCenter,
    BsTooltipPlacement.start => AlignmentDirectional.centerStart.resolve(Directionality.of(context)),
    BsTooltipPlacement.end => AlignmentDirectional.centerEnd.resolve(Directionality.of(context)),
  };

  Alignment get _followerAnchor => switch (_effectivePlacement) {
    BsTooltipPlacement.top => Alignment.bottomCenter,
    BsTooltipPlacement.bottom => Alignment.topCenter,
    BsTooltipPlacement.start => AlignmentDirectional.centerEnd.resolve(Directionality.of(context)),
    BsTooltipPlacement.end => AlignmentDirectional.centerStart.resolve(Directionality.of(context)),
  };

  void _scheduleShow() {
    if (!_controller.enabled) return;
    _autoHideTimer?.cancel();
    _waitTimer?.cancel();
    if (widget.waitDuration == Duration.zero) {
      _controller.show();
    } else {
      _waitTimer = Timer(widget.waitDuration, _controller.show);
    }
  }

  void _hideAfter(Duration duration) {
    _waitTimer?.cancel();
    _autoHideTimer?.cancel();
    if (duration == Duration.zero) {
      _controller.hide();
    } else {
      _autoHideTimer = Timer(duration, _controller.hide);
    }
  }

  Future<void> _fadeOut() async {
    await _fadeController.reverse();
    if (mounted && !_controller.isShown) {
      _overlayController.hide();
      widget.onHidden?.call();
    }
  }

  @override
  void dispose() {
    _waitTimer?.cancel();
    _autoHideTimer?.cancel();
    _controller.removeListener(_handleControllerChanged);
    _ownedController?.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasContent) return widget.child;

    _fadeController.duration = BsTransitions.resolve(context, _baseFadeDuration);

    final isDark = BsTheme.of(context) == Brightness.dark;
    final style = (isDark ? BsTooltipStyle.darkDefaults : BsTooltipStyle.defaults).merge(widget.style);

    return CompositedTransformTarget(
      link: _link,
      child: OverlayPortal(
        controller: _overlayController,
        overlayChildBuilder: (context) => Stack(
          children: [
            IgnorePointer(
              child: CompositedTransformFollower(
                link: _link,
                targetAnchor: _targetAnchor,
                followerAnchor: _followerAnchor,
                child: FadeTransition(
                  opacity: _fadeController,
                  child: Opacity(
                    opacity: style.opacity ?? BsTooltipStyle.defaultOpacity,
                    child: _BsTooltipContent(message: _effectiveMessage, placement: _effectivePlacement, style: style),
                  ),
                ),
              ),
            ),
          ],
        ),
        child: MouseRegion(
          onEnter: (_) => _scheduleShow(),
          onExit: (_) => _hideAfter(Duration.zero),
          child: GestureDetector(
            onLongPress: () {
              _scheduleShow();
              _hideAfter(widget.showDuration);
            },
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class _BsTooltipContent extends StatelessWidget {
  const _BsTooltipContent({required this.message, required this.placement, required this.style});

  final Widget message;
  final BsTooltipPlacement placement;
  final BsTooltipStyle style;

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);
    final background = style.background ?? BsTooltipStyle.defaultBackground;

    final bubble = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: style.maxWidth ?? BsTooltipStyle.defaultMaxWidth),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(style.borderRadius ?? BsTooltipStyle.defaultBorderRadius),
        ),
        child: Padding(
          padding: style.padding ?? BsTooltipStyle.defaultPadding,
          child: DefaultTextStyle.merge(
            style: TextStyle(
              color: style.color ?? BsTooltipStyle.defaultColor,
              fontSize: style.fontSize ?? BsTooltipStyle.defaultFontSize,
            ),
            textAlign: TextAlign.center,
            child: message,
          ),
        ),
      ),
    );

    return switch (placement) {
      BsTooltipPlacement.top => Column(
        mainAxisSize: MainAxisSize.min,
        children: [bubble, _BsTooltipArrow(direction: _BsTooltipArrowDirection.down, color: background, style: style)],
      ),
      BsTooltipPlacement.bottom => Column(
        mainAxisSize: MainAxisSize.min,
        children: [_BsTooltipArrow(direction: _BsTooltipArrowDirection.up, color: background, style: style), bubble],
      ),
      // Row's own child order is already logical (first child sits at the
      // start edge, auto-flipping physical sides under RTL) — only the
      // arrow glyph's drawn direction needs to flip along with it, so it
      // still visually points at the target once that flip happens.
      BsTooltipPlacement.start => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          bubble,
          _BsTooltipArrow(
            direction: textDirection == TextDirection.rtl ? _BsTooltipArrowDirection.left : _BsTooltipArrowDirection.right,
            color: background,
            style: style,
          ),
        ],
      ),
      BsTooltipPlacement.end => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _BsTooltipArrow(
            direction: textDirection == TextDirection.rtl ? _BsTooltipArrowDirection.right : _BsTooltipArrowDirection.left,
            color: background,
            style: style,
          ),
          bubble,
        ],
      ),
    };
  }
}

enum _BsTooltipArrowDirection { up, down, left, right }

class _BsTooltipArrow extends StatelessWidget {
  const _BsTooltipArrow({required this.direction, required this.color, required this.style});

  final _BsTooltipArrowDirection direction;
  final Color color;
  final BsTooltipStyle style;

  @override
  Widget build(BuildContext context) {
    final width = style.arrowWidth ?? BsTooltipStyle.defaultArrowWidth;
    final height = style.arrowHeight ?? BsTooltipStyle.defaultArrowHeight;
    final vertical = direction == _BsTooltipArrowDirection.up || direction == _BsTooltipArrowDirection.down;

    return CustomPaint(
      size: vertical ? Size(width, height) : Size(height, width),
      painter: _BsTooltipArrowPainter(direction: direction, color: color),
    );
  }
}

class _BsTooltipArrowPainter extends CustomPainter {
  _BsTooltipArrowPainter({required this.direction, required this.color});

  final _BsTooltipArrowDirection direction;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    switch (direction) {
      case _BsTooltipArrowDirection.down:
        path
          ..moveTo(0, 0)
          ..lineTo(size.width, 0)
          ..lineTo(size.width / 2, size.height)
          ..close();
      case _BsTooltipArrowDirection.up:
        path
          ..moveTo(0, size.height)
          ..lineTo(size.width, size.height)
          ..lineTo(size.width / 2, 0)
          ..close();
      case _BsTooltipArrowDirection.right:
        path
          ..moveTo(0, 0)
          ..lineTo(0, size.height)
          ..lineTo(size.width, size.height / 2)
          ..close();
      case _BsTooltipArrowDirection.left:
        path
          ..moveTo(size.width, 0)
          ..lineTo(size.width, size.height)
          ..lineTo(0, size.height / 2)
          ..close();
    }
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _BsTooltipArrowPainter oldDelegate) =>
      oldDelegate.direction != direction || oldDelegate.color != color;
}
