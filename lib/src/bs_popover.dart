import 'package:flutter/widgets.dart';

import 'bs_theme.dart';
import 'tokens/bs_popover_style.dart';

/// Which side of the trigger a [BsPopover]'s bubble opens on, with its
/// arrow pointing back at the trigger.
enum BsPopoverPlacement { top, bottom, start, end }

/// Programmatic control of a [BsPopover], independent of its
/// [BsPopover.triggerBuilder]-driven open/close — mirrors Bootstrap's own
/// `popover.enable()`/`.disable()`/`.toggleEnabled()`, `.show()`/`.hide()`/
/// `.toggle()`, and `.setContent()` API, plus a `setPlacement` with no
/// Bootstrap equivalent (see [BsTooltipController], which this mirrors).
///
/// Only overrides [BsPopover.content] — not [BsPopover.title] — since
/// unlike `content`, `title` is already nullable on the widget itself, so a
/// controller override couldn't tell "no override" apart from "override to
/// no title" the way [setContent]'s null does.
class BsPopoverController extends ChangeNotifier {
  BsPopoverController({bool enabled = true}) {
    _enabled = enabled;
  }

  late bool _enabled;
  bool _shown = false;
  Widget? _content;
  BsPopoverPlacement? _placement;

  /// Whether the popover currently responds to its trigger.
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

  /// Whether the popover bubble is currently open.
  bool get isShown => _shown;

  /// Opens the popover immediately. Does nothing while [enabled] is false.
  void show() {
    if (!_enabled) return;
    _setShown(true);
  }

  /// Closes the popover immediately.
  void hide() => _setShown(false);

  /// Opens the popover if it's closed, closes it if it's open.
  void toggle() => _shown ? hide() : show();

  void _setShown(bool value) {
    if (value == _shown) return;
    _shown = value;
    notifyListeners();
  }

  /// Overrides [BsPopover.content]. Null (the default) falls back to it.
  Widget? get content => _content;

  /// Replaces the displayed body, e.g. to update a popover already on
  /// screen without rebuilding the [BsPopover] itself. Pass null to fall
  /// back to [BsPopover.content] again.
  void setContent(Widget? content) {
    _content = content;
    notifyListeners();
  }

  /// Overrides [BsPopover.placement]. Null (the default) falls back to it.
  BsPopoverPlacement? get placement => _placement;

  /// Moves the bubble to a different side of the trigger, e.g. to flip it
  /// away from a screen edge, without rebuilding the [BsPopover] itself.
  /// Pass null to fall back to [BsPopover.placement] again.
  void setPlacement(BsPopoverPlacement? placement) {
    _placement = placement;
    notifyListeners();
  }
}

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
    this.controller,
    this.onShow,
    this.onShown,
    this.onHide,
    this.onHidden,
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

  /// Programmatic enable/disable and show/hide. Defaults to an
  /// internally-owned controller (always enabled, initially closed) when
  /// null.
  final BsPopoverController? controller;

  /// Called as soon as the popover is triggered to open. Mirrors
  /// Bootstrap's `show.bs.popover`.
  final VoidCallback? onShow;

  /// Called once the popover has finished opening. [BsPopover] has no
  /// open/close animation, so this fires right after [onShow].
  /// Mirrors Bootstrap's `shown.bs.popover`.
  final VoidCallback? onShown;

  /// Called as soon as the popover is triggered to close. Mirrors
  /// Bootstrap's `hide.bs.popover`.
  final VoidCallback? onHide;

  /// Called once the popover has finished closing. [BsPopover] has no
  /// open/close animation, so this fires right after [onHide]. Mirrors
  /// Bootstrap's `hidden.bs.popover`.
  final VoidCallback? onHidden;

  @override
  State<BsPopover> createState() => _BsPopoverState();
}

class _BsPopoverState extends State<BsPopover> {
  final _link = LayerLink();
  final _overlayController = OverlayPortalController();
  BsPopoverController? _ownedController;
  bool _wasShown = false;

