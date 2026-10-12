import 'dart:math' as math;

import 'package:flutter/widgets.dart';

import 'bs_clip_rrect.dart';
import 'bs_placement.dart';
import 'bs_theme.dart';
import 'tokens/bs_dropdown_style.dart';
import 'bs_decorated_box.dart';

/// Which side of the toggle a [BsDropdown]'s menu opens on.
enum BsDropdownDirection {
  /// `.dropdown` (default): opens below the toggle.
  down,

  /// `.dropup`: opens above the toggle.
  up,

  /// `.dropstart`: opens to the toggle's left.
  start,

  /// `.dropend`: opens to the toggle's right.
  end,
}

/// A row in a [BsDropdown]'s menu.
sealed class BsDropdownEntry {
  const BsDropdownEntry();
}

/// Programmatic control of a [BsDropdown], independent of its
/// [BsDropdown.toggleBuilder]-driven open/close — mirrors [BsPopoverController]
/// (Bootstrap's dropdown JS plugin has no controller of its own to draw an
/// API from instead): `enable()`/`disable()`/`toggleEnabled()`,
/// `show()`/`hide()`/`toggle()`, and `setItems()`/`setDirection()`
/// overrides.
class BsDropdownController extends ChangeNotifier {
  BsDropdownController({bool enabled = true}) {
    _enabled = enabled;
  }

  late bool _enabled;
  bool _shown = false;
  List<BsDropdownEntry>? _items;
  BsDropdownDirection? _direction;

  /// Whether the dropdown currently responds to its toggle.
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

  /// Whether the menu is currently open.
  bool get isShown => _shown;

  /// Opens the menu immediately. Does nothing while [enabled] is false.
  void show() {
    if (!_enabled) return;
    _setShown(true);
  }

  /// Closes the menu immediately.
  void hide() => _setShown(false);

  /// Opens the menu if it's closed, closes it if it's open.
  void toggle() => _shown ? hide() : show();

  void _setShown(bool value) {
    if (value == _shown) return;
    _shown = value;
    notifyListeners();
  }

  /// Overrides [BsDropdown.items]. Null (the default) falls back to it.
  List<BsDropdownEntry>? get items => _items;

  /// Replaces the menu's rows, e.g. to update a dropdown already open
  /// without rebuilding the [BsDropdown] itself. Pass null to fall back to
  /// [BsDropdown.items] again.
  void setItems(List<BsDropdownEntry>? items) {
    _items = items;
    notifyListeners();
  }

  /// Overrides [BsDropdown.direction]. Null (the default) falls back to it.
  BsDropdownDirection? get direction => _direction;

  /// Moves the menu to a different side of the toggle, e.g. to flip it away
  /// from a screen edge, without rebuilding the [BsDropdown] itself. Pass
  /// null to fall back to [BsDropdown.direction] again.
  void setDirection(BsDropdownDirection? direction) {
    _direction = direction;
    notifyListeners();
  }
}

/// `.dropdown-item`: a single actionable row.
class BsDropdownItem extends BsDropdownEntry {
  const BsDropdownItem({
    required this.child,
    this.onTap,
    this.active = false,
    this.disabled = false,
  });

  final Widget child;

  /// Called when tapped, just before the menu closes. Ignored when
  /// [disabled].
  final VoidCallback? onTap;

  /// `.active`: highlights this item as the current selection.
  final bool active;

  /// `.disabled`: dims the item and ignores taps.
  final bool disabled;
}

/// `.dropdown-divider`: a thin horizontal rule separating item groups.
class BsDropdownDivider extends BsDropdownEntry {
  const BsDropdownDivider();
}

/// `.dropdown-header`: a non-interactive label introducing a group of items.
class BsDropdownHeader extends BsDropdownEntry {
  const BsDropdownHeader({required this.child});

  final Widget child;
}

