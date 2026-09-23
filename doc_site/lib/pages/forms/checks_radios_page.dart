import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

class ChecksRadiosPage extends StatefulWidget {
  const ChecksRadiosPage({super.key});

  @override
  State<ChecksRadiosPage> createState() => _ChecksRadiosPageState();
}

class _ChecksRadiosPageState extends State<ChecksRadiosPage> {
  bool _checked = true;
  bool _switched = false;
  int _radio = 1;

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Checks & radios',
      lead:
          'BsFormCheck draws a checkbox, radio, or switch glyph (via BsFormCheckType) next to an optional '
          'label, toggling a bool value when either is tapped; passing onChanged: null disables it.',
      examples: [
        DocExample(
          title: 'Checkbox',
          description: 'The default type is BsFormCheckType.checkbox.',
          code: '''
BsFormCheck(
  value: checked,
  onChanged: (v) => setState(() => checked = v),
  label: Text('Default checkbox'),
)''',
          preview: BsFormCheck(
            value: _checked,
            onChanged: (v) => setState(() => _checked = v),
            label: const Text('Default checkbox'),
          ),
        ),
        DocExample(
          title: 'Radios',
          description: 'BsFormCheckType.radio renders a round glyph; group them by driving each onChanged from the same state variable.',
          code: '''
BsFormCheck(
  type: BsFormCheckType.radio,
  value: radio == 1,
  onChanged: (_) => setState(() => radio = 1),
  label: Text('Radio 1'),
)
BsFormCheck(
  type: BsFormCheckType.radio,
  value: radio == 2,
  onChanged: (_) => setState(() => radio = 2),
  label: Text('Radio 2'),
)''',
          preview: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BsFormCheck(
                type: BsFormCheckType.radio,
                value: _radio == 1,
                onChanged: (_) => setState(() => _radio = 1),
                label: const Text('Radio 1'),
              ),
              const SizedBox(height: 8),
              BsFormCheck(
                type: BsFormCheckType.radio,
                value: _radio == 2,
                onChanged: (_) => setState(() => _radio = 2),
                label: const Text('Radio 2'),
              ),
            ],
          ),
        ),
        DocExample(
          title: 'Switch',
          description: 'BsFormCheckType.switchToggle renders a pill-shaped track with a sliding thumb instead of a checkbox glyph.',
          code: '''
BsFormCheck(
  type: BsFormCheckType.switchToggle,
  value: switched,
  onChanged: (v) => setState(() => switched = v),
  label: Text('Toggle switch'),
)''',
          preview: BsFormCheck(
            type: BsFormCheckType.switchToggle,
            value: _switched,
            onChanged: (v) => setState(() => _switched = v),
            label: const Text('Toggle switch'),
          ),
        ),
        const DocExample(
          title: 'Disabled',
          description: 'Passing onChanged: null dims the control and blocks taps on both the glyph and its label.',
          code: '''
BsFormCheck(
  value: false,
  onChanged: null,
  label: Text('Disabled checkbox'),
)''',
          preview: BsFormCheck(
            value: false,
            onChanged: null,
            label: Text('Disabled checkbox'),
          ),
        ),
      ],
    );
  }
}
