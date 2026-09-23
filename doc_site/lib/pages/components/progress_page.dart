import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Progress',
      lead:
          'BsProgress renders a rounded, height-capped track filled to value between min and max, while '
          'BsProgress.stacked lays several BsProgressBar segments side by side inside one track.',
      examples: [
        DocExample(
          title: 'Basic',
          description: 'A single BsProgress filled to a percentage of its min/max range.',
          code: "BsProgress(value: 25)",
          preview: const BsProgress(value: 25),
        ),
        DocExample(
          title: 'Variants',
          description: 'variant recolors the fill using the same BsVariant palette as buttons and alerts.',
          code: '''
Column(
  children: [
    BsProgress(value: 50, variant: BsVariant.success),
    BsProgress(value: 50, variant: BsVariant.info),
    BsProgress(value: 50, variant: BsVariant.warning),
    BsProgress(value: 50, variant: BsVariant.danger),
  ],
)''',
          preview: Column(
            children: [
              for (final variant in [BsVariant.success, BsVariant.info, BsVariant.warning, BsVariant.danger])
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: BsProgress(value: 50, variant: variant),
                ),
            ],
          ),
        ),
        DocExample(
          title: 'Label',
          description: 'label centers a widget, typically text, on top of the fill.',
          code: "BsProgress(value: 75, label: Text('75%'))",
          preview: BsProgress(value: 75, label: const Text('75%')),
        ),
        DocExample(
          title: 'Height',
          description: 'height overrides the track\'s default thickness.',
          code: "BsProgress(value: 25, height: 4)",
          preview: const BsProgress(value: 25, height: 4),
        ),
        DocExample(
          title: 'Striped',
          description: 'striped: true overlays diagonal stripes on the fill.',
          code: "BsProgress(value: 60, striped: true, variant: BsVariant.success)",
          preview: const BsProgress(value: 60, striped: true, variant: BsVariant.success),
        ),
        DocExample(
          title: 'Animated stripes',
          description: 'animated: true keeps the stripes scrolling continuously (implies striped).',
          code: "BsProgress(value: 60, animated: true, variant: BsVariant.info)",
          preview: const BsProgress(value: 60, animated: true, variant: BsVariant.info),
        ),
        DocExample(
          title: 'Multiple bars',
          description: 'BsProgress.stacked lays out several independently colored BsProgressBar segments in one track.',
          code: '''
BsProgress.stacked(
  bars: [
    BsProgressBar(value: 15, variant: BsVariant.success),
    BsProgressBar(value: 30, variant: BsVariant.warning, striped: true),
    BsProgressBar(value: 20, variant: BsVariant.danger),
  ],
)''',
          preview: const BsProgress.stacked(
            bars: [
              BsProgressBar(value: 15, variant: BsVariant.success),
              BsProgressBar(value: 30, variant: BsVariant.warning, striped: true),
              BsProgressBar(value: 20, variant: BsVariant.danger),
            ],
          ),
        ),
      ],
    );
  }
}
