import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

class CloseButtonPage extends StatelessWidget {
  const CloseButtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Close button',
      lead:
          'BsCloseButton is the small "×" tap target used to dismiss alerts, modals, and toasts — a generic, '
          'unstyled dismiss affordance rather than a component tied to any one container.',
      examples: [
        DocExample(
          title: 'Example',
          description: 'The default close button, ready to be wired to an onPressed callback.',
          code: '''BsCloseButton(onPressed: () {})''',
          preview: BsCloseButton(onPressed: () {}),
        ),
        DocExample(
          title: 'Disabled',
          description: 'Passing null for onPressed renders the button in a dimmed, non-interactive state.',
          code: '''BsCloseButton(onPressed: null)''',
          preview: const BsCloseButton(onPressed: null),
        ),
        DocExample(
          title: 'On a dark background',
          description: 'style: BsCloseButtonStyle(color: ...) inverts the icon color for use over dark surfaces.',
          code: '''
BsCloseButton(
  onPressed: () {},
  style: BsCloseButtonStyle(color: BsColors.white),
)''',
          preview: ColoredBox(
            color: BsColors.gray900,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: BsCloseButton(onPressed: () {}, style: const BsCloseButtonStyle(color: BsColors.white)),
            ),
          ),
        ),
      ],
    );
  }
}
