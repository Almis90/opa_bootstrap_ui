import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

class CollapsePage extends StatelessWidget {
  const CollapsePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Collapse',
      lead:
          'BsCollapse animates a child in and out of view by growing or shrinking its extent along one axis — '
          'the caller owns the isExpanded flag, so any trigger (a button, a link, external state) can drive it.',
      examples: [
        DocExample(
          title: 'Basic',
          description: 'By default the extent animates vertically, hiding the child entirely when collapsed.',
          code: '''
BsButton(
  onPressed: () => setState(() => _expanded = !_expanded),
  child: Text(_expanded ? 'Hide' : 'Toggle'),
),
BsCollapse(
  isExpanded: _expanded,
  child: ColoredBox(
    color: Color(0xFFF8F9FA),
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Text("Some placeholder content for the collapse component."),
    ),
  ),
)''',
          preview: const _VerticalDemo(),
        ),
        DocExample(
          title: 'Horizontal',
          description:
              'axis: BsCollapseAxis.horizontal animates width instead of height, for content that unfolds sideways.',
          code: '''
BsCollapse(
  isExpanded: _expanded,
  axis: BsCollapseAxis.horizontal,
  child: Container(
    width: 160,
    color: Color(0xFFF8F9FA),
    padding: EdgeInsets.all(16),
    child: Text('This content is 160px wide and appears/disappears horizontally.'),
  ),
)''',
          preview: const _HorizontalDemo(),
        ),
        DocExample(
          title: 'Programmatic control',
          description:
              'A BsCollapseController lets code outside expand(), collapse(), or toggle() it — pass it instead of '
              'isExpanded, which is ignored once a controller is given.',
          code: '''
final controller = BsCollapseController();

Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Wrap(
      spacing: 8,
      children: [
        BsButton(onPressed: controller.expand, child: Text('Expand')),
        BsButton(onPressed: controller.collapse, child: Text('Collapse')),
        BsButton(onPressed: controller.toggle, child: Text('Toggle')),
      ],
    ),
    BsCollapse(
      controller: controller,
      child: ColoredBox(
        color: Color(0xFFF8F9FA),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Driven by an external BsCollapseController.'),
        ),
      ),
    ),
  ],
)''',
          preview: const _ControllerDemo(),
        ),
        DocExample(
          title: 'Events',
          description:
              'onShow/onHide fire immediately once an expand or collapse is triggered; onShown/onHidden fire once '
              "the size animation actually finishes — mirroring Bootstrap's show.bs.collapse/shown.bs.collapse/"
              'hide.bs.collapse/hidden.bs.collapse.',
          code: '''
BsCollapse(
  onShow: () => log('show'),
  onShown: () => log('shown'),
  onHide: () => log('hide'),
  onHidden: () => log('hidden'),
  child: Text('Some content'),
)''',
          preview: const _EventsDemo(),
        ),
      ],
    );
  }
}

class _VerticalDemo extends StatefulWidget {
  const _VerticalDemo();

  @override
  State<_VerticalDemo> createState() => _VerticalDemoState();
}

class _VerticalDemoState extends State<_VerticalDemo> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BsButton(onPressed: () => setState(() => _expanded = !_expanded), child: Text(_expanded ? 'Hide' : 'Toggle')),
        const SizedBox(height: 8),
        BsCollapse(
          isExpanded: _expanded,
          child: const ColoredBox(
            color: Color(0xFFF8F9FA),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Some placeholder content for the collapse component. This panel's height "
                'is animated when toggled, and the panel is not shown at all when collapsed.',
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HorizontalDemo extends StatefulWidget {
  const _HorizontalDemo();

  @override
  State<_HorizontalDemo> createState() => _HorizontalDemoState();
}

class _HorizontalDemoState extends State<_HorizontalDemo> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BsButton(onPressed: () => setState(() => _expanded = !_expanded), child: Text(_expanded ? 'Hide' : 'Toggle')),
        const SizedBox(width: 8),
        SizedBox(
          height: 120,
          child: BsCollapse(
            isExpanded: _expanded,
            axis: BsCollapseAxis.horizontal,
            child: Container(
              width: 160,
              color: const Color(0xFFF8F9FA),
              padding: const EdgeInsets.all(16),
              child: const Text('This content is 160px wide and appears/disappears horizontally.'),
            ),
          ),
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
            BsButton(size: BsSize.sm, onPressed: _controller.expand, child: const Text('Expand')),
            BsButton(size: BsSize.sm, onPressed: _controller.collapse, child: const Text('Collapse')),
            BsButton(size: BsSize.sm, onPressed: _controller.toggle, child: const Text('Toggle')),
          ],
        ),
        const SizedBox(height: 8),
        BsCollapse(
          controller: _controller,
          child: const ColoredBox(
            color: Color(0xFFF8F9FA),
            child: Padding(padding: EdgeInsets.all(16), child: Text('Driven by an external BsCollapseController.')),
          ),
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
  bool _expanded = false;
  final _events = <String>[];

  void _log(String event) => setState(() => _events.add(event));

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BsButton(
          size: BsSize.sm,
          onPressed: () => setState(() => _expanded = !_expanded),
          child: Text(_expanded ? 'Hide' : 'Toggle'),
        ),
        const SizedBox(height: 8),
        BsCollapse(
          isExpanded: _expanded,
          onShow: () => _log('show'),
          onShown: () => _log('shown'),
          onHide: () => _log('hide'),
          onHidden: () => _log('hidden'),
          child: const ColoredBox(
            color: Color(0xFFF8F9FA),
            child: Padding(padding: EdgeInsets.all(16), child: Text('Some content')),
          ),
        ),
        const SizedBox(height: 8),
        if (_events.isEmpty)
          Text('No events yet — click Toggle above.', style: TextStyle(color: BsBody.secondaryColorOf(context)))
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
