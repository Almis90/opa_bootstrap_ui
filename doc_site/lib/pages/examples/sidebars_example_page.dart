import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/bootstrap_icon.dart';
import '../../src/example_divider.dart';
import '../../src/github_avatar.dart';
import '../../src/inline_line.dart';

/// The "Sidebars" example: a port of Bootstrap's own `examples/sidebars` page —
/// five sidebars side by side in a `100vh`-tall, horizontally scrolling
/// `main.d-flex.flex-nowrap`: a dark and a light nav-pills sidebar with a user
/// dropdown, an icon-only one, a collapsible one and a list group.
class SidebarsExamplePage extends StatelessWidget {
  const SidebarsExamplePage({super.key});

  static const _links = [
    (BootstrapIconData.home, 'Home'),
    (BootstrapIconData.speedometer2, 'Dashboard'),
    (BootstrapIconData.table, 'Orders'),
    (BootstrapIconData.grid, 'Products'),
    (BootstrapIconData.peopleCircle, 'Customers'),
  ];

  @override
  Widget build(BuildContext context) {
    // main { height: 100vh; overflow-x: auto; overflow-y: hidden }
    return SizedBox(
      height: MediaQuery.sizeOf(context).height,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: const [
            _NavPillsSidebar(dark: true),
            ExampleDivider.vertical(),
            _NavPillsSidebar(dark: false),
            ExampleDivider.vertical(),
            _IconSidebar(),
            ExampleDivider.vertical(),
            _CollapsibleSidebar(),
            ExampleDivider.vertical(),
            _ListGroupSidebar(),
            ExampleDivider.vertical(),
          ],
        ),
      ),
    );
  }
}

/// The user `.dropdown`'s menu: New project…, Settings, Profile, Sign out.
List<BsDropdownEntry> _userMenu() => [
  BsDropdownItem(onTap: () {}, child: const Text('New project...')),
  BsDropdownItem(onTap: () {}, child: const Text('Settings')),
  BsDropdownItem(onTap: () {}, child: const Text('Profile')),
  const BsDropdownDivider(),
  BsDropdownItem(onTap: () {}, child: const Text('Sign out')),
];

/// `<a class="dropdown-toggle">`: [content] then the `::after` caret (a flex
/// item, so centred on the row).
Widget _toggleLink(
  VoidCallback toggle, {
  required List<Widget> content,
  MainAxisAlignment alignment = MainAxisAlignment.start,
}) {
  return MouseRegion(
    cursor: SystemMouseCursors.click,
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: toggle,
      child: Row(
        mainAxisAlignment: alignment,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ...content,
          const SizedBox(width: BsDropdownCaret.marginStart),
          const BsDropdownCaret(),
        ],
      ),
    ),
  );
}

/// `d-flex align-items-center … <svg class="bi me-2"> <span>`: a sidebar's
/// brand link.
Widget _brand(
  BuildContext context, {
  required double iconWidth,
  required double iconHeight,
  required Widget label,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      BootstrapIcon(
        BootstrapIconData.bootstrap,
        width: iconWidth,
        height: iconHeight,
      ),
      const SizedBox(width: 8),
      label,
    ],
  );
}

/// The first two sidebars: `d-flex flex-column flex-shrink-0 p-3` (`text-bg-dark`
/// or `bg-body-tertiary`), 280px wide: brand, `<hr>`, nav pills, `<hr>` and a
/// user dropdown.
class _NavPillsSidebar extends StatelessWidget {
  const _NavPillsSidebar({required this.dark});

  final bool dark;

  @override
  Widget build(BuildContext context) {
    final color = dark ? BsTextColor.white : BsTextColor.bodyEmphasis;
    final nav = BsNav(
      variant: BsNavVariant.pills,
      vertical: true,
      items: [
        for (final (i, (icon, label)) in SidebarsExamplePage._links.indexed)
          BsNavItem(
            onTap: () {},
            active: i == 0,
            textColor: i == 0 ? null : color,
            child: InlineIconLabel(icon: icon, label: Text(label)),
          ),
      ],
    );
    final column = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        BsBox(
          // mb-3 mb-md-0
          mb: const BsResponsiveValue(xs: BsSpacing.s3, md: BsSpacing.s0),
          textColor: color,
          child: _brand(
            context,
            iconWidth: 40,
            iconHeight: 32,
            label: BsBox(fs: BsFs.fs4, child: const Text('Sidebar')),
          ),
        ),
        const BsHr(),
        Expanded(
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(width: double.infinity, child: nav),
          ),
        ),
        const BsHr(),
        _UserDropdown(color: color, dark: dark),
      ],
    );
    return SizedBox(
      width: 280,
      child: BsBox(
        p: BsSpacing.s3,
        textBg: dark ? BsVariant.dark : null,
        bg: dark ? null : BsBg.bodyTertiary,
        child: column,
      ),
    );
  }
}

