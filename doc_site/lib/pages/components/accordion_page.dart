import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

class AccordionPage extends StatelessWidget {
  const AccordionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Accordion',
      lead:
          'BsAccordion stacks BsAccordionItem headers and bodies and drives an internal expand/collapse '
          'state machine — by default only one item is open at a time, since every item shares the same parent group.',
      examples: [
        DocExample(
          title: 'Basic example',
          description: 'initiallyExpanded seeds which item indices start open; opening another item closes the rest.',
          code: '''
BsAccordion(
  initiallyExpanded: const {0},
  items: [
    BsAccordionItem(
      header: Text('Accordion Item #1'),
      body: Text("This is the first item's accordion body."),
    ),
    BsAccordionItem(
      header: Text('Accordion Item #2'),
      body: Text("Selecting it closes the first, since neither item is detached."),
    ),
    BsAccordionItem(
      header: Text('Accordion Item #3'),
      body: Text("This is the third item's accordion body."),
    ),
  ],
)''',
          preview: SizedBox(
            width: 400,
            child: BsAccordion(
              initiallyExpanded: const {0},
              items: const [
                BsAccordionItem(
                  header: Text('Accordion Item #1'),
                  body: Text("This is the first item's accordion body."),
                ),
                BsAccordionItem(
                  header: Text('Accordion Item #2'),
                  body: Text('Selecting it closes the first, since neither item is detached.'),
                ),
                BsAccordionItem(
                  header: Text('Accordion Item #3'),
                  body: Text("This is the third item's accordion body."),
                ),
              ],
            ),
          ),
        ),
        DocExample(
          title: 'Always open',
          description: 'allDetached: true lets every item stay open independently, like omitting data-bs-parent on all of them.',
          code: '''
BsAccordion(
  allDetached: true,
  initiallyExpanded: const {0},
  items: [
    BsAccordionItem(header: Text('Accordion Item #1'), body: Text('...')),
    BsAccordionItem(header: Text('Accordion Item #2'), body: Text('...')),
    BsAccordionItem(header: Text('Accordion Item #3'), body: Text('...')),
  ],
)''',
          preview: SizedBox(
            width: 400,
            child: BsAccordion(
              allDetached: true,
              initiallyExpanded: const {0},
              items: const [
                BsAccordionItem(header: Text('Accordion Item #1'), body: Text("This is the first item's accordion body.")),
                BsAccordionItem(
                  header: Text('Accordion Item #2'),
                  body: Text('This stays open alongside the first, since allDetached is true.'),
                ),
                BsAccordionItem(header: Text('Accordion Item #3'), body: Text("This is the third item's accordion body.")),
              ],
            ),
          ),
        ),
        DocExample(
          title: 'One item detached',
          description: 'detached: true on a single item exempts just that item from the shared group, while the rest keep collapsing each other.',
          code: '''
BsAccordion(
  initiallyExpanded: const {0},
  items: [
    BsAccordionItem(header: Text('Accordion Item #1'), body: Text('...')),
    BsAccordionItem(
      detached: true,
      header: Text('Accordion Item #2 (detached)'),
      body: Text('Opening it never closes #1 or #3, and vice versa.'),
    ),
    BsAccordionItem(header: Text('Accordion Item #3'), body: Text('...')),
  ],
)''',
          preview: SizedBox(
            width: 400,
            child: BsAccordion(
              initiallyExpanded: const {0},
              items: const [
                BsAccordionItem(header: Text('Accordion Item #1'), body: Text("This is the first item's accordion body.")),
                BsAccordionItem(
                  detached: true,
                  header: Text('Accordion Item #2 (detached)'),
                  body: Text('Opening it never closes #1 or #3, and vice versa.'),
                ),
                BsAccordionItem(header: Text('Accordion Item #3'), body: Text("This is the third item's accordion body.")),
              ],
            ),
          ),
        ),
        DocExample(
          title: 'Flush',
          description: 'flush: true removes the outer border and rounded corners so the accordion spans edge-to-edge.',
          code: '''
BsAccordion(
  flush: true,
  items: [
    BsAccordionItem(header: Text('Accordion Item #1'), body: Text('...')),
    BsAccordionItem(header: Text('Accordion Item #2'), body: Text('...')),
    BsAccordionItem(header: Text('Accordion Item #3'), body: Text('...')),
  ],
)''',
          preview: SizedBox(
            width: 400,
            child: BsAccordion(
              flush: true,
              items: const [
                BsAccordionItem(header: Text('Accordion Item #1'), body: Text("This is the first item's accordion body.")),
                BsAccordionItem(header: Text('Accordion Item #2'), body: Text("This is the second item's accordion body.")),
                BsAccordionItem(header: Text('Accordion Item #3'), body: Text("This is the third item's accordion body.")),
              ],
            ),
          ),
        ),
        DocExample(
          title: 'Custom icon',
          description: 'iconBuilder replaces the default chevron with any widget, given the current color and expanded state.',
          code: '''
BsAccordion(
  initiallyExpanded: const {0},
  iconBuilder: (context, color, isExpanded) => Text(
    isExpanded ? '−' : '+',
    style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold),
  ),
  items: [
    BsAccordionItem(header: Text('Accordion Item #1'), body: Text('...')),
    BsAccordionItem(header: Text('Accordion Item #2'), body: Text('...')),
  ],
)''',
          preview: SizedBox(
            width: 400,
            child: BsAccordion(
              initiallyExpanded: const {0},
              iconBuilder: (context, color, isExpanded) => Text(
                isExpanded ? '−' : '+',
                style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              items: const [
                BsAccordionItem(header: Text('Accordion Item #1'), body: Text("This is the first item's accordion body.")),
                BsAccordionItem(header: Text('Accordion Item #2'), body: Text("This is the second item's accordion body.")),
              ],
            ),
          ),
        ),
        DocExample(
          title: 'Programmatic control',
          description: 'A BsAccordionController lets code outside the accordion call expand(index) or collapseAll() directly.',
          code: '''
final controller = BsAccordionController();

Column(
  children: [
    BsButton(onPressed: () => controller.expand(0), child: Text('Expand #1')),
    BsButton(onPressed: controller.collapseAll, child: Text('Collapse all')),
    BsAccordion(
      controller: controller,
      items: [
        BsAccordionItem(header: Text('Accordion Item #1'), body: Text('...')),
        BsAccordionItem(header: Text('Accordion Item #2'), body: Text('...')),
      ],
    ),
  ],
)''',
          preview: const _ControllerDemo(),
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
  late final BsAccordionController _controller = BsAccordionController();

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
          spacing: 12,
          runSpacing: 8,
          children: [
            BsButton(size: BsSize.sm, onPressed: () => _controller.expand(0), child: const Text('Expand #1')),
            BsButton(size: BsSize.sm, onPressed: () => _controller.expand(1), child: const Text('Expand #2')),
            BsButton(
              size: BsSize.sm,
              variant: BsVariant.secondary,
              onPressed: _controller.collapseAll,
              child: const Text('Collapse all'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: 400,
          child: BsAccordion(
            controller: _controller,
            items: const [
              BsAccordionItem(
                header: Text('Accordion Item #1'),
                body: Text('Driven by an external BsAccordionController.'),
              ),
              BsAccordionItem(header: Text('Accordion Item #2'), body: Text("This is the second item's accordion body.")),
            ],
          ),
        ),
      ],
    );
  }
}
