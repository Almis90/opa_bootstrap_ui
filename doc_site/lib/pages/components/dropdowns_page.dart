import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

class DropdownsPage extends StatelessWidget {
  const DropdownsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Dropdowns',
      lead:
          'BsDropdown pairs a toggleBuilder — any widget that calls the given toggle callback — with an overlay '
          'menu of BsDropdownItem/BsDropdownHeader/BsDropdownDivider entries, positioned relative to the toggle.',
      examples: [
        DocExample(
          title: 'Basic',
          description: 'toggleBuilder receives the toggle callback and current open state to build the trigger widget.',
          code: '''
BsDropdown(
  toggleBuilder: (context, toggle, isOpen) => BsButton(
    onPressed: toggle,
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [Text('Dropdown button'), SizedBox(width: 8), BsDropdownCaret(color: BsColors.white)],
    ),
  ),
  items: [
    BsDropdownItem(child: Text('Action'), onTap: () {}),
    BsDropdownItem(child: Text('Another action'), onTap: () {}),
    BsDropdownItem(child: Text('Something else here'), onTap: () {}),
  ],
)''',
          preview: BsDropdown(
            toggleBuilder: (context, toggle, isOpen) =>
                BsButton(onPressed: toggle, child: _toggleLabel('Dropdown button')),
            items: [
              BsDropdownItem(child: const Text('Action'), onTap: () {}),
              BsDropdownItem(child: const Text('Another action'), onTap: () {}),
              BsDropdownItem(child: const Text('Something else here'), onTap: () {}),
            ],
          ),
        ),
        DocExample(
          title: 'Header, divider and disabled item',
          description: 'BsDropdownHeader labels a group, BsDropdownDivider separates groups, and disabled: true mutes an item.',
          code: '''
BsDropdown(
  toggleBuilder: (context, toggle, isOpen) => BsButton(onPressed: toggle, child: ...),
  items: [
    BsDropdownHeader(child: Text('Header')),
    BsDropdownItem(child: Text('Active item'), active: true),
    BsDropdownItem(child: Text('A regular item')),
    BsDropdownDivider(),
    BsDropdownItem(child: Text('Disabled item'), disabled: true),
  ],
)''',
          preview: BsDropdown(
            toggleBuilder: (context, toggle, isOpen) => BsButton(onPressed: toggle, child: _toggleLabel('Actions')),
            items: const [
              BsDropdownHeader(child: Text('Header')),
              BsDropdownItem(child: Text('Active item'), active: true),
              BsDropdownItem(child: Text('A regular item')),
              BsDropdownDivider(),
              BsDropdownItem(child: Text('Disabled item'), disabled: true),
            ],
          ),
        ),
        DocExample(
          title: 'Menu end-aligned',
          description: 'alignEnd: true right-aligns the menu against the toggle instead of the default left alignment.',
          code: '''
BsDropdown(
  alignEnd: true,
  toggleBuilder: (context, toggle, isOpen) => BsButton(onPressed: toggle, child: ...),
  items: [
    BsDropdownItem(child: Text('Action')),
    BsDropdownItem(child: Text('Another action')),
  ],
)''',
          preview: Align(
            alignment: Alignment.centerRight,
            child: BsDropdown(
              alignEnd: true,
              toggleBuilder: (context, toggle, isOpen) => BsButton(onPressed: toggle, child: _toggleLabel('End-aligned')),
              items: const [BsDropdownItem(child: Text('Action')), BsDropdownItem(child: Text('Another action'))],
            ),
          ),
        ),
        DocExample(
          title: 'Directions',
          description: 'direction controls which side of the toggle the menu opens toward: up, start, or end.',
          code: '''
BsDropdown(
  direction: BsDropdownDirection.up,
  toggleBuilder: (context, toggle, isOpen) => BsButton(onPressed: toggle, child: ...),
  items: [
    BsDropdownItem(child: Text('Action')),
    BsDropdownItem(child: Text('Another action')),
  ],
)''',
          preview: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _directionDropdown('Dropup', BsDropdownDirection.up),
              const SizedBox(width: 16),
              _directionDropdown('Dropstart', BsDropdownDirection.start),
              const SizedBox(width: 16),
              _directionDropdown('Dropend', BsDropdownDirection.end),
            ],
          ),
        ),
        DocExample(
          title: 'Dark menu',
          description: 'style: BsDropdownStyle.dark swaps the menu to a dark background with light text.',
          code: '''
BsDropdown(
  style: BsDropdownStyle.dark,
  toggleBuilder: (context, toggle, isOpen) => BsButton(onPressed: toggle, child: ...),
  items: [
    BsDropdownItem(child: Text('Action'), active: true),
    BsDropdownItem(child: Text('Another action')),
    BsDropdownDivider(),
    BsDropdownItem(child: Text('Something else here')),
  ],
)''',
          preview: BsDropdown(
            style: BsDropdownStyle.dark,
            toggleBuilder: (context, toggle, isOpen) => BsButton(onPressed: toggle, child: _toggleLabel('Dark dropdown')),
            items: const [
              BsDropdownItem(child: Text('Action'), active: true),
              BsDropdownItem(child: Text('Another action')),
              BsDropdownDivider(),
              BsDropdownItem(child: Text('Something else here')),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _directionDropdown(String label, BsDropdownDirection direction) {
    return BsDropdown(
      direction: direction,
      toggleBuilder: (context, toggle, isOpen) => BsButton(onPressed: toggle, child: _toggleLabel(label)),
      items: const [BsDropdownItem(child: Text('Action')), BsDropdownItem(child: Text('Another action'))],
    );
  }

  static Widget _toggleLabel(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [Text(text), const SizedBox(width: 8), const BsDropdownCaret(color: BsColors.white)],
    );
  }
}
