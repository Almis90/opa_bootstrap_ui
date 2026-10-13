import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_content.dart';
import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

/// "Color": the palette, the theme colors and the shades derived from them.
class ColorPage extends StatelessWidget {
  const ColorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      leadGap: 0,
      title: 'Color',
      lead:
          'opa_bootstrap_ui has the extensive color system of Bootstrap, '
          'which themes its components: the palette, the theme colors, and '
          'the subtle and emphasis shades that adapt to light and dark.',
      children: [
        const DocHeading('Colors'),
        DocText([
          'Bootstrap 5.3 added colors for secondary and tertiary text and '
              'backgrounds, and a ',
          DocCode('-bg-subtle'),
          ', ',
          DocCode('-border-subtle'),
          ' and ',
          DocCode('-text-emphasis'),
          ' shade for each theme color, to make it easier to customize '
              'across color modes. They are all here, as the constants of ',
          DocCode('BsBody'),
          ' and the getters of ',
          DocCode('BsVariant'),
          ', each with a counterpart for dark. The ones of BsBody have an ',
          DocCode('Of(context)'),
          ' that returns the right one for the ambient brightness (see ',
          DocLink.page('Color modes', 'Customize', 'Color modes'),
          ').',
        ]),
        DocText([
          DocBold('Heads up!'),
          ' The same confusion as in Bootstrap lurks in the names: the ',
          DocCode('BsVariant.secondary'),
          ' theme color is not the secondary color of the body, which is ',
          DocCode('BsBody.secondaryColor'),
          ', and the ',
          DocCode('light'),
          ' and ',
          DocCode('dark'),
          ' theme colors are not the light and dark modes.',
        ]),
        const _BodyColors(),
        DocList([
          DocListItem([
            DocBold('Body'),
            ' is the default foreground and background, including '
                'components.',
          ]),
          DocListItem([
            DocBold('Secondary'),
            ': use the color for lighter text, and the background for '
                'dividers and for the disabled states of components.',
          ]),
          DocListItem([
            DocBold('Tertiary'),
            ': use the color for even lighter text, and the background for '
                'hover states, accents and wells.',
          ]),
          DocListItem([
            DocBold('Emphasis'),
            ' is for text of higher contrast. It has no background.',
          ]),
          DocListItem([
            DocBold('Border'),
            ' is for the borders of components, dividers and rules. The '
                'translucent one blends with the background beneath it.',
          ]),
        ]),
        const DocHeading('Using the new colors', sub: true),
        DocText([
          'The utility classes of Bootstrap, such as ',
          DocCode('.bg-primary-subtle'),
          ', are the ',
          DocCode('bgSubtle'),
          ', ',
          DocCode('borderSubtle'),
          ' and ',
          DocCode('textEmphasis'),
          ' of a ',
          DocCode('BsVariant'),
          '. The body tones are also values of ',
          DocCode('BsBox'),
          ': ',
          DocCode('BsBg.bodySecondary'),
          ', ',
          DocCode('BsBg.bodyTertiary'),
          ', ',
          DocCode('BsTextColor.bodySecondary'),
          ', ',
          DocCode('BsTextColor.bodyTertiary'),
          ' and ',
          DocCode('BsTextColor.bodyEmphasis'),
          '.',
        ]),
        DocExample(
          title: 'Example element with utilities',
          code: '''
BsBox(
  p: BsSpacing.s3,
  bg: BsBg.bodyTertiary,
  textColor: BsTextColor.bodyEmphasis,
  border: true,
  rounded: BsRounded.r2,
  child: const Text('Body tertiary, with emphasis text'),
)

Container(
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: BsVariant.primary.bgSubtle,
    border: Border.all(color: BsVariant.primary.borderSubtle),
    borderRadius: BorderRadius.circular(BsBorders.radius),
  ),
  child: Text(
    'Primary subtle, with emphasis text',
    style: TextStyle(color: BsVariant.primary.textEmphasis),
  ),
)''',
          preview: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const BsBox(
                p: BsSpacing.s3,
                bg: BsBg.bodyTertiary,
                textColor: BsTextColor.bodyEmphasis,
                border: true,
                rounded: BsRounded.r2,
                child: Text('Body tertiary, with emphasis text'),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: BsVariant.primary.bgSubtle,
                  border: Border.all(color: BsVariant.primary.borderSubtle),
                  borderRadius: BorderRadius.circular(BsBorders.radius),
                ),
                child: Text(
                  'Primary subtle, with emphasis text',
                  style: TextStyle(color: BsVariant.primary.textEmphasis),
                ),
              ),
            ],
          ),
        ),
        DocText([
          'The getters of ',
          DocCode('BsVariant'),
          ' return the light-mode colors, and the ones starting with ',
          DocCode('dark'),
          ' the dark-mode ones. ',
          DocCode('BsBadge'),
          ' (with ',
          DocCode('subtle: true'),
          ') and ',
          DocCode('BsAlert'),
          ' choose between them for you.',
        ]),
        const DocHeading('Theme colors'),
        DocText([
          'A subset of all the colors makes up the smaller palette that '
              'themes the components: the eight values of ',
          DocCode('BsVariant'),
          '. Each is the ',
          DocCode('variant'),
          ' of the widgets that take one.',
        ]),
        DocExample(
          code: '''
for (final variant in BsVariant.values) {
  swatch(variant.name, variant.color);
}''',
          preview: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              for (final variant in BsVariant.values)
                _ThemeColor(variant.name, variant.color),
            ],
          ),
        ),
        DocText([
          DocBold('Primary'),
          ' is the main theme color, used for hyperlinks, focus styles and '
              'the active states of components and forms. ',
          DocBold('Success'),
          ' is for positive actions and information, ',
          DocBold('danger'),
          ' for errors and dangerous actions, ',
          DocBold('warning'),
          ' for non-destructive warnings, and ',
          DocBold('info'),
          ' for neutral, informative content. ',
          DocBold('Light'),
          ' and ',
          DocBold('dark'),
          ' are additional options for less and for more contrast.',
        ]),
        DocText([
          'The enum is closed, so the eight stay eight. For a ninth, see ',
          'the "Your own colors" section below.',
        ]),
        const DocHeading('All colors'),
        DocText([
          DocCode('BsColors'),
          ' has the palette of Bootstrap: ',
          DocCode('white'),
          ', ',
          DocCode('black'),
          ', the nine grays ',
          DocCode('gray100'),
          ' to ',
          DocCode('gray900'),
          ' and the ten colors ',
          DocCode('blue'),
          ', ',
          DocCode('indigo'),
          ', ',
          DocCode('purple'),
          ', ',
          DocCode('pink'),
          ', ',
          DocCode('red'),
          ', ',
          DocCode('orange'),
          ', ',
          DocCode('yellow'),
          ', ',
          DocCode('green'),
          ', ',
          DocCode('teal'),
          ' and ',
          DocCode('cyan'),
          '. The colors are the middle step, 500, of the scale of nine '
              'that Bootstrap builds on each; the library has the middle '
              'step only, and the other eight are one call away (see '
              'below).',
        ]),
        const _AllColors(),
        DocText([
          'Keep an eye on contrast as you choose colors: ',
          DocCode('BsColorUtils.contrast'),
          ' picks white or black text for a background.',
        ]),
        const DocHeading('Shades and tints', sub: true),
        DocText([
          'Bootstrap builds each scale with Sass\'s ',
          DocCode('mix()'),
          ', which blends the color with white or black, and not with '
              '',
          DocCode('lighten()'),
          ' and ',
          DocCode('darken()'),
          ', which move the lightness only. The result is a much more '
              'complete suite of colors, and ',
          DocCode('BsColorUtils'),
          ' does the same arithmetic. The scale is:',
        ]),
        DocTable(
          headers: ['Step', 'Bootstrap', 'opa_bootstrap_ui'],
          rows: [
            for (final step in _steps) [step.name, step.sass, step.dart],
          ],
        ),
        DocText([
          'There are no maps to loop over, as in Bootstrap\'s ',
          DocCode(r'$colors'),
          ', ',
          DocCode(r'$theme-colors'),
          ' and ',
          DocCode(r'$grays'),
          ': loop over ',
          DocCode('BsVariant.values'),
          ' for the theme colors, and list the ones of ',
          DocCode('BsColors'),
          ' you want.',
        ]),
        const DocHeading('Your own colors'),
        DocText([
          'Where Bootstrap has you add a color to a Sass map and recompile, '
              'a color of your own is a value you hand to the style of the '
              'widget. The factories derive the rest of a button\'s states '
              'from one color, as the library does for its own, and the '
              'shades of ',
          DocCode('BsColorUtils'),
          ' give an alert its three.',
        ]),
        DocExample(
          code: '''
final purple = BsColors.purple;

BsButton(
  onPressed: () {},
  style: BsButtonStyle.solid(purple),
  child: const Text('Purple'),
)

BsButton(
  onPressed: () {},
  style: BsButtonStyle.outline(purple),
  child: const Text('Purple'),
)

BsAlert(
  variant: BsVariant.primary,
  style: BsAlertStyle(
    color: BsColorUtils.shade(purple, 0.6),
    background: BsColorUtils.tint(purple, 0.8),
    borderColor: BsColorUtils.tint(purple, 0.6),
  ),
  child: const Text('A purple alert, from one color.'),
)''',
          preview: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  BsButton(
                    onPressed: () {},
                    style: BsButtonStyle.solid(BsColors.purple),
                    child: const Text('Purple'),
                  ),
                  BsButton(
                    onPressed: () {},
                    style: BsButtonStyle.outline(BsColors.purple),
                    child: const Text('Purple'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              BsAlert(
                variant: BsVariant.primary,
                style: BsAlertStyle(
                  color: BsColorUtils.shade(BsColors.purple, 0.6),
                  background: BsColorUtils.tint(BsColors.purple, 0.8),
                  borderColor: BsColorUtils.tint(BsColors.purple, 0.6),
                ),
                child: const Text('A purple alert, from one color.'),
              ),
            ],
          ),
        ),
        DocText([
          'Colors in a style are fixed: they do not change with the color '
              'mode. Choose them from the brightness where you build the '
              'widget, as ',
          DocLink.page('Color modes', 'Customize', 'Color modes'),
          ' shows.',
        ]),
        const DocHeading('Generating utilities'),
        DocText([
          'Bootstrap has you extend its utility API to get a text class for '
              'every color of the palette. The utilities here are values of '
              'enums, so a color that is not one of them goes where a ',
          DocCode('Color'),
          ' is accepted instead: the ',
          DocCode('color'),
          ' of a ',
          DocCode('TextStyle'),
          ', or of a ',
          DocCode('BoxDecoration'),
          '.',
        ]),
        const DocCodeSnippet('''
Text(
  'text-purple-300',
  style: TextStyle(color: BsColorUtils.tint(BsColors.purple, 0.4)),
)'''),
      ],
    );
  }
}

