import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

/// The "Headers" example: several full-width header/nav bar layouts stacked
/// on one page, mirroring Bootstrap's own `examples/headers` page — six
/// variants ranging from a bare brand-and-nav bar to a dark navbar with a
/// search box and a two-tier "double header".
class HeadersExamplePage extends StatelessWidget {
  const HeadersExamplePage({super.key});

  static final List<BsNavbarItem> _mainNavItems = [
    BsNavbarItem(child: const Text('Home'), active: true, onTap: () {}),
    BsNavbarItem(child: const Text('Features'), onTap: () {}),
    BsNavbarItem(child: const Text('Pricing'), onTap: () {}),
    BsNavbarItem(child: const Text('FAQs'), onTap: () {}),
    BsNavbarItem(child: const Text('About'), onTap: () {}),
  ];

  static List<BsNavItem> _mainNavPillItems() => [
    BsNavItem(child: const Text('Home'), active: true, onTap: () {}),
    BsNavItem(child: const Text('Features'), onTap: () {}),
    BsNavItem(child: const Text('Pricing'), onTap: () {}),
    BsNavItem(child: const Text('FAQs'), onTap: () {}),
    BsNavItem(child: const Text('About'), onTap: () {}),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _Section(
          label: 'Simple header',
          description: "A centered brand and nav — Bootstrap's baseline header.",
          child: _simpleHeader(context),
        ),
        _Section(
          label: 'Centered navigation',
          description: 'Just the nav, no brand — a lighter-weight variant of the simple header.',
          child: _centeredNav(context),
        ),
        _Section(
          label: 'Header with call-to-action buttons',
          description: 'Brand, nav, and Login/Sign-up buttons, spread across the bar.',
          child: _ctaHeader(context),
        ),
        _Section(
          label: 'Dark header with search',
          description: 'A dark BsNavbar with a search box and outline/warning buttons.',
          child: _darkSearchHeader(context),
        ),
        _Section(
          label: 'Dashboard header with dropdown',
          description: 'A product-style header: nav items, search, and a user-menu BsDropdown.',
          child: _dashboardHeader(context),
        ),
        _Section(
          label: 'Double header',
          description: 'A slim utility bar stacked above the main brand-and-search bar.',
          isLast: true,
          child: _doubleHeader(context),
        ),
      ],
    );
  }

  Widget _simpleHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: BsBorders.colorOf(context)))),
      child: BsContainer(
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 32,
          runSpacing: 12,
          children: [
            Text('Company name', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: BsBody.colorOf(context))),
            BsNav(variant: BsNavVariant.pills, items: _mainNavPillItems()),
          ],
        ),
      ),
    );
  }

  Widget _centeredNav(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: BsContainer(child: Center(child: BsNav(variant: BsNavVariant.pills, items: _mainNavPillItems()))),
    );
  }

  Widget _ctaHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: BsBorders.colorOf(context)))),
      child: BsContainer(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final brand = Text(
              'Company name',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: BsBody.colorOf(context)),
            );
            final nav = BsNav(variant: BsNavVariant.pills, items: _mainNavPillItems());
            final buttons = Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                BsButton(variant: BsVariant.primary, outline: true, onPressed: () {}, child: const Text('Login')),
                const SizedBox(width: 8),
                BsButton(variant: BsVariant.primary, onPressed: () {}, child: const Text('Sign-up')),
              ],
            );

            if (constraints.maxWidth < BsBreakpoint.md.minWidth) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [brand, const SizedBox(height: 16), nav, const SizedBox(height: 16), buttons],
              );
            }
            return Row(
              children: [brand, Expanded(child: Center(child: nav)), buttons],
            );
          },
        ),
      ),
    );
  }

  Widget _darkSearchHeader(BuildContext context) {
    return BsNavbar(
      colorScheme: BsNavbarColorScheme.dark,
      background: BsColors.gray900,
      brand: const Text('Company name'),
      onBrandTap: () {},
      items: _mainNavItems,
      trailing: [
        const SizedBox(width: 200, child: BsFormControl(placeholder: 'Search')),
        const SizedBox(width: 12),
        BsButton(variant: BsVariant.light, outline: true, onPressed: () {}, child: const Text('Login')),
        const SizedBox(width: 8),
        BsButton(variant: BsVariant.warning, onPressed: () {}, child: const Text('Sign-up')),
      ],
      expandBreakpoint: BsBreakpoint.lg,
    );
  }

  Widget _dashboardHeader(BuildContext context) {
    final isDark = BsTheme.of(context) == Brightness.dark;
    return Container(
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: BsBorders.colorOf(context)))),
      child: BsNavbar(
        colorScheme: isDark ? BsNavbarColorScheme.dark : BsNavbarColorScheme.light,
        background: BsBody.backgroundOf(context),
        brand: const Text('Dashboard'),
        onBrandTap: () {},
        items: [
          BsNavbarItem(child: const Text('Overview'), active: true, onTap: () {}),
          BsNavbarItem(child: const Text('Inventory'), onTap: () {}),
          BsNavbarItem(child: const Text('Customers'), onTap: () {}),
          BsNavbarItem(child: const Text('Products'), onTap: () {}),
        ],
        trailing: [
          const SizedBox(width: 200, child: BsFormControl(placeholder: 'Search')),
          const SizedBox(width: 16),
          BsDropdown(
            alignEnd: true,
            toggleBuilder: (context, toggle, isOpen) => MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(onTap: toggle, child: const _Avatar(initials: 'MD')),
            ),
            items: const [
              BsDropdownHeader(child: Text('Signed in as mdo')),
              BsDropdownDivider(),
              BsDropdownItem(child: Text('New project')),
              BsDropdownItem(child: Text('Settings')),
              BsDropdownItem(child: Text('Profile')),
              BsDropdownDivider(),
              BsDropdownItem(child: Text('Sign out')),
            ],
          ),
        ],
        expandBreakpoint: BsBreakpoint.lg,
      ),
    );
  }

  Widget _doubleHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            color: BsBody.tertiaryBackgroundOf(context),
            border: Border(bottom: BorderSide(color: BsBorders.colorOf(context))),
          ),
          child: BsContainer(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final utilityLinks = BsNav(variant: BsNavVariant.plain, items: _mainNavPillItems());
                final authLinks = BsNav(
                  variant: BsNavVariant.plain,
                  items: [
                    BsNavItem(child: const Text('Login'), onTap: () {}),
                    BsNavItem(child: const Text('Sign up'), onTap: () {}),
                  ],
                );
                if (constraints.maxWidth < BsBreakpoint.md.minWidth) {
                  return Center(child: utilityLinks);
                }
                return Row(children: [utilityLinks, const Spacer(), authLinks]);
              },
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: BsContainer(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final brand = Text(
                  'Company name',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: BsBody.colorOf(context)),
                );
                const search = SizedBox(width: 240, child: BsFormControl(placeholder: 'Search'));
                if (constraints.maxWidth < BsBreakpoint.md.minWidth) {
                  return Column(mainAxisSize: MainAxisSize.min, children: [brand, const SizedBox(height: 16), search]);
                }
                return Row(children: [brand, const Spacer(), search]);
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.label, required this.description, required this.child, this.isLast = false});

  final String label;
  final String description;
  final Widget child;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: BsBody.secondaryColorOf(context), letterSpacing: 0.3)),
              const SizedBox(height: 2),
              Text(description, style: TextStyle(fontSize: 13, color: BsBody.tertiaryColorOf(context))),
            ],
          ),
        ),
        child,
        if (!isLast) const SizedBox(height: 8),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({required this.initials});

  final String initials;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      alignment: Alignment.center,
      decoration: const BoxDecoration(color: BsColors.blue, shape: BoxShape.circle),
      child: Text(initials, style: const TextStyle(color: BsColors.white, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}
