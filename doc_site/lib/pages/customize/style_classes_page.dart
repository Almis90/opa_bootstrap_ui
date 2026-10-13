import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_content.dart';
import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

/// "Style classes": the counterpart of Bootstrap's "CSS variables".
class StyleClassesPage extends StatelessWidget {
  const StyleClassesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      leadGap: 0,
      title: 'Style classes',
      lead:
          'Each component has a style class: the values of its CSS '
          'variables, which you can set after the library is compiled, '
          'and while the app runs.',
      children: [
        DocText([
          'Bootstrap includes many CSS custom properties in its compiled CSS '
              'for real-time customization without the need to recompile '
              'Sass. A Flutter app has no inspector to tweak them in, and the '
              'package is compiled with it; what takes their place is the ',
          DocCode('Bs*Style'),
          ' class of each component, which is passed to the widget, and can '
              'change on any frame.',
        ]),
        const DocHeading('Component variables'),
        DocText([
          'Bootstrap 5 uses custom properties as the local variables of its '
              'components, assigned at the base component level, such as ',
          DocCode('.navbar'),
          ' for the navbar and its sub-components. A ',
          DocCode('Bs*Style'),
          ' is the same thing for the widget: all the values that you can '
              'tune in one place, and named after what they style.',
        ]),
        DocTable(
          headers: ['Component', 'Style class'],
          rows: [
            ['Accordion', 'BsAccordionStyle'],
            ['Alert', 'BsAlertStyle'],
            ['Badge', 'BsBadgeStyle'],
            ['Breadcrumb', 'BsBreadcrumbStyle'],
            ['Button', 'BsButtonStyle'],
            ['Card', 'BsCardStyle'],
            ['Carousel', 'BsCarouselStyle'],
            ['Close button', 'BsCloseButtonStyle'],
            ['Code', 'BsCodeStyle'],
            ['Dropdown', 'BsDropdownStyle'],
            ['Figure', 'BsFigureStyle'],
            ['Forms', 'BsFormStyle'],
            ['List group', 'BsListGroupStyle'],
            ['Modal', 'BsModalStyle'],
            ['Nav', 'BsNavStyle'],
            ['Navbar', 'BsNavbarStyle'],
            ['Offcanvas', 'BsOffcanvasStyle'],
            ['Pagination', 'BsPaginationStyle'],
            ['Placeholder', 'BsPlaceholderStyle'],
            ['Popover', 'BsPopoverStyle'],
            ['Progress', 'BsProgressStyle'],
            ['Spinner', 'BsSpinnerStyle'],
            ['Table', 'BsTableStyle'],
            ['Thumbnail', 'BsThumbnailStyle'],
            ['Toast', 'BsToastStyle'],
            ['Tooltip', 'BsTooltipStyle'],
          ],
        ),
        DocText([
          'Each page of the components lists the fields of its style next to '
              'the examples. They are named after the CSS variable, with the '
              'component dropped: ',
          DocCode(r'--bs-alert-padding-x'),
          ' and ',
          DocCode(r'--bs-alert-border-radius'),
          ' are the ',
          DocCode('padding'),
          ' and the ',
          DocCode('borderRadius'),
          ' of a ',
          DocCode('BsAlertStyle'),
          '.',
        ]),
        const DocHeading('How a style is applied', sub: true),
        DocList(ordered: true, [
          DocListItem([
            'Every field is nullable. A ',
            DocCode('null'),
            ' means that the widget keeps the default of Bootstrap, so a '
                'style with one field set changes that one thing.',
          ]),
          DocListItem([
            'The widget merges the style over the defaults with ',
            DocCode('merge'),
            ', which is also yours to call, to build a style from another: ',
            DocCode('base.merge(overrides)'),
            ' takes the fields of the second where it has them.',
          ]),
          DocListItem([
            'The defaults are public, as ',
            DocCode('static const'),
            ' values named ',
            DocCode('default…'),
            ', such as ',
            DocCode('BsAlertStyle.defaultBorderRadius'),
            ', and many styles collect them in a ',
            DocCode('defaults'),
            ' object. Read them to derive a value of your own, such as a '
                'radius that is a little more than the default.',
          ]),
          DocListItem([
            'The variant and size of a widget are applied first, and the '
                'style on top, so it wins over them.',
          ]),
        ]),
        DocText([
          'A style belongs to the widget it is given to. It is not '
              'inherited by the widgets beneath it, as a custom property is '
              'by the elements of a subtree, because nothing provides it to '
              'them. To restyle every alert, pass the same style to each: '
              'keep it in a constant, or in a widget of your own (see ',
          DocLink.page('Components', 'Customize', 'Components'),
          ').',
        ]),
        const DocExample(
          code: '''
const rounded = BsAlertStyle(borderRadius: 24);
const square = BsAlertStyle(borderRadius: 0);

// Swapping the style in setState restyles the alert on the next frame.
BsAlert(
  variant: BsVariant.info,
  style: isRound ? rounded : square,
  child: const Text('The corners change at run time.'),
)''',
          preview: _RadiusDemo(),
        ),
        const DocHeading('Root variables'),
        DocText([
          'The variables of ',
          DocCode(':root'),
          ' are the tokens of the library, which are available anywhere, '
              'not only below a widget of Bootstrap: they are constants. See ',
          DocLink.page('Tokens', 'Customize', 'Tokens'),
          '. The ones that depend on the color mode have an ',
          DocCode('Of(context)'),
          ' method, which looks up the ambient brightness, and plays the '
              'part of the variables that Bootstrap reassigns under ',
          DocCode('[data-bs-theme=dark]'),
          '.',
        ]),
        DocTable(
          headers: ['Bootstrap', 'opa_bootstrap_ui'],
          rows: [
            [
              'var(--bs-body-color), var(--bs-body-bg)',
              'BsBody.colorOf(context), BsBody.backgroundOf(context)',
            ],
            ['var(--bs-border-color)', 'BsBorders.colorOf(context)'],
            [
              'var(--bs-link-color), var(--bs-link-hover-color)',
              'BsLink.colorOf(context), BsLink.hoverColorOf(context)',
            ],
            [
              'var(--bs-blue), var(--bs-primary)',
              'BsColors.blue, BsVariant.primary.color',
            ],
            [
              'var(--bs-font-sans-serif), var(--bs-font-monospace)',
              'BsTypography.fontFamilySansSerif, .fontFamilyMonospace',
            ],
          ],
        ),
        const DocHeading('Prefix', sub: true),
        DocText([
          'Bootstrap prefixes its variables with ',
          DocCode('bs-'),
          ' to avoid collisions with the CSS of others, and lets you change '
              'it with ',
          DocCode(r'$prefix'),
          '. The names here are prefixed with ',
          DocCode('Bs'),
          ' for the same reason, and Dart has what CSS lacks to resolve a '
              'clash: import the library with ',
          DocCode('as'),
          ' or ',
          DocCode('show'),
          ' and ',
          DocCode('hide'),
          ' what you do not want.',
        ]),
        const DocCodeSnippet('''
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart' as bs;

bs.BsButton(onPressed: () {}, child: const Text('Save'))'''),
        const DocHeading('Examples'),
        DocText([
          'Bootstrap\'s example resets the font and the link color of the '
              'page. The same two settings are the ',
          DocCode('textStyle'),
          ' of ',
          DocCode('BsApp'),
          ' and the link tokens:',
        ]),
        const DocCodeSnippet('''
BsApp(
  textStyle: TextStyle(
    fontFamily: BsTypography.fontFamilyMonospace.first,
    fontSize: BsTypography.fontSizeBase,
    height: BsTypography.lineHeightBase,
  ),
  home: const MyHome(),
)

Text('A link', style: TextStyle(color: BsLink.color))'''),
        DocText([
          'Passing a ',
          DocCode('textStyle'),
          ' replaces the default one of the app, whose text color follows '
              'the color mode; set a ',
          DocCode('color'),
          ' in it, from ',
          DocCode('BsBody.colorOf(context)'),
          ', if you want the text to follow it still. See ',
          DocLink.page('Color modes', 'Customize', 'Color modes'),
          '.',
        ]),
        const DocHeading('Focus variables'),
        DocText([
          'Bootstrap\'s focus ring is a pair of variables, a width and a '
              'color of a given opacity. They are the constants of ',
          DocCode('BsFocusRing'),
          ': ',
          DocCode('width'),
          ' (4), ',
          DocCode('opacity'),
          ' (0.25), ',
          DocCode('blur'),
          ' (0) and ',
          DocCode('color()'),
          ', which returns the color of the ring for a base color, the '
              'primary one by default. Where a widget lets you change its '
              'ring, it is a field of its style: ',
          DocCode('BsButtonStyle'),
          ' has ',
          DocCode('focusRingColor'),
          ' and ',
          DocCode('focusRingWidth'),
          '. The offsets ',
          DocCode('x'),
          ' and ',
          DocCode('y'),
          ' of Bootstrap are not tokens here. The button draws its ring '
              'from the solid color you give it, at half opacity.',
        ]),
        const DocCodeSnippet('''
BsButton(
  onPressed: () {},
  style: BsButtonStyle(
    focusRingColor: BsVariant.danger.color,
    focusRingWidth: 6,
  ),
  child: const Text('A wide, red focus ring'),
)'''),
        const DocHeading('Grid breakpoints'),
        DocText([
          'Bootstrap warns that CSS variables do not work in media queries, '
              'so the breakpoints cannot be used there. The ones here are '
              'values of Dart, so they can be used anywhere: ',
          DocCode('BsBreakpoint.md.minWidth'),
          ' is 768, in a comparison, a ',
          DocCode('LayoutBuilder'),
          ' or a ',
          DocCode('switch'),
          ' on ',
          DocCode('BsBreakpoint.forWidth(width)'),
          '.',
        ]),
      ],
    );
  }
}

class _RadiusDemo extends StatefulWidget {
  const _RadiusDemo();

  @override
  State<_RadiusDemo> createState() => _RadiusDemoState();
}

class _RadiusDemoState extends State<_RadiusDemo> {
  bool _round = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BsAlert(
          variant: BsVariant.info,
          style: BsAlertStyle(borderRadius: _round ? 24 : 0),
          child: const Text('The corners change at run time.'),
        ),
        BsButton(
          variant: BsVariant.secondary,
          outline: true,
          onPressed: () => setState(() => _round = !_round),
          child: Text(_round ? 'Square the corners' : 'Round the corners'),
        ),
      ],
    );
  }
}
