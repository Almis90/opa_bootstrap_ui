import 'package:flutter/widgets.dart';

import 'bs_theme.dart';
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

    final isDark = BsTheme.of(context) == Brightness.dark;
    final style = (isDark ? BsNavStyle.darkDefaults : BsNavStyle.defaults).merge(this.style);
    final isTabs = variant == BsNavVariant.tabs;
    final isUnderline = variant == BsNavVariant.underline;

    // `.nav-underline` applies a flex `gap` between items, on top of each
    // link's own padding — the other variants rely on padding alone.
    final gap = style.underlineGap ?? BsNavStyle.defaultUnderlineGap;
    final gapWidget = vertical ? SizedBox(height: gap) : SizedBox(width: gap);

    final children = <Widget>[
      for (var i = 0; i < items.length; i++) ...[
        if (isUnderline && i > 0) gapWidget,
        _BsNavLinkWidget(item: items[i], variant: variant, style: style, expand: fill && !vertical),
      ],
    ];

    // IntrinsicWidth bounds the column's width (to its widest item) so
    // crossAxisAlignment.stretch can stretch every item to match — a bare
    // Column would otherwise inherit the unbounded width of an enclosing
    // Row and crash.
    //
    // The horizontal Row only takes MainAxisSize.max when fill stretches
    // its items to share the available width (`.nav-fill`/`.nav-justified`,
    // which needs that space to divide up); otherwise a real `.nav` sizes
    // to its content like any other unstretched flex item, so the Row
    // matches that with MainAxisSize.min — without it, a bare BsNav placed
    // next to a sibling (e.g. in a Wrap or a Row) would always claim the
    // rest of that shared row's width for itself instead of just its own
    // links, pushing the sibling onto its own line/row.
    final Widget nav = vertical
        ? IntrinsicWidth(child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: children))
        : Row(
            mainAxisSize: fill ? MainAxisSize.max : MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: children,
          );

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
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final style = widget.style;
    final enabled = item.onTap != null && !item.disabled;
    final radius = widget.variant == BsNavVariant.pills
        ? style.pillsBorderRadius ?? BsNavStyle.defaultPillsBorderRadius
        : style.tabsBorderRadius ?? BsNavStyle.defaultTabsBorderRadius;
    final borderRadius = BorderRadius.circular(radius);

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
              border = Border.all(color: style.tabsLinkHoverBorderColor ?? BsNavStyle.defaultTabsLinkHoverBorderColor);
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
        boxShadow: [
          if (_focused)
            BoxShadow(
              color: style.linkFocusRingColor ?? BsNavStyle.defaultLinkFocusRingColor,
              spreadRadius: style.linkFocusRingWidth ?? BsNavStyle.defaultLinkFocusRingWidth,
            ),
        ],
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
      child: Focus(
        onFocusChange: enabled ? (focused) => setState(() => _focused = focused) : null,
        child: GestureDetector(behavior: HitTestBehavior.opaque, onTap: enabled ? item.onTap : null, child: content),
      ),
    );

    return widget.expand ? Expanded(child: link) : link;
  }
}

/// Programmatic control of a [BsTabView] — mirrors Bootstrap's own
/// `bootstrap.Tab` JS plugin's `show()` method. Pair with a [BsNav] by
/// driving each [BsNavItem.active]/[BsNavItem.onTap] from [index]/[show]
/// yourself — [BsNav] and [BsTabView] stay as decoupled as Bootstrap's own
/// `.nav` markup and `.tab-content` are, so a controller only wires into
/// whichever pane view you actually use.
class BsTabController extends ChangeNotifier {
  BsTabController({int initialIndex = 0}) : _index = initialIndex;

  int _index;

  /// The currently active pane's index into [BsTabView.children].
  int get index => _index;

  /// Switches to [index], mirroring `bootstrap.Tab.show()`. A no-op if
  /// [index] is already active.
  void show(int index) {
    if (index == _index) return;
    _index = index;
    notifyListeners();
  }
}

