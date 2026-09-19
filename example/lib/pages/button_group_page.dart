import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'demo_page.dart';

class ButtonGroupPage extends StatelessWidget {
  const ButtonGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Button group',
      children: [
        DemoSection(
          title: 'Basic examples',
          child: Wrap(
            spacing: 24,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.start,
            children: [
              BsButtonGroup(
                children: [
                  BsButton(onPressed: () {}, child: const Text('Left')),
                  BsButton(onPressed: () {}, child: const Text('Middle')),
                  BsButton(onPressed: () {}, child: const Text('Right')),
                ],
              ),
              BsButtonGroup(
                size: BsSize.sm,
                children: [
                  BsButton(variant: BsVariant.secondary, onPressed: () {}, child: const Text('1')),
                  BsButton(variant: BsVariant.secondary, onPressed: () {}, child: const Text('2')),
                  BsButton(variant: BsVariant.secondary, onPressed: () {}, child: const Text('3')),
                ],
              ),
              SizedBox(
                width: 160,
                child: BsButtonGroup(
                  vertical: true,
                  children: [
                    BsButton(onPressed: () {}, child: const Text('Top')),
                    BsButton(onPressed: () {}, child: const Text('Middle')),
                    BsButton(onPressed: () {}, child: const Text('Bottom')),
                  ],
                ),
              ),
              BsButtonGroup(
                children: [
                  BsButton(active: true, onPressed: () {}, child: const Text('Active link')),
                  BsButton(onPressed: () {}, child: const Text('Link')),
                  BsButton(onPressed: () {}, child: const Text('Link')),
                ],
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Sizing',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final groupSize in [BsSize.lg, BsSize.normal, BsSize.sm]) ...[
                BsButtonGroup(
                  size: groupSize,
                  children: [
                    BsButton(outline: true, onPressed: () {}, child: const Text('Left')),
                    BsButton(outline: true, onPressed: () {}, child: const Text('Middle')),
                    BsButton(outline: true, onPressed: () {}, child: const Text('Right')),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
        DemoSection(title: 'Checkbox and radio toggle groups', child: const _ToggleGroupDemo()),
      ],
    );
  }
}

class _ToggleGroupDemo extends StatefulWidget {
  const _ToggleGroupDemo();

  @override
  State<_ToggleGroupDemo> createState() => _ToggleGroupDemoState();
}

class _ToggleGroupDemoState extends State<_ToggleGroupDemo> {
  List<bool> _checkboxSelected = [false, false, false];
  List<bool> _radioSelected = [true, false, false];
  List<bool> _verticalCheckboxSelected = [false, false, false];
  List<bool> _verticalRadioSelected = [true, false, false];

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 24,
      runSpacing: 12,
      crossAxisAlignment: WrapCrossAlignment.start,
      children: [
        BsToggleButtonGroup(
          isSelected: _checkboxSelected,
          onPressed: (index) {
            setState(() {
              _checkboxSelected = [..._checkboxSelected];
              _checkboxSelected[index] = !_checkboxSelected[index];
            });
          },
          children: const [Text('Checkbox 1'), Text('Checkbox 2'), Text('Checkbox 3')],
        ),
        BsToggleButtonGroup(
          isSelected: _radioSelected,
          onPressed: (index) {
            setState(() {
              _radioSelected = List.generate(_radioSelected.length, (i) => i == index);
            });
          },
          children: const [Text('Radio 1'), Text('Radio 2'), Text('Radio 3')],
        ),
        SizedBox(
          width: 140,
          child: BsToggleButtonGroup(
            vertical: true,
            isSelected: _verticalCheckboxSelected,
            onPressed: (index) {
              setState(() {
                _verticalCheckboxSelected = [..._verticalCheckboxSelected];
                _verticalCheckboxSelected[index] = !_verticalCheckboxSelected[index];
              });
            },
            children: const [Text('Checkbox 1'), Text('Checkbox 2'), Text('Checkbox 3')],
          ),
        ),
        SizedBox(
          width: 140,
          child: BsToggleButtonGroup(
            vertical: true,
            isSelected: _verticalRadioSelected,
            onPressed: (index) {
              setState(() {
                _verticalRadioSelected = List.generate(_verticalRadioSelected.length, (i) => i == index);
              });
            },
            children: const [Text('Radio 1'), Text('Radio 2'), Text('Radio 3')],
          ),
        ),
      ],
    );
  }
}
