import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';
import '../../src/doc_style_table.dart';

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
          description:
              'BsDropdownHeader labels a group, BsDropdownDivider separates groups, and disabled: true mutes an item.',
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
              toggleBuilder: (context, toggle, isOpen) =>
                  BsButton(onPressed: toggle, child: _toggleLabel('End-aligned')),
              items: const [
                BsDropdownItem(child: Text('Action')),
                BsDropdownItem(child: Text('Another action')),
              ],
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
            toggleBuilder: (context, toggle, isOpen) =>
                BsButton(onPressed: toggle, child: _toggleLabel('Dark dropdown')),
            items: const [
              BsDropdownItem(child: Text('Action'), active: true),
              BsDropdownItem(child: Text('Another action')),
              BsDropdownDivider(),
              BsDropdownItem(child: Text('Something else here')),
            ],
          ),
        ),
        DocExample(
          title: 'Programmatic control',
          description:
              'A BsDropdownController lets code outside the dropdown show(), hide(), toggle(), enable()/disable() '
              'it, and override its items or direction with setItems()/setDirection() — all independent of the '
              "dropdown's own toggle. Clicking any button below while the menu is open closes it first, the same "
              'as clicking anywhere else outside it would — the change still applies, so Show it again afterward '
              'to see it.',
          code: '''
final controller = BsDropdownController();

Column(
  children: [
    Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        BsButton(onPressed: controller.show, child: Text('Show')),
        BsButton(onPressed: controller.hide, child: Text('Hide')),
        BsButton(onPressed: controller.toggle, child: Text('Toggle')),
        BsButton(onPressed: controller.disable, child: Text('Disable')),
        BsButton(onPressed: controller.enable, child: Text('Enable')),
        BsButton(
          onPressed: () => controller.setItems([BsDropdownItem(child: Text('Updated item'))]),
          child: Text('Change items'),
        ),
        BsButton(
          onPressed: () => controller.setDirection(BsDropdownDirection.up),
          child: Text('Change direction'),
        ),
      ],
    ),
    BsDropdown(
      controller: controller,
      items: [BsDropdownItem(child: Text('Original item'))],
      toggleBuilder: (context, toggle, isOpen) =>
          BsButton(onPressed: toggle, child: Text('Click, or use the buttons above')),
    ),
  ],
)''',
          preview: const _ControllerDemo(),
        ),
        DocExample(
          title: 'Events',
          description:
              'onShow/onHide fire immediately once an open or close is triggered; onShown/onHidden fire right '
              'after — BsDropdown has no open/close animation to wait on — mirroring Bootstrap\'s '
              "show.bs.dropdown/shown.bs.dropdown/hide.bs.dropdown/hidden.bs.dropdown.",
          code: '''
BsDropdown(
  items: [BsDropdownItem(child: Text('Item'))],
  onShow: () => log('show'),
  onShown: () => log('shown'),
  onHide: () => log('hide'),
  onHidden: () => log('hidden'),
  toggleBuilder: (context, toggle, isOpen) => BsButton(onPressed: toggle, child: Text('Click me')),
)''',
          preview: const _EventsDemo(),
        ),
      ],
      children: const [
        DocStyleTable(
          styleClass: 'BsDropdownStyle',
          defaultsNote:
              'Fields reading an ambient --bs-* custom property in Bootstrap (color, background, borderColor, '
              'dividerColor, linkColor, linkHoverColor, linkHoverBackground, linkDisabledColor) swap for their '
              'dark-theme counterparts when BsTheme.of(context) is Brightness.dark. That\'s separate from '
              'BsDropdownStyle.dark, a distinct literal palette for .dropdown-menu-dark — pass it as style to force '
              'a dark-looking menu regardless of page theme, rather than following it.',
          rows: [
            DocStyleRow(field: 'minWidth', defaultValue: '160'),
            DocStyleRow(field: 'padding', defaultValue: 'EdgeInsets.symmetric(vertical: 8)'),
            DocStyleRow(field: 'spacer', defaultValue: '2'),
            DocStyleRow(field: 'fontSize', defaultValue: '16'),
            DocStyleRow(field: 'color', defaultValue: 'BsColors.gray900'),
            DocStyleRow(field: 'background', defaultValue: 'BsColors.white'),
            DocStyleRow(field: 'borderColor', defaultValue: 'Black at ~18% opacity'),
            DocStyleRow(field: 'borderRadius', defaultValue: '6'),
            DocStyleRow(field: 'borderWidth', defaultValue: '1'),
            DocStyleRow(field: 'dividerColor', defaultValue: 'Black at ~18% opacity; same as borderColor'),
            DocStyleRow(field: 'dividerMarginY', defaultValue: '8'),
            DocStyleRow(field: 'boxShadow', defaultValue: 'Black at ~15% opacity, offset (0, 8), 16 blur'),
            DocStyleRow(field: 'linkColor', defaultValue: 'BsColors.gray900; same as color'),
            DocStyleRow(field: 'linkHoverColor', defaultValue: 'BsColors.gray900; same as color'),
            DocStyleRow(field: 'linkHoverBackground', defaultValue: 'BsColors.gray100'),
            DocStyleRow(field: 'linkActiveColor', defaultValue: 'BsColors.white'),
            DocStyleRow(field: 'linkActiveBackground', defaultValue: 'BsVariant.primary.color (BsColors.blue)'),
            DocStyleRow(field: 'linkDisabledColor', defaultValue: 'BsColors.gray400'),
            DocStyleRow(field: 'itemPadding', defaultValue: 'EdgeInsets.symmetric(horizontal: 16, vertical: 4)'),
            DocStyleRow(field: 'headerColor', defaultValue: 'BsColors.gray600'),
            DocStyleRow(field: 'headerPadding', defaultValue: 'EdgeInsets.symmetric(horizontal: 16, vertical: 8)'),
          ],
        ),
      ],
    );
  }

  static Widget _directionDropdown(String label, BsDropdownDirection direction) {
    return BsDropdown(
      direction: direction,
      toggleBuilder: (context, toggle, isOpen) => BsButton(onPressed: toggle, child: _toggleLabel(label)),
      items: const [
        BsDropdownItem(child: Text('Action')),
        BsDropdownItem(child: Text('Another action')),
      ],
    );
  }

  static Widget _toggleLabel(String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(text),
        const SizedBox(width: 8),
        const BsDropdownCaret(color: BsColors.white),
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
  late final BsDropdownController _controller = BsDropdownController();
  bool _itemsChanged = false;
  int _directionIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleItems() {
    _itemsChanged = !_itemsChanged;
    _controller.setItems(_itemsChanged ? const [BsDropdownItem(child: Text('Updated item'))] : null);
  }

  void _cycleDirection() {
    _directionIndex = (_directionIndex + 1) % BsDropdownDirection.values.length;
    _controller.setDirection(BsDropdownDirection.values[_directionIndex]);
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
            BsButton(size: BsSize.sm, onPressed: _controller.show, child: const Text('Show')),
            BsButton(size: BsSize.sm, onPressed: _controller.hide, child: const Text('Hide')),
            BsButton(size: BsSize.sm, onPressed: _controller.toggle, child: const Text('Toggle')),
            BsButton(
              size: BsSize.sm,
              variant: BsVariant.secondary,
              onPressed: _controller.disable,
              child: const Text('Disable'),
            ),
            BsButton(
              size: BsSize.sm,
              variant: BsVariant.secondary,
              onPressed: _controller.enable,
              child: const Text('Enable'),
            ),
            BsButton(
              size: BsSize.sm,
              variant: BsVariant.secondary,
              onPressed: _toggleItems,
              child: const Text('Change items'),
            ),
            BsButton(
              size: BsSize.sm,
              variant: BsVariant.secondary,
              onPressed: _cycleDirection,
              child: const Text('Change direction'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        BsDropdown(
          controller: _controller,
          items: const [BsDropdownItem(child: Text('Original item'))],
          toggleBuilder: (context, toggle, isOpen) =>
              BsButton(onPressed: toggle, child: const Text('Click, or use the buttons above')),
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
        BsDropdown(
          items: const [BsDropdownItem(child: Text('Item'))],
          onShow: () => _log('show'),
          onShown: () => _log('shown'),
          onHide: () => _log('hide'),
          onHidden: () => _log('hidden'),
          toggleBuilder: (context, toggle, isOpen) => BsButton(onPressed: toggle, child: const Text('Click me')),
        ),
        const SizedBox(height: 16),
        if (_events.isEmpty)
          Text('No events yet — click the button above.', style: TextStyle(color: BsBody.secondaryColorOf(context)))
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
