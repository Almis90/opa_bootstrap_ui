import 'package:flutter/widgets.dart';

import 'bs_breakpoint.dart';
import 'bs_collapse.dart';
import 'bs_flex.dart';
import 'bs_offcanvas.dart';
import 'bs_focusable.dart';
import 'bs_spacing.dart';
import 'tokens/bs_focus_ring.dart';
import 'tokens/bs_navbar_style.dart';
import 'tokens/bs_transitions.dart';
import 'bs_decorated_box.dart';

/// Which color scheme a [BsNavbar] uses for its text: [light] for a light background, [dark]
/// for a dark one. The background itself is set separately via [BsNavbar.background].
enum BsNavbarColorScheme { light, dark }

/// A single link within a [BsNavbar].
class BsNavbarItem {
  const BsNavbarItem({
    required this.child,
    this.onTap,
    this.active = false,
    this.disabled = false,
    this.padded = true,
  });

  final Widget child;
  final VoidCallback? onTap;

  /// Highlights this item as the current page.
  final bool active;

  /// Whether the item adds the link's own padding around [child]. A [child] that is a whole
  /// item of its own (a dropdown anchoring its menu to the item's box) passes false and pads
  /// itself.
  final bool padded;

  /// Dims the item and ignores taps.
  final bool disabled;
}

/// A Bootstrap navbar: a header bar with a [brand], a row of [items], and optional
/// [trailing] widgets (for example a search box or button).
///
/// Below [expandBreakpoint], [items] and [trailing] drop into a [BsCollapse] toggled by a
/// hamburger button. Pass null to always collapse behind the toggler regardless of width.
class BsNavbar extends StatefulWidget {
  const BsNavbar({
    super.key,
    this.brand,
    this.onBrandTap,
    this.items = const [],
    this.trailing = const [],
    this.colorScheme = BsNavbarColorScheme.light,
    this.background,
    this.expandBreakpoint = BsBreakpoint.lg,
    this.centerItems = false,
    this.spreadItems = false,
    this.hideBrandWhenExpanded = false,
    this.endItems = false,
    this.offcanvasBuilder,
    this.onToggle,
    this.bareToggler = false,
    this.collapseBuilder,
    this.style,
    this.collapseController,
    this.onShow,
    this.onShown,
    this.onHide,
    this.onHidden,
  });

  /// Typically the site or app name, or its logo.
  final Widget? brand;

  /// Called when [brand] is tapped. Leave null for a non-interactive brand.
  final VoidCallback? onBrandTap;

  /// The navigation links.
  final List<BsNavbarItem> items;

  /// Extra content shown after [items] (e.g. a search form or button),
  /// always visible when expanded and stacked below the nav items when
  /// collapsed.
  final List<Widget> trailing;

  final BsNavbarColorScheme colorScheme;

  /// The bar's background. There is no default: null stays transparent.
  final Color? background;

  /// The viewport width at and above which [items] and [trailing] show inline instead of behind
  /// the toggler. Null means never expand.
  final BsBreakpoint? expandBreakpoint;

  /// When expanded, the [items] sit in the middle of the bar rather than after the brand.
  final bool centerItems;

  /// When expanded, the [items] spread across the whole bar.
  final bool spreadItems;

  /// `d-md-none` on the brand: it only shows while collapsed.
  final bool hideBrandWhenExpanded;

  /// When expanded, the [items] sit at the end of the bar, 16 logical pixels before the
  /// [trailing] widgets. For an offcanvas navbar.
  final bool endItems;

  /// For an offcanvas navbar: below [expandBreakpoint] the toggler opens what this builds,
  /// typically a [BsOffcanvas], given the rendered nav links, instead of revealing a
  /// [BsCollapse].
  final Widget Function(BuildContext context, List<Widget> links)?
  offcanvasBuilder;

  /// Called when the toggler is tapped, in place of opening the collapse or
  /// offcanvas: for a navbar whose menu is the caller's own (the page then
  /// shows it wherever it likes).
  final VoidCallback? onToggle;

