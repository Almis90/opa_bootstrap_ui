import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/example_navbar_page.dart';

/// The "Navbars offcanvas" example (`examples/navbars-offcanvas`): navbars
/// whose toggler opens an offcanvas holding the links and a search form — a
/// dark one, a light one, and one that expands at `lg`.
class NavbarsOffcanvasExamplePage extends StatelessWidget {
  const NavbarsOffcanvasExamplePage({super.key});

  /// `<form class="d-flex …"><input class="form-control me-2"> <button
  /// class="btn btn-outline-success">Search</button></form>`.
  static Widget _form({bool fill = false}) {
    const input = BsFormControl(placeholder: 'Search');
    return BsFlex(
      inline: !fill,
      children: [
        BsFlexItem(
          me: BsSpacing.s2,
          flexGrow: fill,
          child: fill
              ? input
              : ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 193),
                  child: input,
                ),
        ),
        BsFlexItem(
          flexShrink: false,
          child: BsButton(
            variant: BsVariant.success,
            outline: true,
            onPressed: () {},
            child: const Text('Search'),
          ),
        ),
      ],
    );
  }

  /// `.offcanvas.offcanvas-end [text-bg-dark]`: a header with a close button and
  /// a body of `.navbar-nav.pe-3` links followed by the form (`mt-3`).
  static Widget _offcanvas(
    BuildContext context,
    List<Widget> links, {
    required bool dark,
  }) {
    final panel = BsOffcanvas(
      placement: BsOffcanvasPlacement.end,
      header: BsOffcanvasHeader(
        child: const Text('Offcanvas'),
        onClose: () => Navigator.of(context).pop(),
      ),
      body: BsOffcanvasBody(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BsBox(
              pe: BsSpacing.s3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: links,
              ),
            ),
            BsBox(mt: BsSpacing.s3, child: _form(fill: true)),
          ],
        ),
      ),
    );
    return dark ? BsTheme(brightness: Brightness.dark, child: panel) : panel;
  }

  static List<BsNavbarItem> _items(BsBreakpoint? expand) => [
    BsNavbarItem(child: const Text('Home'), active: true, onTap: () {}),
    BsNavbarItem(child: const Text('Link'), onTap: () {}),
    navbarDropdownItem('Dropdown', expandBreakpoint: expand, divider: true),
  ];

  static Widget _bar({
    required String brand,
    required bool dark,
    BsBreakpoint? expand,
    bool last = false,
  }) {
    final bar = BsNavbar(
      colorScheme: dark ? BsNavbarColorScheme.dark : BsNavbarColorScheme.light,
      expandBreakpoint: expand,
      brand: Text(brand),
      endItems: true,
      items: _items(expand),
      trailing: [if (expand != null) _form()],
      offcanvasBuilder: (context, links) =>
          _offcanvas(context, links, dark: dark),
    );
    return Padding(
      // (the last bar's 20px margin collapses into the container's 3rem)
      padding: EdgeInsets.only(bottom: last ? 0 : 20),
      child: BsTheme(
        brightness: dark ? Brightness.dark : Brightness.light,
        child: BsBox(
          bg: dark ? BsBg.dark : BsBg.bodyTertiary,
          child: BsContainer.fluid(child: bar),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final link = TextStyle(
      color: BsLink.colorOf(context),
      decoration: TextDecoration.underline,
      decorationColor: BsLink.colorOf(context),
    );
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _bar(brand: 'Dark offcanvas navbar', dark: true),
          _bar(brand: 'Light offcanvas navbar', dark: false),
          _bar(
            brand: 'Responsive offcanvas navbar',
            dark: true,
            expand: BsBreakpoint.lg,
            last: true,
          ),
          // <div class="container my-5"><div class="bg-body-tertiary p-5 rounded">
          BsContainer(
            my: BsSpacing.s5,
            child: BsBox(
              p: BsSpacing.s5,
              bg: BsBg.bodyTertiary,
              rounded: BsRounded.r2,
              // <div class="col-sm-8 py-5 mx-auto">
              child: BsBox(
                col: const BsResponsiveValue(sm: BsCol(8)),
                py: BsSpacing.s5,
                mx: BsSpacing.auto,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const BsBox(
                      mb: BsSpacing.s2,
                      textColor: BsTextColor.bodyEmphasis,
                      child: BsDisplayHeading(
                        BsDisplayLevel.d5,
                        fw: BsFw.normal,
                        child: Text('Navbar with offcanvas examples'),
                      ),
                    ),
                    // <p class="fs-5">
                    BsBox(
                      fs: BsFs.fs5,
                      mb: BsSpacing.s3,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            const TextSpan(
                              text:
                                  'This example shows how responsive offcanvas '
                                  'menus work within the navbar. For positioning '
                                  'of navbars, checkout the ',
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
                        "From the top down, you'll see a dark navbar, light "
                        'navbar and a responsive navbar—each with offcanvases '
                        'built in. Resize your browser window to the large '
                        'breakpoint to see the toggle for the offcanvas.',
                      ),
                    ),
                    BsBox(
                      mb: BsSpacing.s3,
                      child: Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: BsButton(
                          onPressed: () {},
                          child: const Text(
                            'Learn more about offcanvas navbars »',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