class _Step {
  const _Step(this.name, this.sass, this.dart);

  final String name;
  final String sass;
  final String dart;
}

const _steps = [
  _Step('100', r'tint-color($color, 80%)', 'BsColorUtils.tint(color, 0.8)'),
  _Step('200', r'tint-color($color, 60%)', 'BsColorUtils.tint(color, 0.6)'),
  _Step('300', r'tint-color($color, 40%)', 'BsColorUtils.tint(color, 0.4)'),
  _Step('400', r'tint-color($color, 20%)', 'BsColorUtils.tint(color, 0.2)'),
  _Step('500', r'$color', 'color'),
  _Step('600', r'shade-color($color, 20%)', 'BsColorUtils.shade(color, 0.2)'),
  _Step('700', r'shade-color($color, 40%)', 'BsColorUtils.shade(color, 0.4)'),
  _Step('800', r'shade-color($color, 60%)', 'BsColorUtils.shade(color, 0.6)'),
  _Step('900', r'shade-color($color, 80%)', 'BsColorUtils.shade(color, 0.8)'),
];

Color _step(Color color, int step) => switch (step) {
  < 500 => BsColorUtils.tint(color, (500 - step) / 500),
  > 500 => BsColorUtils.shade(color, (step - 500) / 500),
  _ => color,
};

