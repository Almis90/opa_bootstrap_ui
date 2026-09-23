import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

class SelectPage extends StatefulWidget {
  const SelectPage({super.key});

  @override
  State<SelectPage> createState() => _SelectPageState();
}

class _SelectPageState extends State<SelectPage> {
  String? _fruit = 'apple';

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Select',
      lead:
          'BsFormSelect<T> is a generic dropdown built on BsDropdown: it renders a BsFormControl-styled '
          'toggle showing the item whose value matches value, and opens a menu of BsFormSelectItem<T> options.',
      examples: [
        DocExample(
          title: 'Basic',
          description: 'value is matched against each item\'s value by ==; a non-matching (or null) value falls back to placeholder.',
          code: '''
BsFormSelect<String>(
  value: fruit,
  placeholder: Text('Choose...'),
  onChanged: (v) => setState(() => fruit = v),
  items: [
    BsFormSelectItem(value: 'apple', label: Text('Apple')),
    BsFormSelectItem(value: 'banana', label: Text('Banana')),
    BsFormSelectItem(value: 'cherry', label: Text('Cherry')),
  ],
)''',
          preview: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BsFormSelect<String>(
                value: _fruit,
                placeholder: const Text('Choose...'),
                onChanged: (v) => setState(() => _fruit = v),
                items: const [
                  BsFormSelectItem(value: 'apple', label: Text('Apple')),
                  BsFormSelectItem(value: 'banana', label: Text('Banana')),
                  BsFormSelectItem(value: 'cherry', label: Text('Cherry')),
                ],
              ),
              const SizedBox(height: 4),
              Text('Value: $_fruit'),
            ],
          ),
        ),
      ],
    );
  }
}
