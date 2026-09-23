import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

class RangePage extends StatefulWidget {
  const RangePage({super.key});

  @override
  State<RangePage> createState() => _RangePageState();
}

class _RangePageState extends State<RangePage> {
  double _range = 40;

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Range',
      lead:
          'BsFormRange is a custom-painted slider between min and max, driven by tap and drag gestures rather '
          'than a platform Slider, so its track and thumb match Bootstrap\'s .form-range styling exactly.',
      examples: [
        DocExample(
          title: 'Basic',
          description: 'value, min, and max are doubles; onChanged fires continuously while dragging. Omit onChanged to disable it.',
          code: '''
BsFormRange(
  value: range,
  onChanged: (v) => setState(() => range = v),
)''',
          preview: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BsFormRange(
                value: _range,
                onChanged: (v) => setState(() => _range = v),
              ),
              const SizedBox(height: 4),
              Text('Value: ${_range.round()}'),
            ],
          ),
        ),
      ],
    );
  }
}
