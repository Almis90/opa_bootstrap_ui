import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'demo_page.dart';

class FigurePage extends StatelessWidget {
  const FigurePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Figures',
      children: [
        DemoSection(
          title: 'Basic',
          child: BsFigure(
            image: _placeholderImage(),
            caption: const BsFigureCaption(
              child: Text('A caption for the above image.'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _placeholderImage() {
    return const DecoratedBox(
      decoration: BoxDecoration(color: BsColors.gray300),
      child: SizedBox(width: 400, height: 300),
    );
  }
}
