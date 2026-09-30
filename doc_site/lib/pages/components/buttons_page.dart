import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';
import '../../src/doc_style_table.dart';

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
      children: const [
        DocStyleTable(
          styleClass: 'BsButtonStyle',
          sassFile: 'scss/_buttons.scss',
          defaultsNote:
              'BsButtonStyle has no single BsButtonStyle.defaults — the color/padding/radius fields are computed '
              'by BsButtonStyle.forVariant(variant, size: size). The values below are what that resolves to for '
              "BsButton's own defaults, variant: BsVariant.primary and size: BsSize.normal — pass a different "
              'variant/size and the color/padding/radius rows change; the rest stay fixed.',
          rows: [
            DocStyleRow(field: 'color', bootstrapVar: '--bs-btn-color', defaultValue: 'BsColors.white (#fff)'),
            DocStyleRow(field: 'background', bootstrapVar: '--bs-btn-bg', defaultValue: 'BsColors.blue (#0d6efd)'),
            DocStyleRow(field: 'borderColor', bootstrapVar: '--bs-btn-border-color', defaultValue: 'BsColors.blue (#0d6efd); same as background'),
            DocStyleRow(field: 'hoverColor', bootstrapVar: '--bs-btn-hover-color', defaultValue: 'BsColors.white (#fff)'),
            DocStyleRow(field: 'hoverBackground', bootstrapVar: '--bs-btn-hover-bg', defaultValue: '#0b5ed7 (background shaded 15%)'),
            DocStyleRow(field: 'hoverBorderColor', bootstrapVar: '--bs-btn-hover-border-color', defaultValue: '#0a58ca (borderColor shaded 20%)'),
            DocStyleRow(field: 'activeColor', bootstrapVar: '--bs-btn-active-color', defaultValue: 'BsColors.white (#fff)'),
            DocStyleRow(field: 'activeBackground', bootstrapVar: '--bs-btn-active-bg', defaultValue: '#0a58ca (background shaded 20%)'),
            DocStyleRow(field: 'activeBorderColor', bootstrapVar: '--bs-btn-active-border-color', defaultValue: '#0a53be (borderColor shaded 25%)'),
            DocStyleRow(field: 'padding', bootstrapVar: '--bs-btn-padding-x / -y', defaultValue: '12×6 (sm: 8×4, lg: 16×8)'),
            DocStyleRow(field: 'textStyle', bootstrapVar: '--bs-btn-font-* / -line-height', defaultValue: '16px, normal weight, 1.5 line-height (sm: 14px, lg: 20px)'),
            DocStyleRow(field: 'borderRadius', bootstrapVar: '--bs-btn-border-radius', defaultValue: '6px (sm: 4px, lg: 8px)'),
            DocStyleRow(field: 'borderWidth', bootstrapVar: '--bs-btn-border-width', defaultValue: '1'),
            DocStyleRow(field: 'disabledOpacity', bootstrapVar: '--bs-btn-disabled-opacity', defaultValue: '0.65'),
            DocStyleRow(field: 'boxShadow', bootstrapVar: '--bs-btn-box-shadow', defaultValue: 'Inset top highlight + subtle drop shadow'),
            DocStyleRow(field: 'activeShadow', bootstrapVar: '--bs-btn-active-shadow', defaultValue: 'Inset pressed-in shadow'),
            DocStyleRow(field: 'focusRingColor', bootstrapVar: '--bs-btn-focus-shadow-rgb', defaultValue: '#3184fd (mix of color/borderColor at 15%)'),
            DocStyleRow(field: 'focusRingWidth', bootstrapVar: r'$btn-focus-width', defaultValue: '4'),
            DocStyleRow(field: 'transitionDuration', bootstrapVar: r'$btn-transition', defaultValue: '150ms'),
            DocStyleRow(field: 'transitionCurve', bootstrapVar: r'$btn-transition', defaultValue: 'easeInOut'),
          ],
        ),
      ],
    );
  }
}
