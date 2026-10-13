import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_content.dart';
import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

const _mono = TextStyle(
  fontFamily: 'Menlo',
  fontFamilyFallback: ['Monaco', 'Consolas', 'Courier New', 'monospace'],
  fontSize: 14,
);

Widget _bullet(String text, {Widget? marker}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(
        width: 32,
        child: marker ?? const Text('•', textAlign: TextAlign.center),
      ),
      Expanded(child: Text(text)),
    ],
  );
}

Widget _list(List<Widget> items) {
  return BsBox(
    mb: BsSpacing.s3,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: items,
    ),
  );
}

/// "Reboot": the baseline a Bootstrap page gets from its stylesheet, and what
/// gives a Flutter app the same one.
class RebootPage extends StatelessWidget {
  const RebootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      leadGap: 0,
      title: 'Reboot',
      lead:
          'Reboot is the baseline Bootstrap lays under every page: opinionated '
          'defaults for the elements, so that what you build on top starts '
          'from an elegant, consistent and simple place. Flutter has no '
          'browser stylesheet to reset, so here it is the text defaults of '
          'BsApp and the margins of a few widgets.',
      children: [
        const DocHeading('Approach'),
        DocText([
          'Reboot builds on Normalize, to make the elements of a page look '
              'the same in every browser. A Flutter widget looks the same '
              'everywhere to begin with, and the library has no native '
              'elements to override. What is left of the guidelines '
              'Bootstrap chose its overrides by carries over:',
        ]),
        DocList([
          DocListItem([
            'Sizes are in logical pixels, from the base of 16, where '
                'Bootstrap uses ',
            DocCode('rem'),
            's, so that spacing scales with the root font size.',
          ]),
          DocListItem([
            DocBold('Avoid the top margin.'),
            ' The widgets that have a margin have it at the bottom, which is '
                'a simpler mental model: ',
            DocCode('BsHeading'),
            ' has 8 pixels, ',
            DocCode('BsBlockquote'),
            ' and ',
            DocCode('BsHr'),
            ' 16. Flutter has no margin collapsing, but the rule still '
                'keeps the spacing of a column easy to read.',
          ]),
          DocListItem([
            DocBold('Keep the font properties to a minimum.'),
            ' A widget sets only the ones that make it what it is, such as '
                'the size and weight of a heading, and inherits the rest '
                'from the ',
            DocCode('DefaultTextStyle'),
            ' above it.',
          ]),
        ]),
        const DocHeading('Tokens'),
        DocText([
          'Bootstrap turns its Sass variables into CSS variables, such as ',
          DocCode('--bs-body-color'),
          ', that any element can override for the elements inside it. The '
              'counterpart is the tokens (see ',
          DocLink.page('Tokens', 'Customize', 'Tokens'),
          '): the ',
          DocCode('BsBody'),
          ', ',
          DocCode('BsTypography'),
          ' and ',
          DocCode('BsLink'),
          ' classes hold the values, and the widgets read them. The inheriting '
              'part is the Flutter one: wrap any subtree in a ',
          DocCode('DefaultTextStyle.merge'),
          ' to change the text of everything inside it, as ',
          DocCode('style="--bs-body-color: #333;"'),
          ' does for the page.',
        ]),
        DocExample(
          code: '''
DefaultTextStyle.merge(
  style: TextStyle(color: Color(0xFF333333)),
  child: Text('Everything in here is #333.'),
)''',
          preview: DefaultTextStyle.merge(
            style: const TextStyle(color: Color(0xFF333333)),
            child: const Text('Everything in here is #333.'),
          ),
        ),
        const DocHeading('Page defaults'),
        DocText([
          'In Bootstrap the ',
          DocCode('<html>'),
          ' and ',
          DocCode('<body>'),
          ' elements get better page-wide defaults. In Flutter that is ',
          DocCode('BsApp'),
          ', which wraps the app in a ',
          DocCode('DefaultTextStyle'),
          ' that has:',
        ]),
        DocList([
          DocListItem([
            'The font family, size, weight and line height of the body: the '
                'system font stack (below), 16 logical pixels, 400 and 1.5.',
          ]),
          DocListItem([
            'The text color of the body, ',
            DocCode('BsBody.colorOf(context)'),
            ': dark gray in the light theme and light gray in the dark one.',
          ]),
          DocListItem([
            'A half-leading that is divided equally above and below the '
                'glyphs, as it is on the web. Flutter splits it in proportion '
                'to the ascent and descent by default, which sits text '
                'about a pixel high in a 1.5 line box.',
          ]),
        ]),
        DocText([
          'Pass ',
          DocCode('textStyle'),
          ' to ',
          DocCode('BsApp'),
          ' for a style of your own. It replaces this one whole, and is not '
              'brightness-aware: choose the color from ',
          DocCode('BsBody'),
          ' yourself if the app has both themes.',
        ]),
        DocText([
          DocBold('The background is not painted for you.'),
          ' Bootstrap gives the ',
          DocCode('<body>'),
          ' a ',
          DocCode('background-color'),
          ' for safety. ',
          DocCode('BsApp'),
          ' paints none: the page is as transparent as the window of the '
              'platform is. Paint it with the body color, which follows the '
              'theme, around the content of the app:',
        ]),
        const DocCodeSnippet('''
BsApp(
  home: BsBox(
    bg: BsBg.body,
    child: MyPage(),
  ),
)'''),
        DocText([
          DocBold('Box sizing.'),
          ' Bootstrap sets ',
          DocCode('box-sizing: border-box'),
          ' on everything. A Flutter widget is always like that: the size '
              'that its parent gives it includes its padding and its border, '
              'so the declared width is never exceeded.',
        ]),
        DocText([
          DocBold('The root font size.'),
          ' The base is 16 logical pixels, as the browser default is, in '
              'place of ',
          DocCode(r'$font-size-root'),
          '. Bootstrap uses ',
          DocCode('rem'),
          's so that the page respects the size the visitor chose in the '
              'browser. Flutter\'s counterpart is the text scale of the '
              'platform, which scales the text of the app, see ',
          DocLink.page('Accessibility', 'Getting started', 'Accessibility'),
          '.',
        ]),
        const DocHeading('Native font stack'),
        DocText([
          'Bootstrap uses a "native font stack", or "system font stack", for '
              'the best text rendering on every device and OS: ',
          DocCode('BsTypography.fontFamilySansSerif'),
          ' lists the families the library asks for, in order, and ',
          DocCode('BsApp'),
          ' puts them on the body:',
        ]),
        DocCodeSnippet(
          BsTypography.fontFamilySansSerif.map((name) => '- $name').join('\n'),
        ),
        DocText([
          'This is the stack of Bootstrap, without the families it adds for '
              'Linux (Noto Sans and Liberation Sans) and the emoji fonts at '
              'the end. Because the emoji fonts are not in it, a symbol '
              'that has an emoji form is drawn in whatever font the platform '
              'falls back to.',
        ]),
        DocText([
          'There are two things to keep in mind. On the web, Flutter draws '
              'the text itself and cannot reach the fonts of the system, so '
              'it falls back to its own, and a font you want has to be '
              'bundled, see ',
          DocLink.page(
            'Platforms & devices',
            'Getting started',
            'Platforms & devices',
          ),
          '. And a script that the stack does not cover, such as Arabic, '
              'needs a font of its own, passed to ',
          DocCode('BsApp.extraFontFamilyFallback'),
          '. To switch the font of the whole app, pass a ',
          DocCode('textStyle'),
          '; the ',
          DocCode('BsTypography'),
          ' stack is the one the widgets that set a family of their own use, '
              'such as ',
          DocCode('BsCode'),
          ', with the monospace stack.',
        ]),
        const DocHeading('Headings'),
        DocText([
          'A heading has no top margin, a bottom margin of 8 pixels, and a '
              'tight line height of 1.2. It inherits its color by default. '
              'Where Bootstrap has ',
          DocCode('--bs-heading-color'),
          ' for it, wrap the heading in a ',
          DocCode('DefaultTextStyle.merge'),
          ' with the color, as above. The sizes of the first four levels are '
              'fluid below the ',
          DocCode('xl'),
          ' breakpoint, as Bootstrap\'s responsive font sizes are; the table '
              'shows the size from ',
          DocCode('xl'),
          ' up.',
        ]),
        DocTable(
          headers: ['Heading', 'Example', 'Size'],
          rows: [
            for (final (level, size) in [
              (BsHeadingLevel.h1, BsTypography.h1FontSize),
              (BsHeadingLevel.h2, BsTypography.h2FontSize),
              (BsHeadingLevel.h3, BsTypography.h3FontSize),
              (BsHeadingLevel.h4, BsTypography.h4FontSize),
              (BsHeadingLevel.h5, BsTypography.h5FontSize),
              (BsHeadingLevel.h6, BsTypography.h6FontSize),
            ])
              [
                'BsHeadingLevel.${level.name}',
                BsHeading(
                  level,
                  mb: BsSpacing.s0,
                  child: Text('${level.name}. Bootstrap heading'),
                ),
                '${size.toStringAsFixed(0)}px',
              ],
          ],
        ),
        const DocHeading('Paragraphs'),
        DocText([
          'Flutter has no paragraph element: a ',
          DocCode('Text'),
          ' has no margin at all. For the margin that ',
          DocCode('p'),
          ' has, which is 16 pixels at the bottom, put it in a ',
          DocCode('BsBox'),
          '.',
        ]),
        DocExample(
          code: '''
BsBox(
  mb: BsSpacing.s3,
  child: Text('This is an example paragraph.'),
)''',
          preview: const BsBox(
            mb: BsSpacing.s3,
            child: Text('This is an example paragraph.'),
          ),
        ),
        const DocHeading('Links'),
        DocText([
          'Links have a default color and underline applied. While links '
              'change on hover, they do not change based on whether someone '
              'has visited them. ',
          DocCode('BsAnchor'),
          ' is a link of its own, and ',
          DocCode('BsInlineAnchors'),
          ' makes the links inside a sentence, so that the line breaks stay '
              'right. See ',
          DocLink.page('Typography', 'Content', 'Typography'),
          '.',
        ]),
        DocExample(
          code: '''
BsAnchor(
  onTap: () {},
  child: Text('This is an example link'),
)''',
          preview: BsAnchor(
            onTap: () {},
            child: const Text('This is an example link'),
          ),
        ),
        DocText([
          'A link does not get a focus style of its own, and it does not '
              'take part in the keyboard focus order: it answers a tap or a '
              'click only. Bootstrap changes the link color with ',
          DocCode('--bs-link-opacity'),
          '; here ',
          DocCode('linkColor'),
          ' sets a fixed color, and an ',
          DocCode('Opacity'),
          ' around the link sets how strong it is.',
        ]),
        DocExample(
          code: '''
Opacity(
  opacity: .5,
  child: BsAnchor(
    onTap: () {},
    child: Text('This is an example link'),
  ),
)''',
          preview: Opacity(
            opacity: .5,
            child: BsAnchor(
              onTap: () {},
              child: const Text('This is an example link'),
            ),
          ),
        ),
        DocText([
          'There is no counterpart to the placeholder link of Bootstrap, '
              'the one without an ',
          DocCode('href'),
          ' that is reset to the text around it. A ',
          DocCode('BsAnchor'),
          ' looks and acts like a link, with or without ',
          DocCode('onTap'),
          ', so leave it out where there is nothing to open, and write the '
              'text.',
        ]),
        const DocHeading('Horizontal rules'),
        DocText([
          'The horizontal rule is simplified. Like the browser\'s it is '
              'one line, but in the color of the text at 25% opacity, with a '
              '16 pixel margin above and below, and the color is the '
              'ambient one: a rule in a ',
          DocCode('BsBox'),
          ' with a ',
          DocCode('textColor'),
          ' takes that color. ',
          DocCode('my'),
          ' sets the margin.',
        ]),
        DocExample(
          code: '''
Column(
  children: [
    BsHr(),
    BsBox(
      textColor: BsTextColor.success,
      child: BsHr(),
    ),
  ],
)''',
          preview: const Column(
            children: [
              BsHr(),
              BsBox(textColor: BsTextColor.success, child: BsHr()),
            ],
          ),
        ),
        DocText([
          'The rule is one pixel and does not take a thickness, a border '
              'color or an opacity: for the ',
          DocCode('border border-danger border-2 opacity-50'),
          ' rule of Bootstrap, draw your own with a ',
          DocCode('Container'),
          ' of the height you want.',
        ]),
        const DocHeading('Lists'),
        DocText([
          'There are no list widgets in the library, as there are none for '
              'the elements that Flutter does not have. A list is rows of a '
              'marker and a text, in a column. As in Reboot, the list has no '
              'top margin and 16 pixels at the bottom, a nested list has '
              'none, and the marker takes the indent that ',
          DocCode('padding-left: 2rem'),
          ' does.',
        ]),
        DocExample(
          code: '''
Widget bullet(String text, {Widget? marker}) => Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SizedBox(
      width: 32,
      child: marker ?? Text('•', textAlign: TextAlign.center),
    ),
    Expanded(child: Text(text)),
  ],
);

BsBox(
  mb: BsSpacing.s3,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      bullet('All lists have their top margin removed'),
      bullet('And their bottom margin normalized'),
      bullet('Nested lists have no bottom margin'),
      Padding(
        padding: EdgeInsetsDirectional.only(start: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            bullet('This way they have a more even appearance'),
            bullet('Particularly when followed by more list items'),
          ],
        ),
      ),
      bullet('The left padding has also been reset'),
    ],
  ),
)

BsBox(
  mb: BsSpacing.s3,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      bullet('Here is an ordered list', marker: Text('1.', textAlign: TextAlign.end)),
      bullet('With a few list items', marker: Text('2.', textAlign: TextAlign.end)),
    ],
  ),
)''',
          preview: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _list([
                _bullet('All lists have their top margin removed'),
                _bullet('And their bottom margin normalized'),
                _bullet('Nested lists have no bottom margin'),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _bullet('This way they have a more even appearance'),
                      _bullet('Particularly when followed by more list items'),
                    ],
                  ),
                ),
                _bullet('The left padding has also been reset'),
              ]),
              _list([
                _bullet(
                  'Here is an ordered list',
                  marker: const Text('1.', textAlign: TextAlign.end),
                ),
                _bullet(
                  'With a few list items',
                  marker: const Text('2.', textAlign: TextAlign.end),
                ),
              ]),
            ],
          ),
        ),
        DocText([
          'A description list has simpler spacing: the terms are bold, and '
              'each definition has no left margin and 8 pixels at the bottom.',
        ]),
        DocExample(
          code: '''
BsBox(
  mb: BsSpacing.s3,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Description lists', style: TextStyle(fontWeight: FontWeight.w700)),
      BsBox(mb: BsSpacing.s2, child: Text('A description list is perfect for defining terms.')),
      Text('Term', style: TextStyle(fontWeight: FontWeight.w700)),
      BsBox(mb: BsSpacing.s2, child: Text('Definition for the term.')),
      BsBox(mb: BsSpacing.s2, child: Text('A second definition for the same term.')),
    ],
  ),
)''',
          preview: const BsBox(
            mb: BsSpacing.s3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Description lists',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                BsBox(
                  mb: BsSpacing.s2,
                  child: Text(
                    'A description list is perfect for defining terms.',
                  ),
                ),
                Text('Term', style: TextStyle(fontWeight: FontWeight.w700)),
                BsBox(
                  mb: BsSpacing.s2,
                  child: Text('Definition for the term.'),
                ),
                BsBox(
                  mb: BsSpacing.s2,
                  child: Text('A second definition for the same term.'),
                ),
              ],
            ),
          ),
        ),
        const DocHeading('Inline code'),
        DocText([
          'Wrap inline snippets of code in ',
          DocCode('BsCode'),
          ': monospace, 14 pixels, in the code color, pink in the light '
              'theme and a lighter pink in the dark one. Nothing needs '
              'escaping, since it is a widget and not markup.',
        ]),
        DocExample(
          code: '''
Wrap(
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    Text('For example, '),
    BsCode(child: Text('<section>')),
    Text(' should be wrapped as inline.'),
  ],
)''',
          preview: const Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text('For example, '),
              BsCode(child: Text('<section>')),
              Text(' should be wrapped as inline.'),
            ],
          ),
        ),
        const DocHeading('Code blocks'),
        DocText([
          'Use ',
          DocCode('BsPre'),
          ' for multiple lines of code. It sets the monospace family and the '
              'size of 14 pixels, and leaves the color to the text around it, '
              'as Reboot does. Line breaks and spaces in a ',
          DocCode('Text'),
          ' are kept. It has no margin of its own, and does not scroll: wrap '
              'it in a ',
          DocCode('SingleChildScrollView'),
          ' for long lines, and in a ',
          DocCode('BsBox'),
          ' for the 16 pixels at the bottom.',
        ]),
        DocExample(
          code: '''
BsBox(
  mb: BsSpacing.s3,
  child: BsPre(
    child: Text('<p>Sample text here...</p>\\n<p>And another line of sample text here...</p>'),
  ),
)''',
          preview: const BsBox(
            mb: BsSpacing.s3,
            child: BsPre(
              child: Text(
                '<p>Sample text here...</p>\n'
                '<p>And another line of sample text here...</p>',
              ),
            ),
          ),
        ),
        DocText([
          'On the web the monospace families are not reachable, and the code '
              'falls back to a proportional font until you bundle one, see ',
          DocLink.page(
            'Platforms & devices',
            'Getting started',
            'Platforms & devices',
          ),
          '.',
        ]),
        const DocHeading('Variables'),
        DocText([
          'There is no widget for ',
          DocCode('<var>'),
          '. It is the text in italics:',
        ]),
        DocExample(
          code: '''
Text.rich(
  TextSpan(
    children: [
      TextSpan(text: 'y', style: italic),
      TextSpan(text: ' = '),
      TextSpan(text: 'm', style: italic),
      TextSpan(text: 'x', style: italic),
      TextSpan(text: ' + '),
      TextSpan(text: 'b', style: italic),
    ],
  ),
)''',
          preview: const Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'y',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                TextSpan(text: ' = '),
                TextSpan(
                  text: 'm',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                TextSpan(
                  text: 'x',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
                TextSpan(text: ' + '),
                TextSpan(
                  text: 'b',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ],
            ),
          ),
        ),
        const DocHeading('User input'),
        DocText([
          'Use ',
          DocCode('BsKbd'),
          ' to indicate input that is typically entered via keyboard. It is '
              'monospace on a dark, rounded background, and sits in a row of '
              'text. For a combination of keys, put one ',
          DocCode('BsKbd'),
          ' next to the other.',
        ]),
        DocExample(
          code: '''
Wrap(
  crossAxisAlignment: WrapCrossAlignment.center,
  children: [
    Text('To switch directories, type '),
    BsKbd(child: Text('cd')),
    Text(' followed by the name of the directory.'),
  ],
)''',
          preview: const Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text('To switch directories, type '),
              BsKbd(child: Text('cd')),
              Text(' followed by the name of the directory.'),
            ],
          ),
        ),
        const DocHeading('Sample output'),
        DocText([
          'For sample output from a program there is no ',
          DocCode('<samp>'),
          ' either: it is the monospace family at the size of the text '
              'around it.',
        ]),
        DocExample(
          code: '''
Text(
  'This text is meant to be treated as sample output from a computer program.',
  style: TextStyle(
    fontFamily: BsTypography.fontFamilyMonospace.first,
    fontFamilyFallback: BsTypography.fontFamilyMonospace.skip(1).toList(),
  ),
)''',
          preview: Text(
            'This text is meant to be treated as sample output from a '
            'computer program.',
            style: _mono.copyWith(fontSize: null),
          ),
        ),
        const DocHeading('Tables'),
        DocText([
          'A bare table element is rebooted to a simpler baseline, and the ',
          DocCode('.table'),
          ' class adds the padding and the borders. ',
          DocCode('BsTable'),
          ' is the second: a table that has its cell padding, its rules and '
              'its caption, below the rows, in the muted color. The options '
              'are on the ',
          DocLink.page('Tables', 'Content', 'Tables'),
          ' page.',
        ]),
        DocExample(
          code: '''
BsTable(
  caption: Text('This is an example table, and this is its caption to describe the contents.'),
  columns: [for (var i = 0; i < 4; i++) Text('Table heading')],
  rows: [
    for (var row = 0; row < 3; row++)
      BsTableRow(cells: [for (var i = 0; i < 4; i++) Text('Table cell')]),
  ],
)''',
          preview: BsTable(
            caption: const Text(
              'This is an example table, and this is its caption to describe '
              'the contents.',
            ),
            columns: [
              for (var i = 0; i < 4; i++)
                const Text(
                  'Table heading',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
            ],
            rows: [
              for (var row = 0; row < 3; row++)
                BsTableRow(
                  cells: [for (var i = 0; i < 4; i++) const Text('Table cell')],
                ),
            ],
          ),
        ),
        const DocHeading('Forms'),
        DocText([
          'Reboot gives the form elements simpler base styles: fieldsets '
              'with no border, labels that can take a margin, controls that '
              'inherit the font. None of it is needed here. There are no '
              'native controls to normalize: every control is a themed ',
          DocCode('Bs*'),
          ' widget, with the font and the line height of the text around '
              'it, and the pointing hand where it can be pressed. See ',
          DocLink.page('Form control', 'Forms', 'Form control'),
          ' and the pages that follow it. A label is ',
          DocCode('BsFormLabel'),
          '.',
        ]),
        const DocHeading('Pointers on buttons', sub: true),
        DocText([
          'Reboot changes the cursor of an element with ',
          DocCode('role="button"'),
          ' to a pointer. A widget of your own that can be pressed gets the '
              'same with a ',
          DocCode('MouseRegion'),
          ' around a ',
          DocCode('GestureDetector'),
          ':',
        ]),
        const DocCodeSnippet('''
MouseRegion(
  cursor: SystemMouseCursors.click,
  child: GestureDetector(
    onTap: () {},
    child: Text('Non-button element button'),
  ),
)'''),
        const DocHeading('Misc elements'),
        const DocHeading('Address', sub: true),
        DocText([
          'There is no ',
          DocCode('<address>'),
          '. Its changes are already how text behaves in Flutter: it is not '
              'italic, and the line height is inherited. What is left is the '
              'bottom margin of 16 pixels, and the line breaks, which are '
              'the ones in the string.',
        ]),
        DocExample(
          code: '''
BsBox(
  mb: BsSpacing.s3,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('ACME Corporation', style: TextStyle(fontWeight: FontWeight.w700)),
      Text('1123 Fictional St,\\nSan Francisco, CA 94103'),
      Text('P: (123) 456-7890'),
    ],
  ),
)''',
          preview: const BsBox(
            mb: BsSpacing.s3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ACME Corporation',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                Text('1123 Fictional St,\nSan Francisco, CA 94103'),
                Text('P: (123) 456-7890'),
              ],
            ),
          ),
        ),
        const DocHeading('Blockquote', sub: true),
        DocText([
          'The default margin of a blockquote in the browser is ',
          DocCode('1em 40px'),
          ', which Reboot resets to ',
          DocCode('0 0 1rem'),
          '. ',
          DocCode('BsBlockquote'),
          ' has just the 16 pixels at the bottom, and a font size of 20. '
              'Its footer is in ',
          DocLink.page('Typography', 'Content', 'Typography'),
          '.',
        ]),
        DocExample(
          code: '''
BsBlockquote(
  child: Text('A well-known quote, contained in a blockquote element.'),
)''',
          preview: const BsBlockquote(
            child: Text(
              'A well-known quote, contained in a blockquote element.',
            ),
          ),
        ),
        const DocHeading('Inline elements', sub: true),
        DocText([
          'An abbreviation is underlined with dots, and the pointer is the '
              'help one. The text of its ',
          DocCode('title'),
          ' is what a ',
          DocCode('BsTooltip'),
          ' shows, on hover or a long press.',
        ]),
        DocExample(
          code: '''
BsTooltip(
  message: Text('HyperText Markup Language'),
  child: MouseRegion(
    cursor: SystemMouseCursors.help,
    child: Text(
      'HTML',
      style: TextStyle(
        decoration: TextDecoration.underline,
        decorationStyle: TextDecorationStyle.dotted,
      ),
    ),
  ),
)''',
          preview: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text('The '),
              BsTooltip(
                message: const Text('HyperText Markup Language'),
                child: const MouseRegion(
                  cursor: SystemMouseCursors.help,
                  child: Text(
                    'HTML',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.dotted,
                    ),
                  ),
                ),
              ),
              const Text(' abbreviation element.'),
            ],
          ),
        ),
        const DocHeading('Summary', sub: true),
        DocText([
          'A disclosure widget with a summary is a ',
          DocCode('BsAccordion'),
          ', whose header is the summary and whose pointer is the hand. See ',
          DocLink.page('Accordion', 'Components', 'Accordion'),
          '.',
        ]),
        const DocHeading('The hidden attribute'),
        DocText([
          'Bootstrap makes ',
          DocCode('[hidden]'),
          ' win over every other ',
          DocCode('display'),
          '. In Flutter an element is hidden by not building it, which '
              'cannot be overridden by accident. To keep its place in the '
              'layout, see ',
          DocLink.page('Utilities for layout', 'Layout', 'Utilities'),
          '.',
        ]),
      ],
    );
  }
}