/// A Bootstrap dropdown (`.dropdown`): a menu of [items] revealed next to a
/// custom toggle, positioned and closed the way Material's `MenuAnchor`
/// anchors and dismisses its overlay.
///
/// [toggleBuilder] mirrors `MenuAnchor.builder`: it's handed a `toggle`
/// callback to wire up to the toggle widget's own tap handler, since
/// [BsDropdown] can't safely intercept gestures on a child it didn't build.
class BsDropdown extends StatefulWidget {
  const BsDropdown({
    super.key,
    required this.toggleBuilder,
    required this.items,
    this.direction = BsDropdownDirection.down,
    this.alignEnd = false,
    this.flip = true,
    this.style,
    this.onOpenChanged,
    this.controller,
    this.onShow,
    this.onShown,
    this.onHide,
    this.onHidden,
  });

  /// Builds the toggle widget. Call `toggle` from it (e.g. as a
  /// [BsButton.onPressed]) to open/close the menu; `isOpen` reflects the
  /// menu's current state.
  final Widget Function(BuildContext context, VoidCallback toggle, bool isOpen)
  toggleBuilder;

  /// The menu's rows, in order.
  final List<BsDropdownEntry> items;

  /// Which side of the toggle the menu opens on.
  final BsDropdownDirection direction;

  /// `.dropdown-menu-end`: aligns the menu's trailing edge with the
  /// toggle's instead of its leading edge. Only affects [direction]s
  /// [BsDropdownDirection.down]/[BsDropdownDirection.up].
  final bool alignEnd;

  /// Popper's `flip` and `preventOverflow` modifiers, which Bootstrap's
  /// dropdowns run by default: when the menu wouldn't fit inside the screen
  /// where [direction] and [alignEnd] put it, it opens on the opposite
  /// alignment or side instead (a `.dropdown` near the bottom edge becomes a
  /// `.dropup`, a left-aligned menu at the right edge becomes right-aligned),
  /// and as a last resort slides along the toggle to stay on screen. Pass
  /// false to always open exactly where asked.
  final bool flip;

  /// Style overrides layered on top of [BsDropdownStyle.defaults]. Pass
  /// [BsDropdownStyle.dark] for `.dropdown-menu-dark`.
  final BsDropdownStyle? style;

  /// Called whenever the menu opens or closes.
  final ValueChanged<bool>? onOpenChanged;

  /// Programmatic enable/disable and show/hide. Defaults to an
  /// internally-owned controller (always enabled, initially closed) when
  /// null.
  final BsDropdownController? controller;

  /// Called as soon as the menu is triggered to open. Mirrors Bootstrap's
  /// `show.bs.dropdown`.
  final VoidCallback? onShow;

  /// Called once the menu has finished opening. [BsDropdown] has no
  /// open/close animation, so this fires right after [onShow]. Mirrors
  /// Bootstrap's `shown.bs.dropdown`.
  final VoidCallback? onShown;

  /// Called as soon as the menu is triggered to close. Mirrors Bootstrap's
  /// `hide.bs.dropdown`.
  final VoidCallback? onHide;

  /// Called once the menu has finished closing. [BsDropdown] has no
  /// open/close animation, so this fires right after [onHide]. Mirrors
  /// Bootstrap's `hidden.bs.dropdown`.
  final VoidCallback? onHidden;

  @override
  State<BsDropdown> createState() => _BsDropdownState();
}

