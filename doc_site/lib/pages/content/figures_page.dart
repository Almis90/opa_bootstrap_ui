import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_content.dart';
import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

const _asset = AssetImage('assets/examples/heroes/bootstrap-themes.png');

String _number(double value) =>
    value == value.roundToDouble() ? value.toInt().toString() : '$value';

/// "Figures": `BsFigure` and `BsFigureCaption`, and `BsFigureStyle`.
class FiguresPage extends StatelessWidget {
  const FiguresPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      leadGap: 0,
      title: 'Figures',
      lead:
          'Documentation and examples for displaying related images and '
          'text with the figure component in Bootstrap.',
      children: [
        DocText([
          'Anytime you need to display a piece of content, like an image with '
              'an optional caption, consider using a ',
          DocCode('BsFigure'),
          '. It is the ',
          DocCode('<figure>'),
          ' of Bootstrap with its ',
          DocCode('<figcaption>'),
          ': pass the picture as ',
          DocCode('image'),
          ' and, under it, a ',
          DocCode('BsFigureCaption'),
          ' as ',
          DocCode('caption'),
          '. The classes ',
          DocCode('.figure'),
          ', ',
          DocCode('.figure-img'),
          ' and ',
          DocCode('.figure-caption'),
          ' are what the two widgets do: the figure is as wide as its widest '
              'part, with the caption 8 logical pixels below the image, and the '
              'caption is small and muted.',
        ]),
        DocText([
          'Images in figures have no explicit size, so use a ',
          DocCode('BsImage'),
          ' with ',
          DocCode('fluid: true'),
          ' to make the picture responsive (see ',
          DocLink.page('Images', 'Content', 'Images'),
          '). The figure has to know the width of its image, which an ',
          DocCode('Image'),
          ', a ',
          DocCode('BsImage'),
          ' and a ',
          DocCode('SizedBox'),
          ' can tell, to line up the caption with it.',
        ]),
        DocExample(
          code: '''
BsFigure(
  image: BsImage(
    image: AssetImage('assets/bootstrap-themes.png'),
    width: 400,
    fluid: true,
    rounded: BsRounded.r2,
    alt: 'A page of themes',
  ),
  caption: BsFigureCaption(
    child: Text('A caption for the above image.'),
  ),
)''',
          preview: const BsFigure(
            image: BsImage(
              image: _asset,
              width: 400,
              fluid: true,
              rounded: BsRounded.r2,
              alt: 'A page of themes',
            ),
            caption: BsFigureCaption(
              child: Text('A caption for the above image.'),
            ),
          ),
        ),
        DocText([
          'A figure has no margin of its own. The Reboot of Bootstrap gives ',
          DocCode('<figure>'),
          ' a bottom margin of 16 pixels (see ',
          DocLink.page('Reboot', 'Content', 'Reboot'),
          '); add it with a ',
          DocCode('BsBox'),
          ' around the figure when you need it, as ',
          DocCode('mb: BsSpacing.s3'),
          '.',
        ]),
        const DocHeading('Aligning the caption'),
        DocText([
          'Aligning the caption of a figure is easy with the text alignment '
              'of a ',
          DocCode('BsBox'),
          ' (see ',
          DocLink.page('Text', 'Utilities', 'Text'),
          '), which does for the caption what ',
          DocCode('.text-end'),
          ' does in Bootstrap. The caption is as wide as the figure, so it '
              'lines up with the image.',
        ]),
        DocExample(
          code: '''
BsFigure(
  image: BsImage(
    image: AssetImage('assets/bootstrap-themes.png'),
    width: 400,
    fluid: true,
    rounded: BsRounded.r2,
    alt: 'A page of themes',
  ),
  caption: BsBox(
    textAlign: BsTextAlign.end,
    child: BsFigureCaption(
      child: Text('A caption for the above image.'),
    ),
  ),
)''',
          preview: const BsFigure(
            image: BsImage(
              image: _asset,
              width: 400,
              fluid: true,
              rounded: BsRounded.r2,
              alt: 'A page of themes',
            ),
            caption: BsBox(
              textAlign: BsTextAlign.end,
              child: BsFigureCaption(
                child: Text('A caption for the above image.'),
              ),
            ),
          ),
        ),
        const DocHeading('Tokens'),
        DocText([
          'The look of a caption is the fields of a ',
          DocCode('BsFigureStyle'),
          ', given as the ',
          DocCode('style'),
          ' of a ',
          DocCode('BsFigureCaption'),
          ' and layered over the defaults, which are the dark ones in dark '
              'mode. Both fields are optional.',
        ]),
        DocTable(
          headers: ['Bootstrap (Sass)', 'BsFigureStyle', 'Default'],
          rows: [
            [
              r'$figure-caption-font-size',
              'captionFontSize',
              '${_number(BsFigureStyle.defaultCaptionFontSize)} logical '
                  'pixels, the size of small text',
            ],
            [
              r'$figure-caption-color',
              'captionColor',
              'The secondary color of the body: gray 600, and the dark one in '
                  'dark mode',
            ],
          ],
        ),
        DocExample(
          code: '''
BsFigure(
  image: BsImage(...),
  caption: BsFigureCaption(
    style: BsFigureStyle(captionFontSize: 16, captionColor: BsColors.blue),
    child: Text('A caption for the above image.'),
  ),
)''',
          preview: const BsFigure(
            image: BsImage(
              image: _asset,
              width: 400,
              fluid: true,
              rounded: BsRounded.r2,
              alt: 'A page of themes',
            ),
            caption: BsFigureCaption(
              style: BsFigureStyle(
                captionFontSize: 16,
                captionColor: BsColors.blue,
              ),
              child: Text('A caption for the above image.'),
            ),
          ),
        ),
      ],
    );
  }
}
