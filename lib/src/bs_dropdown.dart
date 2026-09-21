import 'package:flutter/widgets.dart';

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

  @override
  State<BsDropdown> createState() => _BsDropdownState();
}

class _BsDropdownState extends State<BsDropdown> {
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
    final style = BsDropdownStyle.defaults.merge(widget.style);

    return CompositedTransformTarget(
      link: _link,
      child: OverlayPortal(
        controller: _overlayController,
        overlayChildBuilder: (context) => _buildOverlay(style),
        child: widget.toggleBuilder(context, _toggle, _isOpen),
      ),
    );
  }

  Widget _buildOverlay(BsDropdownStyle style) {
    final spacer = style.spacer ?? BsDropdownStyle.defaultSpacer;
    final (Alignment targetAnchor, Alignment followerAnchor, Offset offset) = switch (widget.direction) {
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
        Positioned.fill(child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: _close)),
        CompositedTransformFollower(
          link: _link,
          targetAnchor: targetAnchor,
          followerAnchor: followerAnchor,
          offset: offset,
          child: _BsDropdownMenu(items: widget.items, style: style, onItemTap: _close),
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

    return ConstrainedBox(
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [for (final entry in items) _buildEntry(entry)],
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
      color = style.linkColor ?? BsDropdownStyle.defaultColor;
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
