import 'package:flutter/widgets.dart';

import 'bs_theme.dart';
import 'tokens/bs_dropdown_style.dart';

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
  const BsDropdownItem({required this.child, this.onTap, this.active = false, this.disabled = false});

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
  final Widget Function(BuildContext context, VoidCallback toggle, bool isOpen) toggleBuilder;

  /// The menu's rows, in order.
  final List<BsDropdownEntry> items;

  /// Which side of the toggle the menu opens on.
  final BsDropdownDirection direction;

  /// `.dropdown-menu-end`: aligns the menu's trailing edge with the
  /// toggle's instead of its leading edge. Only affects [direction]s
  /// [BsDropdownDirection.down]/[BsDropdownDirection.up].
  final bool alignEnd;

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

class _BsDropdownState extends State<BsDropdown> {
  final _link = LayerLink();
  final _overlayController = OverlayPortalController();
  BsDropdownController? _ownedController;
  bool _wasShown = false;

  BsDropdownController get _controller => widget.controller ?? (_ownedController ??= BsDropdownController());

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
  List<BsDropdownEntry> get _effectiveItems => _controller.items ?? widget.items;

  /// [BsDropdown.direction], unless overridden by [BsDropdownController.setDirection].
  BsDropdownDirection get _effectiveDirection => _controller.direction ?? widget.direction;

  @override
  Widget build(BuildContext context) {
    final isDark = BsTheme.of(context) == Brightness.dark;
    final style = (isDark ? BsDropdownStyle.darkDefaults : BsDropdownStyle.defaults).merge(widget.style);

    return CompositedTransformTarget(
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
    final spacer = style.spacer ?? BsDropdownStyle.defaultSpacer;
    final (Alignment targetAnchor, Alignment followerAnchor, Offset offset) = switch (_effectiveDirection) {
      BsDropdownDirection.down => widget.alignEnd
          ? (Alignment.bottomRight, Alignment.topRight, Offset(0, spacer))
          : (Alignment.bottomLeft, Alignment.topLeft, Offset(0, spacer)),
      BsDropdownDirection.up => widget.alignEnd
          ? (Alignment.topRight, Alignment.bottomRight, Offset(0, -spacer))
          : (Alignment.topLeft, Alignment.bottomLeft, Offset(0, -spacer)),
      BsDropdownDirection.start => (Alignment.topLeft, Alignment.topRight, Offset(-spacer, 0)),
      BsDropdownDirection.end => (Alignment.topRight, Alignment.topLeft, Offset(spacer, 0)),
    };

    return Stack(
      children: [
        // TapRegion (not a full-screen hit-test barrier) detects an outside
        // tap passively, without absorbing it — see the identical fix and
        // explanation on BsPopover's outside-tap dismissal.
        TapRegion(
          groupId: this,
          onTapOutside: (_) => _controller.hide(),
          child: CompositedTransformFollower(
            link: _link,
            targetAnchor: targetAnchor,
            followerAnchor: followerAnchor,
            offset: offset,
            child: _BsDropdownMenu(items: _effectiveItems, style: style, onItemTap: _controller.hide),
          ),
        ),
      ],
    );
  }
}

class _BsDropdownMenu extends StatelessWidget {
  const _BsDropdownMenu({required this.items, required this.style, required this.onItemTap});

  final List<BsDropdownEntry> items;
  final BsDropdownStyle style;
  final VoidCallback onItemTap;

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(style.borderRadius ?? BsDropdownStyle.defaultBorderRadius);

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
        constraints: BoxConstraints(minWidth: style.minWidth ?? BsDropdownStyle.defaultMinWidth),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: style.background ?? BsDropdownStyle.defaultBackground,
            border: Border.all(
              color: style.borderColor ?? BsDropdownStyle.defaultBorderColor,
              width: style.borderWidth ?? BsDropdownStyle.defaultBorderWidth,
            ),
            borderRadius: borderRadius,
            boxShadow: style.boxShadow ?? BsDropdownStyle.defaultBoxShadow,
          ),
          child: ClipRRect(
            borderRadius: borderRadius,
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
                  children: [for (final entry in items) _buildEntry(entry)],
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
      BsDropdownItem() => _BsDropdownItemWidget(item: entry, style: style, onTap: onItemTap),
    };
  }
}

class _BsDropdownItemWidget extends StatefulWidget {
  const _BsDropdownItemWidget({required this.item, required this.style, required this.onTap});

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
      background = style.linkActiveBackground ?? BsDropdownStyle.defaultLinkActiveBackground;
      color = style.linkActiveColor ?? BsDropdownStyle.defaultLinkActiveColor;
    } else if (_hovered && enabled) {
      background = style.linkHoverBackground ?? BsDropdownStyle.defaultLinkHoverBackground;
      color = style.linkHoverColor ?? style.linkColor ?? BsDropdownStyle.defaultColor;
    } else {
      background = const Color(0x00000000);
      color = enabled
          ? (style.linkColor ?? BsDropdownStyle.defaultColor)
          : (style.linkDisabledColor ?? BsDropdownStyle.defaultLinkDisabledColor);
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
        child: ColoredBox(
          color: background,
          child: Padding(
            padding: style.itemPadding ?? BsDropdownStyle.defaultItemPadding,
            child: DefaultTextStyle.merge(style: TextStyle(color: color), child: item.child),
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
      padding: EdgeInsets.symmetric(vertical: style.dividerMarginY ?? BsDropdownStyle.defaultDividerMarginY),
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
        style: TextStyle(color: style.headerColor ?? BsDropdownStyle.defaultHeaderColor, fontSize: 14),
        child: entry.child,
      ),
    );
  }
}

/// A small downward-pointing triangle, replicating the caret Bootstrap's
/// CSS automatically appends after `.dropdown-toggle` content. Add it
/// manually inside a [BsDropdown.toggleBuilder]'s returned widget.
class BsDropdownCaret extends StatelessWidget {
  const BsDropdownCaret({super.key, this.color, this.size = 8});

  final Color? color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(size, size * 0.7),
      painter: _BsDropdownCaretPainter(color ?? DefaultTextStyle.of(context).style.color ?? const Color(0xFF000000)),
    );
  }
}

class _BsDropdownCaretPainter extends CustomPainter {
  _BsDropdownCaretPainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _BsDropdownCaretPainter oldDelegate) => oldDelegate.color != color;
}
