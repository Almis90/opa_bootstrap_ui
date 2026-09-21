import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'demo_page.dart';

class PopoverPage extends StatelessWidget {
  const PopoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Popovers',
      children: [
        DemoSection(
          title: 'Basic, with title',
          child: BsPopover(
            title: const Text('Popover title'),
            content: const Text('And here is some amazing content. It is very engaging. Right?'),
            triggerBuilder: (context, toggle, isOpen) =>
                BsButton(onPressed: toggle, child: const Text('Click to toggle popover')),
          ),
        ),
        DemoSection(
          title: 'Without a title',
          child: BsPopover(
            content: const Text('This popover has no header.'),
            triggerBuilder: (context, toggle, isOpen) => BsButton(onPressed: toggle, child: const Text('Toggle')),
          ),
        ),
        DemoSection(
          title: 'Placements',
          child: Wrap(
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

  Widget _placementPopover(BsPopoverPlacement placement, String label) {
    return BsPopover(
      placement: placement,
      title: Text('$label popover'),
      content: const Text('Some popover content.'),
      triggerBuilder: (context, toggle, isOpen) => BsButton(onPressed: toggle, child: Text(label)),
    );
  }
}
