import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'demo_page.dart';

class FormPage extends StatefulWidget {
  const FormPage({super.key});

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  bool _checked = true;
  bool _switched = false;
  int _radio = 1;
  double _range = 40;
  String? _fruit = 'apple';

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Forms',
      children: [
        const DemoSection(
          title: 'Text input',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BsFormLabel(child: Text('Email address')),
              BsFormControl(placeholder: 'name@example.com'),
              BsFormText(
                child: Text("We'll never share your email with anyone else."),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Sizes',
          child: Column(
            children: [
              const BsFormControl(
                size: BsFormControlSize.large,
                placeholder: 'Large input',
              ),
              const SizedBox(height: 8),
              const BsFormControl(placeholder: 'Default input'),
              const SizedBox(height: 8),
              const BsFormControl(
                size: BsFormControlSize.small,
                placeholder: 'Small input',
              ),
            ],
          ),
        ),
        const DemoSection(
          title: 'Disabled / validation',
          child: Column(
            children: [
              BsFormControl(placeholder: 'Disabled input', enabled: false),
              SizedBox(height: 8),
              BsFormControl(placeholder: 'Looks good!', valid: true),
              SizedBox(height: 8),
              BsFormControl(
                placeholder: 'Please provide a value',
                valid: false,
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Checks, radios, and switches',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BsFormCheck(
                value: _checked,
                onChanged: (v) => setState(() => _checked = v),
                label: const Text('Default checkbox'),
              ),
              const SizedBox(height: 8),
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
              const SizedBox(height: 8),
              BsFormCheck(
                type: BsFormCheckType.switchToggle,
                value: _switched,
                onChanged: (v) => setState(() => _switched = v),
                label: const Text('Toggle switch'),
              ),
              const SizedBox(height: 8),
              const BsFormCheck(
                value: false,
                onChanged: null,
                label: Text('Disabled checkbox'),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Select',
          child: Column(
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
        DemoSection(
          title: 'Range',
          child: Column(
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
