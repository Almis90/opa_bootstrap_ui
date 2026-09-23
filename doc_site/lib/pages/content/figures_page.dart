import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

class FiguresPage extends StatelessWidget {
  const FiguresPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Figures',
      lead:
          'BsFigure pairs an image with an optional BsFigureCaption underneath, styled as a small, muted line '
          'of text beneath the content it describes.',
      examples: [
        DocExample(
          title: 'Basic',
          description: 'Pass any widget as image — here a plain color swatch stands in for a real Image — and a BsFigureCaption below it.',
          code: '''
BsFigure(
  image: DecoratedBox(
    decoration: BoxDecoration(color: BsColors.gray300),
    child: SizedBox(width: 400, height: 300),
  ),
  caption: BsFigureCaption(child: Text('A caption for the above image.')),
)''',
          preview: const BsFigure(
            image: DecoratedBox(
              decoration: BoxDecoration(color: BsColors.gray300),
              child: SizedBox(width: 400, height: 300),
            ),
            caption: BsFigureCaption(child: Text('A caption for the above image.')),
          ),
        ),
      ],
    );
  }
}
