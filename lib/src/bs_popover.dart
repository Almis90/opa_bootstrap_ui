import 'package:flutter/widgets.dart';

import 'bs_clip_rrect.dart';
import 'bs_placement.dart';
import 'bs_theme.dart';
import 'tokens/bs_popover_style.dart';
import 'bs_decorated_box.dart';

/// Which side of the trigger a [BsPopover]'s bubble opens on, with its
/// arrow pointing back at the trigger.
enum BsPopoverPlacement { top, bottom, start, end }

/// Programmatic control of a [BsPopover], independent of its [BsPopover.triggerBuilder]-driven
/// open and close: enable and disable it, show, hide and toggle it, and override its content,
/// placement and so on.
///
/// Only overrides [BsPopover.content], not [BsPopover.title]: the title is already nullable on
/// the widget itself, so a controller override could not tell "no override" apart from
/// "override to no title" the way [setContent]'s null does.
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

/// A Bootstrap popover: a bordered bubble with an optional [title] and [content], pointed at
/// its trigger by a small arrow.
///
/// Positioned and dismissed the way [BsDropdown] anchors and closes its menu, with a
/// [CompositedTransformTarget], a [CompositedTransformFollower] and an [OverlayPortal].
///
/// [triggerBuilder] is handed a `toggle` callback: call it from the widget it returns (for
/// example a [BsButton.onPressed]) to open and close the popover.
class BsPopover extends StatefulWidget {
  const BsPopover({
    super.key,
    required this.triggerBuilder,
    this.title,
    required this.content,
    this.placement,
    this.flip = true,
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
  final Widget Function(BuildContext context, VoidCallback toggle, bool isOpen)
  triggerBuilder;

  /// The popover's header. Omit for a popover with no header.
  final Widget? title;

  /// The popover's body.
  final Widget content;

  /// Which side of the trigger the bubble opens on. Null (the default) is the
  /// trigger's right, as `Popover.Default.placement: 'right'` is (unlike a
  /// tooltip's `top`): [BsPopoverPlacement.end] in a left-to-right page, and
  /// [BsPopoverPlacement.start] in a right-to-left one, where that is the same
  /// physical side.
  final BsPopoverPlacement? placement;

  /// Keeps the bubble on screen: when it would not fit on the side [placement] asks for, it opens
  /// on the opposite side instead (its arrow flipping with it), and slides along the trigger to
  /// stay in view, the arrow keeping its aim. Pass false to always open exactly where asked.
  final bool flip;

  /// Style overrides layered on top of [BsPopoverStyle.defaults].
  final BsPopoverStyle? style;

  final ValueChanged<bool>? onOpenChanged;

  /// Programmatic enable/disable and show/hide. Defaults to an
  /// internally-owned controller (always enabled, initially closed) when
  /// null.
  final BsPopoverController? controller;

  /// Called as soon as the popover is triggered to open.
  final VoidCallback? onShow;

  /// Called once the popover has finished opening. [BsPopover] has no open or close animation, so
  /// this fires right after [onShow].
  final VoidCallback? onShown;

  /// Called as soon as the popover is triggered to close.
  final VoidCallback? onHide;

  /// Called once the popover has finished closing. [BsPopover] has no open or close animation, so
  /// this fires right after [onHide].
  final VoidCallback? onHidden;

  @override
  State<BsPopover> createState() => _BsPopoverState();
}

class _BsPopoverState extends State<BsPopover>
    with BsPlacementTracker<BsPopover> {
  final _link = LayerLink();
  final _overlayController = OverlayPortalController();
  BsPopoverController? _ownedController;
  bool _wasShown = false;

  @override
  BsPlacement get preferredPlacement {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return switch (_effectivePlacement) {
      BsPopoverPlacement.top => const BsPlacement(BsPlacementSide.top),
      BsPopoverPlacement.bottom => const BsPlacement(BsPlacementSide.bottom),
      BsPopoverPlacement.start => BsPlacement(
        rtl ? BsPlacementSide.right : BsPlacementSide.left,
      ),
      BsPopoverPlacement.end => BsPlacement(
        rtl ? BsPlacementSide.left : BsPlacementSide.right,
      ),
    };
  }

  @override
  bool get flipEnabled => widget.flip;

  @override
  bool get placementActive => _controller.isShown;

  BsPopoverController get _controller =>
      widget.controller ?? (_ownedController ??= BsPopoverController());

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleControllerChanged);
  }