/// A crossfading content swapper (`.tab-content`/`.tab-pane.fade`),
/// typically paired with a [BsNav] whose active item picks [activeIndex].
///
/// Controllable either way Bootstrap's own `data-bs-toggle="tab"` can be:
/// pass [activeIndex] and flip it from the parent (e.g. a [BsNavItem]'s
/// `onTap` calling `setState`), or pass a [controller] and call
/// [BsTabController.show] from anywhere with access to it. [activeIndex] is
/// ignored when [controller] is given — omit it and set [activeIndex] on
/// the internally-owned controller instead.
class BsTabView extends StatefulWidget {
  const BsTabView({
    super.key,
    this.activeIndex,
    required this.children,
    this.duration,
    this.controller,
    this.onShow,
    this.onShown,
    this.onHide,
    this.onHidden,
  });

  /// Index into [children] of the pane to show. Ignored when [controller]
  /// is given; only meaningful with the internally-owned controller that's
  /// used instead.
  final int? activeIndex;

  /// One entry per nav item, in the same order.
  final List<Widget> children;

  /// `$transition-fade` override.
  final Duration? duration;

  /// Drives which pane is active instead of [activeIndex]. Defaults to an
  /// internally-owned controller (seeded from [activeIndex]) when null.
  final BsTabController? controller;

  /// Called immediately when a new pane is triggered active, before the
  /// fade transition starts, with the newly active index. Mirrors
  /// Bootstrap's `show.bs.tab`.
  final ValueChanged<int>? onShow;

  /// Called once the newly active pane's fade-in finishes, with its index.
  /// Mirrors Bootstrap's `shown.bs.tab`.
  final ValueChanged<int>? onShown;

  /// Called immediately when the previously active pane starts fading out,
  /// with its index. Mirrors Bootstrap's `hide.bs.tab`.
  final ValueChanged<int>? onHide;

  /// Called once the previously active pane's fade-out finishes, with its
  /// index. Mirrors Bootstrap's `hidden.bs.tab`.
  final ValueChanged<int>? onHidden;

  @override
  State<BsTabView> createState() => _BsTabViewState();
}

class _BsTabViewState extends State<BsTabView> {
  BsTabController? _ownedController;
  late int _lastIndex;
  int? _pendingFrom;
  int? _pendingTo;

  BsTabController get _controller =>
      widget.controller ?? (_ownedController ??= BsTabController(initialIndex: widget.activeIndex ?? 0));

  @override
  void initState() {
    super.initState();
    _lastIndex = _controller.index;
    _controller.addListener(_handleControllerChanged);
  }

  @override
  void didUpdateWidget(covariant BsTabView oldWidget) {
    super.didUpdateWidget(oldWidget);
    // activeIndex only drives the internally-owned controller — an
    // explicit controller is always the source of truth once given.
    if (widget.controller == null && widget.activeIndex != null && widget.activeIndex != _controller.index) {
      _controller.show(widget.activeIndex!);
    }
  }

  void _handleControllerChanged() {
    final newIndex = _controller.index;
    if (newIndex != _lastIndex) {
      final oldIndex = _lastIndex;
      _lastIndex = newIndex;
      _pendingFrom = oldIndex;
      _pendingTo = newIndex;
      widget.onHide?.call(oldIndex);
      widget.onShow?.call(newIndex);

      final duration = widget.duration ?? BsTransitions.fade;
      Future.delayed(duration, () {
        if (!mounted) return;
        // Only fire if this is still the transition we scheduled it for —
        // a rapid second switch before this fires means this one never
        // actually completed, so reporting it would be stale.
        if (_pendingFrom != oldIndex || _pendingTo != newIndex) return;
        _pendingFrom = null;
        _pendingTo = null;
        widget.onHidden?.call(oldIndex);
        widget.onShown?.call(newIndex);
      });
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);
    _ownedController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final index = _controller.index;
    return AnimatedSwitcher(
      duration: widget.duration ?? BsTransitions.fade,
      child: KeyedSubtree(key: ValueKey(index), child: widget.children[index]),
    );
  }
}
