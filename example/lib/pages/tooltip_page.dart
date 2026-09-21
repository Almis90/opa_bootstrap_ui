import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'demo_page.dart';

class TooltipPage extends StatelessWidget {
  const TooltipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Tooltips',
      children: [
        DemoSection(
          title: 'Basic (hover, or long-press on touch)',
          child: BsTooltip(
            message: const Text('Tooltip text'),
            child: BsButton(onPressed: () {}, child: const Text('Hover over me')),
          ),
        ),
        DemoSection(
          title: 'Placements',
          child: Wrap(
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
        DemoSection(
          title: 'On plain text',
          child: BsTooltip(
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
