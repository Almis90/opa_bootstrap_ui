import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

class ContainersPage extends StatelessWidget {
  const ContainersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Containers',
      lead:
          'BsContainer caps its child\'s width at each breakpoint\'s max-width and centers it, '
          'matching Bootstrap\'s .container. A .fluid constructor always fills the available '
          'width, and responsiveFrom caps only from a given breakpoint upward.',
      examples: [
        DocExample(
          title: '.container',
          description: 'The default constructor caps width at every breakpoint. Resize the window to see it step.',
          code: "BsContainer(child: content)",
          preview: BsContainer(child: _box('BsContainer')),
        ),
        DocExample(
          title: '.container-fluid',
          description: 'BsContainer.fluid always spans 100% of its parent\'s width.',
          code: "BsContainer.fluid(child: content)",
          preview: BsContainer.fluid(child: _box('BsContainer.fluid')),
        ),
        DocExample(
          title: '.container-md',
          description: 'BsContainer.responsiveFrom(breakpoint) is fluid below the given breakpoint and capped from it upward.',
          code: "BsContainer.responsiveFrom(BsBreakpoint.md, child: content)",
          preview: BsContainer.responsiveFrom(BsBreakpoint.md, child: _box('BsContainer.responsiveFrom(md)')),
        ),
      ],
    );
  }

  static Widget _box(String label) {
    return DecoratedBox(
      decoration: const BoxDecoration(color: BsColors.gray200),
      child: Padding(padding: const EdgeInsets.symmetric(vertical: 16), child: Center(child: Text(label))),
    );
  }
}