String _hex(Color color) =>
    '#${(color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';

class _BodyColors extends StatelessWidget {
  const _BodyColors();

  @override
  Widget build(BuildContext context) {
    Widget swatch(Color color) => Container(
      width: 64,
      height: 28,
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: BsBorders.colorOf(context)),
        borderRadius: BorderRadius.circular(BsBorders.radiusSm),
      ),
    );
    return DocTable(
      headers: ['Description', 'Swatch', 'Value'],
      rows: [
        [
          'Body color',
          swatch(BsBody.colorOf(context)),
          'BsBody.color, BsBody.colorOf(context)',
        ],
        [
          'Body background',
          swatch(BsBody.backgroundOf(context)),
          'BsBody.background, BsBody.backgroundOf(context)',
        ],
        [
          'Secondary color',
          swatch(BsBody.secondaryColorOf(context)),
          'BsBody.secondaryColor, BsBody.secondaryColorOf(context)',
        ],
        [
          'Secondary background',
          swatch(BsBody.secondaryBackgroundOf(context)),
          'BsBody.secondaryBackground, BsBody.secondaryBackgroundOf(context)',
        ],
        [
          'Tertiary color',
          swatch(BsBody.tertiaryColorOf(context)),
          'BsBody.tertiaryColor, BsBody.tertiaryColorOf(context)',
        ],
        [
          'Tertiary background',
          swatch(BsBody.tertiaryBackgroundOf(context)),
          'BsBody.tertiaryBackground, BsBody.tertiaryBackgroundOf(context)',
        ],
        [
          'Emphasis color',
          swatch(BsBody.emphasisColorOf(context)),
          'BsBody.emphasisColor, BsBody.emphasisColorOf(context)',
        ],
        [
          'Border color',
          swatch(BsBorders.colorOf(context)),
          'BsBorders.color, BsBorders.colorOf(context)',
        ],
        [
          'Translucent border color',
          swatch(BsBorders.colorTranslucentOf(context)),
          'BsBorders.colorTranslucent, BsBorders.colorTranslucentOf(context)',
        ],
      ],
    );
  }
}

