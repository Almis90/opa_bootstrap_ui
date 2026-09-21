import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'demo_page.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Progress',
      children: [
        DemoSection(title: 'Basic', child: const BsProgress(value: 25)),
        DemoSection(
          title: 'Variants',
          child: Column(
            children: [
              for (final variant in [
                BsVariant.success,
                BsVariant.info,
                BsVariant.warning,
                BsVariant.danger,
              ])
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: BsProgress(value: 50, variant: variant),
                ),
            ],
          ),
        ),
        DemoSection(
          title: 'Label',
          child: BsProgress(value: 75, label: const Text('75%')),
        ),
        DemoSection(
          title: 'Height',
          child: const BsProgress(value: 25, height: 4),
        ),
        DemoSection(
          title: 'Striped',
          child: BsProgress(
            value: 60,
            striped: true,
            variant: BsVariant.success,
          ),
        ),
        DemoSection(
          title: 'Animated stripes',
          child: BsProgress(value: 60, animated: true, variant: BsVariant.info),
        ),
        DemoSection(
          title: 'Multiple bars',
          child: BsProgress.stacked(
            bars: [
              BsProgressBar(value: 15, variant: BsVariant.success),
              BsProgressBar(
                value: 30,
                variant: BsVariant.warning,
                striped: true,
              ),
              BsProgressBar(value: 20, variant: BsVariant.danger),
            ],
          ),
        ),
      ],
    );
  }
}
