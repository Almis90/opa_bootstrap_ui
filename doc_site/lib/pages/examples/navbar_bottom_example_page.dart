import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/example_navbar_page.dart';

/// The "Bottom navbar" example (`examples/navbar-bottom`): a `.navbar
/// .fixed-bottom.navbar-expand-sm.bg-dark` pinned to the viewport's bottom
/// (see [fixed]), with a dropup in its nav.
class NavbarBottomExamplePage extends StatelessWidget {
  const NavbarBottomExamplePage({super.key});

  /// The `position: fixed; right: 0; bottom: 0; left: 0` navbar.
  static Widget fixed(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: NavbarExampleBar(
        brand: 'Bottom navbar',
        expandBreakpoint: BsBreakpoint.sm,
        items: [
          ...navbarExampleItems(),
          // <li class="nav-item dropup"><a class="nav-link dropdown-toggle">
          BsNavbarItem(
            onTap: () {},
            padded: false,
            child: BsDropdown(
              direction: BsDropdownDirection.up,
              toggleBuilder: (context, toggle, isOpen) => GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: toggle,
                // The whole `.nav-item`, link padding included, so the menu
                // opens from its edge.
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  child: BsFlex(
                    inline: true,
                    alignItems: BsAlign.start,
                    children: [
                      const Text('Dropup'),
                      // `.dropdown-toggle::after`: .255em from the text, raised
                      // .255em off the baseline of the 24px line.
                      Padding(
                        padding: EdgeInsets.only(
                          left: BsDropdownCaret.marginStart,
                          top: 17 - 4.08 - BsDropdownCaret.heightFor(context),
                        ),
                        child: const BsDropdownCaret(up: true),
                      ),
                    ],
                  ),
                ),
              ),
              items: [
                for (final label in const [
                  'Action',
                  'Another action',
                  'Something else here',
                ])
                  BsDropdownItem(child: Text(label), onTap: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const NavbarExampleMain(
      title: 'Bottom Navbar example',
      lead:
          'This example is a quick exercise to illustrate how the bottom '
          'navbar works.',
      mt: BsSpacing.s3,
    );
  }
}
