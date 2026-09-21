import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'demo_page.dart';

class SpinnerPage extends StatelessWidget {
  const SpinnerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Spinners',
      children: [
        DemoSection(
          title: 'Border spinner',
          child: Row(
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
        DemoSection(
          title: 'Grow spinner',
          child: Row(
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
        DemoSection(
          title: 'Colors',
          child: Wrap(
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
        DemoSection(
          title: 'In a button',
          child: BsButton(
            onPressed: () {},
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const BsSpinnerBorder(size: BsSpinnerSize.small, color: BsColors.white, semanticsLabel: null),
                const SizedBox(width: 8),
                const Text('Loading...'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
