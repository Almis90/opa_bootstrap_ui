import 'package:flutter/widgets.dart';

import 'bs_colors.dart';
import 'tokens/bs_nav_style.dart';
import 'tokens/bs_transitions.dart';

/// Which Bootstrap nav style a [BsNav] renders.
enum BsNavVariant {
  /// `.nav`: plain links, no active-state styling of its own.
  plain,

  /// `.nav-tabs`: bordered, with the active item raised like a folder tab.
  tabs,

  /// `.nav-pills`: the active item gets a filled pill background.
  pills,

  /// `.nav-underline`: the active (and hovered) item gets a colored
  /// bottom border instead of a background.
  underline,
}

/// A single `.nav-link` within a [BsNav].
class BsNavItem {
  const BsNavItem({required this.child, this.onTap, this.active = false, this.disabled = false});

  final Widget child;
  final VoidCallback? onTap;

  /// Highlights this item as the current selection, per [BsNavVariant].
  final bool active;

  /// `.disabled`: dims the item and ignores taps.
  final bool disabled;
}

/// A Bootstrap nav (`.nav`): a row (or, per [vertical], column) of
/// [BsNavItem]s, styled per [variant].
///
/// Unlike Material's `TabBar`, which animates a sliding indicator between
/// tabs, each item's active/hover state here switches immediately — the
/// same immediate-state approach [BsListGroup] and [BsButtonGroup] already
/// use for their own active items, kept for consistency rather than
/// introducing a one-off animated indicator.
///
/// Pair with [BsTabView] to switch content when [BsNavItem.onTap] changes
/// which item is active.
class BsNav extends StatelessWidget {
  const BsNav({
    super.key,
    required this.items,
    this.variant = BsNavVariant.plain,
    this.vertical = false,
    this.fill = false,
    this.style,
  });

  /// The links to render, in order.
  final List<BsNavItem> items;

  final BsNavVariant variant;

  /// `.flex-column`: stacks items top to bottom instead of side by side.
  final bool vertical;

  /// `.nav-fill`/`.nav-justified`: stretches every item to equal width
  /// (only meaningful when not [vertical]).
  final bool fill;

  /// Style overrides layered on top of [BsNavStyle.defaults].
  final BsNavStyle? style;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final style = BsNavStyle.defaults.merge(this.style);
    final isTabs = variant == BsNavVariant.tabs;

    final children = [
      for (final item in items)
        _BsNavLinkWidget(item: item, variant: variant, style: style, expand: fill && !vertical),
    ];

    // IntrinsicWidth bounds the column's width (to its widest item) so
    // crossAxisAlignment.stretch can stretch every item to match — a bare
    // Column would otherwise inherit the unbounded width of an enclosing
    // Row and crash.
    final Widget nav = vertical
        ? IntrinsicWidth(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children))
        : Row(crossAxisAlignment: CrossAxisAlignment.end, children: children);

    if (!isTabs) return nav;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: style.tabsBorderColor ?? BsNavStyle.defaultTabsBorderColor,
            width: style.tabsBorderWidth ?? BsNavStyle.defaultTabsBorderWidth,
          ),
        ),
      ),
      child: nav,
    );
  }
}

class _BsNavLinkWidget extends StatefulWidget {
  const _BsNavLinkWidget({required this.item, required this.variant, required this.style, required this.expand});

  final BsNavItem item;
  final BsNavVariant variant;
  final BsNavStyle style;
  final bool expand;

  @override
  State<_BsNavLinkWidget> createState() => _BsNavLinkWidgetState();
}

class _BsNavLinkWidgetState extends State<_BsNavLinkWidget> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final style = widget.style;
    final enabled = item.onTap != null && !item.disabled;
    final borderRadius = BorderRadius.circular(style.tabsBorderRadius ?? BsNavStyle.defaultTabsBorderRadius);

    Color? color;
    Color background = const Color(0x00000000);
    Border? border;
    FontWeight? fontWeight;

    final restColor = style.linkColor ?? BsNavStyle.defaultLinkColor;
    final hoverColor = style.linkHoverColor ?? restColor;

    if (item.disabled) {
      color = style.linkDisabledColor ?? BsNavStyle.defaultLinkDisabledColor;
    } else {
      switch (widget.variant) {
        case BsNavVariant.plain:
          color = _hovered ? hoverColor : restColor;
        case BsNavVariant.tabs:
          final borderColor = style.tabsBorderColor ?? BsNavStyle.defaultTabsBorderColor;
          if (item.active) {
            color = style.tabsLinkActiveColor ?? BsNavStyle.defaultTabsLinkActiveColor;
            background = style.tabsLinkActiveBackground ?? BsNavStyle.defaultTabsLinkActiveBackground;
            // A uniform-color border, not a bottom edge matching
            // [background] to blend into the container's shared border
            // line below it — Border.paint refuses non-uniform side
            // colors together with a borderRadius.
            border = Border.all(color: style.tabsLinkActiveBorderColor ?? borderColor);
          } else {
            color = _hovered ? hoverColor : restColor;
            if (_hovered) {
              border = Border.all(color: BsColors.gray200);
            }
          }
        case BsNavVariant.pills:
          if (item.active) {
            color = style.pillsLinkActiveColor ?? BsNavStyle.defaultPillsLinkActiveColor;
            background = style.pillsLinkActiveBackground ?? BsNavStyle.defaultPillsLinkActiveBackground;
          } else {
            color = _hovered ? hoverColor : restColor;
          }
        case BsNavVariant.underline:
          final underlineWidth = style.underlineBorderWidth ?? BsNavStyle.defaultUnderlineBorderWidth;
          if (item.active) {
            color = style.underlineLinkActiveColor ?? BsNavStyle.defaultUnderlineLinkActiveColor;
            fontWeight = FontWeight.bold;
            border = Border(bottom: BorderSide(color: color, width: underlineWidth));
          } else {
            color = _hovered ? hoverColor : restColor;
            border = Border(
              bottom: BorderSide(color: _hovered ? hoverColor : const Color(0x00000000), width: underlineWidth),
            );
          }
      }
    }

    final content = DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        border: border,
        borderRadius: widget.variant == BsNavVariant.pills || widget.variant == BsNavVariant.tabs ? borderRadius : null,
      ),
      child: Padding(
        padding: style.linkPadding ?? BsNavStyle.defaultLinkPadding,
        child: DefaultTextStyle.merge(
          style: TextStyle(color: color, fontWeight: fontWeight),
          textAlign: widget.expand ? TextAlign.center : null,
          child: item.child,
        ),
      ),
    );

    final link = MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: enabled ? (_) => setState(() => _hovered = true) : null,
      onExit: enabled ? (_) => setState(() => _hovered = false) : null,
      child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: enabled ? item.onTap : null, child: content),
    );

    return widget.expand ? Expanded(child: link) : link;
  }
}

/// A crossfading content swapper (`.tab-content`/`.tab-pane.fade`),
/// typically paired with a [BsNav] whose active item picks [activeIndex].
class BsTabView extends StatelessWidget {
  const BsTabView({super.key, required this.activeIndex, required this.children, this.duration});

  /// Index into [children] of the pane to show.
  final int activeIndex;

  /// One entry per nav item, in the same order.
  final List<Widget> children;

  /// `$transition-fade` override.
  final Duration? duration;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration ?? BsTransitions.fade,
      child: KeyedSubtree(key: ValueKey(activeIndex), child: children[activeIndex]),
    );
  }
}
