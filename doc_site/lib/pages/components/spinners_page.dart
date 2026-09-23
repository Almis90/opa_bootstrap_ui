import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

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
    );
  }
}
