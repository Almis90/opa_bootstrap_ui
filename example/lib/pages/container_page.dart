import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'demo_page.dart';

class ContainerPage extends StatelessWidget {
  const ContainerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Container',
      children: [
        DemoSection(
          title: '.container (resize the window)',
          child: BsContainer(child: _box('BsContainer')),
        ),
        DemoSection(
          title: '.container-fluid',
          child: BsContainer.fluid(child: _box('BsContainer.fluid')),
        ),
        DemoSection(
          title: '.container-md',
          child: BsContainer.responsiveFrom(
            BsBreakpoint.md,
            child: _box('BsContainer.responsiveFrom(md)'),
          ),
        ),
      ],
    );
  }

  Widget _box(String label) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: BsColors.gray200),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(child: Text(label)),
      ),
    );
  }
}
