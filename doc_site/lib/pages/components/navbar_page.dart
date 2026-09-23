import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

class NavbarPage extends StatelessWidget {
  const NavbarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Navbar',
      lead:
          'BsNavbar lays out a brand, a row of BsNavbarItems, and optional trailing widgets in a header bar, '
          'collapsing everything behind a hamburger toggle below its expandBreakpoint.',
      examples: [
        DocExample(
          title: 'Basic',
          description: 'At narrow widths, the brand row and items collapse behind a toggler button.',
          code: '''
BsNavbar(
  background: BsColors.gray100,
  brand: Text('Navbar'),
  items: [
    BsNavbarItem(child: Text('Home'), active: true, onTap: () {}),
    BsNavbarItem(child: Text('Features'), onTap: () {}),
    BsNavbarItem(child: Text('Pricing'), onTap: () {}),
    BsNavbarItem(child: Text('Disabled'), disabled: true),
  ],
)''',
          preview: BsNavbar(
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
        DocExample(
          title: 'Dark, colored background',
          description: 'colorScheme: BsNavbarColorScheme.dark switches the text/toggler contrast for a dark background.',
          code: '''
BsNavbar(
  colorScheme: BsNavbarColorScheme.dark,
  background: BsColors.gray900,
  brand: Text('Navbar'),
  items: [
    BsNavbarItem(child: Text('Home'), active: true, onTap: () {}),
    BsNavbarItem(child: Text('Features'), onTap: () {}),
    BsNavbarItem(child: Text('Pricing'), onTap: () {}),
  ],
)''',
          preview: BsNavbar(
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
        DocExample(
          title: 'Never expands',
          description: 'Passing expandBreakpoint: null keeps the navbar collapsed behind the toggler at every width.',
          code: '''
BsNavbar(
  expandBreakpoint: null,
  background: BsColors.gray100,
  brand: Text('Navbar'),
  items: [
    BsNavbarItem(child: Text('Home'), onTap: () {}),
    BsNavbarItem(child: Text('Features'), onTap: () {}),
  ],
)''',
          preview: BsNavbar(
            expandBreakpoint: null,
            background: BsColors.gray100,
            brand: const Text('Navbar'),
            items: [
              BsNavbarItem(child: const Text('Home'), onTap: () {}),
              BsNavbarItem(child: const Text('Features'), onTap: () {}),
            ],
          ),
        ),
        DocExample(
          title: 'Trailing content',
          description: 'trailing renders extra widgets, such as a sign-in button, after the nav items.',
          code: '''
BsNavbar(
  background: BsColors.gray100,
  brand: Text('Navbar'),
  items: [
    BsNavbarItem(child: Text('Home'), active: true, onTap: () {}),
    BsNavbarItem(child: Text('Features'), onTap: () {}),
    BsNavbarItem(child: Text('Pricing'), onTap: () {}),
  ],
  trailing: [BsButton(outline: true, onPressed: () {}, child: Text('Sign in'))],
)''',
          preview: SizedBox(
            width: 700,
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
      ],
    );
  }
}
