import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'demo_page.dart';

class TypographyPage extends StatelessWidget {
  const TypographyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Typography',
      children: [
        DemoSection(
          title: 'Headings',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final level in BsHeadingLevel.values)
                BsHeading(
                  level,
                  child: Text('${level.name.toUpperCase()}. Bootstrap heading'),
                ),
            ],
          ),
        ),
        DemoSection(
          title: 'Display headings',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final level in BsDisplayLevel.values)
                BsDisplayHeading(
                  level,
                  child: Text('Display ${level.name.substring(1)}'),
                ),
            ],
          ),
        ),
        const DemoSection(
          title: 'Lead',
          child: BsLead(
            child: Text(
              'This is a lead paragraph. It stands out from regular paragraphs.',
            ),
          ),
        ),
        DemoSection(
          title: 'Inline text elements',
          child: Column(
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
        const DemoSection(
          title: 'Blockquote',
          child: BsBlockquote(
            footer: BsBlockquoteFooter(
              child: Text('Someone famous in Source Title'),
            ),
            child: Text(
              'A well-known quote, contained in a blockquote element.',
            ),
          ),
        ),
        DemoSection(
          title: 'Code',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BsCode(child: Text('<html></html>')),
              const SizedBox(height: 8),
              const BsKbd(child: Text('Ctrl+C')),
              const SizedBox(height: 8),
              const BsPre(child: Text('.someClass {\n  color: red;\n}')),
            ],
          ),
        ),
      ],
    );
  }
}