class _ThemeColor extends StatelessWidget {
  const _ThemeColor(this.name, this.color);

  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 56,
            decoration: BoxDecoration(
              color: color,
              border: Border.all(color: BsBorders.colorOf(context)),
              borderRadius: BorderRadius.circular(BsBorders.radius),
            ),
          ),
          const SizedBox(height: 4),
          Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(
            _hex(color),
            style: TextStyle(
              fontSize: 12,
              color: BsBody.secondaryColorOf(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _AllColors extends StatelessWidget {
  const _AllColors();

  static const _colors = {
    'blue': BsColors.blue,
    'indigo': BsColors.indigo,
    'purple': BsColors.purple,
    'pink': BsColors.pink,
    'red': BsColors.red,
    'orange': BsColors.orange,
    'yellow': BsColors.yellow,
    'green': BsColors.green,
    'teal': BsColors.teal,
    'cyan': BsColors.cyan,
  };

  static const _grays = [
    BsColors.gray100,
    BsColors.gray200,
    BsColors.gray300,
    BsColors.gray400,
    BsColors.gray500,
    BsColors.gray600,
    BsColors.gray700,
    BsColors.gray800,
    BsColors.gray900,
  ];

  @override
  Widget build(BuildContext context) {
    Widget row(String name, List<Color> colors) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Row(
            children: [
              for (final color in colors)
                Expanded(child: Container(height: 40, color: color)),
            ],
          ),
        ],
      ),
    );
    return DocExample(
      code: '''
final steps = [
  for (final weight in [0.8, 0.6, 0.4, 0.2]) BsColorUtils.tint(color, weight),
  color,
  for (final weight in [0.2, 0.4, 0.6, 0.8]) BsColorUtils.shade(color, weight),
];''',
      preview: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final entry in _colors.entries)
            row(entry.key, [
              for (var step = 100; step <= 900; step += 100)
                _step(entry.value, step),
            ]),
          row('gray', _grays),
        ],
      ),
    );
  }
}
