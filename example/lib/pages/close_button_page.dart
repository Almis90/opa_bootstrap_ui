import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'demo_page.dart';

class CloseButtonPage extends StatelessWidget {
  const CloseButtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Close button',
      children: [
        DemoSection(title: 'Example', child: BsCloseButton(onPressed: () {})),
        DemoSection(title: 'Disabled', child: const BsCloseButton(onPressed: null)),
        DemoSection(
          title: 'On a dark background',
          child: ColoredBox(
            color: BsColors.gray900,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: BsCloseButton(
                onPressed: () {},
                style: const BsCloseButtonStyle(color: BsColors.white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
