import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/bootstrap_icon.dart';
import '../../src/example_navbar_page.dart';

/// The "Offcanvas navbar" example (`examples/offcanvas-navbar`): a fixed navbar
/// whose menu slides in over the page below `lg`, a scrolling secondary nav and
/// a page of "recent updates" cards on a `bg-body-tertiary` body.
class OffcanvasNavbarExamplePage extends StatelessWidget {
  const OffcanvasNavbarExamplePage({super.key});

  static const _purple = Color(0xFF6F42C1);
  static const _gray900 = Color(0xFF343A40);

  /// The `position: fixed` navbar and its sliding menu.
  static Widget fixed(BuildContext context) =>
      const Positioned.fill(child: _FixedNavbar());

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    // body { padding-top: 56px } on `bg-body-tertiary`
    return ColoredBox(
      color: BsBg.bodyTertiary.of(context),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: height),
        child: Padding(
          padding: const EdgeInsets.only(top: 56),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _scroller(context),
              BsContainer(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // (`my-3` blocks stacked in the flow: their margins collapse)
                    const SizedBox(height: 16),
                    _banner(),
                    const SizedBox(height: 16),
                    _card(context, 'Recent updates', [
                      _update(
                        const Color(0xFF007BFF),
                        'Some representative placeholder content, with some information about this user. Imagine this being some sort of status update, perhaps?',
                      ),
                      _update(
                        const Color(0xFFE83E8C),
                        'Some more representative placeholder content, related to this other user. Another status update, perhaps.',
                      ),
                      _update(
                        const Color(0xFF6F42C1),
                        'This user also gets some representative placeholder content. Maybe they did something interesting, and you really want to highlight this in the recent updates.',
                      ),
                    ], 'All updates'),
                    const SizedBox(height: 16),
                    _card(context, 'Suggestions', [
                      for (var i = 0; i < 3; i++) _suggestion(),
                    ], 'All suggestions'),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // <div class="nav-scroller bg-body shadow-sm"><nav class="nav">
  static Widget _scroller(BuildContext context) {
    Widget link(String text, {bool active = false, Widget? badge}) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: DefaultTextStyle.merge(
          softWrap: false,
          style: TextStyle(
            fontSize: 14,
            fontWeight: active ? FontWeight.w500 : FontWeight.w400,
            color: active ? _gray900 : const Color(0xFF6C757D),
          ),
          child: badge == null
              ? Text(text)
              : Row(children: [Text('$text '), badge]),
        ),
      );
    }

    return BsBox(
      bg: BsBg.body,
      shadow: BsShadow.sm,
      child: SizedBox(
        height: 44, // 2.75rem
        child: ClipRect(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                link('Dashboard', active: true),
                link(
                  'Friends',
                  badge: const BsBadge(
                    variant: BsVariant.light,
                    pill: true,
                    child: Text('27'),
                  ),
                ),
                link('Explore'),
                link('Suggestions'),
                for (var i = 0; i < 5; i++) link('Link'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // <div class="d-flex align-items-center p-3 my-3 text-white bg-purple rounded shadow-sm">
  static Widget _banner() {
    return BsBox(
      textColor: BsTextColor.white,
      child: BsDecoratedContainer(
        decoration: BoxDecoration(
          color: _purple,
          borderRadius: BorderRadius.circular(BsRounded.r2.radius),
          boxShadow: BsShadows.shadowSm,
        ),
        padding: const EdgeInsets.all(16),
        child: BsFlex(
          alignItems: BsAlign.center,
          children: [
            // <img class="me-3" src="bootstrap-logo-white.svg" width="48" height="38">
            const BsFlexItem(
              me: BsSpacing.s3,
              child: BootstrapIcon(
                BootstrapIconData.bootstrapLogo,
                width: 48,
                height: 38,
                color: BsColors.white,
              ),
            ),
            // <div class="lh-1">
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                BsHeading(
                  BsHeadingLevel.h6,
                  lh: BsLh.lh1,
                  mb: BsSpacing.s0,
                  child: Text('Bootstrap'),
                ),
                BsBox(
                  lh: BsLh.lh1,
                  child: BsSmall(block: true, child: Text('Since 2011')),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // <div class="my-3 p-3 bg-body rounded shadow-sm"><h6 class="border-bottom pb-2 mb-0">
  static Widget _card(
    BuildContext context,
    String title,
    List<Widget> rows,
    String more,
  ) {
    return BsBox(
      p: BsSpacing.s3,
      bg: BsBg.body,
      rounded: BsRounded.r2,
      shadow: BsShadow.sm,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          BsBox(
            borderBottom: true,
            pb: BsSpacing.s2,
            child: BsHeading(
              BsHeadingLevel.h6,
              mb: BsSpacing.s0,
              child: Text(title),
            ),
          ),
          ...rows,
          // <small class="d-block text-end mt-3"><a href="#">
          BsBox(
            mt: BsSpacing.s3,
            textAlign: BsTextAlign.end,
            child: BsSmall(
              block: true,
              child: Text(
                more,
                style: TextStyle(
                  color: BsLink.colorOf(context),
                  decoration: TextDecoration.underline,
                  decorationColor: BsLink.colorOf(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// `<Placeholder width="32" height="32" class="flex-shrink-0 me-2 rounded">`.
  static Widget _avatar(Color color) => BsFlexItem(
    flexShrink: false,
    me: BsSpacing.s2,
    alignSelf: BsAlign.start,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(BsRounded.r2.radius),
      child: SizedBox(width: 32, height: 32, child: ColoredBox(color: color)),
    ),
  );

  // <div class="d-flex text-body-secondary pt-3"> … <p class="pb-3 mb-0 small lh-sm border-bottom">
  static Widget _update(Color color, String text) {
    return BsBox(
      pt: BsSpacing.s3,
      textColor: BsTextColor.bodySecondary,
      child: BsFlex(
        children: [
          _avatar(color),
          BsFlexItem(
            child: BsBox(
              pb: BsSpacing.s3,
              borderBottom: true,
              child: BsSmall(
                block: true,
                child: _lhSm(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const BsBox(
                        fw: BsFw.bold,
                        child: Text(
                          '@username',
                          style: TextStyle(color: _gray900),
                        ),
                      ),
                      Text(text),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// `lh-sm` on 14px text: 17.5px lines, which Flutter would round to 18.
  static Widget _lhSm(Widget child) => DefaultTextStyle.merge(
    style: const TextStyle(height: 1.25),
    child: BsCssLineHeight(
      fontSize: 14,
      lineHeight: 1.25,
      perLine: true,
      child: child,
    ),
  );

  static Widget _suggestion() {
    return BsBox(
      pt: BsSpacing.s3,
      textColor: BsTextColor.bodySecondary,
      child: BsFlex(
        children: [
          _avatar(const Color(0xFF007BFF)),
          BsFlexItem(
            w: BsWidth.w100,
            child: Builder(
              builder: (context) => BsBox(
                pb: BsSpacing.s3,
                borderBottom: true,
                child: BsSmall(
                  block: true,
                  child: _lhSm(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        BsFlex(
                          justifyContent: BsJustify.between,
                          children: [
                            const BsBox(
                              fw: BsFw.bold,
                              child: Text(
                                'Full Name',
                                style: TextStyle(color: _gray900),
                              ),
                            ),
                            Text(
                              'Follow',
                              style: TextStyle(
                                color: BsLink.colorOf(context),
                                decoration: TextDecoration.underline,
                                decorationColor: BsLink.colorOf(context),
                              ),
                            ),
                          ],
                        ),
                        const Text('@username'),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The fixed navbar (`navbar-expand-lg fixed-top bg-dark`) and, below `lg`, its
/// `.offcanvas-collapse`: a full-width panel under the bar that slides in from
/// the right when the toggler is tapped.
class _FixedNavbar extends StatefulWidget {
  const _FixedNavbar();

  @override
  State<_FixedNavbar> createState() => _FixedNavbarState();
}

class _FixedNavbarState extends State<_FixedNavbar> {
  bool _open = false;

  static const _expand = BsBreakpoint.lg;

  List<BsNavbarItem> _items() => [
    BsNavbarItem(child: const Text('Dashboard'), active: true, onTap: () {}),
    BsNavbarItem(child: const Text('Notifications'), onTap: () {}),
    BsNavbarItem(child: const Text('Profile'), onTap: () {}),
    BsNavbarItem(child: const Text('Switch account'), onTap: () {}),
    navbarDropdownItem('Settings', expandBreakpoint: _expand),
  ];

  @override
  Widget build(BuildContext context) {
    final expanded = MediaQuery.sizeOf(context).width >= _expand.minWidth;
    final items = _items();
    return BsTheme(
      brightness: Brightness.dark,
      child: Stack(
        children: [
          // The panel first, so the bar stays over it.
          if (!expanded)
            Positioned(
              top: 56,
              bottom: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                ignoring: !_open,
                child: ClipRect(
                  child: AnimatedSlide(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    offset: _open ? Offset.zero : const Offset(1, 0),
                    child: ColoredBox(
                      color: OffcanvasNavbarExamplePage._gray900,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              for (final item in items) _PanelLink(item: item),
                              const SizedBox(height: 8), // ul.mb-2
                              const NavbarSearchForm(fill: true),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: BsBox(
              bg: BsBg.dark,
              child: BsContainer.fluid(
                child: BsNavbar(
                  colorScheme: BsNavbarColorScheme.dark,
                  expandBreakpoint: _expand,
                  brand: const Text('Offcanvas navbar'),
                  items: items,
                  trailing: const [
                    NavbarSearchInput(expandBreakpoint: _expand),
                  ],
                  bareToggler: true,
                  onToggle: () => setState(() => _open = !_open),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// A `.nav-link` in the sliding panel (no horizontal padding).
class _PanelLink extends StatelessWidget {
  const _PanelLink({required this.item});

  final BsNavbarItem item;

  @override
  Widget build(BuildContext context) {
    final color = item.disabled
        ? BsNavbarStyle.darkDisabledColor
        : item.active
        ? BsNavbarStyle.darkActiveColor
        : BsNavbarStyle.darkColor;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: item.onTap,
      child: Padding(
        padding: item.padded
            ? const EdgeInsets.symmetric(vertical: 8)
            : EdgeInsets.zero,
        child: DefaultTextStyle.merge(
          style: TextStyle(color: color),
          child: item.child,
        ),
      ),
    );
  }
}
