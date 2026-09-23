import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

class InputGroupPage extends StatelessWidget {
  const InputGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Input group',
      lead:
          'BsInputGroup lays out its children in a row sharing one border, letting a BsFormControl (with '
          'showBorder: false, wrapped in Expanded) sit flush against static BsInputGroupText addons.',
      examples: [
        const DocExample(
          title: 'Leading addon',
          description: 'A single BsInputGroupText before an Expanded, borderless BsFormControl.',
          code: '''
BsInputGroup(
  children: [
    BsInputGroupText(child: Text('@')),
    Expanded(child: BsFormControl(showBorder: false, placeholder: 'Username')),
  ],
)''',
          preview: BsInputGroup(
            children: [
              BsInputGroupText(child: Text('@')),
              Expanded(child: BsFormControl(showBorder: false, placeholder: 'Username')),
            ],
          ),
        ),
        DocExample(
          title: 'Leading and trailing addons',
          description: 'BsInputGroupText can appear on both sides of the control, e.g. a currency symbol and unit.',
          code: r'''
BsInputGroup(
  children: [
    BsInputGroupText(child: Text('$')),
    Expanded(child: BsFormControl(showBorder: false, placeholder: 'Amount')),
    BsInputGroupText(child: Text('.00')),
  ],
)''',
          preview: const BsInputGroup(
            children: [
              BsInputGroupText(child: Text(r'$')),
              Expanded(child: BsFormControl(showBorder: false, placeholder: 'Amount')),
              BsInputGroupText(child: Text('.00')),
            ],
          ),
        ),
      ],
    );
  }
}
