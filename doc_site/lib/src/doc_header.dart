import 'dart:math' as math;

import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'app_section.dart';
import 'bootstrap_icon.dart';
import 'example_theme_toggler.dart';

/// Bootstrap's own violet (`--bd-violet-bg`, the docs' `.btn-bd-primary`).
const _violet = Color(0xFF712CF9);

/// `rgba($white, .85)`: the navbar links' color.
const _linkColor = Color(0xD9FFFFFF);

/// The docs site's header height: `.bd-navbar`'s `.75rem` of padding around
/// its 40px row.
const docHeaderHeight = 64.0;

/// The docs site's top bar, `Navigation.astro` + `_navbar.scss`
/// (`.navbar.navbar-expand-lg.bd-navbar`): the logo, the Docs / Examples
/// links, a version dropdown and the theme switcher. (The original's Icons,
/// Blog, GitHub, X and Open Collective links and its search box have no
/// counterpart here.)
///
/// From `lg` up the links sit in the bar; below it they move into an
/// offcanvas opened from a "three dots" toggler, and the bar shows the docs
/// sidebar's own toggler, the logo centered, and that toggler.
class DocHeader extends StatelessWidget {
  const DocHeader({
    super.key,
    required this.section,
    required this.onSelectSection,
    required this.themeMode,
    required this.onThemeModeChanged,
    required this.onOpenSidebar,
  });

  final AppSection section;
  final ValueChanged<AppSection> onSelectSection;

  /// [BsApp.brightness] as set, where null is `auto` (follow the OS).
  final Brightness? themeMode;
  final ValueChanged<Brightness?> onThemeModeChanged;

  /// The docs sidebar's toggler (`#bdSidebar`'s offcanvas), shown below `lg`
  /// on the Docs tab.
  final VoidCallback onOpenSidebar;

  static const _version = 'v5.3';

