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
          description:
              'colorScheme: BsNavbarColorScheme.dark switches the text/toggler contrast for a dark background.',
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
        DocExample(
          title: 'Programmatic control',
          description:
              'A BsCollapseController passed as collapseController lets code outside expand(), collapse(), or '
              "toggle() the mobile menu — the same controller BsCollapse itself takes, since BsNavbar's mobile "
              'menu is a BsCollapse under the hood.',
          code: '''
final controller = BsCollapseController();

Column(
  children: [
    Wrap(
      spacing: 8,
      children: [
        BsButton(onPressed: controller.expand, child: Text('Open menu')),
        BsButton(onPressed: controller.collapse, child: Text('Close menu')),
        BsButton(onPressed: controller.toggle, child: Text('Toggle menu')),
      ],
    ),
    BsNavbar(
      expandBreakpoint: null, // always collapsed, so the demo stays visible
      collapseController: controller,
      background: BsColors.gray100,
      brand: Text('Navbar'),
      items: [
        BsNavbarItem(child: Text('Home'), active: true, onTap: () {}),
        BsNavbarItem(child: Text('Features'), onTap: () {}),
      ],
    ),
  ],
)''',
          preview: const _ControllerDemo(),
        ),
        DocExample(
          title: 'Events',
          description:
              'onShow/onHide fire immediately once the mobile menu is triggered open/closed; onShown/onHidden '
              "fire once the collapse animation actually finishes — mirroring BsCollapse's own events (and, "
              "through it, Bootstrap's show.bs.collapse/shown.bs.collapse/hide.bs.collapse/hidden.bs.collapse).",
          code: '''
BsNavbar(
  expandBreakpoint: null,
  background: BsColors.gray100,
  brand: Text('Navbar'),
  items: [BsNavbarItem(child: Text('Home'), onTap: () {})],
  onShow: () => log('show'),
  onShown: () => log('shown'),
  onHide: () => log('hide'),
  onHidden: () => log('hidden'),
)''',
          preview: const _EventsDemo(),
        ),
      ],
    );
  }
}

class _ControllerDemo extends StatefulWidget {
  const _ControllerDemo();

  @override
  State<_ControllerDemo> createState() => _ControllerDemoState();
}

class _ControllerDemoState extends State<_ControllerDemo> {
  late final BsCollapseController _controller = BsCollapseController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            BsButton(size: BsSize.sm, onPressed: _controller.expand, child: const Text('Open menu')),
            BsButton(size: BsSize.sm, onPressed: _controller.collapse, child: const Text('Close menu')),
            BsButton(size: BsSize.sm, onPressed: _controller.toggle, child: const Text('Toggle menu')),
          ],
        ),
        const SizedBox(height: 12),
        BsNavbar(
          expandBreakpoint: null,
          collapseController: _controller,
          background: BsColors.gray100,
          brand: const Text('Navbar'),
          items: [
            BsNavbarItem(child: const Text('Home'), active: true, onTap: () {}),
            BsNavbarItem(child: const Text('Features'), onTap: () {}),
          ],
        ),
      ],
    );
  }
}

class _EventsDemo extends StatefulWidget {
  const _EventsDemo();

  @override
  State<_EventsDemo> createState() => _EventsDemoState();
}

class _EventsDemoState extends State<_EventsDemo> {
  final _events = <String>[];

  void _log(String event) => setState(() => _events.add(event));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BsNavbar(
          expandBreakpoint: null,
          background: BsColors.gray100,
          brand: const Text('Navbar'),
          items: [BsNavbarItem(child: const Text('Home'), onTap: () {})],
          onShow: () => _log('show'),
          onShown: () => _log('shown'),
          onHide: () => _log('hide'),
          onHidden: () => _log('hidden'),
        ),
        const SizedBox(height: 12),
        if (_events.isEmpty)
          Text(
            'No events yet — tap the hamburger toggler above.',
            style: TextStyle(color: BsBody.secondaryColorOf(context)),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [for (final event in _events) BsBadge(variant: BsVariant.secondary, child: Text(event))],
          ),
      ],
    );
  }
}
