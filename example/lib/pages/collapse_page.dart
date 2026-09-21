import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'demo_page.dart';

class CollapsePage extends StatefulWidget {
  const CollapsePage({super.key});

  @override
  State<CollapsePage> createState() => _CollapsePageState();
}

class _CollapsePageState extends State<CollapsePage> {
  bool _verticalExpanded = false;
  bool _horizontalExpanded = false;

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Collapse',
      children: [
        DemoSection(
          title: 'Basic',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BsButton(
                onPressed: () => setState(() => _verticalExpanded = !_verticalExpanded),
                child: Text(_verticalExpanded ? 'Hide' : 'Toggle'),
              ),
              const SizedBox(height: 8),
              BsCollapse(
                isExpanded: _verticalExpanded,
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
          ),
        ),
        DemoSection(
          title: 'Horizontal',
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BsButton(
                onPressed: () => setState(() => _horizontalExpanded = !_horizontalExpanded),
                child: Text(_horizontalExpanded ? 'Hide' : 'Toggle'),
              ),
              const SizedBox(width: 8),
              SizedBox(
                height: 120,
                child: BsCollapse(
                  isExpanded: _horizontalExpanded,
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
          ),
        ),
      ],
    );
  }
}