/// `<div class="dropdown">`: avatar, name and caret over a `shadow` menu.
class _UserDropdown extends StatelessWidget {
  const _UserDropdown({required this.color, required this.dark});

  final BsTextColor color;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    Widget dropdown = BsDropdown(
      toggleBuilder: (context, toggle, isOpen) => BsBox(
        textColor: color,
        child: _toggleLink(
          toggle,
          content: const [
            GithubAvatar(),
            SizedBox(width: 8),
            Text('mdo', style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
      ),
      items: _userMenu(),
    );
    if (dark) {
      // <ul class="dropdown-menu shadow" data-bs-theme="dark">
      dropdown = BsTheme(brightness: Brightness.dark, child: dropdown);
    }
    return dropdown;
  }
}

/// `d-flex flex-column flex-shrink-0 bg-body-tertiary` at `4.5rem`: the
/// brand, icon-only nav pills (each `py-3 border-bottom rounded-0`, with a
/// tooltip) and an avatar dropdown above a top border.
class _IconSidebar extends StatelessWidget {
  const _IconSidebar();

  @override
  Widget build(BuildContext context) {
    final nav = BsNav(
      variant: BsNavVariant.pills,
      vertical: true,
      items: [
        for (final (i, (icon, label)) in SidebarsExamplePage._links.indexed)
          BsNavItem(
            onTap: () {},
            active: i == 0,
            py: BsSpacing.s3,
            rounded: BsRounded.r0,
            borderBottom: true,
            // (`text-center`) <svg class="bi" width="24" height="24">
            child: Center(
              child: BsTooltip(
                message: Text(label),
                placement: BsTooltipPlacement.end,
                child: InlineLine(
                  lowered: 2,
                  child: BootstrapIcon(icon, width: 24, height: 24),
                ),
              ),
            ),
          ),
      ],
    );
    return SizedBox(
      width: 72,
      child: BsBox(
        bg: BsBg.bodyTertiary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // <a class="d-block p-3 link-body-emphasis">
            BsBox(
              p: BsSpacing.s3,
              textColor: BsTextColor.bodyEmphasis,
              child: BsTooltip(
                message: const Text('Icon-only'),
                placement: BsTooltipPlacement.end,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: InlineLine(
                    lowered: 2,
                    child: BootstrapIcon(
                      BootstrapIconData.bootstrap,
                      width: 40,
                      height: 32,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.topLeft,
                child: SizedBox(width: double.infinity, child: nav),
              ),
            ),
            // <div class="dropdown border-top">
            BsBox(
              borderTop: true,
              child: BsDropdown(
                toggleBuilder: (context, toggle, isOpen) => BsBox(
                  p: BsSpacing.s3,
                  textColor: BsTextColor.bodyEmphasis,
                  child: _toggleLink(
                    toggle,
                    alignment: MainAxisAlignment.center,
                    content: const [GithubAvatar(size: 24)],
                  ),
                ),
                items: _userMenu(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The third sidebar: `flex-shrink-0 p-3` at 280px with a bordered brand and
/// `btn-toggle` buttons that each collapse a `btn-toggle-nav` list.
class _CollapsibleSidebar extends StatefulWidget {
  const _CollapsibleSidebar();

  @override
  State<_CollapsibleSidebar> createState() => _CollapsibleSidebarState();
}

class _CollapsibleSidebarState extends State<_CollapsibleSidebar> {
  static const _groups = [
    ('Home', ['Overview', 'Updates', 'Reports']),
    ('Dashboard', ['Overview', 'Weekly', 'Monthly', 'Annually']),
    ('Orders', ['New', 'Processed', 'Shipped', 'Returned']),
    ('Account', ['New...', 'Profile', 'Settings', 'Sign out']),
  ];

  // `#home-collapse` is `.collapse.show`.
  final _expanded = [true, false, false, false];

  Widget _group(int i) {
    final (title, links) = _groups[i];
    return Padding(
      // li.mb-1
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: _ToggleButton(
              label: title,
              expanded: _expanded[i],
              onPressed: () => setState(() => _expanded[i] = !_expanded[i]),
            ),
          ),
          BsCollapse(
            isExpanded: _expanded[i],
            child: Padding(
              // pb-1
              padding: const EdgeInsets.only(bottom: 4),
              child: DefaultTextStyle.merge(
                // fw-normal small
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 1.5,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [for (final link in links) _NavLink(link)],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: BsBox(
        p: BsSpacing.s3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // <a class="d-flex align-items-center pb-3 mb-3 … border-bottom">
            BsBox(
              pb: BsSpacing.s3,
              mb: BsSpacing.s3,
              borderBottom: true,
              textColor: BsTextColor.bodyEmphasis,
              child: _brand(
                context,
                iconWidth: 30,
                iconHeight: 24,
                label: BsBox(
                  fs: BsFs.fs5,
                  fw: BsFw.semibold,
                  child: const Text('Collapsible'),
                ),
              ),
            ),
            _group(0),
            _group(1),
            _group(2),
            // <li class="border-top my-3">: its margins swallow the `mb-1`
            // above it.
            const Padding(
              padding: EdgeInsets.only(top: 12, bottom: 16),
              child: BsBox(borderTop: true),
            ),
            _group(3),
          ],
        ),
      ),
    );
  }
}

/// `.btn.btn-toggle.d-inline-flex.align-items-center.rounded.border-0`: a
/// chevron (`::before`, `1.25em` wide, turned 90° while expanded) and a
/// semibold label.
class _ToggleButton extends StatefulWidget {
  const _ToggleButton({
    required this.label,
    required this.expanded,
    required this.onPressed,
  });

  final String label;
  final bool expanded;
  final VoidCallback onPressed;

  @override
  State<_ToggleButton> createState() => _ToggleButtonState();
}

class _ToggleButtonState extends State<_ToggleButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final dark = BsTheme.of(context) == Brightness.dark;
    final emphasis = BsBody.emphasisColorOf(context);
    final active = _hovered || widget.expanded;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onPressed,
        child: BsDecoratedBox(
          decoration: BoxDecoration(
            color: _hovered ? BsBody.tertiaryBackgroundOf(context) : null,
            borderRadius: BorderRadius.circular(BsBorders.radius),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: AnimatedRotation(
                      turns: widget.expanded ? 0.25 : 0,
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.ease,
                      child: BootstrapIcon(
                        BootstrapIconData.chevronToggle,
                        color: dark
                            ? const Color(0x80FFFFFF)
                            : const Color(0x80000000),
                      ),
                    ),
                  ),
                ),
                Text(
                  widget.label,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: active ? emphasis.withValues(alpha: 0.85) : emphasis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// `.btn-toggle-nav a.link-body-emphasis.d-inline-flex.rounded`: padding
/// `.1875rem .5rem`, `margin-top: .125rem; margin-left: 1.25rem`.
class _NavLink extends StatefulWidget {
  const _NavLink(this.label);

  final String label;

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 2, left: 20),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {},
          child: BsDecoratedBox(
            decoration: BoxDecoration(
              color: _hovered ? BsBody.tertiaryBackgroundOf(context) : null,
              borderRadius: BorderRadius.circular(BsBorders.radius),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              child: Text(
                widget.label,
                style: TextStyle(color: BsBody.emphasisColorOf(context)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The fourth sidebar: `bg-body-tertiary` at 380px — a bordered brand over a
/// scrolling `list-group-flush`.
class _ListGroupSidebar extends StatelessWidget {
  const _ListGroupSidebar();

  static const _days = ['Wed', 'Tues', 'Mon'];

  BsListGroupItem _item(BuildContext context, int i) {
    final active = i == 0;
    final secondary = BsTextColor.bodySecondary.of(context);
    return BsListGroupItem(
      onTap: () {},
      active: active,
      py: BsSpacing.s3,
      // lh-sm
      child: DefaultTextStyle.merge(
        style: const TextStyle(height: 1.25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Padding(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Text(
                    'List group item heading',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
                DefaultTextStyle.merge(
                  style: TextStyle(
                    fontSize: 14,
                    color: active ? null : secondary,
                  ),
                  child: BsCssLineHeight(
                    fontSize: 14,
                    lineHeight: 1.25,
                    perLine: true,
                    child: Text(_days[i % 3]),
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topLeft,
              child: BsBox(
                col: const BsCol(10),
                mb: BsSpacing.s1,
                child: DefaultTextStyle.merge(
                  style: const TextStyle(fontSize: 14),
                  child: BsCssLineHeight(
                    fontSize: 14,
                    lineHeight: 1.25,
                    perLine: true,
                    child: const Text(
                      'Some placeholder content in a paragraph below the '
                      'heading and date.',
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 380,
      child: BsBox(
        bg: BsBg.bodyTertiary,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BsBox(
              p: BsSpacing.s3,
              borderBottom: true,
              textColor: BsTextColor.bodyEmphasis,
              child: _brand(
                context,
                iconWidth: 30,
                iconHeight: 24,
                label: BsBox(
                  fs: BsFs.fs5,
                  fw: BsFw.semibold,
                  child: const Text('List group'),
                ),
              ),
            ),
            // .list-group.list-group-flush.border-bottom.scrollarea
            Flexible(
              child: BsBox(
                borderBottom: true,
                child: SingleChildScrollView(
                  child: BsListGroup(
                    flush: true,
                    items: [for (var i = 0; i < 12; i++) _item(context, i)],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
