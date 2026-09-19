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
                    'closes the first, since alwaysOpen defaults to false.',
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
          title: 'Flush, always open',
          child: SizedBox(
            width: 400,
            child: BsAccordion(
              flush: true,
              alwaysOpen: true,
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
      ],
    );
  }
}
