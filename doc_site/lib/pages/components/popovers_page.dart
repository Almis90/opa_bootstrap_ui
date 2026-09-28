import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

class PopoversPage extends StatelessWidget {
  const PopoversPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Popovers',
      lead:
          'BsPopover manages its own open/closed state internally and hands triggerBuilder a toggle callback and '
          'isOpen flag to build the trigger widget, popping up a bordered content box with an optional title '
          'near the trigger.',
      examples: [
        DocExample(
          title: 'Basic, with title',
          description: 'title and content together produce a popover with a header strip above the body text.',
          code: '''
BsPopover(
  title: Text('Popover title'),
  content: Text('And here is some amazing content. It is very engaging. Right?'),
  triggerBuilder: (context, toggle, isOpen) =>
      BsButton(onPressed: toggle, child: Text('Click to toggle popover')),
)''',
          preview: BsPopover(
            title: const Text('Popover title'),
            content: const Text('And here is some amazing content. It is very engaging. Right?'),
            triggerBuilder: (context, toggle, isOpen) =>
                BsButton(onPressed: toggle, child: const Text('Click to toggle popover')),
          ),
        ),
        DocExample(
          title: 'Without a title',
          description: 'Omitting title renders just the content, with no header strip.',
          code: '''
BsPopover(
  content: Text('This popover has no header.'),
  triggerBuilder: (context, toggle, isOpen) => BsButton(onPressed: toggle, child: Text('Toggle')),
)''',
          preview: BsPopover(
            content: const Text('This popover has no header.'),
            triggerBuilder: (context, toggle, isOpen) => BsButton(onPressed: toggle, child: const Text('Toggle')),
          ),
        ),
        DocExample(
          title: 'Placements',
          description: 'placement controls which side of the trigger the popover opens toward.',
          code: '''
BsPopover(
  placement: BsPopoverPlacement.top,
  title: Text('Top popover'),
  content: Text('Some popover content.'),
  triggerBuilder: (context, toggle, isOpen) => BsButton(onPressed: toggle, child: Text('Top')),
)''',
          preview: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              _placementPopover(BsPopoverPlacement.top, 'Top'),
              _placementPopover(BsPopoverPlacement.bottom, 'Bottom'),
              _placementPopover(BsPopoverPlacement.start, 'Start'),
              _placementPopover(BsPopoverPlacement.end, 'End'),
            ],
          ),
        ),
        DocExample(
          title: 'Programmatic control',
          description:
              'A BsPopoverController lets code outside the popover show(), hide(), toggle(), enable()/disable() '
              'it, and override its content or placement with setContent()/setPlacement() — all independent of '
              "the popover's own trigger. Clicking any button below while the popover is open closes it first, "
              'the same as clicking anywhere else outside it would — the change still applies, so Show it again '
              'afterward to see it.',
          code: '''
final controller = BsPopoverController();

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
          onPressed: () => controller.setContent(Text('Updated content')),
          child: Text('Change content'),
        ),
        BsButton(
          onPressed: () => controller.setPlacement(BsPopoverPlacement.bottom),
          child: Text('Change placement'),
        ),
      ],
    ),
    BsPopover(
      controller: controller,
      content: Text('Original content'),
      triggerBuilder: (context, toggle, isOpen) =>
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
              'after — BsPopover has no open/close animation to wait on, unlike BsTooltip\'s fade — mirroring '
              "Bootstrap's show.bs.popover/shown.bs.popover/hide.bs.popover/hidden.bs.popover.",
          code: '''
BsPopover(
  content: Text('Popover content'),
  onShow: () => log('show'),
  onShown: () => log('shown'),
  onHide: () => log('hide'),
  onHidden: () => log('hidden'),
  triggerBuilder: (context, toggle, isOpen) => BsButton(onPressed: toggle, child: Text('Click me')),
)''',
          preview: const _EventsDemo(),
        ),
      ],
    );
  }

  static Widget _placementPopover(BsPopoverPlacement placement, String label) {
    return BsPopover(
      placement: placement,
      title: Text('$label popover'),
      content: const Text('Some popover content.'),
      triggerBuilder: (context, toggle, isOpen) => BsButton(onPressed: toggle, child: Text(label)),
    );
  }
}

class _ControllerDemo extends StatefulWidget {
  const _ControllerDemo();

  @override
  State<_ControllerDemo> createState() => _ControllerDemoState();
}

class _ControllerDemoState extends State<_ControllerDemo> {
  late final BsPopoverController _controller = BsPopoverController();
  bool _contentChanged = false;
  int _placementIndex = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleContent() {
    _contentChanged = !_contentChanged;
    _controller.setContent(_contentChanged ? const Text('Updated content') : null);
  }

  void _cyclePlacement() {
    _placementIndex = (_placementIndex + 1) % BsPopoverPlacement.values.length;
    _controller.setPlacement(BsPopoverPlacement.values[_placementIndex]);
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
              onPressed: _toggleContent,
              child: const Text('Change content'),
            ),
            BsButton(
              size: BsSize.sm,
              variant: BsVariant.secondary,
              onPressed: _cyclePlacement,
              child: const Text('Change placement'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        BsPopover(
          controller: _controller,
          content: const Text('Original content'),
          triggerBuilder: (context, toggle, isOpen) =>
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
        BsPopover(
          content: const Text('Popover content'),
          onShow: () => _log('show'),
          onShown: () => _log('shown'),
          onHide: () => _log('hide'),
          onHidden: () => _log('hidden'),
          triggerBuilder: (context, toggle, isOpen) => BsButton(onPressed: toggle, child: const Text('Click me')),
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