  void _handleControllerChanged() {
    setState(
      () {},
    ); // picks up content/placement changes even while already open
    final isShown = _controller.isShown;
    // A setContent()/setPlacement() call while already open (or closed)
    // notifies too, but that's not an open/close transition.
    if (isShown == _wasShown) return;
    _wasShown = isShown;
    if (isShown) {
      resetPlacement();
      startResolvingPlacement();
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
  BsPopoverPlacement get _effectivePlacement =>
      _controller.placement ??
      widget.placement ??
      // The default placement is the physical right, so the start side in a right-to-left layout.
      (Directionality.of(context) == TextDirection.rtl
          ? BsPopoverPlacement.start
          : BsPopoverPlacement.end);

  @override
  Widget build(BuildContext context) {
    final isDark = BsTheme.of(context) == Brightness.dark;
    final style =
        (isDark ? BsPopoverStyle.darkDefaults : BsPopoverStyle.defaults).merge(
          widget.style,
        );

    return CompositedTransformTarget(
      key: placementTargetKey,
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
    // Until the bubble has been measured (see [BsPlacementTracker]) it sits
    // at the preferred placement, invisible; afterwards wherever flipping
    // chose, with its arrow slid back to aim at the trigger.
    final resolved = currentPlacement;
    final placement = resolved.placement;
    final hidden = placementPending;
    final size = placementContentSize;
    final arrowOffset = size == null
        ? 0.0
        : arrowShift(
            shift: resolved.alongShift,
            contentExtent: placement.side.isVertical ? size.width : size.height,
            arrowExtent: style.arrowWidth ?? BsPopoverStyle.defaultArrowWidth,
            padding: style.borderRadius ?? BsPopoverStyle.defaultBorderRadius,
          );

    return Stack(
      children: [
        // The TapRegion sits inside the follower (see BsDropdown): wrapped around it, its box would
        // stay at the Stack's origin and a tap on the popover itself would count as outside it.
        //
        // A TapRegion (not a full-screen hit-test barrier) detects an outside tap passively, without
        // absorbing it, so closing the popover this way still lets that same tap reach whatever it
        // actually landed on instead of swallowing clicks meant for other widgets.
        CompositedTransformFollower(
          link: _link,
          targetAnchor: placement.targetAnchor,
          followerAnchor: placement.followerAnchor,
          offset: resolved.shift,
          child: TapRegion(
            groupId: this,
            onTapOutside: (_) => _controller.hide(),
            child: IgnorePointer(
              ignoring: hidden,
              child: Opacity(
                opacity: hidden ? 0 : 1,
                child: _BsPopoverContent(
                  key: placementContentKey,
                  title: widget.title,
                  content: _effectiveContent,
                  side: placement.side,
                  arrowOffset: arrowOffset,
                  style: style,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BsPopoverContent extends StatelessWidget {
  const _BsPopoverContent({
    super.key,
    required this.title,
    required this.content,
    required this.side,
    required this.arrowOffset,
    required this.style,
  });

  final Widget? title;
  final Widget content;

  /// The (physical) side of the trigger the bubble sits on; its arrow points
  /// back across the opposite edge.
  final BsPlacementSide side;

  /// How far the arrow has slid along its edge to keep aiming at the trigger.
  final double arrowOffset;
  final BsPopoverStyle style;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(
      style.borderRadius ?? BsPopoverStyle.defaultBorderRadius,
    );

    // Without IntrinsicWidth, the Column below's `crossAxisAlignment:
    // stretch` would stretch the popover out to the overlay Stack's full
    // (screen-sized) loose width instead of shrinking to its actual title/
    // content width — see the identical fix and explanation on
    // BsDropdown's `_BsDropdownMenu`.
    final box = IntrinsicWidth(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: style.maxWidth ?? BsPopoverStyle.defaultMaxWidth,
        ),
        child: BsDecoratedBox(
          decoration: BoxDecoration(
            color: style.background ?? BsPopoverStyle.defaultBackground,
            border: Border.all(
              color: style.borderColor ?? BsPopoverStyle.defaultBorderColor,
              width: style.borderWidth ?? BsPopoverStyle.defaultBorderWidth,
            ),
            borderRadius: borderRadius,
            boxShadow: style.boxShadow,
          ),
          child: BsClipRRect(
            borderRadius: borderRadius,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (title != null)
                  BsDecoratedBox(
                    decoration: BoxDecoration(
                      color:
                          style.headerBackground ??
                          BsPopoverStyle.defaultHeaderBackground,
                    ),
                    child: Padding(
                      padding:
                          style.headerPadding ??
                          BsPopoverStyle.defaultHeaderPadding,
                      child: DefaultTextStyle.merge(
                        style: TextStyle(
                          fontSize:
                              style.headerFontSize ??
                              BsPopoverStyle.defaultHeaderFontSize,
                          color: style.headerColor,
                          fontWeight: FontWeight.bold,
                        ),
                        child: title!,
                      ),
                    ),
                  ),
                Padding(
                  padding:
                      style.bodyPadding ?? BsPopoverStyle.defaultBodyPadding,
                  child: DefaultTextStyle.merge(
                    style: TextStyle(
                      fontSize:
                          style.fontSize ?? BsPopoverStyle.defaultFontSize,
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

    Widget arrow(_BsPopoverArrowDirection direction) => Transform.translate(
      offset: side.isVertical ? Offset(arrowOffset, 0) : Offset(0, arrowOffset),
      child: _BsPopoverArrow(direction: direction, style: style),
    );

    // Physical layout: a flipped popover must land on the side it resolved to
    // whatever the text direction, so the Rows are forced left-to-right.
    return switch (side) {
      BsPlacementSide.top => Column(
        mainAxisSize: MainAxisSize.min,
        children: [box, arrow(_BsPopoverArrowDirection.down)],
      ),
      BsPlacementSide.bottom => Column(
        mainAxisSize: MainAxisSize.min,
        children: [arrow(_BsPopoverArrowDirection.up), box],
      ),
      BsPlacementSide.left => Row(
        textDirection: TextDirection.ltr,
        mainAxisSize: MainAxisSize.min,
        children: [box, arrow(_BsPopoverArrowDirection.right)],
      ),
      BsPlacementSide.right => Row(
        textDirection: TextDirection.ltr,
        mainAxisSize: MainAxisSize.min,
        children: [arrow(_BsPopoverArrowDirection.left), box],
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
    final vertical =
        direction == _BsPopoverArrowDirection.up ||
        direction == _BsPopoverArrowDirection.down;

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
