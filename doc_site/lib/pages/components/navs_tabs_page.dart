import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

class NavsTabsPage extends StatefulWidget {
  const NavsTabsPage({super.key});

  @override
  State<NavsTabsPage> createState() => _NavsTabsPageState();
}

class _NavsTabsPageState extends State<NavsTabsPage> {
  int _tabsIndex = 0;
  int _pillsIndex = 0;
  int _underlineIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Navs & tabs',
      lead:
          'BsNav renders a row (or column) of BsNavItems in one of three visual variants — tabs, pills, or '
          'underline — and BsTabView swaps its children based on an activeIndex, the same split Bootstrap '
          'makes between its .nav markup and the .tab-pane content it controls.',
      examples: [
        DocExample(
          title: 'Tabs, with tab content',
          description: 'BsNavVariant.tabs paired with a BsTabView whose activeIndex tracks the selected nav item.',
          code: '''
BsNav(
  variant: BsNavVariant.tabs,
  items: [
    BsNavItem(child: Text('Home'), active: tabsIndex == 0, onTap: () => select(0)),
    BsNavItem(child: Text('Profile'), active: tabsIndex == 1, onTap: () => select(1)),
    BsNavItem(child: Text('Contact'), active: tabsIndex == 2, onTap: () => select(2)),
  ],
),
BsTabView(
  activeIndex: tabsIndex,
  children: [
    Text('Content for Home.'),
    Text('Content for Profile.'),
    Text('Content for Contact.'),
  ],
)''',
          preview: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BsNav(
                variant: BsNavVariant.tabs,
                items: _demoItems(_tabsIndex, (i) => setState(() => _tabsIndex = i)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: BsTabView(
                  activeIndex: _tabsIndex,
                  children: const [
                    Text('Content for Home.'),
                    Text('Content for Profile.'),
                    Text('Content for Contact.'),
                  ],
                ),
              ),
            ],
          ),
        ),
        DocExample(
          title: 'Pills',
          description: 'BsNavVariant.pills renders items as filled, rounded pills instead of bordered tabs.',
          code: '''
BsNav(
  variant: BsNavVariant.pills,
  items: [
    BsNavItem(child: Text('Home'), active: pillsIndex == 0, onTap: () => select(0)),
    BsNavItem(child: Text('Profile'), active: pillsIndex == 1, onTap: () => select(1)),
    BsNavItem(child: Text('Contact'), active: pillsIndex == 2, onTap: () => select(2)),
  ],
)''',
          preview: BsNav(
            variant: BsNavVariant.pills,
            items: _demoItems(_pillsIndex, (i) => setState(() => _pillsIndex = i)),
          ),
        ),
        DocExample(
          title: 'Underline',
          description: 'BsNavVariant.underline draws a thin indicator line beneath the active item instead of a background.',
          code: '''
BsNav(
  variant: BsNavVariant.underline,
  items: [...],
)''',
          preview: BsNav(
            variant: BsNavVariant.underline,
            items: _demoItems(_underlineIndex, (i) => setState(() => _underlineIndex = i)),
          ),
        ),
        DocExample(
          title: 'Disabled item',
          description: 'disabled: true on a BsNavItem dims it and ignores taps, regardless of variant.',
          code: '''
BsNav(
  variant: BsNavVariant.tabs,
  items: [
    BsNavItem(child: Text('Active'), active: true, onTap: () {}),
    BsNavItem(child: Text('Link'), onTap: () {}),
    BsNavItem(child: Text('Disabled'), disabled: true),
  ],
)''',
          preview: BsNav(
            variant: BsNavVariant.tabs,
            items: [
              BsNavItem(child: const Text('Active'), active: true, onTap: () {}),
              BsNavItem(child: const Text('Link'), onTap: () {}),
              const BsNavItem(child: Text('Disabled'), disabled: true),
            ],
          ),
        ),
        DocExample(
          title: 'Fill (equal width)',
          description: 'fill: true stretches each item to share the available width equally.',
          code: '''
BsNav(
  variant: BsNavVariant.tabs,
  fill: true,
  items: [...],
)''',
          preview: BsNav(
            variant: BsNavVariant.tabs,
            fill: true,
            items: _demoItems(0, (_) {}),
          ),
        ),
        DocExample(
          title: 'Vertical pills',
          description: 'vertical: true stacks items in a column, useful alongside a scrollspy or tab content pane.',
          code: '''
BsNav(
  variant: BsNavVariant.pills,
  vertical: true,
  items: [...],
)''',
          preview: BsNav(
            variant: BsNavVariant.pills,
            vertical: true,
            items: _demoItems(0, (_) {}),
          ),
        ),
      ],
    );
  }

  List<BsNavItem> _demoItems(int activeIndex, ValueChanged<int> onSelect) {
    const labels = ['Home', 'Profile', 'Contact'];
    return [
      for (var i = 0; i < labels.length; i++)
        BsNavItem(child: Text(labels[i]), active: i == activeIndex, onTap: () => onSelect(i)),
    ];
  }
}
