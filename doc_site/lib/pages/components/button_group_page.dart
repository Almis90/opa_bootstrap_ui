import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

class ButtonGroupPage extends StatelessWidget {
  const ButtonGroupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Button group',
      lead:
          'BsButtonGroup wraps a row (or, with vertical: true, a column) of BsButtons and collapses their shared '
          'edges into one visually joined control; BsToggleButtonGroup layers on checkbox- or radio-like selection state.',
      examples: [
        DocExample(
          title: 'Basic examples',
          description: 'A group of buttons rendered with shared, collapsed borders instead of individual gaps.',
          code: '''
BsButtonGroup(
  children: [
    BsButton(onPressed: () {}, child: Text('Left')),
    BsButton(onPressed: () {}, child: Text('Middle')),
    BsButton(onPressed: () {}, child: Text('Right')),
  ],
)''',
          preview: Wrap(
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
        DocExample(
          title: 'Sizing',
          description: 'size on the group (rather than on each button) sets a consistent size for every button inside it.',
          code: '''
Column(
  children: [
    for (final groupSize in [BsSize.lg, BsSize.normal, BsSize.sm])
      BsButtonGroup(
        size: groupSize,
        children: [
          BsButton(outline: true, onPressed: () {}, child: Text('Left')),
          BsButton(outline: true, onPressed: () {}, child: Text('Middle')),
          BsButton(outline: true, onPressed: () {}, child: Text('Right')),
        ],
      ),
  ],
)''',
          preview: Column(
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
        DocExample(
          title: 'Checkbox and radio toggle groups',
          description:
              'BsToggleButtonGroup drives isSelected/onPressed externally, so callers implement either checkbox '
              '(independent toggles) or radio (single selection) semantics on top of the same widget.',
          code: '''
BsToggleButtonGroup(
  isSelected: _checkboxSelected,
  onPressed: (index) => setState(() {
    _checkboxSelected[index] = !_checkboxSelected[index];
  }),
  children: [Text('Checkbox 1'), Text('Checkbox 2'), Text('Checkbox 3')],
)''',
          preview: const _ToggleGroupDemo(),
        ),
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
