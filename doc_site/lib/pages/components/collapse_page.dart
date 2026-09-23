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
          description: 'axis: BsCollapseAxis.horizontal animates width instead of height, for content that unfolds sideways.',
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
        BsButton(
          onPressed: () => setState(() => _expanded = !_expanded),
          child: Text(_expanded ? 'Hide' : 'Toggle'),
        ),
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
        BsButton(
          onPressed: () => setState(() => _expanded = !_expanded),
          child: Text(_expanded ? 'Hide' : 'Toggle'),
        ),
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
