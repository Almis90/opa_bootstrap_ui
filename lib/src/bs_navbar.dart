import 'package:flutter/widgets.dart';

import 'bs_breakpoint.dart';
import 'bs_collapse.dart';
import 'tokens/bs_navbar_style.dart';

/// `.navbar-light`/`.navbar-dark`: which color scheme a [BsNavbar] uses for
/// its text (its background is set separately via [BsNavbar.background],
/// the same way Bootstrap pairs `.navbar-light`/`.navbar-dark` with a
/// separate `.bg-*` utility class).
enum BsNavbarColorScheme { light, dark }

/// A single `.nav-link` within a [BsNavbar].
class BsNavbarItem {
  const BsNavbarItem({required this.child, this.onTap, this.active = false, this.disabled = false});

  final Widget child;
  final VoidCallback? onTap;

  /// `.active`: highlights this item as the current page.
  final bool active;

  /// `.disabled`: dims the item and ignores taps.
  final bool disabled;
}

/// A Bootstrap navbar (`.navbar`): a header bar with a [brand], a row of
/// [items], and optional [trailing] widgets (e.g. a search box or button).
///
/// Below [expandBreakpoint], [items]/[trailing] drop into a
/// [BsCollapse] toggled by a hamburger button — the same `.navbar-toggler`
/// + `.navbar-collapse` behavior Bootstrap's JS drives, reusing the
/// [BsCollapse] this package already built rather than reaching for
/// Material's `Drawer`/`NavigationRail` responsive pattern, which solves a
/// similar problem a different way (a side panel, not an inline reveal).
/// Pass null (Bootstrap's bare `.navbar`, with no `.navbar-expand-*` class)
/// to always collapse behind the toggler regardless of width.
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
    this.style,
  });

  /// `.navbar-brand`: typically the site/app name or logo.
  final Widget? brand;

  /// Called when [brand] is tapped. Leave null for a non-interactive brand.
  final VoidCallback? onBrandTap;

  /// `.navbar-nav`'s `.nav-item`s.
  final List<BsNavbarItem> items;

  /// Extra content shown after [items] (e.g. a search form or button),
  /// always visible when expanded and stacked below the nav items when
  /// collapsed.
  final List<Widget> trailing;

  final BsNavbarColorScheme colorScheme;

  /// The bar's background. Bootstrap leaves this to a separate `.bg-*`
  /// utility, so there's no default here either — null stays transparent.
  final Color? background;

  /// `.navbar-expand-{breakpoint}`: the viewport width at and above which
  /// [items]/[trailing] show inline instead of behind the toggler. Null
  /// means "never expand".
  final BsBreakpoint? expandBreakpoint;

  /// Style overrides layered on top of [BsNavbarStyle.light]/[BsNavbarStyle.dark].
  final BsNavbarStyle? style;

  @override
  State<BsNavbar> createState() => _BsNavbarState();
}

class _BsNavbarState extends State<BsNavbar> {
  bool _open = false;

  void _toggle() => setState(() => _open = !_open);

  @override
  Widget build(BuildContext context) {
    final baseStyle = widget.colorScheme == BsNavbarColorScheme.dark ? BsNavbarStyle.dark : BsNavbarStyle.light;
    final style = baseStyle.merge(widget.style);

    return DecoratedBox(
      decoration: BoxDecoration(color: widget.background),
      child: Padding(
        padding: style.padding ?? BsNavbarStyle.defaultPadding,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final expanded =
                widget.expandBreakpoint != null && constraints.maxWidth >= widget.expandBreakpoint!.minWidth;

            final brandAndToggler = Row(
              children: [
                if (widget.brand != null) _BsNavbarBrand(onTap: widget.onBrandTap, style: style, child: widget.brand!),
                const Spacer(),
                if (!expanded) _BsNavbarToggler(isOpen: _open, onTap: _toggle, style: style),
              ],
            );

            if (expanded) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.brand != null)
                    _BsNavbarBrand(onTap: widget.onBrandTap, style: style, child: widget.brand!),
                  for (final item in widget.items) _BsNavbarLink(item: item, style: style),
                  const Spacer(),
                  ...widget.trailing,
                ],
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                brandAndToggler,
                BsCollapse(
                  isExpanded: _open,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final item in widget.items) _BsNavbarLink(item: item, style: style),
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
  const _BsNavbarBrand({required this.child, required this.onTap, required this.style});

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
          padding: EdgeInsets.only(right: style.brandMarginEnd ?? BsNavbarStyle.defaultBrandMarginEnd),
          child: DefaultTextStyle.merge(
            style: TextStyle(
              color: color,
              fontSize: style.brandFontSize ?? BsNavbarStyle.defaultBrandFontSize,
              fontWeight: FontWeight.bold,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class _BsNavbarLink extends StatefulWidget {
  const _BsNavbarLink({required this.item, required this.style});

  final BsNavbarItem item;
  final BsNavbarStyle style;

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
          padding: EdgeInsets.symmetric(horizontal: style.navLinkPaddingX ?? BsNavbarStyle.defaultNavLinkPaddingX, vertical: 8),
          child: DefaultTextStyle.merge(style: TextStyle(color: color), child: item.child),
        ),
      ),
    );
  }
}

class _BsNavbarToggler extends StatefulWidget {
  const _BsNavbarToggler({required this.isOpen, required this.onTap, required this.style});

  final bool isOpen;
  final VoidCallback onTap;
  final BsNavbarStyle style;

  @override
  State<_BsNavbarToggler> createState() => _BsNavbarTogglerState();
}

class _BsNavbarTogglerState extends State<_BsNavbarToggler> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final style = widget.style;
    final color = style.color ?? BsNavbarStyle.lightColor;

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: (style.togglerBorderColor ?? BsNavbarStyle.lightTogglerBorderColor).withValues(
                alpha: _hovered ? 1 : 0.6,
              ),
            ),
            borderRadius: BorderRadius.circular(style.togglerBorderRadius ?? BsNavbarStyle.defaultTogglerBorderRadius),
          ),
          child: Padding(
            padding: style.togglerPadding ?? BsNavbarStyle.defaultTogglerPadding,
            child: CustomPaint(
              size: Size.square(style.togglerFontSize ?? BsNavbarStyle.defaultTogglerFontSize),
              painter: _BsNavbarTogglerIconPainter(color),
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

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.height * 0.1
      ..strokeCap = StrokeCap.round;
    for (final fraction in [0.2, 0.5, 0.8]) {
      final y = size.height * fraction;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _BsNavbarTogglerIconPainter oldDelegate) => oldDelegate.color != color;
}
