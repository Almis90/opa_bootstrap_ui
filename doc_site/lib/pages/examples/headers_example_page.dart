import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/bootstrap_icon.dart';
import '../../src/dropdown_caret.dart';

/// The "Headers" example: a faithful port of Bootstrap's own
/// `examples/headers` page — the same brand text, nav items, and flex-wrap
/// reflow behavior as the original, which builds every header from plain
/// flex utility classes rather than the `.navbar` component (so none of
/// these collapse behind a hamburger toggle; they just reflow).
class HeadersExamplePage extends StatelessWidget {
  const HeadersExamplePage({super.key});

  static const _mainLabels = ['Home', 'Features', 'Pricing', 'FAQs', 'About'];
  static const _dashboardLabels = ['Overview', 'Inventory', 'Customers', 'Products'];
  static const _px2 = BsNavStyle(linkPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 8));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _simpleHeader(context),
        const _ExampleDivider(),
        _centeredNav(context),
        const _ExampleDivider(),
        _ctaHeader(context),
        const _ExampleDivider(),
        _darkSearchHeader(context),
        const _ExampleDivider(),
        _dropdownHeader(context),
        const _ExampleDivider(),
        _gridDropdownSection(context),
        const _ExampleDivider(),
        _doubleHeader(context),
        const _ExampleDivider(),
        _iconNavHeader(context),
        const _ExampleDivider(),
      ],
    );
  }

  // --- Section bodies, in the same order as Bootstrap's own page ---

  static Widget _simpleHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: BsBorders.colorOf(context)))),
      child: BsContainer(
        child: _flexHeader(
          breakpoint: BsBreakpoint.md,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const _BootstrapMark(),
                const SizedBox(width: 8),
                Text('Simple header', style: TextStyle(fontSize: 20, color: BsBody.emphasisColorOf(context))),
              ],
            ),
            BsNav(variant: BsNavVariant.pills, items: _pillNavItems(_mainLabels)),
          ],
        ),
      ),
    );
  }

  static Widget _centeredNav(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: BsContainer(child: Center(child: BsNav(variant: BsNavVariant.pills, items: _pillNavItems(_mainLabels)))),
    );
  }

  static Widget _ctaHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: BsBorders.colorOf(context)))),
      child: BsContainer(
        child: LayoutBuilder(
          builder: (context, constraints) {
            const brand = _BootstrapMark();
            final nav = BsNav(
              variant: BsNavVariant.plain,
              style: _px2,
              items: _plainNavItems(_mainLabels, firstColor: BsBody.secondaryColorOf(context)),
            );
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
            return Row(children: [brand, Expanded(child: Center(child: nav)), buttons]);
          },
        ),
      ),
    );
  }

  static Widget _darkSearchHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      color: BsColors.gray900,
      child: BsContainer(
        child: _flexHeader(
          breakpoint: BsBreakpoint.lg,
          spacerAfterIndex: 1,
          children: [
            const _BootstrapMark(white: true),
            BsNav(
              variant: BsNavVariant.plain,
              style: _px2,
              items: _plainNavItems(_mainLabels, firstColor: BsColors.gray500, restColor: BsColors.white),
            ),
            const SizedBox(width: 200, child: BsFormControl(placeholder: 'Search', style: _darkFormStyle)),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                BsButton(variant: BsVariant.light, outline: true, onPressed: () {}, child: const Text('Login')),
                const SizedBox(width: 8),
                BsButton(variant: BsVariant.warning, onPressed: () {}, child: const Text('Sign-up')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _dropdownHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: BsBorders.colorOf(context)))),
      child: BsContainer(
        child: _flexHeader(
          breakpoint: BsBreakpoint.lg,
          spacerAfterIndex: 1,
          children: [
            const _BootstrapMark(),
            BsNav(
              variant: BsNavVariant.plain,
              style: _px2,
              items: _plainNavItems(
                _dashboardLabels,
                firstColor: BsBody.secondaryColorOf(context),
                restColor: BsBody.emphasisColorOf(context),
              ),
            ),
            const SizedBox(width: 200, child: BsFormControl(placeholder: 'Search')),
            BsDropdown(
              alignEnd: true,
              toggleBuilder: (context, toggle, isOpen) => MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(onTap: toggle, child: const _AvatarToggle()),
              ),
              items: _avatarMenuItems(),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _gridDropdownSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [_gridDropdownHeader(context), const SizedBox(height: 16), _gridPlaceholderBlocks(context)],
    );
  }

  static Widget _gridDropdownHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: BsBorders.colorOf(context)))),
      child: BsContainer.fluid(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: BsDropdown(
                  toggleBuilder: (context, toggle, isOpen) => MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: toggle,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const _BootstrapMark(),
                          // `.me-2` on the svg, then the caret's own margin.
                          const SizedBox(width: 8 + DropdownCaret.marginStart),
                          DropdownCaret(color: BsBody.emphasisColorOf(context)),
                        ],
                      ),
                    ),
                  ),
                  items: _logoMenuItems(),
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  const Expanded(child: BsFormControl(placeholder: 'Search')),
                  const SizedBox(width: 12),
                  BsDropdown(
                    alignEnd: true,
                    toggleBuilder: (context, toggle, isOpen) => MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(onTap: toggle, child: const _AvatarToggle()),
                    ),
                    items: _avatarMenuItems(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _gridPlaceholderBlocks(BuildContext context) {
    return BsContainer.fluid(
      child: Row(
        children: [
          Expanded(child: _placeholderBlock(context)),
          const SizedBox(width: 16),
          Expanded(flex: 2, child: _placeholderBlock(context)),
        ],
      ),
    );
  }

  static Widget _placeholderBlock(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: BsBody.tertiaryBackgroundOf(context),
        border: Border.all(color: BsBorders.colorOf(context)),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }

  static Widget _doubleHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: BsBody.tertiaryBackgroundOf(context),
            border: Border(bottom: BorderSide(color: BsBorders.colorOf(context))),
          ),
          child: BsContainer(
            child: _flexHeader(
              breakpoint: BsBreakpoint.xs,
              children: [
                BsNav(
                  variant: BsNavVariant.plain,
                  style: _px2,
                  items: _plainNavItems(
                    _mainLabels,
                    firstColor: BsBody.emphasisColorOf(context),
                    restColor: BsBody.emphasisColorOf(context),
                  ),
                ),
                BsNav(
                  variant: BsNavVariant.plain,
                  style: _px2,
                  items: [
                    BsNavItem(
                      child: Text('Login', style: TextStyle(color: BsBody.emphasisColorOf(context))),
                      onTap: () {},
                    ),
                    BsNavItem(
                      child: Text('Sign up', style: TextStyle(color: BsBody.emphasisColorOf(context))),
                      onTap: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: BsBorders.colorOf(context)))),
          child: BsContainer(
            child: _flexHeader(
              breakpoint: BsBreakpoint.lg,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const _BootstrapMark(),
                    const SizedBox(width: 8),
                    Text('Double header', style: TextStyle(fontSize: 20, color: BsBody.emphasisColorOf(context))),
                  ],
                ),
                const SizedBox(width: 240, child: BsFormControl(placeholder: 'Search')),
              ],
            ),
          ),
        ),
      ],
    );
  }

  static Widget _iconNavHeader(BuildContext context) {
    const icons = [
      (BootstrapIconData.home, 'Home'),
      (BootstrapIconData.speedometer2, 'Dashboard'),
      (BootstrapIconData.table, 'Orders'),
      (BootstrapIconData.grid, 'Products'),
      (BootstrapIconData.peopleCircle, 'Customers'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: BsColors.gray900,
            border: Border(bottom: BorderSide(color: BsBorders.colorOf(context))),
          ),
          child: _flexHeader(
            breakpoint: BsBreakpoint.lg,
            children: [
              const _BootstrapMark(white: true),
              Wrap(
                runSpacing: 8,
                children: [
                  for (final (icon, label) in icons)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          BootstrapIcon(
                            icon,
                            width: 24,
                            height: 24,
                            color: label == 'Home' ? BsColors.gray500 : BsColors.white,
                          ),
                          const SizedBox(height: 4), // `.mb-1`
                          Text(label, style: TextStyle(fontSize: 12, color: label == 'Home' ? BsColors.gray500 : BsColors.white)),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: BsBorders.colorOf(context)))),
          child: _flexHeader(
            breakpoint: BsBreakpoint.lg,
            children: [
              const SizedBox(width: 240, child: BsFormControl(placeholder: 'Search')),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BsButton(variant: BsVariant.light, onPressed: () {}, child: const Text('Login')),
                  const SizedBox(width: 8),
                  BsButton(variant: BsVariant.primary, onPressed: () {}, child: const Text('Sign-up')),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- Shared nav/menu builders ---

  static List<BsNavItem> _pillNavItems(List<String> labels) => [
    for (var i = 0; i < labels.length; i++) BsNavItem(child: Text(labels[i]), active: i == 0, onTap: () {}),
  ];

  static List<BsNavItem> _plainNavItems(List<String> labels, {Color? firstColor, Color? restColor}) => [
    for (var i = 0; i < labels.length; i++)
      BsNavItem(
        child: Text(labels[i], style: TextStyle(color: i == 0 ? firstColor : restColor)),
        active: i == 0,
        onTap: () {},
      ),
  ];

  static List<BsDropdownEntry> _avatarMenuItems() => const [
    BsDropdownItem(child: Text('New project...')),
    BsDropdownItem(child: Text('Settings')),
    BsDropdownItem(child: Text('Profile')),
    BsDropdownDivider(),
    BsDropdownItem(child: Text('Sign out')),
  ];

  static List<BsDropdownEntry> _logoMenuItems() => const [
    BsDropdownItem(child: Text('Overview'), active: true),
    BsDropdownItem(child: Text('Inventory')),
    BsDropdownItem(child: Text('Customers')),
    BsDropdownItem(child: Text('Products')),
    BsDropdownDivider(),
    BsDropdownItem(child: Text('Reports')),
    BsDropdownItem(child: Text('Analytics')),
  ];

  static const _darkFormStyle = BsFormStyle(
    inputColor: BsColors.white,
    inputBackground: Color(0x1AFFFFFF),
    inputBorderColor: Color(0x1AFFFFFF),
    inputPlaceholderColor: Color(0x80FFFFFF),
  );
}

/// Lays [children] out left-to-right with the free space after
/// [spacerAfterIndex] distributed to its right — the same effect Bootstrap's
/// real headers get from an `me-*-auto` class on one child — collapsing to
/// a centered, wrapped column below [breakpoint].
Widget _flexHeader({
  required List<Widget> children,
  required BsBreakpoint breakpoint,
  int spacerAfterIndex = 0,
  double spacing = 16,
  double runSpacing = 12,
}) {
  return LayoutBuilder(
    builder: (context, constraints) {
      if (constraints.maxWidth < breakpoint.minWidth) {
        return Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: spacing,
          runSpacing: runSpacing,
          children: children,
        );
      }
      final row = <Widget>[];
      for (var i = 0; i < children.length; i++) {
        row.add(children[i]);
        if (i == children.length - 1) continue;
        row.add(i == spacerAfterIndex ? const Spacer() : SizedBox(width: spacing));
      }
      return Row(crossAxisAlignment: CrossAxisAlignment.center, children: row);
    },
  );
}

/// Bootstrap's own `.b-example-divider`: a plain, inset-shadowed gray band
/// separating stacked examples on the same page — the real page has no
/// label or description between sections, just this.
class _ExampleDivider extends StatelessWidget {
  const _ExampleDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: const BoxDecoration(
        color: Color(0x1A000000),
        border: Border.symmetric(horizontal: BorderSide(color: Color(0x26000000))),
      ),
    );
  }
}

/// Bootstrap's own logo (`<svg class="bi" width="40" height="32">`), drawn
/// from the example's own `<symbol id="bootstrap">` path data. Fills with
/// `currentColor`: `link-body-emphasis` by default, `text-white` when [white].
class _BootstrapMark extends StatelessWidget {
  const _BootstrapMark({this.white = false});

  final bool white;

  @override
  Widget build(BuildContext context) => BootstrapIcon(
    BootstrapIconData.bootstrap,
    width: 40,
    height: 32,
    color: white ? BsColors.white : BsBody.emphasisColorOf(context),
  );
}

/// An avatar `.dropdown-toggle`: the image with the CSS caret after it, in
/// `link-body-emphasis`. The caret is an inline-block sitting `.255em` above
/// the text baseline, which the image rests on — so its bottom edge lands
/// `.255em` above the image's own bottom edge.
class _AvatarToggle extends StatelessWidget {
  const _AvatarToggle();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const _GithubAvatar(),
        const SizedBox(width: DropdownCaret.marginStart),
        Padding(
          padding: const EdgeInsets.only(bottom: DropdownCaret.marginStart),
          child: DropdownCaret(color: BsBody.emphasisColorOf(context)),
        ),
      ],
    );
  }
}

/// The same `github.com/mdo.png` avatar Bootstrap's own dropdown examples
/// use.
class _GithubAvatar extends StatelessWidget {
  const _GithubAvatar({this.size = 32});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.network(
        'https://github.com/mdo.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          width: size,
          height: size,
          alignment: Alignment.center,
          color: BsColors.gray400,
          child: Text('M', style: TextStyle(color: BsColors.white, fontSize: size * 0.42, fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
