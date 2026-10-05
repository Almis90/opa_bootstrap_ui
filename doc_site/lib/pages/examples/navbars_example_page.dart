import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/example_code.dart';
import '../../src/example_navbar_page.dart';

/// The "Navbars" example: a port of Bootstrap's own `examples/navbars` page —
/// thirteen navbars showing `.navbar-expand-*`, containers and centred navs.
/// Each is a [BsNavbar] whose `expandBreakpoint` is the `navbar-expand-*` class
/// (null for a bare `.navbar`, which never expands).
class NavbarsExamplePage extends StatelessWidget {
  const NavbarsExamplePage({super.key});

  /// The page's `.navbar { margin-bottom: 20px }`.
  static Widget _gap(Widget child) =>
      Padding(padding: const EdgeInsets.only(bottom: 20), child: child);

  /// `<nav class="navbar [navbar-expand-*] bg-dark" data-bs-theme="dark"><div
  /// class="container[-xl|-fluid]">…`.
  static Widget _dark({
    String? brand,
    required BsBreakpoint? expand,
    bool dropdown = true,
    bool disabled = true,
    bool search = true,
    bool centered = false,
    String firstLabel = 'Home',
    Widget Function(Widget bar)? container,
  }) {
    final items = [
      BsNavbarItem(child: Text(firstLabel), active: true, onTap: () {}),
      BsNavbarItem(child: const Text('Link'), onTap: () {}),
      if (disabled) const BsNavbarItem(child: Text('Disabled'), disabled: true),
      if (dropdown) navbarDropdownItem('Dropdown', expandBreakpoint: expand),
    ];
    final bar = BsNavbar(
      colorScheme: BsNavbarColorScheme.dark,
      expandBreakpoint: expand,
      brand: brand == null ? null : Text(brand),
      centerItems: centered,
      items: items,
      trailing: [if (search) NavbarSearchInput(expandBreakpoint: expand)],
    );
    return _gap(
      BsTheme(
        brightness: Brightness.dark,
        child: BsBox(
          bg: BsBg.dark,
          child: container == null
              ? BsContainer.fluid(child: bar)
              : container(bar),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _dark(brand: 'Never expand', expand: null),
          _dark(
            brand: 'Always expand',
            expand: BsBreakpoint.xs,
            dropdown: false,
            disabled: false,
          ),
          _dark(brand: 'Expand at sm', expand: BsBreakpoint.sm),
          _dark(brand: 'Expand at md', expand: BsBreakpoint.md),
          _dark(brand: 'Expand at lg', expand: BsBreakpoint.lg),
          _dark(brand: 'Expand at xl', expand: BsBreakpoint.xl),
          _dark(brand: 'Expand at xxl', expand: BsBreakpoint.xxl),
          // <div class="container">
          _dark(
            brand: 'Container',
            expand: BsBreakpoint.lg,
            container: (bar) => BsContainer(child: bar),
          ),
          // <div class="container-xl">
          _dark(
            brand: 'Container XL',
            expand: BsBreakpoint.lg,
            container: (bar) =>
                BsContainer.responsiveFrom(BsBreakpoint.xl, child: bar),
          ),
          // <div class="container-xl mb-4"><p>Matching .container-xl...</p>
          // (the paragraph's own 1rem margin collapses into the container's 1.5rem)
          const BsContainer.responsiveFrom(
            BsBreakpoint.xl,
            child: BsBox(
              mb: BsSpacing.s4,
              child: Text('Matching .container-xl...'),
            ),
          ),
          // Tenth: no brand, centred nav only.
          _dark(
            expand: BsBreakpoint.lg,
            centered: true,
            search: false,
            firstLabel: 'Centered nav only',
          ),
          // <div class="container">
          BsContainer(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _light(brand: 'Navbar'),
                _light(
                  centered: true,
                  search: false,
                  firstLabel: 'Centered nav only',
                ),
                _centeredNav(),
                _intro(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// `<nav class="navbar navbar-expand-lg bg-body-tertiary rounded">`.
  static Widget _light({
    String? brand,
    bool centered = false,
    bool search = true,
    String firstLabel = 'Home',
  }) {
    const expand = BsBreakpoint.lg;
    return _gap(
      BsBox(
        bg: BsBg.bodyTertiary,
        rounded: BsRounded.r2,
        child: BsContainer.fluid(
          child: BsNavbar(
            expandBreakpoint: expand,
            brand: brand == null ? null : Text(brand),
            centerItems: centered,
            items: [
              BsNavbarItem(child: Text(firstLabel), active: true, onTap: () {}),
              BsNavbarItem(child: const Text('Link'), onTap: () {}),
              const BsNavbarItem(child: Text('Disabled'), disabled: true),
              navbarDropdownItem('Dropdown', expandBreakpoint: expand),
            ],
            trailing: [
              if (search) const NavbarSearchInput(expandBreakpoint: expand),
            ],
          ),
        ),
      ),
    );
  }

  /// Thirteenth: `.navbar-collapse.d-lg-flex` holding a `col-lg-3` brand, a
  /// `col-lg-6` centred nav and a `col-lg-3` right-aligned button.
  static Widget _centeredNav() {
    const expand = BsBreakpoint.lg;
    return _gap(
      BsBox(
        bg: BsBg.bodyTertiary,
        rounded: BsRounded.r2,
        child: BsContainer.fluid(
          child: BsNavbar(
            expandBreakpoint: expand,
            items: [
              BsNavbarItem(
                child: const Text('Home'),
                active: true,
                onTap: () {},
              ),
              BsNavbarItem(child: const Text('Link'), onTap: () {}),
              const BsNavbarItem(child: Text('Disabled'), disabled: true),
              navbarDropdownItem('Dropdown', expandBreakpoint: expand),
            ],
            collapseBuilder: (context, expanded, links) {
              final brand = BsFlexItem(
                col: const BsResponsiveValue(lg: BsCol(3)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5),
                  child: DefaultTextStyle.merge(
                    style: TextStyle(
                      fontSize: 20,
                      color: BsBody.emphasisColorOf(context),
                    ),
                    child: const Text('Centered nav'),
                  ),
                ),
              );
              final nav = BsFlexItem(
                col: const BsResponsiveValue(lg: BsCol(6)),
                child: BsFlex(
                  direction: expanded
                      ? BsFlexDirection.row
                      : BsFlexDirection.column,
                  alignItems: expanded ? BsAlign.center : BsAlign.stretch,
                  justifyContent: expanded ? BsJustify.center : null,
                  children: links,
                ),
              );
              final button = BsFlexItem(
                col: const BsResponsiveValue(lg: BsCol(3)),
                child: Align(
                  alignment: expanded
                      ? AlignmentDirectional.centerEnd
                      : AlignmentDirectional.centerStart,
                  child: BsButton(
                    onPressed: () {},
                    child: const Text('Button'),
                  ),
                ),
              );
              return BsFlex(
                direction: expanded
                    ? BsFlexDirection.row
                    : BsFlexDirection.column,
                alignItems: expanded ? BsAlign.center : BsAlign.stretch,
                children: [brand, nav, button],
              );
            },
          ),
        ),
      ),
    );
  }

  // <div class="bg-body-tertiary p-5 rounded"><div class="col-sm-8 mx-auto">
  static Widget _intro(BuildContext context) {
    final link = TextStyle(
      color: BsLink.colorOf(context),
      decoration: TextDecoration.underline,
      decorationColor: BsLink.colorOf(context),
    );
    return BsBox(
      p: BsSpacing.s5,
      bg: BsBg.bodyTertiary,
      rounded: BsRounded.r2,
      child: BsBox(
        col: const BsResponsiveValue(sm: BsCol(8)),
        mx: BsSpacing.auto,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const BsHeading(BsHeadingLevel.h1, child: Text('Navbar examples')),
            BsBox(
              mb: BsSpacing.s3,
              child: Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text:
                          'This example is a quick exercise to illustrate how '
                          'the navbar and its contents work. Some navbars extend '
                          'the width of the viewport, others are confined within a ',
                    ),
                    codeSpan(context, '.container'),
                    const TextSpan(
                      text: '. For positioning of navbars, checkout the ',
                    ),
                    TextSpan(text: 'top', style: link),
                    const TextSpan(text: ' and '),
                    TextSpan(text: 'fixed top', style: link),
                    const TextSpan(text: ' examples.'),
                  ],
                ),
              ),
            ),
            const BsBox(
              mb: BsSpacing.s3,
              child: Text(
                'At the smallest breakpoint, the collapse plugin is used to '
                'hide the links and show a menu button to toggle the collapsed '
                'content.',
              ),
            ),
            BsBox(
              mb: BsSpacing.s3,
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: BsButton(
                  onPressed: () {},
                  child: const Text('View navbar docs »'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