  /// `navbar-toggler p-0 border-0`: just the hamburger icon, with no padding or
  /// border.
  final bool bareToggler;

  /// The whole content of the collapsible area, for navbars that lay it out in their own way
  /// (a three-column centered nav): replaces the default arrangement of [items] and [trailing].
  /// Told whether the navbar is expanded, and given the rendered nav links of [items] to place.
  final Widget Function(
    BuildContext context,
    bool expanded,
    List<Widget> links,
  )?
  collapseBuilder;

  /// Style overrides layered on top of [BsNavbarStyle.light]/[BsNavbarStyle.dark].
  final BsNavbarStyle? style;

  /// Drives the mobile menu's open/closed state below [expandBreakpoint] —
  /// the same [BsCollapseController] [BsCollapse] itself takes, since the
  /// mobile menu literally is a [BsCollapse] under the hood. Defaults to
  /// an internally-owned controller when null.
  final BsCollapseController? collapseController;

  /// Called as soon as the mobile menu is triggered to open, before it
  /// starts animating. Mirrors Bootstrap's `show.bs.collapse`.
  final VoidCallback? onShow;

  /// Called once the mobile menu has finished opening. Mirrors
  /// Bootstrap's `shown.bs.collapse`.
  final VoidCallback? onShown;

  /// Called as soon as the mobile menu is triggered to close, before it
  /// starts animating. Mirrors Bootstrap's `hide.bs.collapse`.
  final VoidCallback? onHide;

  /// Called once the mobile menu has finished closing. Mirrors
  /// Bootstrap's `hidden.bs.collapse`.
  final VoidCallback? onHidden;

  @override
  State<BsNavbar> createState() => _BsNavbarState();
}

class _BsNavbarState extends State<BsNavbar> {
  BsCollapseController? _ownedController;

  BsCollapseController get _controller =>
      widget.collapseController ??
      (_ownedController ??= BsCollapseController());

  @override
  void initState() {
    super.initState();
    _controller.addListener(_handleControllerChanged);
  }

  void _handleControllerChanged() => setState(() {});

