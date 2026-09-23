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
