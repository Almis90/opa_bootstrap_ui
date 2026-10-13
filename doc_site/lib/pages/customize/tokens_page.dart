import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_content.dart';
import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

/// "Tokens": the counterpart of Bootstrap's "Sass" page.
class TokensPage extends StatelessWidget {
  const TokensPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      leadGap: 0,
      title: 'Tokens',
      lead:
          'The values opa_bootstrap_ui is built from, and the functions that '
          'derive new ones: the counterpart of Bootstrap\'s Sass variables, '
          'maps and functions.',
      children: [
        const DocHeading('Where the variables went'),
        DocText([
          'Bootstrap\'s Sass source is a set of partials with hundreds of ',
          DocCode(r'$variables'),
          ', which you override before the stylesheet is compiled. The same '
              'numbers are here as Dart constants, grouped into classes that '
              'are never instantiated. They are exported by the one library '
              'file, so there is nothing to import in a particular order:',
        ]),
        const DocCodeSnippet(
          "import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';",
        ),
        DocTable(
          headers: ['Bootstrap (Sass)', 'opa_bootstrap_ui', 'Holds'],
          rows: [
            [
              r'$white, $gray-100 … $gray-900, $black, $blue … $cyan',
              'BsColors',
              'The palette: the grays and the ten named colors.',
            ],
            [
              r'$theme-colors, and the -text-emphasis, -bg-subtle and '
                  r'-border-subtle maps',
              'BsVariant',
              'The eight contextual colors, with their subtle and emphasis '
                  'shades, for light and for dark.',
            ],
            [
              r'$body-color, $body-bg, $body-secondary-*, $body-tertiary-*, '
                  r'$body-emphasis-color',
              'BsBody',
              'The colors of the page, for light and for dark, with an Of(context) '
                  'for each.',
            ],
            [
              r'$font-family-*, $font-size-*, $font-weight-*, $line-height-*, '
                  r'$h1-font-size …, $display-font-sizes, $lead-*',
              'BsTypography',
              'Font stacks, sizes, weights, line heights, headings and '
                  'display headings.',
            ],
            [
              r'$border-width, $border-color, $border-radius-*',
              'BsBorders',
              'Border widths and colors, and the radii, up to the pill.',
            ],
            [
              r'$box-shadow, $box-shadow-sm, $box-shadow-lg, '
                  r'$box-shadow-inset',
              'BsShadows',
              'The four shadows, as lists of BoxShadow.',
            ],
            [
              r'$transition-base, $transition-fade, $transition-collapse',
              'BsTransitions',
              'The durations and curves of the animations, and the '
                  'reduced-motion rule.',
            ],
            [
              r'$focus-ring-width, -opacity, -blur, -color',
              'BsFocusRing',
              'The focus ring.',
            ],
            [r'$zindex-*', 'BsZIndex', "Bootstrap's stacking order."],
            [
              r'$spacer, $spacers',
              'BsSpacing',
              'The scale of the margin, padding and gap utilities.',
            ],
            [
              r'$grid-breakpoints',
              'BsBreakpoint',
              'xs, sm, md, lg, xl and xxl, with their minimum widths.',
            ],
            [
              r'$grid-columns, $grid-gutter-width, $container-max-widths',
              'BsGrid',
              'The twelve columns, the gutter and the widths of the containers.',
            ],
            [
              r'Component variables, such as $alert-padding-y',
              'BsAlertStyle.defaults, BsButtonStyle.defaults, …',
              'One style class per component. See Style classes.',
            ],
          ],
        ),
        DocText([
          'Bootstrap\'s names are kept where the language allows it: ',
          DocCode(r'$border-radius-lg'),
          ' is ',
          DocCode('BsBorders.radiusLg'),
          ' and ',
          DocCode(r'$font-weight-semibold'),
          ' is ',
          DocCode('BsTypography.fontWeightSemibold'),
          ', so that someone who knows Bootstrap can find the value they '
              'need. Lengths are logical pixels, with the usual ',
          DocCode('16'),
          ' for ',
          DocCode('1rem'),
          '.',
        ]),
        const DocHeading('Variable defaults'),
        DocText([
          'Every Sass variable ends in ',
          DocCode('!default'),
          ', so that you can assign it before Bootstrap does. A constant '
              'cannot be assigned from outside the package, and that is by '
              'design: the compiled library does not read a configuration '
              'that is written after it. What plays the part of the ',
          DocCode('!default'),
          ' is the style class of each component:',
        ]),
        DocList([
          DocListItem([
            'every field of a ',
            DocCode('Bs*Style'),
            ' is nullable, and a ',
            DocCode('null'),
            ' means "use the default";',
          ]),
          DocListItem([
            'the defaults are public: static constants such as ',
            DocCode('BsAlertStyle.defaultBorderRadius'),
            ', and a ',
            DocCode('BsAlertStyle.defaults'),
            ' object built from them;',
          ]),
          DocListItem([
            'the widget merges your style over the defaults with ',
            DocCode('merge'),
            ': the fields you set win, and the rest are Bootstrap\'s.',
          ]),
        ]),
        DocText([
          'So, where you would write ',
          DocCode(r'$alert-border-radius: 0;'),
          ' in Sass, you write the following, on one alert or, in a widget of '
              'your own, on every alert of the app:',
        ]),
        const DocCodeSnippet('''
const BsAlert(
  variant: BsVariant.warning,
  style: BsAlertStyle(borderRadius: 0),
  child: Text('Square corners.'),
)'''),
        DocText([
          'The tokens are also yours to read. Build your own widgets from '
              'the same values as the library\'s, and they stay in step with '
              'it:',
        ]),
        const DocCodeSnippet('''
Text(
  'A lead paragraph',
  style: TextStyle(
    fontSize: BsTypography.leadFontSize,
    fontWeight: BsTypography.leadFontWeight,
    height: BsTypography.lineHeightBase,
    color: BsBody.colorOf(context),
  ),
)'''),
        DocText([
          'A value you want to change for good, such as the base font size '
              'or the radius that every component shares, is a constant in '
              'the source. Depend on your own copy of the package to change '
              'it, as you would edit the partials of Bootstrap, and merge '
              'the releases that follow. Prefer the style classes: they are '
              'the supported way, and they survive an upgrade.',
        ]),
        const DocHeading('Stacking order'),
        DocText([
          DocCode('BsZIndex'),
          ' lists Bootstrap\'s values, from the dropdown at ',
          DocCode('1000'),
          ' to the toast at ',
          DocCode('1090'),
          ', and the library\'s own widgets do not read them: they are '
              'there as the reference of that order, and for your own '
              'overlays to be ranked against it.',
        ]),
        const DocHeading('Maps and loops'),
        DocText([
          'Bootstrap keeps its theme colors, spacers and breakpoints in Sass '
              'maps, loops over them to generate the classes, and offers to '
              'modify, add to and remove from them. Here they are enums, ',
          DocCode('BsVariant'),
          ', ',
          DocCode('BsSpacing'),
          ' and ',
          DocCode('BsBreakpoint'),
          ', and a loop is a loop over ',
          DocCode('values'),
          ':',
        ]),
        const DocCodeSnippet(r'''
for (final variant in BsVariant.values) {
  print('${variant.name}: ${variant.color}');
}'''),
        DocText([
          'An enum is closed, so a map cannot be extended or trimmed in '
              'place. Adding a ninth theme color is not an edit to a map '
              'but a color of your own, passed where the widget takes a '
              'style. See ',
          DocLink.page('Color', 'Customize', 'Color'),
          ' for that, and for what the components derive from a color.',
        ]),
        const DocHeading('Functions'),
        DocText([
          DocCode('BsColorUtils'),
          ' is the counterpart of the functions of ',
          DocCode('_functions.scss'),
          ', and does the same arithmetic as the ones the variants are '
              'defined with.',
        ]),
        DocTable(
          headers: ['Bootstrap', 'opa_bootstrap_ui', 'Description'],
          rows: [
            [
              r'mix($color1, $color2, $weight)',
              'BsColorUtils.mix(color1, color2, weight)',
              'Blends two colors. The weight, from 0 to 1, is the share of '
                  'the first.',
            ],
            [
              r'shade-color($color, $weight)',
              'BsColorUtils.shade(color, weight)',
              'Mixes with black.',
            ],
            [
              r'tint-color($color, $weight)',
              'BsColorUtils.tint(color, weight)',
              'Mixes with white.',
            ],
            [
              r'color-contrast($background)',
              'BsColorUtils.contrast(background, minContrastRatio: 4.5)',
              'Picks white or black for text on the color.',
            ],
          ],
        ),
        DocText([
          'The weight is a fraction, not a percentage: ',
          DocCode(r'shade-color($primary, 20%)'),
          ' is ',
          DocCode('BsColorUtils.shade(BsColors.blue, 0.2)'),
          '.',
        ]),
        DocExample(
          title: 'Shades and tints',
          description:
              'The hover and active colors of a button are a shade of 0.15 '
              'and 0.20 of its color. The subtle backgrounds of an alert are a '
              'tint of 0.8.',
          code: '''
final color = BsVariant.primary.color;

for (final weight in [0.8, 0.6, 0.4, 0.2]) {
  swatch(BsColorUtils.shade(color, weight));
}
swatch(color);
for (final weight in [0.2, 0.4, 0.6, 0.8]) {
  swatch(BsColorUtils.tint(color, weight));
}''',
          preview: Wrap(
            children: [
              for (final weight in [0.8, 0.6, 0.4, 0.2])
                _Swatch(BsColorUtils.shade(BsVariant.primary.color, weight)),
              _Swatch(BsVariant.primary.color),
              for (final weight in [0.2, 0.4, 0.6, 0.8])
                _Swatch(BsColorUtils.tint(BsVariant.primary.color, weight)),
            ],
          ),
        ),
        const DocHeading('Color contrast', sub: true),
        DocText([
          DocCode('contrast'),
          ' returns white if white reaches the ratio against the '
              'background, which is 4.5, the minimum of WCAG AA for text, '
              'unless you pass ',
          DocCode('minContrastRatio'),
          '. Otherwise it returns black if black reaches it, and if neither '
              'does, whichever of the two contrasts more. The buttons use it '
              'to pick their text, which is why the warning one is black.',
        ]),
        DocExample(
          title: 'Text on a color',
          code: '''
for (final variant in BsVariant.values) {
  final background = variant.color;
  Container(
    color: background,
    child: Text(
      variant.name,
      style: TextStyle(color: BsColorUtils.contrast(background)),
    ),
  );
}''',
          preview: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final variant in BsVariant.values)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  color: variant.color,
                  child: Text(
                    variant.name,
                    style: TextStyle(
                      color: BsColorUtils.contrast(variant.color),
                    ),
                  ),
                ),
            ],
          ),
        ),
        DocText([
          'Bootstrap\'s ',
          DocCode('escape-svg()'),
          ' and ',
          DocCode('add()'),
          ' and ',
          DocCode('subtract()'),
          ' have no counterpart, and need none: the images are painted '
              '(see ',
          DocLink.page('Overview', 'Customize', 'Overview'),
          '), and the arithmetic is Dart\'s.',
        ]),
        const DocHeading('Mixins'),
        DocText([
          'Bootstrap\'s mixins, such as ',
          DocCode('media-breakpoint-up()'),
          ' and ',
          DocCode('button-variant()'),
          ', generate CSS for you. What replaces them is a widget or a '
              'class, because that is how Flutter reuses a piece of UI:',
        ]),
        DocTable(
          headers: ['Bootstrap', 'opa_bootstrap_ui'],
          rows: [
            [
              r'media-breakpoint-up(md) { … }',
              'BsResponsiveValue, or BsBreakpoint.md.minWidth against '
                  'MediaQuery.sizeOf(context).width',
            ],
            [
              r'button-variant($background, $border, …)',
              'BsButtonStyle.solid(color), or BsButtonStyle.outline(color)',
            ],
            [
              r'transition($value)',
              'BsTransitions.resolve(context, BsTransitions.base), which '
                  'also honors the reduced-motion setting',
            ],
            [
              r'focus-ring, @include focus-ring',
              'BsFocusRing.width, .opacity, .blur and .color(), for your own focusable widgets and the ones of the library that show a ring',
            ],
          ],
        ),
      ],
    );
  }
}

class _Swatch extends StatelessWidget {
  const _Swatch(this.color);

  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: 48, height: 48, child: ColoredBox(color: color));
  }
}
