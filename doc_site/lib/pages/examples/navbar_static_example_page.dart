import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/example_navbar_page.dart';

/// The "Top navbar" example (`examples/navbar-static`): a `.navbar
/// .navbar-expand-md.bg-dark.mb-4` in the page's flow, above a jumbotron.
class NavbarStaticExamplePage extends StatelessWidget {
  const NavbarStaticExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    return NavbarExampleBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // <nav class="navbar navbar-expand-md bg-dark mb-4" data-bs-theme="dark">
          BsBox(
            mb: BsSpacing.s4,
            child: NavbarExampleBar(
              brand: 'Top navbar',
              expandBreakpoint: BsBreakpoint.md,
              items: navbarExampleItems(),
              trailing: const [NavbarSearchForm()],
            ),
          ),
          const NavbarExampleMain(
            title: 'Navbar example',
            lead:
                'This example is a quick exercise to illustrate how the '
                'top-aligned navbar works. As you scroll, this navbar remains '
                'in its original position and moves with the rest of the page.',
          ),
        ],
      ),
    );
  }
}
