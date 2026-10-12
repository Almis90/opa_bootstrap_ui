import 'package:flutter/widgets.dart';

import 'bs_box.dart';
import 'bs_breakpoint.dart';
import 'bs_flex.dart';
import 'bs_focusable.dart';
import 'bs_responsive_value.dart';
import 'bs_spacing.dart';
import 'bs_theme.dart';
import 'tokens/bs_borders.dart';
import 'tokens/bs_nav_style.dart';
import 'tokens/bs_transitions.dart';
import 'bs_decorated_box.dart';

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
  const BsNavItem({
    required this.child,
    this.onTap,
    this.active = false,
    this.disabled = false,
    this.textColor,
    this.py,
    this.rounded,
    this.borderBottom = false,
  });

  final Widget child;
  final VoidCallback? onTap;

  /// Highlights this item as the current selection, per [BsNavVariant].
  final bool active;

  /// `.disabled`: dims the item and ignores taps.
  final bool disabled;

  /// `text-white`, `link-body-emphasis`…: the link's color in place of the
  /// nav's, unchanged under the pointer. An [active] item keeps its own.
  final BsTextColor? textColor;

  /// `py-*`: vertical padding in place of the nav link's `.5rem`.
  final BsSpacing? py;

  /// `rounded-*` (`rounded-0`): a corner radius in place of the variant's.
  final BsRounded? rounded;

  /// `border-bottom`: a 1px bottom border (inside the item's box, below its
  /// padding), in the border color.
  final bool borderBottom;
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
    this.nowrap = false,
    this.justifyContent,
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

  /// `flex-nowrap`: a horizontal nav keeps all its links on one line (however
  /// narrow its space) instead of wrapping onto more, as in a scrolling
  /// `.nav-scroller`.
  final bool nowrap;

  /// `justify-content-*` on the `.nav` (a flex container): where each line of
  /// a horizontal nav sits when it has more room than its links need, and how
  /// each wrapped line is placed. Needs a bounded width to have any effect —
  /// give the nav a full-width parent, as `.col-12` does.
  final BsResponsive<BsJustify>? justifyContent;

  /// Style overrides layered on top of [BsNavStyle.defaults].
  final BsNavStyle? style;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final isDark = BsTheme.of(context) == Brightness.dark;
    final style = (isDark ? BsNavStyle.darkDefaults : BsNavStyle.defaults)
        .merge(this.style);
    final isTabs = variant == BsNavVariant.tabs;
    final isUnderline = variant == BsNavVariant.underline;

    // `.nav-underline` applies a flex `gap` between items, on top of each
    // link's own padding — the other variants rely on padding alone.
    final gap = style.underlineGap ?? BsNavStyle.defaultUnderlineGap;
    final gapWidget = vertical ? SizedBox(height: gap) : SizedBox(width: gap);

    final children = <Widget>[
      for (var i = 0; i < items.length; i++) ...[
        if (isUnderline && i > 0) gapWidget,
        _BsNavLinkWidget(
          item: items[i],
          variant: variant,
          style: style,
          expand: fill && !vertical,
        ),
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
    //
    // `.nav` is `display: flex; flex-wrap: wrap`, so a horizontal nav too wide
    // for its space wraps onto further lines (left-aligned) instead of
    // overflowing; only `.nav-fill`/`.nav-justified`, whose items share the
    // space out, stay a single Row.
    final Widget nav = vertical
        ? IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: children,
            ),
          )
        : fill
        ? Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: children,
          )
        : nowrap
        ? Row(
            mainAxisSize: justifyContent == null
                ? MainAxisSize.min
                : MainAxisSize.max,
            mainAxisAlignment: _mainAxisAlignment(
              justifyContent?.resolve(
                BsBreakpoint.forWidth(MediaQuery.sizeOf(context).width),
              ),
            ),
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (var i = 0; i < items.length; i++)
                Padding(
                  // (`.nav-underline`'s flex `gap`)
                  padding: EdgeInsetsDirectional.only(
                    end: isUnderline && i < items.length - 1 ? gap : 0,
                  ),
                  child: _BsNavLinkWidget(
                    item: items[i],
                    variant: variant,
                    style: style,
                    expand: false,
                  ),
                ),
            ],
          )
        : Wrap(
            alignment: _wrapAlignment(
              justifyContent?.resolve(
                BsBreakpoint.forWidth(MediaQuery.sizeOf(context).width),
              ),
            ),
            crossAxisAlignment: WrapCrossAlignment.end,
            spacing: isUnderline ? gap : 0,
            children: [
              for (final item in items)
                _BsNavLinkWidget(
                  item: item,
                  variant: variant,
                  style: style,
                  expand: false,
                ),
            ],
          );

    if (!isTabs) return nav;

    return BsDecoratedBox(
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

WrapAlignment _wrapAlignment(BsJustify? justify) => switch (justify) {
  null || BsJustify.start => WrapAlignment.start,
  BsJustify.end => WrapAlignment.end,
  BsJustify.center => WrapAlignment.center,
  BsJustify.between => WrapAlignment.spaceBetween,
  BsJustify.around => WrapAlignment.spaceAround,
  BsJustify.evenly => WrapAlignment.spaceEvenly,
};

MainAxisAlignment _mainAxisAlignment(BsJustify? justify) => switch (justify) {
  null || BsJustify.start => MainAxisAlignment.start,
  BsJustify.end => MainAxisAlignment.end,
  BsJustify.center => MainAxisAlignment.center,
  BsJustify.between => MainAxisAlignment.spaceBetween,
  BsJustify.around => MainAxisAlignment.spaceAround,
  BsJustify.evenly => MainAxisAlignment.spaceEvenly,
};

class _BsNavLinkWidget extends StatefulWidget {
  const _BsNavLinkWidget({
    required this.item,
    required this.variant,
    required this.style,
    required this.expand,
  });

  final BsNavItem item;
  final BsNavVariant variant;
  final BsNavStyle style;
  final bool expand;

  @override
  State<_BsNavLinkWidget> createState() => _BsNavLinkWidgetState();
}

class _BsNavLinkWidgetState extends State<_BsNavLinkWidget> {
  bool _hovered = false;

  EdgeInsetsGeometry _padding(EdgeInsetsGeometry base) {
    final item = widget.item;
    if (item.py == null && !item.borderBottom) return base;
    final resolved = base.resolve(TextDirection.ltr);
    final vertical = item.py?.size;
    return EdgeInsets.fromLTRB(
      resolved.left,
      vertical ?? resolved.top,
      resolved.right,
      (vertical ?? resolved.bottom) + (item.borderBottom ? 1 : 0),
    );
  }

  EdgeInsets _underlinePadding(BsNavStyle style) {
    final padding = style.linkPadding;
    final custom = padding != null && padding != BsNavStyle.defaultLinkPadding;
    final border =
        style.underlineBorderWidth ?? BsNavStyle.defaultUnderlineBorderWidth;
    return custom
        ? (padding as EdgeInsets) + EdgeInsets.only(bottom: border)
        : EdgeInsets.only(top: 8, bottom: 8 + border);
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final style = widget.style;
    final enabled = item.onTap != null && !item.disabled;
    final radius =
        item.rounded?.radius ??
        (widget.variant == BsNavVariant.pills
            ? style.pillsBorderRadius ?? BsNavStyle.defaultPillsBorderRadius
            : style.tabsBorderRadius ?? BsNavStyle.defaultTabsBorderRadius);
    final borderRadius = BorderRadius.circular(radius);

    Color? color;
    Color background = const Color(0x00000000);
    Border? border;
    FontWeight? fontWeight;

    final restColor = style.linkColor ?? BsNavStyle.defaultLinkColor;
    final hoverColor = style.linkHoverColor ?? restColor;
    final textColor = item.textColor?.of(context);

    if (item.disabled) {
      color = style.linkDisabledColor ?? BsNavStyle.defaultLinkDisabledColor;
    } else {
      switch (widget.variant) {
        case BsNavVariant.plain:
          color = textColor ?? (_hovered ? hoverColor : restColor);
        case BsNavVariant.tabs:
          final borderColor =
              style.tabsBorderColor ?? BsNavStyle.defaultTabsBorderColor;
          if (item.active) {
            color =
                style.tabsLinkActiveColor ??
                BsNavStyle.defaultTabsLinkActiveColor;
            background =
                style.tabsLinkActiveBackground ??
                BsNavStyle.defaultTabsLinkActiveBackground;
            // A uniform-color border, not a bottom edge matching
            // [background] to blend into the container's shared border
            // line below it — Border.paint refuses non-uniform side
            // colors together with a borderRadius.
            border = Border.all(
              color: style.tabsLinkActiveBorderColor ?? borderColor,
            );
          } else {
            color = _hovered ? hoverColor : restColor;
            if (_hovered) {
              border = Border.all(
                color:
                    style.tabsLinkHoverBorderColor ??
                    BsNavStyle.defaultTabsLinkHoverBorderColor,
              );
            }
          }
        case BsNavVariant.pills:
          if (item.active) {
            color =
                style.pillsLinkActiveColor ??
                BsNavStyle.defaultPillsLinkActiveColor;
            background =
                style.pillsLinkActiveBackground ??
                BsNavStyle.defaultPillsLinkActiveBackground;
          } else {
            color = textColor ?? (_hovered ? hoverColor : restColor);
          }
        case BsNavVariant.underline:
          final underlineWidth =
              style.underlineBorderWidth ??
              BsNavStyle.defaultUnderlineBorderWidth;
          if (item.active) {
            color =
                style.underlineLinkActiveColor ??
                BsNavStyle.defaultUnderlineLinkActiveColor;
            fontWeight = FontWeight.bold;
            border = Border(
              bottom: BorderSide(color: color, width: underlineWidth),
            );
          } else {
            color = textColor ?? (_hovered ? hoverColor : restColor);
            border = Border(
              bottom: BorderSide(
                color: _hovered ? hoverColor : const Color(0x00000000),
                width: underlineWidth,
              ),
            );
          }
      }
    }

    if (item.borderBottom) {
      border = Border(bottom: BorderSide(color: BsBorders.colorOf(context)));
    }

    Widget content(bool focused) => BsDecoratedBox(
      decoration: BoxDecoration(
        color: background,
        border: border,
        borderRadius:
            widget.variant == BsNavVariant.pills ||
                widget.variant == BsNavVariant.tabs
            ? borderRadius
            : null,
        boxShadow: [
          if (focused)
            BoxShadow(
              color:
                  style.linkFocusRingColor ??
                  BsNavStyle.defaultLinkFocusRingColor,
              spreadRadius:
                  style.linkFocusRingWidth ??
                  BsNavStyle.defaultLinkFocusRingWidth,
            ),
        ],
      ),
      child: Padding(
        padding: _padding(
          // `.nav-underline .nav-link { padding-right/left: 0; border-bottom:
          // .125rem solid transparent }`: the border adds to the link's height.
          widget.variant == BsNavVariant.underline
              ? _underlinePadding(style)
              // `.nav-tabs .nav-link { border: 1px solid transparent }`: always
              // there (the active tab only colors it), and part of its size.
              : widget.variant == BsNavVariant.tabs
              ? (style.linkPadding ?? BsNavStyle.defaultLinkPadding).add(
                  const EdgeInsets.all(1),
                )
              : style.linkPadding ?? BsNavStyle.defaultLinkPadding,
        ),
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
      child: BsFocusableBuilder(
        enabled: enabled,
        // `.nav-link:focus-visible`
        focusVisibleOnly: true,
        builder: (context, focused) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: enabled ? item.onTap : null,
          child: content(focused),
        ),
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

class _BsTabViewState extends State<BsTabView> with SingleTickerProviderStateMixin {
  BsTabController? _ownedController;
  late int _lastIndex;
  int? _pendingFrom;
  int? _pendingTo;

  /// The pane on screen. It trails the controller's index while the old pane
  /// fades out (`.tab-pane.fade`: the active pane loses `.show` and fades over
  /// `$transition-fade`; only when that ends is it replaced, and the new one
  /// then fades in — one after the other, never both at once).
  late int _displayed;

  /// The opacity of the pane on screen.
  late final AnimationController _fade = AnimationController(vsync: this, value: 1)
    ..addStatusListener(_handleFadeStatus);

  BsTabController get _controller =>
      widget.controller ?? (_ownedController ??= BsTabController(initialIndex: widget.activeIndex ?? 0));

  @override
  void initState() {
    super.initState();
    _lastIndex = _controller.index;
    _displayed = _lastIndex;
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

      final duration = BsTransitions.resolve(context, widget.duration ?? BsTransitions.fade);
      _fade.duration = duration;
      // Fade the pane on screen out (or, if it is the one wanted again, back in).
      if (_displayed == newIndex) {
        _fade.forward();
      } else {
        _fade.reverse();
      }
      // The old pane is gone once it has faded out, the new one shown once it
      // has faded in.
      Future.delayed(duration, () {
        if (!mounted) return;
        // Only fire if this is still the transition we scheduled it for —
        // a rapid second switch before this fires means this one never
        // actually completed, so reporting it would be stale.
        if (_pendingFrom != oldIndex || _pendingTo != newIndex) return;
        widget.onHidden?.call(oldIndex);
        Future.delayed(duration, () {
          if (!mounted || _pendingFrom != oldIndex || _pendingTo != newIndex) return;
          _pendingFrom = null;
          _pendingTo = null;
          widget.onShown?.call(newIndex);
        });
      });
    }
    setState(() {});
  }

  void _handleFadeStatus(AnimationStatus status) {
    // Faded out: put the wanted pane in its place and fade it in.
    if (status == AnimationStatus.dismissed && _displayed != _controller.index) {
      setState(() => _displayed = _controller.index);
      _fade.forward();
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);
    _ownedController?.dispose();
    _fade.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: KeyedSubtree(key: ValueKey(_displayed), child: widget.children[_displayed]),
    );
  }
}
