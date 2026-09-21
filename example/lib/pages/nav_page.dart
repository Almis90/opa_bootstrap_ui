import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'demo_page.dart';

class NavPage extends StatefulWidget {
  const NavPage({super.key});

  @override
  State<NavPage> createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  int _tabsIndex = 0;
  int _pillsIndex = 0;
  int _underlineIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Navs and tabs',
      children: [
        DemoSection(
          title: 'Tabs, with tab content',
          child: Column(
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
        DemoSection(
          title: 'Pills',
          child: BsNav(
            variant: BsNavVariant.pills,
            items: _demoItems(_pillsIndex, (i) => setState(() => _pillsIndex = i)),
          ),
        ),
        DemoSection(
          title: 'Underline',
          child: BsNav(
            variant: BsNavVariant.underline,
            items: _demoItems(_underlineIndex, (i) => setState(() => _underlineIndex = i)),
          ),
        ),
        DemoSection(
          title: 'Disabled item',
          child: BsNav(
            variant: BsNavVariant.tabs,
            items: [
              BsNavItem(child: const Text('Active'), active: true, onTap: () {}),
              BsNavItem(child: const Text('Link'), onTap: () {}),
              const BsNavItem(child: Text('Disabled'), disabled: true),
            ],
          ),
        ),
        DemoSection(
          title: 'Fill (equal width)',
          child: BsNav(
            variant: BsNavVariant.tabs,
            fill: true,
            items: _demoItems(0, (_) {}),
          ),
        ),
        DemoSection(
          title: 'Vertical pills',
          child: BsNav(
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
