import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

class TooltipsPage extends StatelessWidget {
  const TooltipsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Tooltips',
      lead:
          'BsTooltip wraps any child and shows a small message bubble on hover (or long-press on touch devices), '
          'positioning it toward a BsTooltipPlacement side of the child without requiring any external state.',
      examples: [
        DocExample(
          title: 'Basic (hover, or long-press on touch)',
          description: 'Wrapping a BsButton in BsTooltip attaches a message bubble to it.',
          code: '''
BsTooltip(
  message: Text('Tooltip text'),
  child: BsButton(onPressed: () {}, child: Text('Hover over me')),
)''',
          preview: BsTooltip(
            message: const Text('Tooltip text'),
            child: BsButton(onPressed: () {}, child: const Text('Hover over me')),
          ),
        ),
        DocExample(
          title: 'Placements',
          description: 'placement controls which side of the child the tooltip bubble appears on.',
          code: '''
BsTooltip(
  placement: BsTooltipPlacement.top,
  message: Text('Tooltip on top'),
  child: BsButton(onPressed: () {}, child: Text('Top')),
)''',
          preview: Wrap(
            spacing: 24,
            runSpacing: 24,
            children: [
              BsTooltip(
                placement: BsTooltipPlacement.top,
                message: const Text('Tooltip on top'),
                child: BsButton(onPressed: () {}, child: const Text('Top')),
              ),
              BsTooltip(
                placement: BsTooltipPlacement.bottom,
                message: const Text('Tooltip on bottom'),
                child: BsButton(onPressed: () {}, child: const Text('Bottom')),
              ),
              BsTooltip(
                placement: BsTooltipPlacement.start,
                message: const Text('Tooltip on start'),
                child: BsButton(onPressed: () {}, child: const Text('Start')),
              ),
              BsTooltip(
                placement: BsTooltipPlacement.end,
                message: const Text('Tooltip on end'),
                child: BsButton(onPressed: () {}, child: const Text('End')),
              ),
            ],
          ),
        ),
        DocExample(
          title: 'On plain text',
          description: 'BsTooltip works on any widget, not just buttons — here it wraps underlined text.',
          code: '''
BsTooltip(
  message: Text('This is an example tooltip.'),
  child: Text(
    'I have a tooltip.',
    style: TextStyle(decoration: TextDecoration.underline),
  ),
)''',
          preview: BsTooltip(
            message: const Text('This is an example tooltip.'),
            child: const Text(
              'I have a tooltip.',
              style: TextStyle(decoration: TextDecoration.underline),
            ),
          ),
        ),
      ],
    );
  }
}
