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
  /// Plain links, with no active-state styling of their own.
  plain,

  /// Bordered, with the active item raised like a folder tab.
  tabs,

  /// The active item gets a filled pill background.
  pills,

  /// The active (and hovered) item gets a colored bottom border instead of a background.
  underline,
}

/// A single link within a [BsNav].
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

  /// Dims the item and ignores taps.
  final bool disabled;

  /// The link's color in place of the nav's, unchanged under the pointer. An [active] item keeps
  /// its own.
  final BsTextColor? textColor;

  /// Vertical padding in place of the link's default.
  final BsSpacing? py;

  /// A corner radius in place of the variant's.
  final BsRounded? rounded;

  /// A 1px bottom border (inside the item's box, below its padding), in the border color.
  final bool borderBottom;
}

/// A Bootstrap nav: a row (or, per [vertical], column) of [BsNavItem]s, styled per [variant].
///
/// Items change their active and hover states immediately, as in [BsListGroup] and
/// [BsButtonGroup]; there is no sliding indicator.
///
/// Pair with [BsTabView] to switch content when [BsNavItem.onTap] changes which item is active.
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

  /// Stacks items top to bottom instead of side by side.
  final bool vertical;

  /// Stretches every item to equal width (only meaningful when not [vertical]).
  final bool fill;

  /// Keeps all the links of a horizontal nav on one line, however narrow its space, instead of
  /// wrapping onto more, as in a scrolling nav.
  final bool nowrap;

  /// Where each line of a horizontal nav sits when it has more room than its links need, and how
  /// each wrapped line is placed. Needs a bounded width to have any effect: give the nav a
  /// full-width parent.
  final BsResponsive<BsJustify>? justifyContent;

  /// Style overrides layered on top of [BsNavStyle.defaults].
  final BsNavStyle? style;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const SizedBox.shrink();

    final isDark = BsTheme.of(context) == Brightness.dark;
    final style = (isDark ? BsNavStyle.darkDefaults : BsNavStyle.defaults)
        .merge(this.style);
    final links = _buildLinks(context, style);

    if (variant != BsNavVariant.tabs) return links;

    // The line the active tab opens onto.
    return BsDecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: style.tabsBorderColor ?? BsNavStyle.defaultTabsBorderColor,
            width: style.tabsBorderWidth ?? BsNavStyle.defaultTabsBorderWidth,
          ),
        ),
      ),
      child: links,
    );
  }

  Widget _buildLinks(BuildContext context, BsNavStyle style) {
    final isUnderline = variant == BsNavVariant.underline;

    // The underline variant puts a gap between its items, on top of the links' own padding;
    // the other variants rely on padding alone.
    final gap = isUnderline
        ? style.underlineGap ?? BsNavStyle.defaultUnderlineGap
        : 0.0;

    Widget link(BsNavItem item, {bool expand = false}) => _BsNavLinkWidget(
      item: item,
      variant: variant,
      style: style,
      expand: expand,
    );

    BsJustify? justify() => justifyContent?.resolve(
      BsBreakpoint.forWidth(MediaQuery.sizeOf(context).width),
    );

    if (vertical) {
      // IntrinsicWidth bounds the column to its widest item so that
      // `stretch` can widen every item to match; a bare Column would take the
      // unbounded width of an enclosing Row.
      return IntrinsicWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < items.length; i++) ...[
              if (i > 0 && gap > 0) SizedBox(height: gap),
              link(items[i]),
            ],
          ],
        ),
      );
    }

    // Fill: the items share out all the space, so the row takes it all.
    if (fill) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0 && gap > 0) SizedBox(width: gap),
            link(items[i], expand: true),
          ],
        ],
      );
    }

    // No wrap: a single line, as wide as its links unless a justification gives it the room to
    // place them in.
    if (nowrap) {
      return Row(
        mainAxisSize: justifyContent == null
            ? MainAxisSize.min
            : MainAxisSize.max,
        mainAxisAlignment: _mainAxisAlignment(justify()),
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < items.length; i++)
            Padding(
              padding: EdgeInsetsDirectional.only(
                end: i < items.length - 1 ? gap : 0,
              ),
              child: link(items[i]),
            ),
        ],
      );
    }

    // Links that do not fit on a line continue on the next, and the nav is only as wide as its
    // links, so that a sibling in a shared row keeps its own space.
    return Wrap(
      alignment: _wrapAlignment(justify()),
      crossAxisAlignment: WrapCrossAlignment.end,
      spacing: gap,
      children: [for (final item in items) link(item)],
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

/// The color, background, border and weight of a nav link in its current
/// state.
class _LinkLook {
  const _LinkLook({
    required this.color,
    this.background = const Color(0x00000000),
    this.border,
    this.fontWeight,
    this.tabBottomRule,
  });

  final Color color;
  final Color background;
  final Border? border;
  final FontWeight? fontWeight;

  /// A tab's bottom border sits over the nav's own line. It takes the active tab's background,
  /// so the line is open beneath the tab, or, when hovered, the line's own color.
  final Color? tabBottomRule;
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

  _LinkLook _look(BuildContext context) {
    final item = widget.item;
    final style = widget.style;
    if (item.disabled) {
      return _LinkLook(
        color: style.linkDisabledColor ?? BsNavStyle.defaultLinkDisabledColor,
      );
    }

    final restColor = style.linkColor ?? BsNavStyle.defaultLinkColor;
    final hoverColor = style.linkHoverColor ?? restColor;
    final stateColor = _hovered ? hoverColor : restColor;
    final linkColor = item.textColor?.of(context) ?? stateColor;

    switch (widget.variant) {
      case BsNavVariant.plain:
        return _LinkLook(color: linkColor);

      case BsNavVariant.tabs:
        final lineColor =
            style.tabsBorderColor ?? BsNavStyle.defaultTabsBorderColor;
        if (item.active) {
          final background =
              style.tabsLinkActiveBackground ??
              BsNavStyle.defaultTabsLinkActiveBackground;
          return _LinkLook(
            color:
                style.tabsLinkActiveColor ??
                BsNavStyle.defaultTabsLinkActiveColor,
            background: background,
            // A border of one color on all sides: [Border] cannot paint sides
            // of different colors together with a border radius.
            border: Border.all(
              color: style.tabsLinkActiveBorderColor ?? lineColor,
            ),
            tabBottomRule: background,
          );
        }
        if (!_hovered) return _LinkLook(color: stateColor);
        return _LinkLook(
          color: stateColor,
          border: Border.all(
            color:
                style.tabsLinkHoverBorderColor ??
                BsNavStyle.defaultTabsLinkHoverBorderColor,
          ),
          tabBottomRule: lineColor,
        );

      case BsNavVariant.pills:
        if (!item.active) return _LinkLook(color: linkColor);
        return _LinkLook(
          color:
              style.pillsLinkActiveColor ??
              BsNavStyle.defaultPillsLinkActiveColor,
          background:
              style.pillsLinkActiveBackground ??
              BsNavStyle.defaultPillsLinkActiveBackground,
        );

      case BsNavVariant.underline:
        final width =
            style.underlineBorderWidth ??
            BsNavStyle.defaultUnderlineBorderWidth;
        if (item.active) {
          final color =
              style.underlineLinkActiveColor ??
              BsNavStyle.defaultUnderlineLinkActiveColor;
          return _LinkLook(
            color: color,
            fontWeight: FontWeight.bold,
            border: Border(
              bottom: BorderSide(color: color, width: width),
            ),
          );
        }
        return _LinkLook(
          color: linkColor,
          border: Border(
            bottom: BorderSide(
              color: _hovered ? hoverColor : const Color(0x00000000),
              width: width,
            ),
          ),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final style = widget.style;
    final variant = widget.variant;
    final enabled = item.onTap != null && !item.disabled;
    final look = _look(context);
    final border = item.borderBottom
        ? Border(bottom: BorderSide(color: BsBorders.colorOf(context)))
        : look.border;

    final radius =
        item.rounded?.radius ??
        (variant == BsNavVariant.pills
            ? style.pillsBorderRadius ?? BsNavStyle.defaultPillsBorderRadius
            : style.tabsBorderRadius ?? BsNavStyle.defaultTabsBorderRadius);

    Widget content(bool focused) => BsDecoratedBox(
      decoration: BoxDecoration(
        color: look.background,
        border: border,
        borderRadius: switch (variant) {
          BsNavVariant.pills => BorderRadius.circular(radius),
          BsNavVariant.tabs => BorderRadius.vertical(
            top: Radius.circular(radius),
          ),
          _ => null,
        },
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
        padding: _padding(switch (variant) {
          // Underline: no horizontal padding, and a transparent bottom border that adds to the
          // link's height.
          BsNavVariant.underline => _underlinePadding(style),
          // Tabs: a transparent border that is always present (the active tab only colors it) and
          // part of the size.
          BsNavVariant.tabs =>
            (style.linkPadding ?? BsNavStyle.defaultLinkPadding).add(
              const EdgeInsets.all(1),
            ),
          _ => style.linkPadding ?? BsNavStyle.defaultLinkPadding,
        }),
        child: DefaultTextStyle.merge(
          style: TextStyle(color: look.color, fontWeight: look.fontWeight),
          textAlign: widget.expand ? TextAlign.center : null,
          child: item.child,
        ),
      ),
    );

    final tabBottomRule = look.tabBottomRule;
    final link = MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: enabled ? (_) => setState(() => _hovered = true) : null,
      onExit: enabled ? (_) => setState(() => _hovered = false) : null,
      child: BsFocusableBuilder(
        enabled: enabled,
        focusVisibleOnly: true,
        builder: (context, focused) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: enabled ? item.onTap : null,
          child: tabBottomRule == null
              ? content(focused)
              : Stack(
                  children: [
                    content(focused),
                    // Between the side borders, which run on down to the line.
                    Positioned(
                      left: 1,
                      right: 1,
                      bottom: 0,
                      height: 1,
                      child: ColoredBox(color: tabBottomRule),
                    ),
                  ],
                ),
        ),
      ),
    );

    return widget.expand ? Expanded(child: link) : link;
  }
}

/// Programmatic control of a [BsTabView]. Pair it with a [BsNav] by driving each
/// [BsNavItem.active] and [BsNavItem.onTap] from [index] and [show] yourself: [BsNav] and
/// [BsTabView] stay decoupled, so a controller only wires into whichever pane view you use.
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

/// A crossfading content swapper, typically paired with a [BsNav] whose active item picks
/// [activeIndex].
///
/// Pass [activeIndex] and flip it from the parent (for example from a [BsNavItem]'s `onTap`
/// calling `setState`), or pass a [controller] and call [BsTabController.show] from anywhere
/// with access to it. [activeIndex] is ignored when [controller] is given; omit it and set
/// [activeIndex] on the internally-owned controller instead.
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

  /// Duration of each fade.
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

class _BsTabViewState extends State<BsTabView>
    with SingleTickerProviderStateMixin {
  BsTabController? _ownedController;
  late int _lastIndex;
  int? _pendingFrom;
  int? _pendingTo;

  /// The pane on screen. It trails the controller's index while the old pane fades out; only
  /// when that ends is it replaced and the new one faded in, one after the other, never both at
  /// once.
  late int _displayed;

  /// The opacity of the pane on screen.
  late final AnimationController _fade = AnimationController(
    vsync: this,
    value: 1,
  )..addStatusListener(_handleFadeStatus);

  BsTabController get _controller =>
      widget.controller ??
      (_ownedController ??= BsTabController(
        initialIndex: widget.activeIndex ?? 0,
      ));

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
    if (widget.controller == null &&
        widget.activeIndex != null &&
        widget.activeIndex != _controller.index) {
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

      final duration = BsTransitions.resolve(
        context,
        widget.duration ?? BsTransitions.fade,
      );
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
          if (!mounted || _pendingFrom != oldIndex || _pendingTo != newIndex) {
            return;
          }
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
    if (status == AnimationStatus.dismissed &&
        _displayed != _controller.index) {
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
      child: KeyedSubtree(
        key: ValueKey(_displayed),
        child: widget.children[_displayed],
      ),
    );
  }
}
