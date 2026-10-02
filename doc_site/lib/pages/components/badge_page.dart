import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';
import '../../src/doc_style_table.dart';

class BadgePage extends StatelessWidget {
  const BadgePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Badge',
      lead:
          'BsBadge is a small, inline label that scales its font-size relative to its parent — drop it next to '
          'text, inside a button, or anywhere else a count or status needs a nudge of visual weight.',
      examples: [
        DocExample(
          title: 'Example',
          description: 'A badge sits inline next to a heading or other text at a proportionally smaller size.',
          code: '''
Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    Text('Example heading ', style: TextStyle(fontSize: 24)),
    BsBadge(child: Text('New')),
  ],
)''',
          preview: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Example heading ', style: TextStyle(fontSize: 24)),
              const BsBadge(child: Text('New')),
            ],
          ),
        ),
        DocExample(
          title: 'Background colors',
          description: 'variant picks the badge\'s background/text pairing from the same BsVariant palette used elsewhere.',
          code: '''
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    for (final variant in BsVariant.values)
      BsBadge(variant: variant, child: Text(variant.name)),
  ],
)''',
          preview: Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [for (final variant in BsVariant.values) BsBadge(variant: variant, child: Text(variant.name))],
          ),
        ),
        DocExample(
          title: 'Pill badges',
          description: 'pill: true rounds the badge into a fully-rounded pill shape.',
          code: '''
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: [
    for (final variant in BsVariant.values)
      BsBadge(variant: variant, pill: true, child: Text(variant.name)),
  ],
)''',
          preview: Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              for (final variant in BsVariant.values) BsBadge(variant: variant, pill: true, child: Text(variant.name)),
            ],
          ),
        ),
        DocExample(
          title: 'In buttons',
          description: 'Badges can sit inside a BsButton\'s child to surface a count, typically in a light/outline variant.',
          code: '''
BsButton(
  onPressed: () {},
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text('Notifications'),
      SizedBox(width: 8),
      BsBadge(variant: BsVariant.light, child: Text('4')),
    ],
  ),
)''',
          preview: Wrap(
            spacing: 12,
            runSpacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              BsButton(
                onPressed: () {},
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [Text('Notifications'), SizedBox(width: 8), BsBadge(variant: BsVariant.light, child: Text('4'))],
                ),
              ),
              BsButton(
                variant: BsVariant.secondary,
                onPressed: () {},
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Messages'),
                    SizedBox(width: 8),
                    BsBadge(variant: BsVariant.light, pill: true, child: Text('12')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
      children: const [
        DocStyleTable(
          styleClass: 'BsBadgeStyle',
          defaultsNote:
              "BsBadgeStyle has no single color/background default — both are null unless overridden, and BsBadge "
              'derives them from its variant parameter (default BsVariant.primary) instead: background is the '
              "variant's raw color, and color is whichever of black/white contrasts best against it. Neither is "
              "theme-sensitive — a variant's raw color is a literal with no dark-mode override. The values below "
              'are for the default variant.',
          rows: [
            DocStyleRow(field: 'color', defaultValue: 'null — derived: BsColors.white (contrast against background)'),
            DocStyleRow(field: 'background', defaultValue: 'null — derived: BsColors.blue (BsVariant.primary.color)'),
            DocStyleRow(field: 'fontSize', defaultValue: '12'),
            DocStyleRow(field: 'fontWeight', defaultValue: 'FontWeight.bold'),
            DocStyleRow(field: 'padding', defaultValue: 'EdgeInsets.symmetric(horizontal: 7.8, vertical: 4.2)'),
            DocStyleRow(field: 'borderRadius', defaultValue: '6'),
          ],
        ),
      ],
    );
  }
}
