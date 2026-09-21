import 'dart:async';

import 'package:flutter/widgets.dart';

import 'tokens/bs_tooltip_style.dart';

/// Which side of [BsTooltip.child] the bubble opens on, with its arrow
/// pointing back at it.
enum BsTooltipPlacement { top, bottom, start, end }

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
  });

  /// Typically a [Text].
  final Widget message;

  /// The widget the tooltip is anchored to and revealed by hovering/
  /// long-pressing.
  final Widget child;

  final BsTooltipPlacement placement;

  /// How long the pointer must hover before the tooltip appears.
  final Duration waitDuration;

  /// How long the tooltip stays up after a long-press trigger (hover
  /// dismisses immediately on pointer-exit instead).
  final Duration showDuration;

  /// Style overrides layered on top of [BsTooltipStyle.defaults].
  final BsTooltipStyle? style;

  @override
  State<BsTooltip> createState() => _BsTooltipState();
}

class _BsTooltipState extends State<BsTooltip> with SingleTickerProviderStateMixin {
  final _link = LayerLink();
  final _overlayController = OverlayPortalController();
  late final AnimationController _fadeController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 150),
  );
  Timer? _waitTimer;
  Timer? _autoHideTimer;

  Alignment get _targetAnchor => switch (widget.placement) {
    BsTooltipPlacement.top => Alignment.topCenter,
    BsTooltipPlacement.bottom => Alignment.bottomCenter,
    BsTooltipPlacement.start => Alignment.centerLeft,
    BsTooltipPlacement.end => Alignment.centerRight,
  };

  Alignment get _followerAnchor => switch (widget.placement) {
    BsTooltipPlacement.top => Alignment.bottomCenter,
    BsTooltipPlacement.bottom => Alignment.topCenter,
    BsTooltipPlacement.start => Alignment.centerRight,
    BsTooltipPlacement.end => Alignment.centerLeft,
  };

  void _scheduleShow() {
    _autoHideTimer?.cancel();
    _waitTimer?.cancel();
    if (widget.waitDuration == Duration.zero) {
      _show();
    } else {
      _waitTimer = Timer(widget.waitDuration, _show);
    }
  }

  void _show() {
    if (!_overlayController.isShowing) _overlayController.show();
    _fadeController.forward();
  }

  void _hideAfter(Duration duration) {
    _waitTimer?.cancel();
    _autoHideTimer?.cancel();
    if (duration == Duration.zero) {
      _hide();
    } else {
      _autoHideTimer = Timer(duration, _hide);
    }
  }

  Future<void> _hide() async {
    await _fadeController.reverse();
    if (mounted) _overlayController.hide();
  }

  @override
  void dispose() {
    _waitTimer?.cancel();
    _autoHideTimer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final style = BsTooltipStyle.defaults.merge(widget.style);

    return CompositedTransformTarget(
      link: _link,
      child: OverlayPortal(
        controller: _overlayController,
        overlayChildBuilder: (context) => IgnorePointer(
          child: CompositedTransformFollower(
            link: _link,
            targetAnchor: _targetAnchor,
            followerAnchor: _followerAnchor,
            child: FadeTransition(
              opacity: _fadeController,
              child: Opacity(
                opacity: style.opacity ?? BsTooltipStyle.defaultOpacity,
                child: _BsTooltipContent(message: widget.message, placement: widget.placement, style: style),
              ),
            ),
          ),
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
      BsTooltipPlacement.start => Row(
        mainAxisSize: MainAxisSize.min,
        children: [bubble, _BsTooltipArrow(direction: _BsTooltipArrowDirection.right, color: background, style: style)],
      ),
      BsTooltipPlacement.end => Row(
        mainAxisSize: MainAxisSize.min,
        children: [_BsTooltipArrow(direction: _BsTooltipArrowDirection.left, color: background, style: style), bubble],
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
