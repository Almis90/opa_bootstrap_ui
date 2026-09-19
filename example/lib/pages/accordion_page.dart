import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'demo_page.dart';

class AccordionPage extends StatelessWidget {
  const AccordionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Accordion',
      children: [
        DemoSection(
          title: 'Basic example',
          child: SizedBox(
            width: 400,
            child: BsAccordion(
              initiallyExpanded: const {0},
              items: [
                BsAccordionItem(
                  header: const Text('Accordion Item #1'),
                  body: const Text(
                    "This is the first item's accordion body. It supports "
                    'HTML content — really, any widget you like.',
                  ),
                ),
                BsAccordionItem(
                  header: const Text('Accordion Item #2'),
                  body: const Text(
                    "This is the second item's accordion body. Selecting it "
                    'closes the first, since none of the items are detached.',
                  ),
                ),
                BsAccordionItem(
                  header: const Text('Accordion Item #3'),
                  body: const Text("This is the third item's accordion body."),
                ),
              ],
            ),
          ),
        ),
        DemoSection(
          title: 'Always open',
          child: SizedBox(
            width: 400,
            child: BsAccordion(
              allDetached: true,
              initiallyExpanded: const {0},
              items: [
                BsAccordionItem(
                  header: const Text('Accordion Item #1'),
                  body: const Text(
                    "This is the first item's accordion body. It supports "
                    'HTML content — really, any widget you like.',
                  ),
                ),
                BsAccordionItem(
                  header: const Text('Accordion Item #2'),
                  body: const Text(
                    "This is the second item's accordion body. It stays "
                    'open alongside the first, since allDetached is true.',
                  ),
                ),
                BsAccordionItem(
                  header: const Text('Accordion Item #3'),
                  body: const Text("This is the third item's accordion body."),
                ),
              ],
            ),
          ),
        ),
        DemoSection(
          title: 'One item detached',
          child: SizedBox(
            width: 400,
            child: BsAccordion(
              initiallyExpanded: const {0},
              items: [
                BsAccordionItem(
                  header: const Text('Accordion Item #1'),
                  body: const Text("This is the first item's accordion body."),
                ),
                BsAccordionItem(
                  detached: true,
                  header: const Text('Accordion Item #2 (detached)'),
                  body: const Text(
                    'This item is detached: opening it never closes #1 or '
                    "#3, and it never gets closed by them either — it's "
                    "independent, like Bootstrap's data-bs-parent omitted "
                    'on just one item.',
                  ),
                ),
                BsAccordionItem(
                  header: const Text('Accordion Item #3'),
                  body: const Text("This is the third item's accordion body."),
                ),
              ],
            ),
          ),
        ),
        DemoSection(
          title: 'Flush',
          child: SizedBox(
            width: 400,
            child: BsAccordion(
              flush: true,
              items: const [
                BsAccordionItem(
                  header: Text('Accordion Item #1'),
                  body: Text(
                    'Placeholder content for this accordion, which is intended to '
                    'demonstrate the .accordion-flush class. This is the first '
                    "item's accordion body.",
                  ),
                ),
                BsAccordionItem(
                  header: Text('Accordion Item #2'),
                  body: Text(
                    'Placeholder content for this accordion, which is intended to '
                    'demonstrate the .accordion-flush class. This is the second '
                    "item's accordion body. Let's imagine this being filled with "
                    'some actual content.',
                  ),
                ),
                BsAccordionItem(
                  header: Text('Accordion Item #3'),
                  body: Text(
                    'Placeholder content for this accordion, which is intended to '
                    'demonstrate the .accordion-flush class. This is the third '
                    "item's accordion body.",
                  ),
                ),
              ],
            ),
          ),
        ),
        DemoSection(
          title: 'Flush + always open',
          child: SizedBox(
            width: 400,
            child: BsAccordion(
              flush: true,
              allDetached: true,
              initiallyExpanded: const {0, 2},
              items: [
                BsAccordionItem(
                  header: const Text('Accordion Item #1'),
                  body: const Text("This is the first item's accordion body."),
                ),
                BsAccordionItem(
                  header: const Text('Accordion Item #2'),
                  body: const Text("This is the second item's accordion body."),
                ),
                BsAccordionItem(
                  header: const Text('Accordion Item #3'),
                  body: const Text("This is the third item's accordion body."),
                ),
              ],
            ),
          ),
        ),
        DemoSection(
          title: 'Custom icon',
          child: SizedBox(
            width: 400,
            child: BsAccordion(
              initiallyExpanded: const {0},
              iconBuilder: (context, color, isExpanded) => Text(
                isExpanded ? '−' : '+',
                style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold),
              ),
              items: [
                BsAccordionItem(
                  header: const Text('Accordion Item #1'),
                  body: const Text("This is the first item's accordion body."),
                ),
                BsAccordionItem(
                  header: const Text('Accordion Item #2'),
                  body: const Text("This is the second item's accordion body."),
                ),
              ],
            ),
          ),
        ),
        DemoSection(title: 'Programmatic control', child: _ControllerDemo()),
      ],
    );
  }
}

class _ControllerDemo extends StatefulWidget {
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
            BsButton(
              size: BsSize.sm,
              onPressed: () => _controller.expand(0),
              child: const Text('Expand #1'),
            ),
            BsButton(
              size: BsSize.sm,
              onPressed: () => _controller.expand(1),
              child: const Text('Expand #2'),
            ),
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
                body: Text(
                  'Driven by an external BsAccordionController — the buttons '
                  'above call expand()/collapseAll() directly.',
                ),
              ),
              BsAccordionItem(
                header: Text('Accordion Item #2'),
                body: Text("This is the second item's accordion body."),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
