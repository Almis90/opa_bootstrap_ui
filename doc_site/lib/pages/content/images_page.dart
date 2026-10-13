import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_content.dart';
import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

const _asset = AssetImage('assets/examples/heroes/bootstrap-themes.png');
const _wideAsset = AssetImage('assets/examples/heroes/bootstrap-docs.png');

String _number(double value) =>
    value == value.roundToDouble() ? value.toInt().toString() : '$value';

/// "Images": responsive images, thumbnails, aligning images, and the
/// `picture` element, with `BsImage` and `BsThumbnail`.
class ImagesPage extends StatelessWidget {
  const ImagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      leadGap: 0,
      title: 'Images',
      lead:
          'Opt images into responsive behavior, so they never become wider '
          'than their parent, and give them lightweight styles, with '
          'BsImage and BsThumbnail.',
      children: [
        const DocHeading('Responsive images'),
        DocText([
          'Images in Bootstrap are made responsive with ',
          DocCode('.img-fluid'),
          ', which applies ',
          DocCode('max-width: 100%'),
          ' and ',
          DocCode('height: auto'),
          ' to the image so that it scales with the parent width. ',
          DocCode('BsImage'),
          ' does the same with ',
          DocCode('fluid: true'),
          '. The height always follows from the aspect ratio of the picture.',
        ]),
        DocExample(
          code: '''
BsImage(
  image: AssetImage('assets/bootstrap-themes.png'),
  width: 400,
  fluid: true,
  alt: 'Responsive image',
)''',
          preview: const BsImage(
            image: _asset,
            width: 400,
            fluid: true,
            alt: 'Responsive image',
          ),
        ),
        DocText([
          'The previews on this page draw an image that belongs to this doc '
              'site. In your app, give ',
          DocCode('image'),
          ' any ',
          DocCode('ImageProvider'),
          ': ',
          DocCode('AssetImage'),
          ', ',
          DocCode('NetworkImage'),
          ' or ',
          DocCode('FileImage'),
          '. Narrow the window and the image above shrinks with it.',
        ]),
        DocText([
          DocCode('width'),
          ' is the width of the whole box, border included, like ',
          DocCode('width'),
          ' with ',
          DocCode('box-sizing: border-box'),
          '. Leave it out and the image takes its natural width, capped by '
              'the container when it is fluid. Without ',
          DocCode('fluid'),
          ' an image keeps its width even where the container is narrower, '
              'and it overflows.',
        ]),
        const DocHeading('Image thumbnails'),
        DocText([
          'In addition to the border radius props of ',
          DocCode('BsImage'),
          ' (see ',
          DocLink.page('Borders', 'Utilities', 'Borders'),
          '), wrap an image in a ',
          DocCode('BsThumbnail'),
          ' to give it a rounded 1px border appearance, like ',
          DocCode('.img-thumbnail'),
          ': 4 logical pixels of padding on the background of the page, then '
              'the border. The frame adds 10 pixels to the width of its '
              'child, so a 190 wide image makes a 200 wide thumbnail.',
        ]),
        DocExample(
          code: '''
BsThumbnail(
  child: BsImage(
    image: AssetImage('assets/bootstrap-themes.png'),
    width: 190,
    alt: 'A thumbnail of a page',
  ),
)''',
          preview: const BsThumbnail(
            child: BsImage(
              image: _asset,
              width: 190,
              alt: 'A thumbnail of a page',
            ),
          ),
        ),
        DocText([
          'The frame is made of the thumbnail variables of Bootstrap. Each is '
              'a field of ',
          DocCode('BsThumbnailStyle'),
          ' that a thumbnail takes as ',
          DocCode('style'),
          ', layered over the defaults. In dark mode the background and the '
              'border color are the dark ones.',
        ]),
        DocExample(
          code: '''
BsThumbnail(
  style: BsThumbnailStyle(
    padding: 8,
    borderWidth: 3,
    borderRadius: 12,
    borderColor: BsColors.blue,
    boxShadow: BsThumbnailStyle.defaultBoxShadow,
  ),
  child: BsImage(
    image: AssetImage('assets/bootstrap-themes.png'),
    width: 184,
    alt: 'A framed thumbnail',
  ),
)''',
          preview: const BsThumbnail(
            style: BsThumbnailStyle(
              padding: 8,
              borderWidth: 3,
              borderRadius: 12,
              borderColor: BsColors.blue,
              boxShadow: BsThumbnailStyle.defaultBoxShadow,
            ),
            child: BsImage(
              image: _asset,
              width: 184,
              alt: 'A framed thumbnail',
            ),
          ),
        ),
        DocText([
          'There is no shadow unless you ask for one. Bootstrap too applies ',
          DocCode(r'$thumbnail-box-shadow'),
          ' only when shadows are enabled, which they are not by default, '
              'and ',
          DocCode('BsThumbnailStyle.defaultBoxShadow'),
          ' is that small shadow.',
        ]),
        const DocHeading('Aligning images'),
        DocText([
          'Bootstrap aligns images with the float classes or the text '
              'alignment classes, and centers a block image with ',
          DocCode('.mx-auto'),
          '. There is no float here, since nothing flows around a widget, '
              'so place the images with the layout widgets instead.',
        ]),
        DocText([
          'To push images to the two sides, which is ',
          DocCode('.float-start'),
          ' and ',
          DocCode('.float-end'),
          ', space them out with a ',
          DocCode('Wrap'),
          ' (or a ',
          DocCode('Row'),
          ' when they are known to fit). The ',
          DocCode('rounded'),
          ' prop takes the corner radius.',
        ]),
        DocExample(
          code: '''
Wrap(
  alignment: WrapAlignment.spaceBetween,
  runSpacing: 16,
  children: [
    BsImage(image: image, width: 200, rounded: BsRounded.r2, alt: '...'),
    BsImage(image: image, width: 200, rounded: BsRounded.r2, alt: '...'),
  ],
)''',
          preview: const Wrap(
            alignment: WrapAlignment.spaceBetween,
            runSpacing: 16,
            children: [
              BsImage(
                image: _asset,
                width: 200,
                rounded: BsRounded.r2,
                alt: 'The first image',
              ),
              BsImage(
                image: _asset,
                width: 200,
                rounded: BsRounded.r2,
                alt: 'The second image',
              ),
            ],
          ),
        ),
        DocText([
          'A block image can be centered with an automatic horizontal margin, '
              'as with ',
          DocCode('.mx-auto d-block'),
          '. An image is inline content by default, placed by the text '
              'around it; ',
          DocCode('block: true'),
          ' makes it a block of its own.',
        ]),
        DocExample(
          code: '''
BsBox(
  mx: BsSpacing.auto,
  child: BsImage(
    image: image,
    width: 200,
    block: true,
    rounded: BsRounded.r2,
    alt: '...',
  ),
)''',
          preview: const BsBox(
            mx: BsSpacing.auto,
            child: BsImage(
              image: _asset,
              width: 200,
              block: true,
              rounded: BsRounded.r2,
              alt: 'A centered image',
            ),
          ),
        ),
        DocText([
          'Or center the inline image with the text alignment of a box, like ',
          DocCode('.text-center'),
          '. The box has to be as wide as the space it is in for the ',
          DocCode('textAlign'),
          ' to have room to work with, so put it in a ',
          DocCode('Column'),
          ' that stretches its children, as the grid does for you.',
        ]),
        DocExample(
          code: '''
Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
  children: [
    BsBox(
      textAlign: BsTextAlign.center,
      child: BsImage(image: image, width: 200, rounded: BsRounded.r2, alt: '...'),
    ),
  ],
)''',
          preview: const Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              BsBox(
                textAlign: BsTextAlign.center,
                child: BsImage(
                  image: _asset,
                  width: 200,
                  rounded: BsRounded.r2,
                  alt: 'A centered image',
                ),
              ),
            ],
          ),
        ),
        const DocHeading('Picture'),
        DocText([
          'Bootstrap\'s advice for the ',
          DocCode('<picture>'),
          ' element is to put the ',
          DocCode('.img-*'),
          ' classes on the ',
          DocCode('<img>'),
          ' and not on the ',
          DocCode('<picture>'),
          '. There is no such element; its two jobs are done by Flutter and '
              'by you:',
        ]),
        DocList([
          DocListItem([
            DocBold('Pixel density.'),
            ' An ',
            DocCode('AssetImage'),
            ' picks the variant for the screen on its own, from the folders '
                'next to the image named after the scale: ',
            DocCode('assets/2.0x/photo.png'),
            ' and ',
            DocCode('assets/3.0x/photo.png'),
            ' for ',
            DocCode('assets/photo.png'),
            '. This is the ',
            DocCode('srcset'),
            ' with ',
            DocCode('2x'),
            ' and ',
            DocCode('3x'),
            '.',
          ]),
          DocListItem([
            DocBold('Art direction.'),
            ' Where ',
            DocCode('<source media>'),
            ' would choose another picture for a viewport, read the '
                'breakpoint and choose the provider (see ',
            DocLink.page('Breakpoints', 'Layout', 'Breakpoints'),
            ').',
          ]),
        ]),
        DocExample(
          code: '''
@override
Widget build(BuildContext context) {
  final breakpoint = BsBreakpoint.forWidth(MediaQuery.sizeOf(context).width);
  final md = breakpoint.index >= BsBreakpoint.md.index;

  return BsImage(
    image: AssetImage(md ? 'assets/wide.png' : 'assets/narrow.png'),
    width: 400,
    fluid: true,
    border: true,
    alt: '...',
  );
}''',
          preview: const _ArtDirection(),
        ),
        const DocHeading('Accessibility'),
        DocText([
          'Describe what the image shows in ',
          DocCode('alt'),
          ', and screen readers announce it as an image with that label. An '
              'empty ',
          DocCode('alt'),
          ' marks the image as decorative, and leaving it out has the same '
              'effect, so say it with an empty string when you mean it. A '
              'decorative image is left out of the semantics tree and a '
              'screen reader skips it. A picture that fails to load is drawn as an empty box and '
              'not as an error.',
        ]),
        const DocHeading('Tokens'),
        DocText([
          'The thumbnail variables of Bootstrap are the fields of ',
          DocCode('BsThumbnailStyle'),
          '. Every field is optional, and the default is used where one is '
              'left out. Sizes are in logical pixels.',
        ]),
        DocTable(
          headers: ['Bootstrap (Sass)', 'BsThumbnailStyle', 'Default'],
          rows: [
            [
              r'$thumbnail-padding',
              'padding',
              _number(BsThumbnailStyle.defaultPadding),
            ],
            [
              r'$thumbnail-bg',
              'background',
              'The page background: white in light mode, the dark body '
                  'background in dark mode',
            ],
            [
              r'$thumbnail-border-width',
              'borderWidth',
              _number(BsThumbnailStyle.defaultBorderWidth),
            ],
            [
              r'$thumbnail-border-color',
              'borderColor',
              'The border color: gray 300 in light mode, gray 700 in dark '
                  'mode',
            ],
            [
              r'$thumbnail-border-radius',
              'borderRadius',
              _number(BsThumbnailStyle.defaultBorderRadius),
            ],
            [
              r'$thumbnail-box-shadow',
              'boxShadow',
              'None. BsThumbnailStyle.defaultBoxShadow is the small shadow.',
            ],
          ],
        ),
      ],
    );
  }
}

class _ArtDirection extends StatelessWidget {
  const _ArtDirection();

  @override
  Widget build(BuildContext context) {
    final breakpoint = BsBreakpoint.forWidth(MediaQuery.sizeOf(context).width);
    final md = breakpoint.index >= BsBreakpoint.md.index;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 8,
      children: [
        BsImage(
          image: md ? _wideAsset : _asset,
          width: 400,
          fluid: true,
          border: true,
          alt: md ? 'The docs page' : 'The themes page',
        ),
        Text(
          md
              ? 'md and up: bootstrap-docs.png'
              : 'Below md: bootstrap-themes.png',
        ),
      ],
    );
  }
}
