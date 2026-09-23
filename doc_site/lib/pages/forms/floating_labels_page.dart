import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

class FloatingLabelsPage extends StatelessWidget {
  const FloatingLabelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Floating labels',
      lead:
          'BsFormFloating stacks a BsFormControl and a label widget, animating the label from centered '
          'placeholder text up into a shrunken corner label once the field is focused or has content.',
      examples: [
        const DocExample(
          title: 'Basic',
          description: 'Tap into either field below to see the label float — obscureText: true turns a field into a password input.',
          code: '''
Column(
  children: [
    BsFormFloating(label: Text('Email address')),
    SizedBox(height: 8),
    BsFormFloating(label: Text('Password'), obscureText: true),
  ],
)''',
          preview: Column(
            children: [
              BsFormFloating(label: Text('Email address')),
              SizedBox(height: 8),
              BsFormFloating(label: Text('Password'), obscureText: true),
            ],
          ),
        ),
      ],
    );
  }
}
