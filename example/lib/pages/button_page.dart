import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'demo_page.dart';

class ButtonPage extends StatelessWidget {
  const ButtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Button',
      children: [
        DemoSection(
          title: 'Variants',
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final variant in BsVariant.values)
                BsButton(variant: variant, onPressed: () {}, child: Text(variant.name)),
            ],
          ),
        ),
        DemoSection(
          title: 'Outline',
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final variant in BsVariant.values)
                BsButton(variant: variant, outline: true, onPressed: () {}, child: Text(variant.name)),
            ],
          ),
        ),
        DemoSection(
          title: 'Sizes',
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              BsButton(size: BsSize.sm, onPressed: () {}, child: const Text('small')),
              BsButton(
                variant: BsVariant.secondary,
                size: BsSize.sm,
                onPressed: () {},
                child: const Text('small'),
              ),
              BsButton(onPressed: () {}, child: const Text('default')),
              BsButton(variant: BsVariant.secondary, onPressed: () {}, child: const Text('default')),
              BsButton(size: BsSize.lg, onPressed: () {}, child: const Text('large')),
              BsButton(
                variant: BsVariant.secondary,
                size: BsSize.lg,
                onPressed: () {},
                child: const Text('large'),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'Disabled',
          child: const Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              BsButton(onPressed: null, child: Text('primary')),
              BsButton(variant: BsVariant.secondary, onPressed: null, child: Text('secondary')),
              BsButton(outline: true, onPressed: null, child: Text('primary')),
              BsButton(
                variant: BsVariant.secondary,
                outline: true,
                onPressed: null,
                child: Text('secondary'),
              ),
            ],
          ),
        ),
        DemoSection(
          title: 'No wrap',
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                child: BsButton(onPressed: () {}, child: const Text('Wraps in a narrow box')),
              ),
              const SizedBox(width: 12),
              BsButton(noWrap: true, onPressed: () {}, child: const Text('Does not wrap')),
            ],
          ),
        ),
        DemoSection(
          title: 'Custom style',
          child: BsButton(
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
        ),
      ],
    );
  }
}
