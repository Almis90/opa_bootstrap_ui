import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';
import '../../src/doc_style_table.dart';

class SpinnersPage extends StatelessWidget {
  const SpinnersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Spinners',
      lead:
          'BsSpinnerBorder and BsSpinnerGrow render Bootstrap\'s two loading-indicator styles — a rotating ring '
          'and a pulsing dot — each taking a color and a BsSpinnerSize.',
      examples: [
        DocExample(
          title: 'Border spinner',
          description: 'BsSpinnerBorder draws a rotating ring; color and size (BsSpinnerSize.small) can be overridden.',
          code: '''
Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    BsSpinnerBorder(),
    SizedBox(width: 16),
    BsSpinnerBorder(color: BsColors.blue),
    SizedBox(width: 16),
    BsSpinnerBorder(size: BsSpinnerSize.small),
  ],
)''',
          preview: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BsSpinnerBorder(),
              const SizedBox(width: 16),
              BsSpinnerBorder(color: BsColors.blue),
              const SizedBox(width: 16),
              const BsSpinnerBorder(size: BsSpinnerSize.small),
            ],
          ),
        ),
        DocExample(
          title: 'Grow spinner',
          description: 'BsSpinnerGrow scales a filled dot in and out instead of rotating a ring.',
          code: '''
Row(
  mainAxisSize: MainAxisSize.min,
  children: [
    BsSpinnerGrow(),
    SizedBox(width: 16),
    BsSpinnerGrow(color: BsColors.green),
    SizedBox(width: 16),
    BsSpinnerGrow(size: BsSpinnerSize.small),
  ],
)''',
          preview: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BsSpinnerGrow(),
              const SizedBox(width: 16),
              BsSpinnerGrow(color: BsColors.green),
              const SizedBox(width: 16),
              const BsSpinnerGrow(size: BsSpinnerSize.small),
            ],
          ),
        ),
        DocExample(
          title: 'Colors',
          description: 'color accepts any BsColors value to match the surrounding context.',
          code: '''
Wrap(
  spacing: 16,
  runSpacing: 16,
  children: [
    for (final color in [BsColors.blue, BsColors.gray600, BsColors.green, BsColors.cyan, BsColors.yellow, BsColors.red])
      BsSpinnerBorder(color: color),
  ],
)''',
          preview: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: [
              for (final color in [
                BsColors.blue,
                BsColors.gray600,
                BsColors.green,
                BsColors.cyan,
                BsColors.yellow,
                BsColors.red,
              ])
                BsSpinnerBorder(color: color),
            ],
          ),
        ),
        DocExample(
          title: 'In a button',
          description: 'A small, white spinner alongside label text signals a pending action inside a BsButton.',
          code: '''
BsButton(
  onPressed: () {},
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      BsSpinnerBorder(size: BsSpinnerSize.small, color: BsColors.white, semanticsLabel: null),
      SizedBox(width: 8),
      Text('Loading...'),
    ],
  ),
)''',
          preview: BsButton(
            onPressed: () {},
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                BsSpinnerBorder(size: BsSpinnerSize.small, color: BsColors.white, semanticsLabel: null),
                SizedBox(width: 8),
                Text('Loading...'),
              ],
            ),
          ),
        ),
      ],
      children: const [
        DocStyleTable(
          styleClass: 'BsSpinnerStyle',
          defaultsNote:
              "The values below are for size: BsSpinnerSize.normal, the default for both BsSpinnerBorder and "
              "BsSpinnerGrow. Passing size: BsSpinnerSize.small swaps in BsSpinnerStyle.small instead, which only "
              "changes size (16) and borderWidth (3.2) — verticalAlign and animationDuration stay the same. "
              "color isn't part of BsSpinnerStyle at all; it's a separate parameter on BsSpinnerBorder/"
              "BsSpinnerGrow, defaulting to the surrounding text color.",
          rows: [
            DocStyleRow(field: 'size', defaultValue: '32'),
            DocStyleRow(field: 'borderWidth', defaultValue: '4'),
            DocStyleRow(field: 'animationDuration', defaultValue: '750ms'),
            DocStyleRow(field: 'verticalAlign', defaultValue: '-2'),
          ],
        ),
      ],
    );
  }
}
