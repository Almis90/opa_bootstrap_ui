import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

class ButtonsPage extends StatelessWidget {
  const ButtonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Buttons',
      lead:
          'BsButton covers Bootstrap\'s eight contextual variants, an outline mode, three sizes, '
          'and a disabled state, plus a style override for one-off brand colors.',
      examples: [
        DocExample(
          title: 'Variants',
          description: 'Set variant to any BsVariant for the matching contextual color.',
          code: '''
for (final variant in BsVariant.values)
  BsButton(variant: variant, onPressed: () {}, child: Text(variant.name))''',
          preview: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [for (final variant in BsVariant.values) BsButton(variant: variant, onPressed: () {}, child: Text(variant.name))],
          ),
        ),
        DocExample(
          title: 'Outline',
          description: 'outline: true swaps the filled background for a bordered, transparent one.',
          code: '''
for (final variant in BsVariant.values)
  BsButton(variant: variant, outline: true, onPressed: () {}, child: Text(variant.name))''',
          preview: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [for (final variant in BsVariant.values) BsButton(variant: variant, outline: true, onPressed: () {}, child: Text(variant.name))],
          ),
        ),
        DocExample(
          title: 'Sizes',
          description: 'size accepts BsSize.sm or BsSize.lg; the default is the standard size.',
          code: '''
BsButton(size: BsSize.sm, onPressed: () {}, child: const Text('small'))
BsButton(onPressed: () {}, child: const Text('default'))
BsButton(size: BsSize.lg, onPressed: () {}, child: const Text('large'))''',
          preview: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              BsButton(size: BsSize.sm, onPressed: () {}, child: const Text('small')),
              BsButton(onPressed: () {}, child: const Text('default')),
              BsButton(size: BsSize.lg, onPressed: () {}, child: const Text('large')),
            ],
          ),
        ),
        DocExample(
          title: 'Disabled',
          description: 'A null onPressed both disables the button and greys it out — there is no separate enabled flag.',
          code: '''
BsButton(onPressed: null, child: Text('primary'))
BsButton(outline: true, onPressed: null, child: Text('primary'))''',
          preview: const Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              BsButton(onPressed: null, child: Text('primary')),
              BsButton(outline: true, onPressed: null, child: Text('primary')),
            ],
          ),
        ),
        DocExample(
          title: 'Custom style',
          description: 'style layers a BsButtonStyle on top of the variant\'s defaults for brand colors Bootstrap doesn\'t ship.',
          code: '''
BsButton(
  onPressed: () {},
  style: const BsButtonStyle(
    color: BsColors.white,
    background: Color(0xFF5C2D91),
    borderColor: Color(0xFF5C2D91),
    hoverBackground: Color(0xFF4A2474),
    activeBackground: Color(0xFF381A59),
  ),
  child: const Text('Custom brand color'),
)''',
          preview: BsButton(
            onPressed: () {},
            style: const BsButtonStyle(
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