  BsPopoverController get _controller => widget.controller ?? (_ownedController ??= BsPopoverController());

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleControllerChanged);
  }

  void _handleControllerChanged() {
    setState(() {}); // picks up content/placement changes even while already open
    final isShown = _controller.isShown;
    // A setContent()/setPlacement() call while already open (or closed)
    // notifies too, but that's not an open/close transition.
    if (isShown == _wasShown) return;
    _wasShown = isShown;
    if (isShown) {
      widget.onShow?.call();
      if (!_overlayController.isShowing) _overlayController.show();
      widget.onShown?.call();
      widget.onOpenChanged?.call(true);
    } else {
      widget.onHide?.call();
      if (_overlayController.isShowing) _overlayController.hide();
      widget.onHidden?.call();
      widget.onOpenChanged?.call(false);
    }
  }

  void _toggle() {
    if (!_controller.enabled) return;
    _controller.toggle();
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);
    _ownedController?.dispose();
    super.dispose();
  }

  /// [BsPopover.content], unless overridden by [BsPopoverController.setContent].
  Widget get _effectiveContent => _controller.content ?? widget.content;

  /// [BsPopover.placement], unless overridden by [BsPopoverController.setPlacement].
  BsPopoverPlacement get _effectivePlacement => _controller.placement ?? widget.placement;

  @override
  Widget build(BuildContext context) {
    final isDark = BsTheme.of(context) == Brightness.dark;
    final style = (isDark ? BsPopoverStyle.darkDefaults : BsPopoverStyle.defaults).merge(widget.style);

    return CompositedTransformTarget(
      link: _link,
      // Shares a groupId with the overlay content's own TapRegion below, so
      // a tap on the trigger itself never counts as "outside" the popover
      // (which would otherwise race with _toggle: TapRegion closes it,
      // then the same tap reopens it via the trigger's own handler).
      child: TapRegion(
        groupId: this,
        child: OverlayPortal(
          controller: _overlayController,
          overlayChildBuilder: (context) => _buildOverlay(style),
          child: widget.triggerBuilder(context, _toggle, _controller.isShown),
        ),
      ),
    );
  }

  Widget _buildOverlay(BsPopoverStyle style) {
    // CompositedTransformFollower's anchors are plain Alignment, not
    // AlignmentGeometry, so start/end need a manual resolve() against the
    // ambient Directionality instead of just handing it AlignmentDirectional.
    final textDirection = Directionality.of(context);
    final (Alignment targetAnchor, Alignment followerAnchor) = switch (_effectivePlacement) {
      BsPopoverPlacement.top => (Alignment.topCenter, Alignment.bottomCenter),
      BsPopoverPlacement.bottom => (Alignment.bottomCenter, Alignment.topCenter),
      BsPopoverPlacement.start => (
        AlignmentDirectional.centerStart.resolve(textDirection),
        AlignmentDirectional.centerEnd.resolve(textDirection),
      ),
      BsPopoverPlacement.end => (
        AlignmentDirectional.centerEnd.resolve(textDirection),
        AlignmentDirectional.centerStart.resolve(textDirection),
      ),
    };

    return Stack(
      children: [
        // TapRegion (not a full-screen hit-test barrier, unlike the
        // Positioned.fill+opaque GestureDetector this replaced) detects an
        // outside tap passively, without absorbing it — so closing the
        // popover this way still lets that same tap reach whatever it
        // actually landed on, matching Bootstrap's own document-click
        // listener instead of swallowing clicks meant for other widgets.
        TapRegion(
          groupId: this,
          onTapOutside: (_) => _controller.hide(),
          child: CompositedTransformFollower(
            link: _link,
            targetAnchor: targetAnchor,
            followerAnchor: followerAnchor,
            child: _BsPopoverContent(
              title: widget.title,
              content: _effectiveContent,
              placement: _effectivePlacement,
              style: style,
            ),
          ),
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
    final textDirection = Directionality.of(context);
    final borderRadius = BorderRadius.circular(style.borderRadius ?? BsPopoverStyle.defaultBorderRadius);

    // Without IntrinsicWidth, the Column below's `crossAxisAlignment:
    // stretch` would stretch the popover out to the overlay Stack's full
    // (screen-sized) loose width instead of shrinking to its actual title/
    // content width — see the identical fix and explanation on
    // BsDropdown's `_BsDropdownMenu`.
    final box = IntrinsicWidth(
      child: ConstrainedBox(
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
                    style: TextStyle(
                      fontSize: style.fontSize ?? BsPopoverStyle.defaultFontSize,
                      color: style.bodyColor ?? BsPopoverStyle.defaultBodyColor,
                    ),
                    child: content,
                  ),
                ),
              ],
            ),
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
      // Row's own child order is already logical (first child sits at the
      // start edge, auto-flipping physical sides under RTL) — only the
      // arrow glyph's drawn direction needs to flip along with it, so it
      // still visually points at the trigger once that flip happens.
      BsPopoverPlacement.start => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          box,
          _BsPopoverArrow(
            direction: textDirection == TextDirection.rtl ? _BsPopoverArrowDirection.left : _BsPopoverArrowDirection.right,
            style: style,
          ),
        ],
      ),
      BsPopoverPlacement.end => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _BsPopoverArrow(
            direction: textDirection == TextDirection.rtl ? _BsPopoverArrowDirection.right : _BsPopoverArrowDirection.left,
            style: style,
          ),
          box,
        ],
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