  @override
  Widget build(BuildContext context) {
    final expanded =
        MediaQuery.sizeOf(context).width >= BsBreakpoint.lg.minWidth;
    // `.bd-navbar::after`: a gradient from the violet to 95% of it over the
    // page's own background.
    final bottom = Color.alphaBlend(
      _violet.withValues(alpha: .95),
      BsBody.backgroundOf(context),
    );
    return SizedBox(
      height: docHeaderHeight,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [_violet, bottom],
          ),
          // `box-shadow: 0 .5rem 1rem rgba($black, .15)`
          boxShadow: BsShadows.shadow,
        ),
        child: Stack(
          children: [
            // `inset 0 -1px 0 rgba($white, .15)`
            const Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              height: 1,
              child: ColoredBox(color: Color(0x26FFFFFF)),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                // `.container-xxl`: fluid until 1400, then 1320 wide.
                constraints: const BoxConstraints(maxWidth: 1320),
                child: Padding(
                  // `.bd-gutter`: `--bs-gutter-x: 3rem`
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  child: expanded
                      ? _expandedBar(context)
                      : _collapsedBar(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _expandedBar(BuildContext context) {
    return Row(
      children: [
        // `.navbar-brand.me-lg-2`
        const Padding(
          padding: EdgeInsetsDirectional.only(end: 8),
          child: _Brand(),
        ),
        _NavLink(
          expanded: true,
          active: section == AppSection.docs,
          onTap: () => onSelectSection(AppSection.docs),
          child: const Text('Docs'),
        ),
        _NavLink(
          expanded: true,
          active: section == AppSection.examples,
          onTap: () => onSelectSection(AppSection.examples),
          child: const Text('Examples'),
        ),
        const Spacer(),
        _VersionMenu(expanded: true, version: _version),
        const _Divider(),
        _ThemeMenu(
          expanded: true,
          mode: themeMode,
          onChanged: onThemeModeChanged,
        ),
      ],
    );
  }

  Widget _collapsedBar(BuildContext context) {
    return Row(
      children: [
        // `.bd-navbar-toggle` (or its `d-lg-none` stand-in): 4.25rem wide,
        // its button pulled `.5rem` out of the gutter.
        SizedBox(
          width: 68,
          child: section == AppSection.docs
              ? Transform.translate(
                  offset: const Offset(-8, 0),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: _Toggler(
                      key: const Key('doc-shell-hamburger'),
                      icon: BootstrapIconData.hamburger,
                      onTap: onOpenSidebar,
                    ),
                  ),
                )
              : null,
        ),
        const Spacer(),
        // `.navbar-brand.p-0.me-0`
        const _Brand(),
        const Spacer(),
        SizedBox(
          width: 68,
          child: Transform.translate(
            offset: const Offset(8, 0),
            child: Align(
              alignment: AlignmentDirectional.centerEnd,
              child: _Toggler(
                key: const Key('doc-shell-nav-toggler'),
                icon: BootstrapIconData.threeDots,
                onTap: () => _openMenu(context),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// The `#bdNavbar` offcanvas (`.offcanvas-lg.offcanvas-end`).
  void _openMenu(BuildContext context) {
    final width = math.min(400.0, MediaQuery.sizeOf(context).width);
    final style = BsOffcanvasStyle(
      background: _violet,
      color: BsColors.white,
      borderWidth: 0,
      // (a zero-width border still paints a hairline)
      borderColor: const Color(0x00000000),
      horizontalWidth: width,
      boxShadow: BsShadows.shadowLg,
    );
    // (The offcanvas outlives this build: it tracks the mode it changes itself.)
    var mode = themeMode;
    showBsOffcanvas<void>(
      context: context,
      placement: BsOffcanvasPlacement.end,
      style: style,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return BsOffcanvas(
            placement: BsOffcanvasPlacement.end,
            style: style,
            header: Padding(
              // `.offcanvas-header.px-4.pb-0`
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'opa_bootstrap_ui',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        height: 1.5,
                        color: BsColors.white,
                      ),
                    ),
                  ),
                  // `.btn-close.btn-close-white`, its `.5rem` of margin
                  // pulled out of the header's box.
                  SizedBox(
                    width: 24,
                    height: 30,
                    child: OverflowBox(
                      alignment: AlignmentDirectional.centerStart,
                      minWidth: 32,
                      maxWidth: 32,
                      minHeight: 32,
                      maxHeight: 32,
                      child: BsCloseButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: const BsCloseButtonStyle(
                          color: BsColors.white,
                          size: 16,
                          padding: EdgeInsets.all(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            body: Padding(
              // `.offcanvas-body.p-4.pt-0`
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _Rule(),
                    // `.navbar-nav.flex-row.flex-wrap`: `.col-6` links.
                    Row(
                      children: [
                        Expanded(
                          child: _NavLink(
                            expanded: false,
                            active: section == AppSection.docs,
                            onTap: () {
                              Navigator.of(context).pop();
                              onSelectSection(AppSection.docs);
                            },
                            child: const Text('Docs'),
                          ),
                        ),
                        Expanded(
                          child: _NavLink(
                            expanded: false,
                            active: section == AppSection.examples,
                            onTap: () {
                              Navigator.of(context).pop();
                              onSelectSection(AppSection.examples);
                            },
                            child: const Text('Examples'),
                          ),
                        ),
                      ],
                    ),
                    const _Rule(),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: _VersionMenu(expanded: false, version: _version),
                    ),
                    // `li.nav-item.py-2` holding an `hr.my-2`
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: _Rule(margin: 8),
                    ),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: _ThemeMenu(
                        expanded: false,
                        mode: mode,
                        onChanged: (value) {
                          mode = value;
                          onThemeModeChanged(value);
                          setState(() {});
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// `.navbar-brand`: the logo at Bootstrap's own 40x32 (`my-1`), tilting and
/// growing under the pointer.
class _Brand extends StatefulWidget {
  const _Brand();

  @override
  State<_Brand> createState() => _BrandState();
}

class _BrandState extends State<_Brand> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        // `transform: rotate(-5deg) scale(1.1)` over `.2s ease-in-out`
        child: AnimatedRotation(
          turns: _hovered ? -5 / 360 : 0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: AnimatedScale(
            scale: _hovered ? 1.1 : 1,
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            child: Image.asset(
              'assets/brand/logo.png',
              width: 40,
              height: 32,
              filterQuality: FilterQuality.high,
            ),
          ),
        ),
      ),
    );
  }
}

/// `.bd-navbar .navbar-toggler.p-2`: a 24px icon with no border.
class _Toggler extends StatefulWidget {
  const _Toggler({super.key, required this.icon, required this.onTap});

  final BootstrapIconData icon;
  final VoidCallback onTap;

  @override
  State<_Toggler> createState() => _TogglerState();
}

class _TogglerState extends State<_Toggler> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: BootstrapIcon(
            widget.icon,
            width: 24,
            height: 24,
            color: _hovered ? BsColors.white : _linkColor,
          ),
        ),
      ),
    );
  }
}

/// `.nav-link.py-2.px-0.px-lg-2`: `.5rem` of padding above and below, and
/// beside it only in the bar (the offcanvas has none).
class _NavLink extends StatefulWidget {
  const _NavLink({
    required this.expanded,
    required this.child,
    required this.onTap,
    this.active = false,
  });

  final bool expanded;
  final bool active;
  final Widget child;
  final VoidCallback onTap;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final bright = widget.active || _hovered;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: widget.expanded ? 8 : 0,
            vertical: 8,
          ),
          child: DefaultTextStyle.merge(
            style: TextStyle(
              color: bright ? BsColors.white : _linkColor,
              fontWeight: widget.active ? FontWeight.w600 : null,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

/// `.btn.btn-link.nav-link.dropdown-toggle`: a [_NavLink] for a dropdown's
/// toggle. [builder] gets the link color to draw its content (and caret) in.
class _NavToggle extends StatefulWidget {
  const _NavToggle({
    required this.expanded,
    required this.onTap,
    required this.builder,
    super.key,
  });

  final bool expanded;
  final VoidCallback onTap;
  final Widget Function(BuildContext context, Color color) builder;

  @override
  State<_NavToggle> createState() => _NavToggleState();
}

class _NavToggleState extends State<_NavToggle> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final color = _hovered ? BsColors.white : _linkColor;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: widget.expanded ? 8 : 0,
            vertical: 8,
          ),
          child: DefaultTextStyle.merge(
            style: TextStyle(color: color),
            child: widget.builder(context, color),
          ),
        ),
      ),
    );
  }
}

/// `.bd-navbar .dropdown-menu`.
final _menuStyle = BsDropdownStyle(
  minWidth: 128,
  padding: const EdgeInsets.all(4),
  fontSize: 14,
  borderRadius: 8,
  itemBorderRadius: 4,
  itemSpacing: 2,
  boxShadow: BsShadows.shadow,
  // `rgba(var(--bd-violet-rgb), .1)` and the violet itself
  linkHoverBackground: const Color(0x1A712CF9),
  linkActiveBackground: _violet,
);

/// The Versions dropdown (`Versions.astro`): just the current release.
class _VersionMenu extends StatelessWidget {
  const _VersionMenu({required this.expanded, required this.version});

  final bool expanded;
  final String version;

  @override
  Widget build(BuildContext context) {
    return BsDropdown(
      alignEnd: expanded,
      style: _menuStyle,
      items: [
        const BsDropdownHeader(child: Text('v5 releases')),
        BsDropdownItem(
          active: true,
          onTap: () {},
          child: const Row(
            children: [
              Expanded(
                child: Text(
                  'Latest (5.3.x)',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(width: 8),
              BootstrapIcon(BootstrapIconData.check2),
            ],
          ),
        ),
      ],
      toggleBuilder: (context, toggle, isOpen) => _NavToggle(
        expanded: expanded,
        onTap: toggle,
        builder: (context, color) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // `<span class="d-lg-none">Bootstrap</span>` then the version
            Text(expanded ? version : 'Bootstrap $version'),
            const SizedBox(width: BsDropdownCaret.marginStart),
            BsDropdownCaret(color: color),
          ],
        ),
      ),
    );
  }
}

/// The theme switcher (`ThemeToggler.astro`): the active mode's icon (and, in
/// the offcanvas, "Toggle theme") opening Light / Dark / Auto.
class _ThemeMenu extends StatelessWidget {
  const _ThemeMenu({
    required this.expanded,
    required this.mode,
    required this.onChanged,
  });

  final bool expanded;
  final Brightness? mode;
  final ValueChanged<Brightness?> onChanged;

  @override
  Widget build(BuildContext context) {
    final active = ExampleThemeToggler.modes.firstWhere((m) => m.$1 == mode).$3;
    return BsDropdown(
      alignEnd: expanded,
      style: _menuStyle,
      items: [
        for (final (value, label, icon) in ExampleThemeToggler.modes)
          BsDropdownItem(
            active: value == mode,
            onTap: () => onChanged(value),
            child: Row(
              children: [
                // `.bi.me-2.opacity-50`
                Opacity(opacity: 0.5, child: BootstrapIcon(icon)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: value == mode
                        ? const TextStyle(fontWeight: FontWeight.w600)
                        : null,
                  ),
                ),
                if (value == mode)
                  const BootstrapIcon(BootstrapIconData.check2),
              ],
            ),
          ),
      ],
      toggleBuilder: (context, toggle, isOpen) => _NavToggle(
        key: const Key('doc-shell-theme-menu'),
        expanded: expanded,
        onTap: toggle,
        builder: (context, color) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // `.bi.my-1`
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: BootstrapIcon(active, color: color),
            ),
            // `<span class="d-lg-none ms-2">Toggle theme</span>`
            if (!expanded) ...[
              const SizedBox(width: 8),
              const Text('Toggle theme'),
            ],
            const SizedBox(width: BsDropdownCaret.marginStart),
            BsDropdownCaret(color: color),
          ],
        ),
      ),
    );
  }
}

/// `.vr.mx-lg-2.h-100`: a 1px, 32px-tall rule at 25% of the navbar's white.
class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        width: 1,
        height: 32,
        child: ColoredBox(color: Color(0x40FFFFFF)),
      ),
    );
  }
}

/// `hr.text-white-50`: `.25` of `rgba($white, .5)`, between `1rem` margins.
class _Rule extends StatelessWidget {
  const _Rule({this.margin = 16});

  final double margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: margin),
      child: const SizedBox(
        height: 1,
        child: ColoredBox(color: Color(0x20FFFFFF)),
      ),
    );
  }
}
