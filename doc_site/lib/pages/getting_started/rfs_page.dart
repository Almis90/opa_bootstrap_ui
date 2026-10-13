import 'package:flutter/widgets.dart';

import '../../src/doc_content.dart';
import '../../src/doc_page.dart';
import '../../src/doc_syntax.dart';

const _docs = 'https://almis90.github.io/opa_rfs/';

/// "RFS": fluid responsive sizing, provided by the opa_rfs package.
class RfsPage extends StatelessWidget {
  const RfsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const DocPage(
      leadGap: 0,
      title: 'RFS',
      lead:
          'RFS is a fluid responsive sizing engine: sizes scale smoothly with '
          'the space they have. In Flutter it comes from the opa_rfs package.',
      children: [
        DocHeading('What is RFS?'),
        DocText([
          'RFS gives a value a maximum and a minimum, and scales it '
              'continuously between them as the available space changes, '
              'instead of jumping at breakpoints. ',
          DocLink.url('opa_rfs', 'https://github.com/Almis90/opa_rfs'),
          ' applies that to font sizes, padding and margins, border radii, '
              'shadows and other dimensions, with one curve for all of them.',
        ]),
        DocHeading('Installation'),
        DocText([
          'opa_rfs is not part of opa_bootstrap_ui and is not installed with '
              'it: add it to your project when you want it.',
        ]),
        DocCodeSnippet('flutter pub add opa_rfs', language: DocLanguage.bash),
        DocCodeSnippet("import 'package:opa_rfs/opa_rfs.dart';"),
        DocText([
          'There is nothing to set up. The headings and display text of '
              'opa_bootstrap_ui already scale fluidly below the ',
          DocCode('xl'),
          ' breakpoint, as Bootstrap\'s responsive font sizes do, without '
              'opa_rfs. Use opa_rfs for the sizes of your own widgets.',
        ]),
        DocHeading('Using RFS'),
        DocText([
          'The widgets of opa_rfs work inside a ',
          DocCode('BsApp'),
          ' like any other. ',
          DocCode('Rfs.contextValue'),
          ' resolves a size from the window, ',
          DocCode('RfsText'),
          ' is a text that scales its font size, and ',
          DocCode('RfsBox'),
          ' is a box that scales its padding, radius and shadow.',
        ]),
        DocCodeSnippet('''
// A value, from the window: 40 on wide windows, easing down to 28.
Text(
  'Fluid headline',
  style: TextStyle(fontSize: Rfs.contextValue(context, 40, min: 28)),
)

// The same, as a widget.
const RfsText('Fluid headline', maxFontSize: 40, minFontSize: 28)

// A box whose padding and radius scale.
RfsBox(
  maxPadding: 32,
  minPadding: 16,
  maxBorderRadius: 24,
  decoration: const BoxDecoration(color: Color(0xFFF8F9FA)),
  child: BsButton(onPressed: () {}, child: const Text('Go')),
)'''),
        DocHeading('RFS API'),
        DocTable(
          headers: ['API', 'Use'],
          rows: [
            [
              'Rfs.value(64, width: 600, min: 36)',
              'Resolves a value for a width you give: predictable, and '
                  'easy to test.',
            ],
            [
              'Rfs.contextValue(context, 48, min: 20)',
              'Resolves a value from the window and the nearest scope.',
            ],
            ['Rfs.fontSize(context, 34)', 'The same, named for font sizes.'],
            [
              'Rfs.valueForSize(24, size: size)',
              'Resolves a value from a Size, optionally by its shortest side.',
            ],
            [
              'RfsValue(max: 64, min: 36)',
              'A pair of limits as a constant, shared across the app and '
                  'resolved with resolve(width: …).',
            ],
          ],
        ),
        DocHeading('Configuration'),
        DocText([
          DocCode('RfsConfig'),
          ' sets how values scale: the ',
          DocCode('baseValue'),
          ' under which a value stays fixed, the ',
          DocCode('breakpoint'),
          ' above which it reaches its maximum, the ',
          DocCode('factor'),
          ' of the curve, and whether scaling is ',
          DocCode('enabled'),
          '. ',
          DocCode('RfsScope'),
          ' shares a configuration with everything below it, and ',
          DocCode('RfsEnabled'),
          ' switches scaling on or off for a subtree.',
        ]),
        DocCodeSnippet('''
RfsScope(
  config: const RfsConfig(baseValue: 16, breakpoint: 1000),
  child: const MyApp(),
)'''),
        DocText([
          'The ',
          DocLink.url('opa_rfs documentation', _docs),
          ' describes each option.',
        ]),
        DocHeading('Responsive sizing'),
        DocText([
          'RFS complements breakpoints; it does not replace them. A '
              'breakpoint changes what is laid out: the number of columns, '
              'what is shown or hidden. RFS changes how big things are in '
              'between. Use a ',
          DocCode('BsResponsiveValue'),
          ' for the first and RFS for the second, and the two work together.',
        ]),
        DocHeading('Accessibility'),
        DocText([
          'opa_rfs chooses the base size of the text, and Flutter\'s ',
          DocCode('TextScaler'),
          ' stays in charge of the scaling the user asks for in the system '
              'settings, so fluid text still follows it.',
        ]),
        DocHeading('Extended documentation'),
        DocList([
          DocListItem([DocLink.url('The opa_rfs guide and playground', _docs)]),
          DocListItem([
            DocLink.url('The opa_rfs API reference', '${_docs}api/'),
          ]),
          DocListItem([
            DocLink.url(
              'opa_rfs on pub.dev',
              'https://pub.dev/packages/opa_rfs',
            ),
          ]),
          DocListItem([
            DocLink.url(
              'opa_rfs on GitHub',
              'https://github.com/Almis90/opa_rfs',
            ),
          ]),
        ]),
      ],
    );
  }
}
