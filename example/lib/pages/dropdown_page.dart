import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'demo_page.dart';

class DropdownPage extends StatelessWidget {
  const DropdownPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Dropdown',
      children: [
        DemoSection(title: 'Basic', child: _basicDropdown()),
        DemoSection(
          title: 'Header, divider and disabled item',
          child: BsDropdown(
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
        DemoSection(
          title: 'Menu end-aligned',
          child: Align(
            alignment: Alignment.centerRight,
            child: BsDropdown(
              alignEnd: true,
              toggleBuilder: (context, toggle, isOpen) => BsButton(onPressed: toggle, child: _toggleLabel('End-aligned')),
              items: const [
                BsDropdownItem(child: Text('Action')),
                BsDropdownItem(child: Text('Another action')),
              ],
            ),
          ),
        ),
        DemoSection(
          title: 'Directions',
          child: Row(
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
        DemoSection(
          title: 'Dark menu',
          child: BsDropdown(
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

  Widget _basicDropdown() {
    return BsDropdown(
      toggleBuilder: (context, toggle, isOpen) => BsButton(onPressed: toggle, child: _toggleLabel('Dropdown button')),
      items: [
        BsDropdownItem(child: const Text('Action'), onTap: () {}),
        BsDropdownItem(child: const Text('Another action'), onTap: () {}),
        BsDropdownItem(child: const Text('Something else here'), onTap: () {}),
      ],
    );
  }

  Widget _directionDropdown(String label, BsDropdownDirection direction) {
    return BsDropdown(
      direction: direction,
      toggleBuilder: (context, toggle, isOpen) => BsButton(onPressed: toggle, child: _toggleLabel(label)),
      items: const [
        BsDropdownItem(child: Text('Action')),
        BsDropdownItem(child: Text('Another action')),
      ],
    );
  }

  Widget _toggleLabel(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [Text(text), const SizedBox(width: 8), const BsDropdownCaret(color: BsColors.white)],
    );
  }
}
