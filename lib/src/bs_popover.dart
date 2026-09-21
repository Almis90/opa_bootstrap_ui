import 'package:flutter/widgets.dart';

import 'tokens/bs_popover_style.dart';

/// Which side of the trigger a [BsPopover]'s bubble opens on, with its
/// arrow pointing back at the trigger.
enum BsPopoverPlacement { top, bottom, start, end }

/// A Bootstrap popover (`.popover`): a bordered bubble with an optional
/// [title] and [content], pointed at its trigger by a small arrow.
///
/// Positioned and dismissed the same way [BsDropdown] anchors and closes
/// its menu — [CompositedTransformTarget]/[CompositedTransformFollower]
/// plus an [OverlayPortal] — since neither Material nor Cupertino has a
/// popover-with-arrow primitive to draw from instead, and this package
/// already solved the anchored-overlay problem once for [BsDropdown].
///
/// [triggerBuilder] mirrors [BsDropdown.toggleBuilder]: call `toggle` from
/// the widget it returns (e.g. a [BsButton.onPressed]) to open/close the
/// popover.
class BsPopover extends StatefulWidget {
  const BsPopover({
    super.key,
    required this.triggerBuilder,
    this.title,
    required this.content,
    this.placement = BsPopoverPlacement.top,
    this.style,
    this.onOpenChanged,
  });

  /// Builds the trigger widget. Call `toggle` from it to open/close the
  /// popover; `isOpen` reflects its current state.
  final Widget Function(BuildContext context, VoidCallback toggle, bool isOpen) triggerBuilder;

  /// `.popover-header`. Omit for a bodyless header, matching Bootstrap's
  /// own `data-bs-title`-less popovers.
  final Widget? title;

  /// `.popover-body`.
  final Widget content;

  final BsPopoverPlacement placement;

  /// Style overrides layered on top of [BsPopoverStyle.defaults].
  final BsPopoverStyle? style;

  final ValueChanged<bool>? onOpenChanged;

  @override
  State<BsPopover> createState() => _BsPopoverState();
}

class _BsPopoverState extends State<BsPopover> {
  final _link = LayerLink();
  final _overlayController = OverlayPortalController();
  bool _isOpen = false;

  void _open() {
    if (_isOpen) return;
    setState(() => _isOpen = true);
    _overlayController.show();
    widget.onOpenChanged?.call(true);
  }

  void _close() {
    if (!_isOpen) return;
    setState(() => _isOpen = false);
    _overlayController.hide();
    widget.onOpenChanged?.call(false);
  }

  void _toggle() => _isOpen ? _close() : _open();

  @override
  Widget build(BuildContext context) {
    final style = BsPopoverStyle.defaults.merge(widget.style);

    return CompositedTransformTarget(
      link: _link,
      child: OverlayPortal(
        controller: _overlayController,
        overlayChildBuilder: (context) => _buildOverlay(style),
        child: widget.triggerBuilder(context, _toggle, _isOpen),
      ),
    );
  }

  Widget _buildOverlay(BsPopoverStyle style) {
    final (Alignment targetAnchor, Alignment followerAnchor) = switch (widget.placement) {
      BsPopoverPlacement.top => (Alignment.topCenter, Alignment.bottomCenter),
      BsPopoverPlacement.bottom => (Alignment.bottomCenter, Alignment.topCenter),
      BsPopoverPlacement.start => (Alignment.centerLeft, Alignment.centerRight),
      BsPopoverPlacement.end => (Alignment.centerRight, Alignment.centerLeft),
    };

    return Stack(
      children: [
        Positioned.fill(child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: _close)),
        CompositedTransformFollower(
          link: _link,
          targetAnchor: targetAnchor,
          followerAnchor: followerAnchor,
          child: _BsPopoverContent(title: widget.title, content: widget.content, placement: widget.placement, style: style),
        ),
      ],
    );
  }
}

class _BsPopoverContent extends StatelessWidget {
  const _BsPopoverContent({required this.title, required this.content, required this.placement, required this.style});

  final Widget? title;
  final Widget content;
  final BsPopoverPlacement placement;
  final BsPopoverStyle style;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(style.borderRadius ?? BsPopoverStyle.defaultBorderRadius);

