import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

class ThumbnailsPage extends StatelessWidget {
  const ThumbnailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Thumbnails',
      lead: 'BsThumbnail wraps an image in a bordered, padded, rounded frame — Bootstrap\'s .img-thumbnail.',
      examples: [
        DocExample(
          title: 'Basic',
          description: 'A plain color swatch stands in for a real Image here.',
          code: '''
BsThumbnail(
  child: Image.network('...'),
)''',
          preview: const BsThumbnail(
            child: DecoratedBox(
              decoration: BoxDecoration(color: BsColors.gray300),
              child: SizedBox(width: 200, height: 150),
            ),
          ),
        ),
        DocExample(
          title: 'Style overrides',
          description: 'style layers overrides — such as a wider border or larger radius — on top of BsThumbnailStyle.defaults.',
          code: '''
BsThumbnail(
  style: BsThumbnailStyle(borderWidth: 3, borderRadius: 12, borderColor: BsColors.blue),
  child: Image.network('...'),
)''',
          preview: const BsThumbnail(
            style: BsThumbnailStyle(borderWidth: 3, borderRadius: 12, borderColor: BsColors.blue),
            child: DecoratedBox(
              decoration: BoxDecoration(color: BsColors.gray300),
              child: SizedBox(width: 200, height: 150),
            ),
          ),
        ),
      ],
    );
  }
}
