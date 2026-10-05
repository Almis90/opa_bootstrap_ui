import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/example_navbar_page.dart';

/// The "Fixed top navbar" example (`examples/navbar-fixed`): a `.navbar
/// .navbar-expand-md.fixed-top.bg-dark` that stays in the viewport (see
/// [fixed]) over a page padded by `4.5rem` and `75rem` tall.
class NavbarFixedExamplePage extends StatelessWidget {
  const NavbarFixedExamplePage({super.key});

  /// The `position: fixed; top: 0; right: 0; left: 0` navbar.
  static Widget fixed(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: NavbarExampleBar(
        brand: 'Fixed navbar',
        expandBreakpoint: BsBreakpoint.md,
        items: navbarExampleItems(),
        trailing: const [NavbarSearchForm()],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // body { padding-top: 4.5rem }
    return const NavbarExampleBody(
      paddingTop: 72,
      child: NavbarExampleMain(
        title: 'Navbar example',
        lead:
            'This example is a quick exercise to illustrate how fixed to top '
            'navbar works. As you scroll, it will remain fixed to the top of '
            'your browser’s viewport.',
      ),
    );
  }
}
