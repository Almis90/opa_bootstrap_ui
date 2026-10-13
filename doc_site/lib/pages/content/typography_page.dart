import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_content.dart';
import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

WidgetSpan _inline(Widget child) => WidgetSpan(
  alignment: PlaceholderAlignment.baseline,
  baseline: TextBaseline.alphabetic,
  child: child,
);

Widget _bullet(String text) => Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    const SizedBox(width: 32, child: Text('•', textAlign: TextAlign.center)),
    Expanded(child: Text(text)),
  ],
);

Widget _abbr(String text, String title, {bool initialism = false}) {
  final label = Text(
    initialism ? text.toUpperCase() : text,
    style: const TextStyle(
      decoration: TextDecoration.underline,
      decorationStyle: TextDecorationStyle.dotted,
    ),
  );
  return BsTooltip(
    message: Text(title),
    child: MouseRegion(
      cursor: SystemMouseCursors.help,
      child: initialism ? BsSmall(child: label) : label,
    ),
  );
}

Widget _quoteFigure({BsTextAlign? align}) {
  final figure = Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      const BsBlockquote(
        child: Text('A well-known quote, contained in a blockquote element.'),
      ),
      BsBlockquoteFooter(
        standalone: true,
        child: Text.rich(
          const TextSpan(
            children: [
              TextSpan(text: 'Someone famous in '),
              TextSpan(
                text: 'Source Title',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    ],
  );
  return align == null ? figure : BsBox(textAlign: align, child: figure);
}

/// "Typography": headings, display headings, lead, inline text, abbreviations,
/// blockquotes and lists.
class TypographyPage extends StatelessWidget {
  const TypographyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      leadGap: 0,
      title: 'Typography',
      lead:
          'Documentation and examples for the typography of opa_bootstrap_ui, '
          'including global settings, headings, body text, lists and more.',
      children: [
        const DocHeading('Global settings'),
        DocText([
          'Bootstrap sets basic global display, typography and link styles. '
              'The counterpart is ',
          DocCode('BsApp'),
          ', which gives the whole app the text defaults below. When more '
              'control is needed, check out the ',
          DocLink.page('text utilities', 'Utilities', 'Text'),
          '.',
        ]),
        DocList([
          DocListItem([
            'Use a ',
            DocLink.page('native font stack', 'Content', 'Reboot'),
            ' that selects the best font family for each OS and device.',
          ]),
          DocListItem([
            'The base size is 16 logical pixels, ',
            DocCode('BsTypography.fontSizeBase'),
            ', the default of the browser. Bootstrap uses it so that '
                'visitors can customize their browser defaults; here the '
                'text scale of the platform does that, see ',
            DocLink.page('Accessibility', 'Getting started', 'Accessibility'),
            '.',
          ]),
          DocListItem([
            DocCode('BsTypography.fontFamilySansSerif'),
            ', ',
            DocCode('fontSizeBase'),
            ' and ',
            DocCode('lineHeightBase'),
            ' (1.5) are the typographic base that ',
            DocCode('BsApp'),
            ' applies to everything below it.',
          ]),
          DocListItem([
            'The color of links is ',
            DocCode('BsLink'),
            ', which ',
            DocCode('BsAnchor'),
            ' and ',
            DocCode('BsInlineAnchors'),
            ' read.',
          ]),
          DocListItem([
            DocCode('BsApp'),
            ' does not paint a background. Wrap the app in a ',
            DocCode('BsBox(bg: BsBg.body)'),
            ' for the color of the body, see ',
            DocLink.page('Reboot', 'Content', 'Reboot'),
            '.',
          ]),
        ]),
        const DocHeading('Headings'),
        DocText([
          'All six levels are available as ',
          DocCode('BsHeading'),
          '; the first four are fluid below the ',
          DocCode('xl'),
          ' breakpoint (see the sizes at the end of the page).',
        ]),
        DocTable(
          headers: ['Widget', 'Example'],
          rows: [
            for (final level in BsHeadingLevel.values)
              [
                'BsHeading(BsHeadingLevel.${level.name})',
                BsHeading(
                  level,
                  mb: BsSpacing.s0,
                  child: Text('${level.name}. Bootstrap heading'),
                ),
              ],
          ],
        ),
        DocExample(
          code: '''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    BsHeading(BsHeadingLevel.h1, child: Text('h1. Bootstrap heading')),
    BsHeading(BsHeadingLevel.h2, child: Text('h2. Bootstrap heading')),
    BsHeading(BsHeadingLevel.h3, child: Text('h3. Bootstrap heading')),
    BsHeading(BsHeadingLevel.h4, child: Text('h4. Bootstrap heading')),
    BsHeading(BsHeadingLevel.h5, child: Text('h5. Bootstrap heading')),
    BsHeading(BsHeadingLevel.h6, child: Text('h6. Bootstrap heading')),
  ],
)''',
          preview: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final level in BsHeadingLevel.values)
                BsHeading(
                  level,
                  child: Text('${level.name}. Bootstrap heading'),
                ),
            ],
          ),
        ),
        DocText([
          'A heading is a widget and not an element, so there is no ',
          DocCode('.h1'),
          ' class for when you cannot use the element: every ',
          DocCode('BsHeading'),
          ' is what both are in Bootstrap. What Bootstrap does with a utility '
              'class, you do with a prop: ',
          DocCode('fs'),
          ' sets another size, ',
          DocCode('fw'),
          ' another weight, ',
          DocCode('lh'),
          ' another line height and ',
          DocCode('mb'),
          ' another margin, and the heading keeps the rest of its level.',
        ]),
        DocExample(
          code: '''
BsHeading(
  BsHeadingLevel.h1,
  fs: BsFs.fs4,
  fw: BsFw.bold,
  child: Text('An h1 at the size of an h4, in bold'),
)''',
          preview: const BsHeading(
            BsHeadingLevel.h1,
            fs: BsFs.fs4,
            fw: BsFw.bold,
            child: Text('An h1 at the size of an h4, in bold'),
          ),
        ),
        const DocHeading('Customizing headings', sub: true),
        DocText([
          'Use a ',
          DocCode('BsSmall'),
          ' in a muted color to recreate the small secondary heading text '
              'from Bootstrap 3. It is a widget in the middle of the text, '
              'so it stays on one line, and it sits on the baseline.',
        ]),
        DocExample(
          code: '''
BsHeading(
  BsHeadingLevel.h3,
  child: Text.rich(
    TextSpan(
      children: [
        TextSpan(text: 'Fancy display heading '),
        WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: DefaultTextStyle.merge(
            style: TextStyle(color: BsBody.secondaryColorOf(context)),
            child: BsSmall(child: Text('With faded secondary text')),
          ),
        ),
      ],
    ),
  ),
)''',
          preview: BsHeading(
            BsHeadingLevel.h3,
            child: Text.rich(
              TextSpan(
                children: [
                  const TextSpan(text: 'Fancy display heading '),
                  _inline(
                    DefaultTextStyle.merge(
                      style: TextStyle(color: BsBody.secondaryColorOf(context)),
                      child: const BsSmall(
                        child: Text('With faded secondary text'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const DocHeading('Display headings'),
        DocText([
          'Traditional headings are designed to work best in the meat of '
              'your page content. When you need a heading to stand out, '
              'consider using a ',
          DocBold('display heading'),
          ': a larger, lighter and slightly more opinionated heading style. '
              'It is ',
          DocCode('BsDisplayHeading'),
          ', with six levels.',
        ]),
        DocExample(
          code: '''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    for (final level in BsDisplayLevel.values)
      BsDisplayHeading(level, child: Text('Display \${level.name.substring(1)}')),
  ],
)''',
          preview: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final level in BsDisplayLevel.values)
                BsBox(
                  pb: level == BsDisplayLevel.d6 ? null : BsSpacing.s3,
                  mb: level == BsDisplayLevel.d6 ? null : BsSpacing.s3,
                  borderBottom: level != BsDisplayLevel.d6,
                  child: BsDisplayHeading(
                    level,
                    child: Text('Display ${level.name.substring(1)}'),
                  ),
                ),
            ],
          ),
        ),
        DocText([
          'A display heading has no margin of its own, where an ',
          DocCode('h1'),
          ' with the class has the one of its element: put a ',
          DocCode('BsBox'),
          ' with ',
          DocCode('mb'),
          ' around it. Its weight is 300 and its line height 1.2, ',
          DocCode('BsTypography.displayFontWeight'),
          ' and ',
          DocCode('displayLineHeight'),
          '; ',
          DocCode('fw'),
          ' and ',
          DocCode('lh'),
          ' change them for one heading. The six sizes are those of Bootstrap\'s ',
          DocCode(r'$display-font-sizes'),
          ' map and are fixed in the ',
          DocCode('BsDisplayLevel'),
          ' enum, which has no counterpart to ',
          DocCode(r'$display-font-family'),
          ' or ',
          DocCode(r'$display-font-style'),
          ': the heading inherits both, so set them with a ',
          DocCode('DefaultTextStyle.merge'),
          ' around it.',
        ]),
        const DocHeading('Lead'),
        DocText([
          'Make a paragraph stand out with ',
          DocCode('BsLead'),
          ': 20 pixels, in a weight of 300.',
        ]),
        const DocExample(
          code: '''
BsLead(
  child: Text('This is a lead paragraph. It stands out from regular paragraphs.'),
)''',
          preview: BsLead(
            child: Text(
              'This is a lead paragraph. It stands out from regular '
              'paragraphs.',
            ),
          ),
        ),
        const DocHeading('Inline text elements'),
        DocText([
          'Styling for common inline text. The highlight and the fine print '
              'are widgets; the rest is a style on a ',
          DocCode('Text'),
          ' or a ',
          DocCode('TextSpan'),
          '.',
        ]),
        DocExample(
          code: '''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  spacing: 16,
  children: [
    Text.rich(
      TextSpan(
        children: [
          TextSpan(text: 'You can use the mark tag to '),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: BsMark(child: Text('highlight')),
          ),
          TextSpan(text: ' text.'),
        ],
      ),
    ),
    Text(
      'This line of text is meant to be treated as deleted text.',
      style: TextStyle(decoration: TextDecoration.lineThrough),
    ),
    Text(
      'This line of text is meant to be treated as no longer accurate.',
      style: TextStyle(decoration: TextDecoration.lineThrough),
    ),
    Text(
      'This line of text is meant to be treated as an addition to the document.',
      style: TextStyle(decoration: TextDecoration.underline),
    ),
    Text(
      'This line of text will render as underlined.',
      style: TextStyle(decoration: TextDecoration.underline),
    ),
    BsSmall(
      child: Text('This line of text is meant to be treated as fine print.'),
    ),
    Text(
      'This line rendered as bold text.',
      style: TextStyle(fontWeight: FontWeight.w700),
    ),
    Text(
      'This line rendered as italicized text.',
      style: TextStyle(fontStyle: FontStyle.italic),
    ),
  ],
)''',
          preview: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(text: 'You can use the mark tag to '),
                    _inline(const BsMark(child: Text('highlight'))),
                    const TextSpan(text: ' text.'),
                  ],
                ),
              ),
              const Text(
                'This line of text is meant to be treated as deleted text.',
                style: TextStyle(decoration: TextDecoration.lineThrough),
              ),
              const Text(
                'This line of text is meant to be treated as no longer '
                'accurate.',
                style: TextStyle(decoration: TextDecoration.lineThrough),
              ),
              const Text(
                'This line of text is meant to be treated as an addition to '
                'the document.',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
              const Text(
                'This line of text will render as underlined.',
                style: TextStyle(decoration: TextDecoration.underline),
              ),
              const BsSmall(
                child: Text(
                  'This line of text is meant to be treated as fine print.',
                ),
              ),
              const Text(
                'This line rendered as bold text.',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),
              const Text(
                'This line rendered as italicized text.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
        DocText([
          'HTML gives these tags a meaning, and Bootstrap asks that they are '
              'used for it, and that other text is styled with a class. Text in '
              'Flutter carries no such meaning: ',
          DocCode('BsMark'),
          ' and ',
          DocCode('BsSmall'),
          ' only look as the elements do, and the rest is a text style. '
              'Use them for the look, and use ',
          DocCode('Semantics'),
          ' where the meaning is needed, see ',
          DocLink.page('Accessibility', 'Getting started', 'Accessibility'),
          '.',
        ]),
        DocList([
          DocListItem([
            DocCode('BsMark'),
            ' highlights text in a light yellow, darker in the dark theme.',
          ]),
          DocListItem([
            DocCode('BsSmall'),
            ' is 87.5% of the size around it. Inline, it leaves the line '
                'height of the line as it was; with ',
            DocCode('block: true'),
            ' it is a box of its own with lines of its own.',
          ]),
          DocListItem([
            DocCode('TextDecoration.underline'),
            ' is ',
            DocCode('<u>'),
            ' and ',
            DocCode('<ins>'),
            ', and ',
            DocCode('TextDecoration.lineThrough'),
            ' is ',
            DocCode('<s>'),
            ' and ',
            DocCode('<del>'),
            '.',
          ]),
          DocListItem([
            DocCode('FontWeight.w700'),
            ' is ',
            DocCode('<strong>'),
            ' and ',
            DocCode('<b>'),
            ', and ',
            DocCode('FontStyle.italic'),
            ' is ',
            DocCode('<em>'),
            ' and ',
            DocCode('<i>'),
            '.',
          ]),
        ]),
        const DocHeading('Text utilities'),
        DocText([
          'Change text alignment, transform, style, weight, line height, '
              'decoration and color with the ',
          DocLink.page('text utilities', 'Utilities', 'Text'),
          ' and the ',
          DocLink.page('color utilities', 'Utilities', 'Colors'),
          '.',
        ]),
        const DocHeading('Abbreviations'),
        DocText([
          'An abbreviation or an acronym shows its expanded version on hover '
              'with a ',
          DocCode('BsTooltip'),
          '. The Reboot style of an ',
          DocCode('abbr'),
          ' is a dotted underline and the help pointer, which you give it '
              'with a ',
          DocCode('TextDecoration'),
          ' and a ',
          DocCode('MouseRegion'),
          ' (see ',
          DocLink.page('Reboot', 'Content', 'Reboot'),
          '). For ',
          DocCode('.initialism'),
          ', a slightly smaller font size, and capitals, put a ',
          DocCode('BsSmall'),
          ' around the text.',
        ]),
        DocExample(
          code: '''
Widget abbr(String text, String title, {bool initialism = false}) {
  final label = Text(
    initialism ? text.toUpperCase() : text,
    style: TextStyle(
      decoration: TextDecoration.underline,
      decorationStyle: TextDecorationStyle.dotted,
    ),
  );
  return BsTooltip(
    message: Text(title),
    child: MouseRegion(
      cursor: SystemMouseCursors.help,
      child: initialism ? BsSmall(child: label) : label,
    ),
  );
}

Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  spacing: 16,
  children: [
    abbr('attr', 'attribute'),
    abbr('HTML', 'HyperText Markup Language', initialism: true),
  ],
)''',
          preview: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16,
            children: [
              _abbr('attr', 'attribute'),
              _abbr('HTML', 'HyperText Markup Language', initialism: true),
            ],
          ),
        ),
        const DocHeading('Blockquotes'),
        DocText([
          'For quoting blocks of content from another source within your '
              'document. Use ',
          DocCode('BsBlockquote'),
          ': 20 pixels, with a margin of 16 at the bottom.',
        ]),
        const DocExample(
          code: '''
BsBlockquote(
  child: Text('A well-known quote, contained in a blockquote element.'),
)''',
          preview: BsBlockquote(
            child: Text(
              'A well-known quote, contained in a blockquote element.',
            ),
          ),
        ),
        const DocHeading('Naming a source', sub: true),
        DocText([
          'Give the quote a ',
          DocCode('footer'),
          ': a ',
          DocCode('BsBlockquoteFooter'),
          ' in smaller, muted text, that starts with a dash. Wrap the name of '
              'the source work in italics, as ',
          DocCode('<cite>'),
          ' does. The footer is part of the blockquote and takes its '
              'margin with it.',
        ]),
        DocExample(
          code: '''
BsBlockquote(
  footer: BsBlockquoteFooter(
    child: Text.rich(
      TextSpan(
        children: [
          TextSpan(text: 'Someone famous in '),
          TextSpan(
            text: 'Source Title',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    ),
  ),
  child: Text('A well-known quote, contained in a blockquote element.'),
)''',
          preview: const BsBlockquote(
            footer: BsBlockquoteFooter(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'Someone famous in '),
                    TextSpan(
                      text: 'Source Title',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),
            ),
            child: Text(
              'A well-known quote, contained in a blockquote element.',
            ),
          ),
        ),
        DocText([
          'Where the HTML spec asks for the attribution outside of the '
              'blockquote, in a ',
          DocCode('figcaption'),
          ', pass ',
          DocCode('standalone: true'),
          ' and put the footer after the blockquote in a column. It is '
              'pulled up over the margin of the blockquote and takes the '
              'alignment of the text around it. The next example uses it.',
        ]),
        const DocHeading('Alignment', sub: true),
        DocText([
          'Use ',
          DocCode('textAlign'),
          ' of a ',
          DocCode('BsBox'),
          ' as needed to change the alignment of your blockquote.',
        ]),
        DocExample(
          code: '''
BsBox(
  textAlign: BsTextAlign.center,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      BsBlockquote(
        child: Text('A well-known quote, contained in a blockquote element.'),
      ),
      BsBlockquoteFooter(
        standalone: true,
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: 'Someone famous in '),
              TextSpan(
                text: 'Source Title',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    ],
  ),
)''',
          preview: _quoteFigure(align: BsTextAlign.center),
        ),
        DocExample(
          code: '''
BsBox(
  textAlign: BsTextAlign.end,
  child: Column(
    // The same blockquote and footer as above.
  ),
)''',
          preview: _quoteFigure(align: BsTextAlign.end),
        ),
        const DocHeading('Lists'),
        const DocHeading('Unstyled', sub: true),
        DocText([
          'There are no list widgets, so an unstyled list is what you get '
              'without a marker: a ',
          DocCode('Column'),
          ' of texts. A nested list is a list of its own, that keeps '
              'its bullets and its 32 pixels of indent: the same one that '
              'Bootstrap\'s ',
          DocCode('.list-unstyled'),
          ' leaves it with. See ',
          DocLink.page('Reboot', 'Content', 'Reboot'),
          ' for the lists with a marker.',
        ]),
        DocExample(
          code: '''
Widget bullet(String text) => Row(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    SizedBox(width: 32, child: Text('•', textAlign: TextAlign.center)),
    Expanded(child: Text(text)),
  ],
);

Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text('This is a list.'),
    Text('It appears completely unstyled.'),
    Text('Structurally, it\\'s still a list.'),
    Text('However, this style only applies to immediate child elements.'),
    Text('Nested lists:'),
    Padding(
      padding: EdgeInsetsDirectional.only(start: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          bullet('are unaffected by this style'),
          bullet('will still show a bullet'),
          bullet('and have appropriate left margin'),
        ],
      ),
    ),
    Text('This may still come in handy in some situations.'),
  ],
)''',
          preview: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('This is a list.'),
              const Text('It appears completely unstyled.'),
              const Text('Structurally, it\'s still a list.'),
              const Text(
                'However, this style only applies to immediate child elements.',
              ),
              const Text('Nested lists:'),
              Padding(
                padding: const EdgeInsetsDirectional.only(start: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _bullet('are unaffected by this style'),
                    _bullet('will still show a bullet'),
                    _bullet('and have appropriate left margin'),
                  ],
                ),
              ),
              const Text('This may still come in handy in some situations.'),
            ],
          ),
        ),
        const DocHeading('Inline', sub: true),
        DocText([
          'Lay the items of a list in a line with a ',
          DocCode('Wrap'),
          ', whose ',
          DocCode('spacing'),
          ' is the margin of 8 pixels between them. They go to the next line '
              'when there is no room for them.',
        ]),
        const DocExample(
          code: '''
Wrap(
  spacing: 8,
  children: [
    Text('This is a list item.'),
    Text('And another one.'),
    Text('But they\\'re displayed inline.'),
  ],
)''',
          preview: Wrap(
            spacing: 8,
            children: [
              Text('This is a list item.'),
              Text('And another one.'),
              Text('But they\'re displayed inline.'),
            ],
          ),
        ),
        const DocHeading('Description list alignment', sub: true),
        DocText([
          'Align terms and descriptions horizontally by using the grid. The '
              'terms are bold and the descriptions have 8 pixels at the '
              'bottom; at the widths below ',
          DocCode('sm'),
          ' they stack, as the columns do. For longer terms, a ',
          DocCode('Text'),
          ' that does not wrap and has an ellipsis for an overflow, is '
              'the counterpart to ',
          DocCode('.text-truncate'),
          '. See ',
          DocLink.page('Grid system', 'Layout', 'Grid'),
          '.',
        ]),
        DocExample(
          code: '''
const bold = TextStyle(fontWeight: FontWeight.w700);

BsRow(
  children: [
    BsFlexItem(
      col: BsResponsiveValue(sm: BsCol(3)),
      child: Text('Description lists', style: bold),
    ),
    BsFlexItem(
      col: BsResponsiveValue(sm: BsCol(9)),
      mb: BsSpacing.s2,
      child: Text('A description list is perfect for defining terms.'),
    ),
    BsFlexItem(
      col: BsResponsiveValue(sm: BsCol(3)),
      child: Text('Term', style: bold),
    ),
    BsFlexItem(
      col: BsResponsiveValue(sm: BsCol(9)),
      mb: BsSpacing.s2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BsBox(mb: BsSpacing.s3, child: Text('Definition for the term.')),
          BsBox(mb: BsSpacing.s3, child: Text('And some more placeholder definition text.')),
        ],
      ),
    ),
    BsFlexItem(
      col: BsResponsiveValue(sm: BsCol(3)),
      child: Text('Another term', style: bold),
    ),
    BsFlexItem(
      col: BsResponsiveValue(sm: BsCol(9)),
      mb: BsSpacing.s2,
      child: Text('This definition is short, so no extra paragraphs or anything.'),
    ),
    BsFlexItem(
      col: BsResponsiveValue(sm: BsCol(3)),
      child: Text(
        'Truncated term is truncated',
        style: bold,
        maxLines: 1,
        softWrap: false,
        overflow: TextOverflow.ellipsis,
      ),
    ),
    BsFlexItem(
      col: BsResponsiveValue(sm: BsCol(9)),
      mb: BsSpacing.s2,
      child: Text('This can be useful when space is tight. Adds an ellipsis at the end.'),
    ),
    BsFlexItem(
      col: BsResponsiveValue(sm: BsCol(3)),
      child: Text('Nesting', style: bold),
    ),
    BsFlexItem(
      col: BsResponsiveValue(sm: BsCol(9)),
      mb: BsSpacing.s2,
      child: BsRow(
        children: [
          BsFlexItem(
            col: BsResponsiveValue(sm: BsCol(4)),
            child: Text('Nested definition list', style: bold),
          ),
          BsFlexItem(
            col: BsResponsiveValue(sm: BsCol(8)),
            mb: BsSpacing.s2,
            child: Text('I heard you like definition lists. Let me put a definition list inside your definition list.'),
          ),
        ],
      ),
    ),
  ],
)''',
          preview: const _DescriptionList(),
        ),
        const DocHeading('Responsive font sizes'),
        DocText([
          'In Bootstrap 5, responsive font sizes are enabled by default, '
              'allowing text to scale more naturally across device and '
              'viewport sizes. The first four heading levels and all the '
              'display headings do the same here: they grow with the width '
              'of the viewport below the ',
          DocCode('xl'),
          ' breakpoint (1200 pixels) and are fixed from there up. Have a '
              'look at the ',
          DocLink.page('RFS page', 'Getting started', 'RFS'),
          ' for the sizes of your own widgets.',
        ]),
        DocTable(
          headers: ['Widget', '375px', '768px', '1200px and up'],
          rows: [
            for (final fs in [BsFs.fs1, BsFs.fs2, BsFs.fs3, BsFs.fs4])
              [
                'BsFs.${fs.name}',
                for (final width in [375.0, 768.0, 1200.0])
                  '${fs.sizeFor(width).toStringAsFixed(1)}px',
              ],
            for (final level in BsDisplayLevel.values)
              [
                'BsDisplayLevel.${level.name}',
                for (final width in [375.0, 768.0, 1200.0])
                  '${level.sizeFor(width).toStringAsFixed(1)}px',
              ],
          ],
        ),
        DocText([
          'The ',
          DocCode('BsFs'),
          ' steps are those of ',
          DocCode('BsHeading'),
          ' for levels 1 to 4, and the fifth and the sixth are fixed at 20 '
              'and 16 pixels. ',
          DocCode('BsBox'),
          ' takes the same steps as its ',
          DocCode('fs'),
          ', also responsive.',
        ]),
        const DocHeading('Tokens'),
        DocText([
          'Headings have some dedicated variables for sizing and spacing, and '
              'so do the other typography elements covered here and in ',
          DocLink.page('Reboot', 'Content', 'Reboot'),
          '. They are constants of ',
          DocCode('BsTypography'),
          ' that the widgets read, that you cannot change: see ',
          DocLink.page('Tokens', 'Customize', 'Tokens'),
          '.',
        ]),
        DocTable(
          headers: ['Bootstrap (Sass)', 'BsTypography', 'Value'],
          rows: [
            [
              r'$font-size-base',
              'fontSizeBase',
              '${BsTypography.fontSizeBase.toStringAsFixed(0)}px',
            ],
            [
              r'$line-height-base',
              'lineHeightBase',
              '${BsTypography.lineHeightBase}',
            ],
            [
              r'$headings-margin-bottom',
              'headingsMarginBottom',
              '${BsTypography.headingsMarginBottom.toStringAsFixed(0)}px',
            ],
            [
              r'$headings-font-weight',
              'headingsFontWeight',
              '${BsTypography.headingsFontWeight.value}',
            ],
            [
              r'$headings-line-height',
              'headingsLineHeight',
              '${BsTypography.headingsLineHeight}',
            ],
            [
              r'$display-font-weight',
              'displayFontWeight',
              '${BsTypography.displayFontWeight.value}',
            ],
            [
              r'$display-line-height',
              'displayLineHeight',
              '${BsTypography.displayLineHeight}',
            ],
            [
              r'$lead-font-size',
              'leadFontSize',
              '${BsTypography.leadFontSize.toStringAsFixed(0)}px',
            ],
            [
              r'$lead-font-weight',
              'leadFontWeight',
              '${BsTypography.leadFontWeight.value}',
            ],
            [
              r'$mark-padding',
              'markPadding',
              '${BsTypography.markPadding.toStringAsFixed(0)}px',
            ],
            [
              r'$blockquote-font-size',
              'blockquoteFontSize',
              '${BsTypography.blockquoteFontSize.toStringAsFixed(0)}px',
            ],
            [
              r'$blockquote-margin-y',
              'blockquoteMarginY',
              '${BsTypography.blockquoteMarginY.toStringAsFixed(0)}px',
            ],
          ],
        ),
        DocText([
          'The sizes of the headings are in the ',
          DocCode('BsFs'),
          ' and ',
          DocCode('BsDisplayLevel'),
          ' enums, because they are fluid. There are no mixins for typography, '
              'and nothing to include; the responsive sizing is the one of the '
              'page above.',
        ]),
      ],
    );
  }
}

