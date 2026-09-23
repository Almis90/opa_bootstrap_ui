import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

class ListGroupPage extends StatelessWidget {
  const ListGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'List group',
      lead:
          'BsListGroup renders a bordered stack of BsListGroupItem rows, each optionally active, disabled, '
          'tappable, or tinted with a BsVariant — a flexible base for simple lists, selectable menus, or feeds.',
      examples: [
        DocExample(
          title: 'Basic',
          description: 'A plain, non-interactive list of items with shared borders.',
          code: '''
BsListGroup(
  items: [
    BsListGroupItem(child: Text('An item')),
    BsListGroupItem(child: Text('A second item')),
    BsListGroupItem(child: Text('A third item')),
  ],
)''',
          preview: BsListGroup(
            items: const [
              BsListGroupItem(child: Text('An item')),
              BsListGroupItem(child: Text('A second item')),
              BsListGroupItem(child: Text('A third item')),
            ],
          ),
        ),
        DocExample(
          title: 'Active and disabled items',
          description: 'active highlights the current item; disabled mutes it and blocks interaction.',
          code: '''
BsListGroup(
  items: [
    BsListGroupItem(child: Text('An active item'), active: true),
    BsListGroupItem(child: Text('A regular item')),
    BsListGroupItem(child: Text('A disabled item'), disabled: true),
  ],
)''',
          preview: BsListGroup(
            items: const [
              BsListGroupItem(child: Text('An active item'), active: true),
              BsListGroupItem(child: Text('A regular item')),
              BsListGroupItem(child: Text('A disabled item'), disabled: true),
            ],
          ),
        ),
        DocExample(
          title: 'Actionable items',
          description: 'onTap turns an item into a hoverable, tappable action row.',
          code: '''
BsListGroup(
  items: [
    BsListGroupItem(child: Text('Tap me'), onTap: () {}),
    BsListGroupItem(child: Text('Tap me too'), onTap: () {}),
    BsListGroupItem(child: Text('A disabled action'), disabled: true),
  ],
)''',
          preview: BsListGroup(
            items: [
              BsListGroupItem(child: const Text('Tap me'), onTap: () {}),
              BsListGroupItem(child: const Text('Tap me too'), onTap: () {}),
              const BsListGroupItem(child: Text('A disabled action'), disabled: true),
            ],
          ),
        ),
        DocExample(
          title: 'Contextual variants',
          description: 'variant tints an individual item with a BsVariant background/text pairing.',
          code: '''
BsListGroup(
  items: [
    BsListGroupItem(child: Text('Primary')),
    BsListGroupItem(child: Text('Success'), variant: BsVariant.success),
    BsListGroupItem(child: Text('Danger'), variant: BsVariant.danger),
    BsListGroupItem(child: Text('Warning'), variant: BsVariant.warning),
  ],
)''',
          preview: BsListGroup(
            items: const [
              BsListGroupItem(child: Text('Primary')),
              BsListGroupItem(child: Text('Success'), variant: BsVariant.success),
              BsListGroupItem(child: Text('Danger'), variant: BsVariant.danger),
              BsListGroupItem(child: Text('Warning'), variant: BsVariant.warning),
            ],
          ),
        ),
        DocExample(
          title: 'Numbered',
          description: 'numbered: true prefixes each item with an automatically incrementing index.',
          code: '''
BsListGroup(
  numbered: true,
  items: [
    BsListGroupItem(child: Text('A numbered item')),
    BsListGroupItem(child: Text('A second numbered item')),
    BsListGroupItem(child: Text('A third numbered item')),
  ],
)''',
          preview: BsListGroup(
            numbered: true,
            items: const [
              BsListGroupItem(child: Text('A numbered item')),
              BsListGroupItem(child: Text('A second numbered item')),
              BsListGroupItem(child: Text('A third numbered item')),
            ],
          ),
        ),
        DocExample(
          title: 'Flush',
          description: 'flush: true removes the outer border and rounded corners for edge-to-edge layouts.',
          code: '''
BsListGroup(
  flush: true,
  items: [
    BsListGroupItem(child: Text('An item')),
    BsListGroupItem(child: Text('A second item')),
    BsListGroupItem(child: Text('A third item')),
  ],
)''',
          preview: BsListGroup(
            flush: true,
            items: const [
              BsListGroupItem(child: Text('An item')),
              BsListGroupItem(child: Text('A second item')),
              BsListGroupItem(child: Text('A third item')),
            ],
          ),
        ),
        DocExample(
          title: 'Horizontal',
          description: 'orientation: BsListGroupOrientation.horizontal lays items out in a row instead of a column.',
          code: '''
BsListGroup(
  orientation: BsListGroupOrientation.horizontal,
  items: [
    BsListGroupItem(child: Text('An item')),
    BsListGroupItem(child: Text('A second item')),
    BsListGroupItem(child: Text('A third item')),
  ],
)''',
          preview: BsListGroup(
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
