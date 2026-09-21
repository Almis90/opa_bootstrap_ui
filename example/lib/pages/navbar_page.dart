import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'demo_page.dart';

class NavbarPage extends StatelessWidget {
  const NavbarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Navbar',
      children: [
        DemoSection(
          title: 'Basic (collapses at this width)',
          child: BsNavbar(
            background: BsColors.gray100,
            brand: const Text('Navbar'),
            items: [
              BsNavbarItem(child: const Text('Home'), active: true, onTap: () {}),
              BsNavbarItem(child: const Text('Features'), onTap: () {}),
              BsNavbarItem(child: const Text('Pricing'), onTap: () {}),
              const BsNavbarItem(child: Text('Disabled'), disabled: true),
            ],
          ),
        ),
        DemoSection(
          title: 'Dark, colored background',
          child: BsNavbar(
            colorScheme: BsNavbarColorScheme.dark,
            background: BsColors.gray900,
            brand: const Text('Navbar'),
            items: [
              BsNavbarItem(child: const Text('Home'), active: true, onTap: () {}),
              BsNavbarItem(child: const Text('Features'), onTap: () {}),
              BsNavbarItem(child: const Text('Pricing'), onTap: () {}),
            ],
          ),
        ),
        DemoSection(
          title: 'Never expands',
          child: BsNavbar(
            expandBreakpoint: null,
            background: BsColors.gray100,
            brand: const Text('Navbar'),
            items: [
              BsNavbarItem(child: const Text('Home'), onTap: () {}),
              BsNavbarItem(child: const Text('Features'), onTap: () {}),
            ],
          ),
        ),
        DemoSection(
          title: 'Expanded (wide enough container)',
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 1000,
              child: BsNavbar(
                background: BsColors.gray100,
                brand: const Text('Navbar'),
                items: [
                  BsNavbarItem(child: const Text('Home'), active: true, onTap: () {}),
                  BsNavbarItem(child: const Text('Features'), onTap: () {}),
                  BsNavbarItem(child: const Text('Pricing'), onTap: () {}),
                ],
                trailing: [BsButton(outline: true, onPressed: () {}, child: const Text('Sign in'))],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