class _DescriptionList extends StatelessWidget {
  const _DescriptionList();

  static const _bold = TextStyle(fontWeight: FontWeight.w700);

  static BsFlexItem _term(String text, int sm, {bool truncate = false}) {
    return BsFlexItem(
      col: BsResponsiveValue(sm: BsCol(sm)),
      child: Text(
        text,
        style: _bold,
        maxLines: truncate ? 1 : null,
        softWrap: truncate ? false : null,
        overflow: truncate ? TextOverflow.ellipsis : null,
      ),
    );
  }

  static BsFlexItem _definition(Widget child, int sm) {
    return BsFlexItem(
      col: BsResponsiveValue(sm: BsCol(sm)),
      mb: BsSpacing.s2,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BsRow(
      children: [
        _term('Description lists', 3),
        _definition(
          const Text('A description list is perfect for defining terms.'),
          9,
        ),
        _term('Term', 3),
        _definition(
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BsBox(mb: BsSpacing.s3, child: Text('Definition for the term.')),
              BsBox(
                mb: BsSpacing.s3,
                child: Text('And some more placeholder definition text.'),
              ),
            ],
          ),
          9,
        ),
        _term('Another term', 3),
        _definition(
          const Text(
            'This definition is short, so no extra paragraphs or anything.',
          ),
          9,
        ),
        _term('Truncated term is truncated', 3, truncate: true),
        _definition(
          const Text(
            'This can be useful when space is tight. Adds an ellipsis at the '
            'end.',
          ),
          9,
        ),
        _term('Nesting', 3),
        _definition(
          BsRow(
            children: [
              _term('Nested definition list', 4),
              _definition(
                const Text(
                  'I heard you like definition lists. Let me put a definition '
                  'list inside your definition list.',
                ),
                8,
              ),
            ],
          ),
          9,
        ),
      ],
    );
  }
}
