import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

class FormControlPage extends StatelessWidget {
  const FormControlPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Form control',
      lead:
          'BsFormControl is a single-line text input built directly on EditableText, since the '
          'package has no Material or Cupertino TextField to wrap. It supports three sizes, a '
          'disabled state, and validation coloring.',
      examples: [
        DocExample(
          title: 'Text input',
          description: 'Pair BsFormLabel and BsFormText around a BsFormControl for a labeled field with help text.',
          code: '''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    BsFormLabel(child: Text('Email address')),
    BsFormControl(placeholder: 'name@example.com'),
    BsFormText(child: Text("We'll never share your email with anyone else.")),
  ],
)''',
          preview: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BsFormLabel(child: Text('Email address')),
              BsFormControl(placeholder: 'name@example.com'),
              BsFormText(child: Text("We'll never share your email with anyone else.")),
            ],
          ),
        ),
        DocExample(
          title: 'Sizes',
          description: 'size accepts BsFormControlSize.small or .large; the default sits between them.',
          code: '''
BsFormControl(size: BsFormControlSize.large, placeholder: 'Large input')
BsFormControl(placeholder: 'Default input')
BsFormControl(size: BsFormControlSize.small, placeholder: 'Small input')''',
          preview: const Column(
            children: [
              BsFormControl(size: BsFormControlSize.large, placeholder: 'Large input'),
              SizedBox(height: 8),
              BsFormControl(placeholder: 'Default input'),
              SizedBox(height: 8),
              BsFormControl(size: BsFormControlSize.small, placeholder: 'Small input'),
            ],
          ),
        ),
        DocExample(
          title: 'Disabled and validation',
          description: 'enabled: false greys the field out and blocks input; valid: true/false tints the border green or red.',
          code: '''
BsFormControl(placeholder: 'Disabled input', enabled: false)
BsFormControl(placeholder: 'Looks good!', valid: true)
BsFormControl(placeholder: 'Please provide a value', valid: false)''',
          preview: const Column(
            children: [
              BsFormControl(placeholder: 'Disabled input', enabled: false),
              SizedBox(height: 8),
              BsFormControl(placeholder: 'Looks good!', valid: true),
              SizedBox(height: 8),
              BsFormControl(placeholder: 'Please provide a value', valid: false),
            ],
          ),
        ),
      ],
    );
  }
}
