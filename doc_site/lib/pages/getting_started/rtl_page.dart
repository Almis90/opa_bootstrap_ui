import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_content.dart';
import '../../src/doc_example.dart';
import '../../src/doc_page.dart';
import '../../src/doc_syntax.dart';

/// "RTL": right-to-left layouts, which follow the ambient `Directionality`.
class RtlPage extends StatelessWidget {
  const RtlPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      leadGap: 0,
      title: 'RTL',
      lead:
          'Learn how to lay out right-to-left text with opa_bootstrap_ui: '
          'one widget tree, flipped by the ambient Directionality.',
      children: [
        const DocHeading('Get familiar'),
        DocText([
          'Read the ',
          DocLink.page('Introduction', 'Getting started', 'Introduction'),
          ' first. Once you have run through it, continue here to turn on '
              'right to left.',
        ]),
        const DocHeading('Required setup'),
        DocText([
          'Two things set a right-to-left app up. The first is a ',
          DocCode('Directionality'),
          ' with ',
          DocCode('TextDirection.rtl'),
          ' above your pages: the counterpart of ',
          DocCode('dir="rtl"'),
          ' on the ',
          DocCode('<html>'),
          ' element. The second is a ',
          DocCode('locale'),
          ' for the language: the counterpart of ',
          DocCode('lang="ar"'),
          '. There is no second stylesheet and no second build: the same '
              'widgets lay themselves out in both directions.',
        ]),
        DocText([
          'The ',
          DocCode('locale'),
          ' does not set the direction by itself. Put the ',
          DocCode('Directionality'),
          ' in the ',
          DocCode('builder'),
          ' of ',
          DocCode('BsApp'),
          ' and it reaches everything below, including modals, offcanvas '
              'panels, dropdown menus and other overlays.',
        ]),
        const DocHeading('Starter template', sub: true),
        const DocCodeSnippet('''
import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BsApp(
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),
      home: const Center(child: Text('مرحبًا بالعالم!')),
    );
  }
}'''),
        const DocHeading('RTL examples', sub: true),
        DocText([
          'Get started with one of the ',
          DocLink.examples('RTL examples'),
          ': Album, Blog, Carousel, Cheatsheet, Checkout and Dashboard each '
              'come in a right-to-left version in Arabic.',
        ]),
        const DocHeading('Approach'),
        DocText([
          'Bootstrap builds a second stylesheet with RTLCSS and renames its '
              'directional classes to logical ones. opa_bootstrap_ui needs '
              'neither: Flutter\'s layout is already directional, and the '
              'library takes its cue from ',
          DocBold('start'),
          ' and ',
          DocBold('end'),
          ' rather than left and right, the way Bootstrap\'s ',
          DocCode('ms-3'),
          ' replaced ',
          DocCode('ml-3'),
          '. Nothing in the library\'s API says left or right, so nothing '
              'has to be renamed or swapped.',
        ]),
        DocTable(
          headers: ['Bootstrap', 'opa_bootstrap_ui'],
          rows: [
            ['ms-*, me-*, ps-*, pe-*', 'BsBox(ms: …, me: …, ps: …, pe: …)'],
            [
              'text-start, text-end',
              'BsBox(textAlign: BsTextAlign.start) and BsTextAlign.end',
            ],
            [
              'border-start, border-end',
              'BsBox(borderStart: true) and borderEnd',
            ],
            ['ms-n3 (a negative start margin)', 'BsPullStart(by: 16, …)'],
            [
              'dropstart, dropend',
              'BsDropdown(direction: BsDropdownDirection.start) and .end',
            ],
            [
              'offcanvas-start, offcanvas-end',
              'BsOffcanvasPlacement.start and .end',
            ],
            [
              'Tooltip and popover placements left and right',
              'BsTooltipPlacement and BsPopoverPlacement .start and .end',
            ],
            [
              'Toast containers pinned to top-0 start-0, …',
              'BsToastPosition.topStart, .topEnd, .bottomStart, …',
            ],
          ],
        ),
        DocText([
          'Use the same approach in your own widgets: ',
          DocCode('EdgeInsetsDirectional'),
          ', ',
          DocCode('AlignmentDirectional'),
          ' and ',
          DocCode('BorderRadiusDirectional'),
          ' instead of ',
          DocCode('EdgeInsets.only(left: …)'),
          ', ',
          DocCode('Alignment.centerLeft'),
          ' and ',
          DocCode('BorderRadius.only(topLeft: …)'),
          '.',
        ]),
        const DocHeading('What flips'),
        DocText([
          'Rows, flex layouts, navs, accordions and anything else laid out '
              'with a ',
          DocCode('BsFlex'),
          ' or a ',
          DocCode('Row'),
          ' read from the right with no work from you. Beyond layout, the '
              'pieces that depend on a physical side follow the direction too:',
        ]),
        const DocList([
          DocListItem([
            'Button groups, card groups and horizontal list groups overlap '
                'their shared edges on the correct side.',
          ]),
          DocListItem([
            'Dropdown menus align to the start or end edge of the toggle, '
                'and tooltips and popovers place themselves on the start or '
                'end side.',
          ]),
          DocListItem([
            'Offcanvas panels slide in from the start or end edge, and the '
                'carousel\'s previous and next controls swap sides.',
          ]),
          DocListItem([
            'Animated progress stripes run in the direction of reading, and '
                'the thumb of a range follows the pointer from the right.',
          ]),
          DocListItem(['Floating labels rise and settle on the right.']),
        ]),
        DocExample(
          title: 'A right-to-left subtree',
          description:
              'The same widgets under a Directionality of TextDirection.rtl.',
          code: '''
Directionality(
  textDirection: TextDirection.rtl,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const BsAlert(
        variant: BsVariant.primary,
        child: Text('مرحبًا بالعالم! هذا تنبيه بسيط.'),
      ),
      BsBreadcrumb(
        items: [
          BsBreadcrumbItem(label: const Text('الرئيسية'), onTap: () {}),
          BsBreadcrumbItem(label: const Text('المكتبة'), onTap: () {}),
          const BsBreadcrumbItem(label: Text('البيانات')),
        ],
      ),
      BsButtonGroup(
        children: [
          BsButton(onPressed: () {}, child: const Text('الأول')),
          BsButton(onPressed: () {}, child: const Text('الثاني')),
          BsButton(onPressed: () {}, child: const Text('الثالث')),
        ],
      ),
    ],
  ),
)''',
          preview: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const BsAlert(
                  variant: BsVariant.primary,
                  child: Text('مرحبًا بالعالم! هذا تنبيه بسيط.'),
                ),
                BsBreadcrumb(
                  items: [
                    BsBreadcrumbItem(
                      label: const Text('الرئيسية'),
                      onTap: () {},
                    ),
                    BsBreadcrumbItem(
                      label: const Text('المكتبة'),
                      onTap: () {},
                    ),
                    const BsBreadcrumbItem(label: Text('البيانات')),
                  ],
                ),
                BsButtonGroup(
                  children: [
                    BsButton(onPressed: () {}, child: const Text('الأول')),
                    BsButton(onPressed: () {}, child: const Text('الثاني')),
                    BsButton(onPressed: () {}, child: const Text('الثالث')),
                  ],
                ),
              ],
            ),
          ),
        ),
        const DocHeading('Customize'),
        DocText([
          'Customizing works the same in both directions, through the ',
          DocCode('Bs*Style'),
          ' classes and the tokens. When a value should differ by direction, '
              'read the direction where you build the widget; there is no '
              'directive to write.',
        ]),
        const DocCodeSnippet('''
final rtl = Directionality.of(context) == TextDirection.rtl;

BsBox(
  // A heavier weight for Latin, a lighter one for Arabic.
  fw: rtl ? BsFw.semibold : BsFw.bold,
  child: const Text('…'),
)'''),
        const DocHeading('Fonts', sub: true),
        DocText([
          'Not every font covers the Arabic script. Bootstrap swaps the '
              'family in its font stack for RTL. In Flutter, add a family '
              'that does cover it with ',
          DocCode('extraFontFamilyFallback'),
          ': it is tried after the default stack, for the glyphs the stack '
              'lacks. Bundle the font as an asset so that no download '
              'happens the first time the script is drawn, and boxes never '
              'show in its place.',
        ]),
        const DocCodeSnippet('''
BsApp(
  extraFontFamilyFallback: const ['Noto Sans Arabic'],
  // …
)'''),
        const DocCodeSnippet(
          '''
flutter:
  fonts:
    - family: Noto Sans Arabic
      fonts:
        - asset: assets/fonts/NotoSansArabic.ttf''',
          language: DocLanguage.yaml,
        ),
        DocText(['The web engine cannot read WOFF2: bundle a TTF or an OTF.']),
        const DocHeading('LTR and RTL at the same time', sub: true),
        DocText([
          'Where Bootstrap needs a class on each side and a custom RTLCSS '
              'rule, here you nest a ',
          DocCode('Directionality'),
          '. A subtree takes the direction of the nearest one above it, so '
              'a right-to-left quote can sit in a left-to-right page, and '
              'the other way around.',
        ]),
        const DocCodeSnippet('''
Directionality(
  textDirection: TextDirection.rtl,
  child: const BsBlockquote(child: Text('…')),
)'''),
        DocText([
          'To switch the whole app at run time, keep the ',
          DocCode('TextDirection'),
          ' in state and read it in the ',
          DocCode('builder'),
          ' of ',
          DocCode('BsApp'),
          '. Keep the ',
          DocCode('locale'),
          ' in step with it.',
        ]),
        const DocHeading('The breadcrumb case'),
        DocText([
          'The ',
          DocLink.page('breadcrumb', 'Components', 'Breadcrumb'),
          ' is the one place where Bootstrap has a variable of its own for '
              'RTL, ',
          DocCode(r'$breadcrumb-divider-flipped'),
          ', which defaults to the same divider. So does the default ',
          DocCode('/'),
          ' here. A divider with a direction, such as an arrow, is yours to '
              'flip: build it from the direction.',
        ]),
        const DocCodeSnippet('''
BsBreadcrumb(
  dividerBuilder: (context) {
    final rtl = Directionality.of(context) == TextDirection.rtl;
    return Text(rtl ? '‹' : '›');
  },
  items: items,
)'''),
        const DocHeading('Testing'),
        DocText([
          'Wrap the widget under test in a ',
          DocCode('Directionality'),
          ' to test it from the right. The library\'s own tests do this for '
              'button groups, card groups and list groups.',
        ]),
        const DocCodeSnippet('''
await tester.pumpWidget(
  Directionality(
    textDirection: TextDirection.rtl,
    child: BsButtonGroup(children: buttons),
  ),
);'''),
        const DocHeading('Additional resources'),
        DocList([
          DocListItem([
            DocLink.url(
              'Directionality, in the Flutter API reference',
              'https://api.flutter.dev/flutter/widgets/Directionality-class.html',
            ),
          ]),
          DocListItem([
            DocLink.url(
              'Internationalizing Flutter apps',
              'https://docs.flutter.dev/ui/accessibility-and-localization/internationalization',
            ),
          ]),
        ]),
      ],
    );
  }
}
