import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WidgetsApp(
      color: BsColors.blue,
      builder: (context, child) => DefaultTextStyle(
        style: const TextStyle(color: BsColors.gray900, fontFamily: 'Roboto'),
        child: ColoredBox(
          color: BsColors.white,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Variants'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      for (final variant in BsVariant.values)
                        BsButton(
                          variant: variant,
                          onPressed: () {},
                          child: Text(variant.name),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Outline'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      for (final variant in BsVariant.values)
                        BsButton(
                          variant: variant,
                          outline: true,
                          onPressed: () {},
                          child: Text(variant.name),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Sizes'),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      BsButton(
                        size: BsSize.sm,
                        onPressed: () {},
                        child: const Text('small'),
                      ),
                      BsButton(
                        variant: BsVariant.secondary,
                        size: BsSize.sm,
                        onPressed: () {},
                        child: const Text('small'),
                      ),
                      BsButton(
                        onPressed: () {},
                        child: const Text('default'),
                      ),
                      BsButton(
                        variant: BsVariant.secondary,
                        onPressed: () {},
                        child: const Text('default'),
                      ),
                      BsButton(
                        size: BsSize.lg,
                        onPressed: () {},
                        child: const Text('large'),
                      ),
                      BsButton(
                        variant: BsVariant.secondary,
                        size: BsSize.lg,
                        onPressed: () {},
                        child: const Text('large'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Disabled'),
                  const SizedBox(height: 8),
                  const Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      BsButton(
                        onPressed: null,
                        child: Text('primary'),
                      ),
                      BsButton(
                        variant: BsVariant.secondary,
                        onPressed: null,
                        child: Text('secondary'),
                      ),
                      BsButton(
                        outline: true,
                        onPressed: null,
                        child: Text('primary'),
                      ),
                      BsButton(
                        variant: BsVariant.secondary,
                        outline: true,
                        onPressed: null,
                        child: Text('secondary'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('No wrap'),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 120,
                        child: BsButton(
                          onPressed: () {},
                          child: const Text('Wraps in a narrow box'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      BsButton(
                        noWrap: true,
                        onPressed: () {},
                        child: const Text('Does not wrap'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Custom style'),
                  const SizedBox(height: 8),
                  BsButton(
                    onPressed: () {},
                    style: const BsButtonStyle(
                      textStyle: TextStyle(fontWeight: FontWeight.w600),
                      color: BsColors.white,
                      background: Color(0xFF5C2D91),
                      borderColor: Color(0xFF5C2D91),
                      hoverColor: BsColors.white,
                      hoverBackground: Color(0xFF4A2474),
                      hoverBorderColor: Color(0xFF4A2474),
                      activeColor: BsColors.white,
                      activeBackground: Color(0xFF381A59),
                      activeBorderColor: Color(0xFF381A59),
                    ),
                    child: const Text('Custom brand color'),
                  ),
                  const SizedBox(height: 24),
                  const Text('Button group'),
                  const SizedBox(height: 8),
                  Wrap(
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
                          BsButton(
                            variant: BsVariant.secondary,
                            onPressed: () {},
                            child: const Text('1'),
                          ),
                          BsButton(
                            variant: BsVariant.secondary,
                            onPressed: () {},
                            child: const Text('2'),
                          ),
                          BsButton(
                            variant: BsVariant.secondary,
                            onPressed: () {},
                            child: const Text('3'),
                          ),
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
                  const SizedBox(height: 24),
                  const Text('Button group sizing'),
                  const SizedBox(height: 8),
                  Column(
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
                  const SizedBox(height: 24),
                  const Text('Checkbox and radio toggle groups'),
                  const SizedBox(height: 8),
                  const _ToggleGroupDemo(),
                  const SizedBox(height: 24),
                  const Text('Accordion'),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 400,
                    child: BsAccordion(
                      initiallyExpanded: const {0},
                      items: [
                        BsAccordionItem(
                          header: const Text('Accordion Item #1'),
                          body: const Text(
                            "This is the first item's accordion body. It supports "
                            'HTML content — really, any widget you like.',
                          ),
                        ),
                        BsAccordionItem(
                          header: const Text('Accordion Item #2'),
                          body: const Text(
                            "This is the second item's accordion body. Selecting it "
                            'closes the first, since alwaysOpen defaults to false.',
                          ),
                        ),
                        BsAccordionItem(
                          header: const Text('Accordion Item #3'),
                          body: const Text("This is the third item's accordion body."),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text('Accordion (flush, always open)'),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 400,
                    child: BsAccordion(
                      flush: true,
                      alwaysOpen: true,
                      initiallyExpanded: const {0, 2},
                      items: [
                        BsAccordionItem(
                          header: const Text('Accordion Item #1'),
                          body: const Text("This is the first item's accordion body."),
                        ),
                        BsAccordionItem(
                          header: const Text('Accordion Item #2'),
                          body: const Text("This is the second item's accordion body."),
                        ),
                        BsAccordionItem(
                          header: const Text('Accordion Item #3'),
                          body: const Text("This is the third item's accordion body."),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
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
