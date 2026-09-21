import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'demo_page.dart';

class ListGroupPage extends StatelessWidget {
  const ListGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'List group',
      children: [
        DemoSection(
          title: 'Basic',
          child: BsListGroup(
            items: const [
              BsListGroupItem(child: Text('An item')),
              BsListGroupItem(child: Text('A second item')),
              BsListGroupItem(child: Text('A third item')),
            ],
          ),
        ),
        DemoSection(
          title: 'Active and disabled items',
          child: BsListGroup(
            items: const [
              BsListGroupItem(child: Text('An active item'), active: true),
              BsListGroupItem(child: Text('A regular item')),
              BsListGroupItem(child: Text('A disabled item'), disabled: true),
            ],
          ),
        ),
        DemoSection(
          title: 'Actionable items',
          child: BsListGroup(
            items: [
              BsListGroupItem(child: const Text('Tap me'), onTap: () {}),
              BsListGroupItem(child: const Text('Tap me too'), onTap: () {}),
              const BsListGroupItem(child: Text('A disabled action'), disabled: true),
            ],
          ),
        ),
        DemoSection(
          title: 'Contextual variants',
          child: BsListGroup(
            items: const [
              BsListGroupItem(child: Text('Primary')),
              BsListGroupItem(child: Text('Success'), variant: BsVariant.success),
              BsListGroupItem(child: Text('Danger'), variant: BsVariant.danger),
              BsListGroupItem(child: Text('Warning'), variant: BsVariant.warning),
            ],
          ),
        ),
        DemoSection(
          title: 'Numbered',
          child: BsListGroup(
            numbered: true,
            items: const [
              BsListGroupItem(child: Text('A numbered item')),
              BsListGroupItem(child: Text('A second numbered item')),
              BsListGroupItem(child: Text('A third numbered item')),
            ],
          ),
        ),
        DemoSection(
          title: 'Flush',
          child: BsListGroup(
            flush: true,
            items: const [
              BsListGroupItem(child: Text('An item')),
              BsListGroupItem(child: Text('A second item')),
              BsListGroupItem(child: Text('A third item')),
            ],
          ),
        ),
        DemoSection(
          title: 'Horizontal',
          child: BsListGroup(
            orientation: BsListGroupOrientation.horizontal,
            items: const [
              BsListGroupItem(child: Text('An item')),
              BsListGroupItem(child: Text('A second item')),
              BsListGroupItem(child: Text('A third item')),
            ],
          ),
        ),
      ],
    );
  }
}
