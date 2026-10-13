import 'package:flutter/widgets.dart';

import '../../src/doc_content.dart';
import '../../src/doc_page.dart';
import '../../src/doc_syntax.dart';

/// "Contents": how the package is organized, what it exports, and an overview
/// of its widgets and utilities.
class ContentsPage extends StatelessWidget {
  const ContentsPage({super.key});

  /// "`A`, `B` and `C`" as the parts of a paragraph.
  static List<Object> _names(List<String> names) => [
    for (var i = 0; i < names.length; i++) ...[
      if (i > 0) i == names.length - 1 ? ' and ' : ', ',
      DocCode(names[i]),
    ],
  ];

  static DocListItem _group(
    String title,
    List<String> names, [
    List<Object> note = const [],
  ]) => DocListItem([
    DocBold(title),
    ': ',
    ..._names(names),
    '.',
    if (note.isNotEmpty) ' ',
    ...note,
  ]);

  @override
  Widget build(BuildContext context) {
    return DocPage(
      leadGap: 0,
      title: 'Contents',
      lead:
          'Discover what is included in opa_bootstrap_ui: how the package is '
          'organized, the library it exports, and the widgets and utilities it '
          'provides.',
      children: [
        const DocHeading('Package structure'),
        const DocText([
          'opa_bootstrap_ui is a Dart package. Its source code is in ',
          DocCode('lib'),
          ', with one file per component, and the rest of the repository holds '
              'the tests, an example app and this documentation site.',
        ]),
        const DocCodeSnippet(
          '''
opa_bootstrap_ui/
├── lib/
│   ├── opa_bootstrap_ui.dart
│   └── src/
│       ├── bs_*.dart
│       └── tokens/
├── example/
├── doc_site/
└── test/''',
          language: DocLanguage.text,
        ),
        const DocText(['What each part is for:']),
        DocList([
          DocListItem([
            DocCode('lib/opa_bootstrap_ui.dart'),
            ': the library you import. It exports everything public, so there '
                'is nothing else to import.',
          ]),
          DocListItem([
            DocCode('lib/src'),
            ': the widgets (',
            DocCode('BsButton'),
            ', ',
            DocCode('BsCard'),
            ', ',
            DocCode('BsModal'),
            '…), the layout (',
            DocCode('BsContainer'),
            ', ',
            DocCode('BsRow'),
            ', ',
            DocCode('BsFlex'),
            '), the utilities (',
            DocCode('BsBox'),
            ', ',
            DocCode('BsSpacing'),
            '…) and the app and theme (',
            DocCode('BsApp'),
            ', ',
            DocCode('BsTheme'),
            ').',
          ]),
          DocListItem([
            DocCode('lib/src/tokens'),
            ': Bootstrap\'s design tokens (colors, borders, typography, '
                'shadows, transitions) and the style class of each component, '
                'such as ',
            DocCode('BsCardStyle'),
            ', which holds the values you can override.',
          ]),
          DocListItem([
            DocCode('example'),
            ': a Flutter app with a page for every component.',
          ]),
          DocListItem([
            DocCode('doc_site'),
            ': this documentation site, including the page templates of the ',
            DocLink.examples('examples'),
            '.',
          ]),
          DocListItem([DocCode('test'), ': the tests of the library.']),
        ]),
        const DocHeading('Package exports'),
        const DocText([
          'Everything public is exported by a single library, so one import is '
              'all you need:',
        ]),
        const DocCodeSnippet(
          "import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';",
        ),
        const DocText([
          'It exports the widgets and their controllers, the style class of '
              'each component, the design tokens, and the utility enums and '
              'helpers. Do not import files from ',
          DocCode('src'),
          ' directly: they are not part of the public API and may move between '
              'releases.',
        ]),
        const DocHeading('Components overview'),
        const DocText([
          'The widgets, in the groups of Bootstrap\'s documentation. Each is '
              'named like its Bootstrap component, with a ',
          DocCode('Bs'),
          ' prefix.',
        ]),
        DocList([
          _group('Layout', ['BsContainer', 'BsRow', 'BsFlex', 'BsFlexItem']),
          _group('Content', [
            'BsHeading',
            'BsDisplayHeading',
            'BsLead',
            'BsBlockquote',
            'BsCode',
            'BsPre',
            'BsKbd',
            'BsHr',
            'BsImage',
            'BsFigure',
            'BsThumbnail',
            'BsTable',
            'BsAnchor',
          ]),
          _group('Forms', [
            'BsFormControl',
            'BsFormSelect',
            'BsFormCheck',
            'BsFormRange',
            'BsFormFile',
            'BsFormFloating',
            'BsFormLabel',
            'BsInputGroup',
          ]),
          _group('Components', [
            'BsAccordion',
            'BsAlert',
            'BsBadge',
            'BsBreadcrumb',
            'BsButton',
            'BsButtonGroup',
            'BsToggleButtonGroup',
            'BsCard',
            'BsCarousel',
            'BsCloseButton',
            'BsCollapse',
            'BsDropdown',
            'BsListGroup',
            'BsModal',
            'BsNavbar',
            'BsNav',
            'BsTabView',
            'BsOffcanvas',
            'BsPagination',
            'BsPlaceholder',
            'BsPopover',
            'BsProgress',
            'BsScrollspyController',
            'BsSpinnerBorder',
            'BsSpinnerGrow',
            'BsToast',
            'BsTooltip',
          ]),
        ]),
        const DocText([
          'Overlays are opened with a function rather than placed in the tree: ',
          DocCode('showBsModal'),
          ', ',
          DocCode('showBsOffcanvas'),
          ' and ',
          DocCode('showBsToast'),
          '.',
        ]),
        const DocHeading('Utilities overview'),
        const DocText([
          'Bootstrap\'s utilities are props rather than classes, with the same '
              'names, so a class list reads straight across.',
        ]),
        DocList([
          _group(
            'Spacing',
            ['BsSpacing'],
            [
              'The steps 0 to 5 and auto, used by the margin and padding props '
                  '(',
              DocCode('m'),
              ' and ',
              DocCode('p'),
              ' with ',
              DocCode('x'),
              ', ',
              DocCode('y'),
              ', ',
              DocCode('t'),
              ', ',
              DocCode('e'),
              ', ',
              DocCode('b'),
              ' and ',
              DocCode('s'),
              ') of ',
              DocCode('BsBox'),
              ' and ',
              DocCode('BsFlexItem'),
              ', and by ',
              DocCode('gap'),
              ' and the gutters of ',
              DocCode('BsFlex'),
              ' and ',
              DocCode('BsRow'),
              '.',
            ],
          ),
          _group(
            'Sizing',
            ['BsWidth', 'BsHeight', 'BsCol'],
            [
              'Widths and heights as a share of the parent, and the columns of a row.',
            ],
          ),
          _group('Flex and alignment', [
            'BsFlexDirection',
            'BsJustify',
            'BsAlign',
          ]),
          _group(
            'Responsive',
            ['BsBreakpoint', 'BsResponsiveValue'],
            [
              'A prop that takes a ',
              DocCode('BsResponsive'),
              ' can change per breakpoint.',
            ],
          ),
          _group('Typography', [
            'BsFs',
            'BsFw',
            'BsLh',
            'BsTextAlign',
            'BsTextColor',
          ]),
          _group('Color and background', [
            'BsBg',
            'BsVariant',
            'BsColors',
            'BsColorUtils',
            'BsBody',
          ]),
          _group('Borders and effects', [
            'BsRounded',
            'BsShadow',
            'BsBorderStyle',
            'BsOpacity',
            'BsBorders',
          ]),
          _group(
            'App and theme',
            ['BsApp', 'BsTheme'],
            [
              'Every component also takes a style class, such as ',
              DocCode('BsButtonStyle'),
              ', to override its look.',
            ],
          ),
        ]),
      ],
    );
  }
}