    final box = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: style.maxWidth ?? BsPopoverStyle.defaultMaxWidth),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: style.background ?? BsPopoverStyle.defaultBackground,
          border: Border.all(
            color: style.borderColor ?? BsPopoverStyle.defaultBorderColor,
            width: style.borderWidth ?? BsPopoverStyle.defaultBorderWidth,
          ),
          borderRadius: borderRadius,
          boxShadow: style.boxShadow ?? BsPopoverStyle.defaultBoxShadow,
        ),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (title != null)
                DecoratedBox(
                  decoration: BoxDecoration(color: style.headerBackground ?? BsPopoverStyle.defaultHeaderBackground),
                  child: Padding(
                    padding: style.headerPadding ?? BsPopoverStyle.defaultHeaderPadding,
                    child: DefaultTextStyle.merge(
                      style: TextStyle(
                        fontSize: style.headerFontSize ?? BsPopoverStyle.defaultHeaderFontSize,
                        color: style.headerColor,
                        fontWeight: FontWeight.bold,
                      ),
                      child: title!,
                    ),
                  ),
                ),
              Padding(
                padding: style.bodyPadding ?? BsPopoverStyle.defaultBodyPadding,
                child: DefaultTextStyle.merge(
                  style: TextStyle(fontSize: style.fontSize ?? BsPopoverStyle.defaultFontSize, color: style.bodyColor),
                  child: content,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    return switch (placement) {
      BsPopoverPlacement.top => Column(
        mainAxisSize: MainAxisSize.min,
        children: [box, _BsPopoverArrow(direction: _BsPopoverArrowDirection.down, style: style)],
      ),
      BsPopoverPlacement.bottom => Column(
        mainAxisSize: MainAxisSize.min,
        children: [_BsPopoverArrow(direction: _BsPopoverArrowDirection.up, style: style), box],
      ),
      BsPopoverPlacement.start => Row(
        mainAxisSize: MainAxisSize.min,
        children: [box, _BsPopoverArrow(direction: _BsPopoverArrowDirection.right, style: style)],
      ),
      BsPopoverPlacement.end => Row(
        mainAxisSize: MainAxisSize.min,
        children: [_BsPopoverArrow(direction: _BsPopoverArrowDirection.left, style: style), box],
      ),
    };
  }
}

enum _BsPopoverArrowDirection { up, down, left, right }

class _BsPopoverArrow extends StatelessWidget {
  const _BsPopoverArrow({required this.direction, required this.style});

  final _BsPopoverArrowDirection direction;
  final BsPopoverStyle style;

  @override
  Widget build(BuildContext context) {
    final width = style.arrowWidth ?? BsPopoverStyle.defaultArrowWidth;
    final height = style.arrowHeight ?? BsPopoverStyle.defaultArrowHeight;
    final vertical = direction == _BsPopoverArrowDirection.up || direction == _BsPopoverArrowDirection.down;

    return CustomPaint(
      size: vertical ? Size(width, height) : Size(height, width),
      painter: _BsPopoverArrowPainter(
        direction: direction,
        background: style.background ?? BsPopoverStyle.defaultBackground,
        borderColor: style.borderColor ?? BsPopoverStyle.defaultBorderColor,
        borderWidth: style.borderWidth ?? BsPopoverStyle.defaultBorderWidth,
      ),
    );
  }
}

class _BsPopoverArrowPainter extends CustomPainter {
  _BsPopoverArrowPainter({
    required this.direction,
    required this.background,
    required this.borderColor,
    required this.borderWidth,
  });

  final _BsPopoverArrowDirection direction;
  final Color background;
  final Color borderColor;
  final double borderWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset apex;
    final Offset baseA;
    final Offset baseB;
    switch (direction) {
      case _BsPopoverArrowDirection.down:
        apex = Offset(size.width / 2, size.height);
        baseA = const Offset(0, 0);
        baseB = Offset(size.width, 0);
      case _BsPopoverArrowDirection.up:
        apex = Offset(size.width / 2, 0);
        baseA = Offset(0, size.height);
        baseB = Offset(size.width, size.height);
      case _BsPopoverArrowDirection.right:
        apex = Offset(size.width, size.height / 2);
        baseA = const Offset(0, 0);
        baseB = Offset(0, size.height);
      case _BsPopoverArrowDirection.left:
        apex = Offset(0, size.height / 2);
        baseA = Offset(size.width, 0);
        baseB = Offset(size.width, size.height);
    }

    final fillPath = Path()
      ..moveTo(baseA.dx, baseA.dy)
      ..lineTo(baseB.dx, baseB.dy)
      ..lineTo(apex.dx, apex.dy)
      ..close();
    canvas.drawPath(fillPath, Paint()..color = background);

    final strokePaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    canvas
      ..drawLine(baseA, apex, strokePaint)
      ..drawLine(baseB, apex, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _BsPopoverArrowPainter oldDelegate) =>
      oldDelegate.direction != direction ||
      oldDelegate.background != background ||
      oldDelegate.borderColor != borderColor ||
      oldDelegate.borderWidth != borderWidth;
}
