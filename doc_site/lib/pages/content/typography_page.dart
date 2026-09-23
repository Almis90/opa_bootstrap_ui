import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

class TypographyPage extends StatelessWidget {
  const TypographyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Typography',
      lead:
          'These widgets style plain Text children — headings, leads, inline marks and links, blockquotes, and '
          'code — to Bootstrap\'s type scale without depending on any platform text theme.',
      examples: [
        DocExample(
          title: 'Headings',
          description: 'BsHeading takes a BsHeadingLevel (h1 through h6) and sizes its child from the same scale as Bootstrap\'s headings.',
          code: '''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    for (final level in BsHeadingLevel.values)
      BsHeading(level, child: Text('\${level.name.toUpperCase()}. Bootstrap heading')),
  ],
)''',
          preview: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final level in BsHeadingLevel.values)
                BsHeading(level, child: Text('${level.name.toUpperCase()}. Bootstrap heading')),
            ],
          ),
        ),
        DocExample(
          title: 'Display headings',
          description: 'BsDisplayHeading takes a BsDisplayLevel (d1 through d6) for larger, lighter-weight hero text than BsHeading.',
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
                BsDisplayHeading(level, child: Text('Display ${level.name.substring(1)}')),
            ],
          ),
        ),
        const DocExample(
          title: 'Lead',
          description: 'BsLead bumps up font size and weight slightly so an intro paragraph stands out from body text.',
          code: '''
BsLead(
  child: Text('This is a lead paragraph. It stands out from regular paragraphs.'),
)''',
          preview: BsLead(
            child: Text('This is a lead paragraph. It stands out from regular paragraphs.'),
          ),
        ),
        DocExample(
          title: 'Inline text elements',
          description: 'BsMark highlights a run of text with a yellow background; BsAnchor renders tappable link-styled text.',
          code: '''
Text.rich(
  TextSpan(
    children: [
      TextSpan(text: 'You can use the mark tag to '),
      WidgetSpan(child: BsMark(child: Text('highlight')), alignment: PlaceholderAlignment.middle),
      TextSpan(text: ' text.'),
    ],
  ),
)
BsAnchor(onTap: () {}, child: Text('This is a link'))''',
          preview: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: 'You can use the mark tag to '),
                    WidgetSpan(
                      child: BsMark(child: Text('highlight')),
                      alignment: PlaceholderAlignment.middle,
                    ),
                    TextSpan(text: ' text.'),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              BsAnchor(onTap: () {}, child: const Text('This is a link')),
            ],
          ),
        ),
        const DocExample(
          title: 'Blockquote',
          description: 'BsBlockquote indents its child and pairs it with an optional BsBlockquoteFooter attributing the source.',
          code: '''
BsBlockquote(
  footer: BsBlockquoteFooter(child: Text('Someone famous in Source Title')),
  child: Text('A well-known quote, contained in a blockquote element.'),
)''',
          preview: BsBlockquote(
            footer: BsBlockquoteFooter(child: Text('Someone famous in Source Title')),
            child: Text('A well-known quote, contained in a blockquote element.'),
          ),
        ),
        DocExample(
          title: 'Code',
          description: 'BsCode, BsKbd, and BsPre style inline code, keyboard input, and preformatted blocks with a monospace font.',
          code: '''
BsCode(child: Text('<html></html>'))
BsKbd(child: Text('Ctrl+C'))
BsPre(child: Text('.someClass {\\n  color: red;\\n}'))''',
          preview: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BsCode(child: Text('<html></html>')),
              SizedBox(height: 8),
              BsKbd(child: Text('Ctrl+C')),
              SizedBox(height: 8),
              BsPre(child: Text('.someClass {\n  color: red;\n}')),
            ],
          ),
        ),
      ],
    );
  }
}