  @override
  void dispose() {
    _controller.removeListener(_handleControllerChanged);
    _ownedController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = widget.colorScheme == BsNavbarColorScheme.dark
        ? BsNavbarStyle.dark
        : BsNavbarStyle.light;
    final style = baseStyle.merge(widget.style);

    return BsDecoratedBox(
      decoration: BoxDecoration(color: widget.background),
      child: Padding(
        padding: style.padding ?? BsNavbarStyle.defaultPadding,
        child: Builder(
          builder: (context) {
            // The breakpoint is the viewport's width, not the room the navbar happens to have.
            final expanded =
                widget.expandBreakpoint != null &&
                MediaQuery.sizeOf(context).width >=
                    widget.expandBreakpoint!.minWidth;

            final brand = widget.brand == null
                ? null
                : BsFlexItem(
                    flexShrink: false,
                    child: _BsNavbarBrand(
                      onTap: widget.onBrandTap,
                      style: style,
                      child: widget.brand!,
                    ),
                  );
            final rawLinks = [
              for (final item in widget.items)
                _BsNavbarLink(item: item, style: style, expanded: expanded),
            ];
            // (A link never gives up room: its words are its minimum width.)
            final links = [
              for (final link in rawLinks)
                BsFlexItem(flexShrink: false, child: link),
            ];
            final custom = widget.collapseBuilder?.call(
              context,
              expanded,
              links,
            );

            if (expanded) {
              return BsFlex(
                alignItems: BsAlign.center,
                children: [
                  if (!widget.hideBrandWhenExpanded) ?brand,
                  BsFlexItem(
                    flexGrow: true,
                    child:
                        custom ??
                        BsFlex(
                          alignItems: BsAlign.center,
                          justifyContent: widget.centerItems
                              ? BsJustify.center
                              : widget.spreadItems
                              ? BsJustify.between
                              : BsJustify.start,
                          children: [
                            if (widget.endItems)
                              const BsFlexItem(
                                ms: BsSpacing.auto,
                                child: SizedBox.shrink(),
                              ),
                            ...links,
                            if (widget.endItems && widget.trailing.isNotEmpty)
                              const SizedBox(width: 16), // pe-3
                            if (widget.trailing.isNotEmpty &&
                                !widget.centerItems &&
                                !widget.endItems)
                              const BsFlexItem(
                                ms: BsSpacing.auto,
                                child: SizedBox.shrink(),
                              ),
                            ...widget.trailing,
                          ],
                        ),
                  ),
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BsFlex(
                  // A toggler with no room left drops to the next line.
                  wrap: true,
                  alignItems: BsAlign.center,
                  justifyContent: BsJustify.between,
                  children: [
                    ?brand,
                    _BsNavbarToggler(
                      isOpen: _controller.isExpanded,
                      bare: widget.bareToggler,
                      onTap: widget.onToggle != null
                          ? widget.onToggle!
                          : widget.offcanvasBuilder == null
                          ? _controller.toggle
                          : () => showBsOffcanvas<void>(
                              context: context,
                              placement: BsOffcanvasPlacement.end,
                              builder: (context) =>
                                  widget.offcanvasBuilder!(context, rawLinks),
                            ),
                      style: style,
                    ),
                  ],
                ),
                if (widget.offcanvasBuilder == null && widget.onToggle == null)
                  BsCollapse(
                    controller: _controller,
                    onShow: widget.onShow,
                    onShown: widget.onShown,
                    onHide: widget.onHide,
                    onHidden: widget.onHidden,
                    child:
                        custom ??
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            // The nav's own bottom margin.
                            ...rawLinks,
                            ...widget.trailing,
                          ],
                        ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _BsNavbarBrand extends StatefulWidget {
  const _BsNavbarBrand({
    required this.child,
    required this.onTap,
    required this.style,
  });

  final Widget child;
  final VoidCallback? onTap;
  final BsNavbarStyle style;

  @override
  State<_BsNavbarBrand> createState() => _BsNavbarBrandState();
}

class _BsNavbarBrandState extends State<_BsNavbarBrand> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final style = widget.style;
    final enabled = widget.onTap != null;
    final color = _hovered && enabled
        ? style.brandHoverColor ?? BsNavbarStyle.lightActiveColor
        : style.brandColor ?? BsNavbarStyle.lightActiveColor;

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : MouseCursor.defer,
      onEnter: enabled ? (_) => setState(() => _hovered = true) : null,
      onExit: enabled ? (_) => setState(() => _hovered = false) : null,
      child: GestureDetector(
        onTap: widget.onTap,
        child: Padding(
          // EdgeInsetsDirectional so the field named "...MarginEnd" is
          // actually applied to the logical end side, not always physical
          // right — Padding.padding is EdgeInsetsGeometry, so this
          // resolves against the ambient Directionality automatically.
          padding: EdgeInsetsDirectional.only(
            top: 5, // `.navbar-brand`: padding-block .3125rem
            bottom: 5,
            end: style.brandMarginEnd ?? BsNavbarStyle.defaultBrandMarginEnd,
          ),
          child: DefaultTextStyle.merge(
            style: TextStyle(
              color: color,
              fontSize:
                  style.brandFontSize ?? BsNavbarStyle.defaultBrandFontSize,
            ),
            // The brand never wraps.
            softWrap: false,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class _BsNavbarLink extends StatefulWidget {
  const _BsNavbarLink({
    required this.item,
    required this.style,
    required this.expanded,
  });

  final BsNavbarItem item;
  final BsNavbarStyle style;

  /// Expanded, a link is padded by 8 logical pixels on each side; collapsed, by none.
  final bool expanded;

  @override
  State<_BsNavbarLink> createState() => _BsNavbarLinkState();
}

class _BsNavbarLinkState extends State<_BsNavbarLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final style = widget.style;
    final enabled = item.onTap != null && !item.disabled;

    final Color color;
    if (item.disabled) {
      color = style.disabledColor ?? BsNavbarStyle.lightDisabledColor;
    } else if (item.active) {
      color = style.activeColor ?? BsNavbarStyle.lightActiveColor;
    } else if (_hovered && enabled) {
      color = style.hoverColor ?? BsNavbarStyle.lightHoverColor;
    } else {
      color = style.color ?? BsNavbarStyle.lightColor;
    }

    return MouseRegion(
      cursor: enabled ? SystemMouseCursors.click : SystemMouseCursors.basic,
      onEnter: enabled ? (_) => setState(() => _hovered = true) : null,
      onExit: enabled ? (_) => setState(() => _hovered = false) : null,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: enabled ? item.onTap : null,
        child: Padding(
          padding: item.padded
              ? EdgeInsets.symmetric(
                  horizontal: widget.expanded
                      ? (style.navLinkPaddingX ??
                            BsNavbarStyle.defaultNavLinkPaddingX)
                      : 0,
                  vertical: 8,
                )
              : EdgeInsets.zero,
          child: DefaultTextStyle.merge(
            style: TextStyle(color: color),
            child: item.child,
          ),
        ),
      ),
    );
  }
}

class _BsNavbarToggler extends StatefulWidget {
  const _BsNavbarToggler({
    required this.isOpen,
    required this.onTap,
    required this.style,
    this.bare = false,
  });

  final bool bare;

  final bool isOpen;
  final VoidCallback onTap;
  final BsNavbarStyle style;

  @override
  State<_BsNavbarToggler> createState() => _BsNavbarTogglerState();
}

class _BsNavbarTogglerState extends State<_BsNavbarToggler> {
  @override
  Widget build(BuildContext context) {
    final style = widget.style;
    final iconColor = style.iconColor ?? BsNavbarStyle.lightIconColor;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: BsFocusableBuilder(
        builder: (context, focused) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          child: BsAnimatedContainer(
            duration: BsTransitions.resolve(
              context,
              style.togglerTransitionDuration ??
                  BsNavbarStyle.defaultTogglerTransitionDuration,
            ),
            decoration: BoxDecoration(
              border: widget.bare
                  ? null
                  : Border.all(
                      color:
                          style.togglerBorderColor ??
                          BsNavbarStyle.lightTogglerBorderColor,
                    ),
              borderRadius: BorderRadius.circular(
                style.togglerBorderRadius ??
                    BsNavbarStyle.defaultTogglerBorderRadius,
              ),
              boxShadow: [
                if (focused)
                  BoxShadow(
                    color: style.togglerFocusRingColor ?? BsFocusRing.color(),
                    spreadRadius:
                        style.togglerFocusRingWidth ??
                        BsNavbarStyle.defaultTogglerFocusRingWidth,
                  ),
              ],
            ),
            child: Padding(
              padding: widget.bare
                  ? EdgeInsets.zero
                  : (style.togglerPadding ??
                        BsNavbarStyle.defaultTogglerPadding),
              child: CustomPaint(
                // The icon is 1.5 times the font size, square.
                size: Size.square(
                  1.5 *
                      (style.togglerFontSize ??
                          BsNavbarStyle.defaultTogglerFontSize),
                ),
                painter: _BsNavbarTogglerIconPainter(iconColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _BsNavbarTogglerIconPainter extends CustomPainter {
  _BsNavbarTogglerIconPainter(this.color);

  final Color color;

  /// The icon's own SVG: `M4 7h22M4 15h22M4 23h22` in a 30-unit viewBox,
  /// stroked 2 units wide with round caps.
  @override
  void paint(Canvas canvas, Size size) {
    final unit = size.width / 30;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2 * unit
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    for (final y in [7.0, 15.0, 23.0]) {
      canvas.drawLine(
        Offset(4 * unit, y * unit),
        Offset(26 * unit, y * unit),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BsNavbarTogglerIconPainter oldDelegate) =>
      oldDelegate.color != color;
}