class _BsDropdownState extends State<BsDropdown>
    with BsPlacementTracker<BsDropdown> {
  final _link = LayerLink();
  final _overlayController = OverlayPortalController();
  BsDropdownController? _ownedController;
  bool _wasShown = false;

  BsDropdownController get _controller =>
      widget.controller ?? (_ownedController ??= BsDropdownController());

  @override
  BsPlacement get preferredPlacement {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    // "Start" alignment is the physical right edge in RTL.
    final align = (widget.alignEnd != rtl)
        ? BsPlacementAlign.end
        : BsPlacementAlign.start;
    return switch (_effectiveDirection) {
      BsDropdownDirection.down => BsPlacement(BsPlacementSide.bottom, align),
      BsDropdownDirection.up => BsPlacement(BsPlacementSide.top, align),
      BsDropdownDirection.start => BsPlacement(
        rtl ? BsPlacementSide.right : BsPlacementSide.left,
        BsPlacementAlign.start,
      ),
      BsDropdownDirection.end => BsPlacement(
        rtl ? BsPlacementSide.left : BsPlacementSide.right,
        BsPlacementAlign.start,
      ),
    };
  }

  @override
  double get placementSpacer =>
      (_style.spacer ?? BsDropdownStyle.defaultSpacer);

  @override
  bool get flipEnabled => widget.flip;

  @override
  bool get placementActive => _controller.isShown;

  BsDropdownStyle get _style =>
      (BsTheme.of(context) == Brightness.dark
              ? BsDropdownStyle.darkDefaults
              : BsDropdownStyle.defaults)
          .merge(widget.style);

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleControllerChanged);
  }

  void _handleControllerChanged() {
    setState(() {}); // picks up items/direction changes even while already open
    final isShown = _controller.isShown;
    // A setItems()/setDirection() call while already open (or closed)
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

  /// [BsDropdown.items], unless overridden by [BsDropdownController.setItems].
  List<BsDropdownEntry> get _effectiveItems =>
      _controller.items ?? widget.items;

  /// [BsDropdown.direction], unless overridden by [BsDropdownController.setDirection].
  BsDropdownDirection get _effectiveDirection =>
      _controller.direction ?? widget.direction;

  @override
  Widget build(BuildContext context) {
    final style = _style;

    return CompositedTransformTarget(
      key: placementTargetKey,
      link: _link,
      // Shares a groupId with the overlay menu's own TapRegion below, so a
      // tap on the toggle itself never counts as "outside" the dropdown
      // (which would otherwise race with _toggle: TapRegion closes it,
      // then the same tap reopens it via the toggle's own handler).
      child: TapRegion(
        groupId: this,
        child: OverlayPortal(
          controller: _overlayController,
          overlayChildBuilder: (context) => _buildOverlay(style),
          child: widget.toggleBuilder(context, _toggle, _controller.isShown),
        ),
      ),
    );
  }

  Widget _buildOverlay(BsDropdownStyle style) {
    // Until the menu has been measured (see [BsPlacementTracker]) it sits at
    // the preferred placement, invisible; afterwards at wherever flipping
    // chose.
    final resolved = currentPlacement;
    final placement = resolved.placement;
    final hidden = placementPending;

    return Stack(
      children: [
        // The TapRegion sits *inside* the follower: a region's "inside" is the
        // box it's laid out in, and the follower only moves its child (and the
        // hit-testing of it) away from the Stack's origin — a TapRegion wrapped
        // around the follower would keep its box at the origin, so a tap on the
        // menu would count as outside it and close the menu on pointer-down,
        // before any item saw the tap.
        //
        // TapRegion (not a full-screen hit-test barrier) detects an outside
        // tap passively, without absorbing it — see the identical fix and
        // explanation on BsPopover's outside-tap dismissal.
        CompositedTransformFollower(
          link: _link,
          targetAnchor: placement.targetAnchor,
          followerAnchor: placement.followerAnchor,
          offset: placement.offset(placementSpacer) + resolved.shift,
          child: TapRegion(
            groupId: this,
            onTapOutside: (_) => _controller.hide(),
            child: IgnorePointer(
              ignoring: hidden,
              child: Opacity(
                opacity: hidden ? 0 : 1,
                child: _BsDropdownMenu(
                  key: placementContentKey,
                  items: _effectiveItems,
                  style: style,
                  onItemTap: _controller.hide,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _BsDropdownMenu extends StatelessWidget {
  const _BsDropdownMenu({
    super.key,
    required this.items,
    required this.style,
    required this.onItemTap,
  });

  final List<BsDropdownEntry> items;
  final BsDropdownStyle style;
  final VoidCallback onItemTap;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(
      style.borderRadius ?? BsDropdownStyle.defaultBorderRadius,
    );

    // The overlay Stack that hosts this menu (see [_buildOverlay]) only
    // *loosens* the tight constraints Overlay hands its entries — it
    // doesn't bound them to the menu's own content. Without IntrinsicWidth,
    // the Column below's `crossAxisAlignment: stretch` would stretch the
    // whole menu out to that loose (screen-sized) width instead of its
    // natural content width, and — for `alignEnd: true` menus, whose
    // `topRight`/`bottomRight` follower anchor reads that bogus width to
    // compute its horizontal offset — shift the entire menu off to the
    // left of the toggle instead of hugging its right edge.
    return IntrinsicWidth(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: style.minWidth ?? BsDropdownStyle.defaultMinWidth,
        ),
        child: BsDecoratedBox(
          decoration: BoxDecoration(
            color: style.background ?? BsDropdownStyle.defaultBackground,
            border: Border.all(
              color: style.borderColor ?? BsDropdownStyle.defaultBorderColor,
              width: style.borderWidth ?? BsDropdownStyle.defaultBorderWidth,
            ),
            borderRadius: borderRadius,
            boxShadow: style.boxShadow,
          ),
          // The border takes room (box-sizing: border-box): the menu's content
          // sits inside it, so a hovered item's background stops at the border
          // instead of painting over it, and the menu is as tall and wide as
          // the CSS one. The clip follows the inside of the rounded border.
          child: Padding(
            padding: EdgeInsets.all(
              style.borderWidth ?? BsDropdownStyle.defaultBorderWidth,
            ),
            child: BsClipRRect(
              borderRadius: BorderRadius.circular(
                math.max(
                  0,
                  (style.borderRadius ?? BsDropdownStyle.defaultBorderRadius) -
                      (style.borderWidth ?? BsDropdownStyle.defaultBorderWidth),
                ),
              ),
              child: Padding(
                padding: style.padding ?? BsDropdownStyle.defaultPadding,
                child: DefaultTextStyle.merge(
                  style: TextStyle(
                    color: style.color ?? BsDropdownStyle.defaultColor,
                    fontSize: style.fontSize ?? BsDropdownStyle.defaultFontSize,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (var i = 0; i < items.length; i++) ...[
                        if (i > 0 && (style.itemSpacing ?? 0) > 0)
                          SizedBox(height: style.itemSpacing),
                        _buildEntry(items[i]),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEntry(BsDropdownEntry entry) {
    return switch (entry) {
      BsDropdownDivider() => _BsDropdownDividerWidget(style: style),
      BsDropdownHeader() => _BsDropdownHeaderWidget(entry: entry, style: style),
      BsDropdownItem() => _BsDropdownItemWidget(
        item: entry,
        style: style,
        onTap: onItemTap,
      ),
    };
  }
}

class _BsDropdownItemWidget extends StatefulWidget {
  const _BsDropdownItemWidget({
    required this.item,
    required this.style,
    required this.onTap,
  });

  final BsDropdownItem item;
  final BsDropdownStyle style;

  /// Called after [BsDropdownItem.onTap] to close the menu.
  final VoidCallback onTap;

  @override
  State<_BsDropdownItemWidget> createState() => _BsDropdownItemWidgetState();
}

class _BsDropdownItemWidgetState extends State<_BsDropdownItemWidget> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final style = widget.style;
    final enabled = !item.disabled;

    final Color background;
    final Color color;
    if (item.active) {
      background =
          style.linkActiveBackground ??
          BsDropdownStyle.defaultLinkActiveBackground;
      color = style.linkActiveColor ?? BsDropdownStyle.defaultLinkActiveColor;
    } else if (_hovered && enabled) {
      background =
          style.linkHoverBackground ??
          BsDropdownStyle.defaultLinkHoverBackground;
      color =
          style.linkHoverColor ??
          style.linkColor ??
          BsDropdownStyle.defaultColor;
    } else {
      background = const Color(0x00000000);
      color = enabled
          ? (style.linkColor ?? BsDropdownStyle.defaultColor)
          : (style.linkDisabledColor ??
                BsDropdownStyle.defaultLinkDisabledColor);
    }

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: enabled ? (_) => setState(() => _hovered = true) : null,
      onExit: enabled ? (_) => setState(() => _hovered = false) : null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled
            ? () {
                item.onTap?.call();
                widget.onTap();
              }
            : null,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: background,
            borderRadius: style.itemBorderRadius == null
                ? null
                : BorderRadius.circular(style.itemBorderRadius!),
          ),
          child: Padding(
            padding: style.itemPadding ?? BsDropdownStyle.defaultItemPadding,
            child: DefaultTextStyle.merge(
              style: TextStyle(color: color),
              child: item.child,
            ),
          ),
        ),
      ),
    );
  }
}

class _BsDropdownDividerWidget extends StatelessWidget {
  const _BsDropdownDividerWidget({required this.style});

  final BsDropdownStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: style.dividerMarginY ?? BsDropdownStyle.defaultDividerMarginY,
      ),
      child: ColoredBox(
        color: style.dividerColor ?? BsDropdownStyle.defaultBorderColor,
        child: const SizedBox(height: 1, width: double.infinity),
      ),
    );
  }
}

class _BsDropdownHeaderWidget extends StatelessWidget {
  const _BsDropdownHeaderWidget({required this.entry, required this.style});

  final BsDropdownHeader entry;
  final BsDropdownStyle style;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: style.headerPadding ?? BsDropdownStyle.defaultHeaderPadding,
      child: DefaultTextStyle.merge(
        style: TextStyle(
          color: style.headerColor ?? BsDropdownStyle.defaultHeaderColor,
          fontSize: 14,
        ),
        child: entry.child,
      ),
    );
  }
}

/// A small downward-pointing triangle, replicating the caret Bootstrap's
/// CSS automatically appends after `.dropdown-toggle` content
/// (`.dropdown-toggle::after`). Add it manually inside a
/// [BsDropdown.toggleBuilder]'s returned widget, [marginStart] after the
/// content.
///
/// Without a [size] it is the stylesheet's own caret: `.3em` of [fontSize]
/// (16 by default) wide on each side, `.3em` tall. Browsers snap border widths
/// down to whole device pixels, so that is 8x4 at 1x and 9x4.5 at 2x rather
/// than 9.6x4.8, and so it is here. Pass [size] for a caret of an explicit
/// width instead (its height is then 70% of it).
class BsDropdownCaret extends StatelessWidget {
  const BsDropdownCaret({
    super.key,
    this.color,
    this.size,
    this.fontSize = 16,
    this.up = false,
  });

  /// `.dropdown-toggle::after`'s `margin-left` (`.255em` of 16px).
  static const double marginStart = 4.08;

  final Color? color;

  /// An explicit width, bypassing the `.3em` border-snapping behaviour.
  final double? size;

  /// The toggle's font size, which `.3em` is relative to.
  final double fontSize;

  /// `.dropup`'s caret: pointing up.
  final bool up;

  /// The height of the stylesheet's caret (its border width) at the ambient
  /// device pixel ratio, for a toggle of [fontSize].
  static double heightFor(BuildContext context, {double fontSize = 16}) {
    final dpr = MediaQuery.maybeDevicePixelRatioOf(context) ?? 1;
    return (fontSize * 0.3 * dpr).floorToDouble() / dpr;
  }

  @override
  Widget build(BuildContext context) {
    final Size caretSize;
    if (size != null) {
      caretSize = Size(size!, size! * 0.7);
    } else {
      final border = heightFor(context, fontSize: fontSize);
      caretSize = Size(border * 2, border);
    }
    return CustomPaint(
      size: caretSize,
      painter: _BsDropdownCaretPainter(
        color ??
            DefaultTextStyle.of(context).style.color ??
            const Color(0xFF000000),
        up: up,
      ),
    );
  }
}

class _BsDropdownCaretPainter extends CustomPainter {
  _BsDropdownCaretPainter(this.color, {required this.up});

  final Color color;
  final bool up;

  @override
  void paint(Canvas canvas, Size size) {
    final path = up
        ? (Path()
            ..moveTo(0, size.height)
            ..lineTo(size.width, size.height)
            ..lineTo(size.width / 2, 0)
            ..close())
        : (Path()
            ..moveTo(0, 0)
            ..lineTo(size.width, 0)
            ..lineTo(size.width / 2, size.height)
            ..close());
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _BsDropdownCaretPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.up != up;
}
