import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_content.dart';
import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

const _columns = BsResponsiveValue<String>(
  xs: '1 column',
  md: '3 columns',
  xl: '6 columns',
);

/// "Breakpoints": the six viewport widths, and how to build on them.
class BreakpointsPage extends StatelessWidget {
  const BreakpointsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      leadGap: 0,
      title: 'Breakpoints',
      lead:
          'Breakpoints are customizable widths that determine how your '
          'responsive layout behaves across device or viewport sizes in '
          'opa_bootstrap_ui.',
      children: [
        const DocHeading('Core concepts'),
        DocList([
          DocListItem([
            DocBold(
              'Breakpoints are the building blocks of responsive design.',
            ),
            ' Use them to control when your layout can be adapted at a '
                'particular viewport or device size.',
          ]),
          DocListItem([
            DocBold(
              'Use the width of the window to architect your layout '
              'by breakpoint.',
            ),
            ' Where CSS has media queries, Flutter has ',
            DocCode('MediaQuery'),
            ': the library reads ',
            DocCode('MediaQuery.sizeOf(context).width'),
            ', which is the width of the viewport, and turns it into a '
                'breakpoint with ',
            DocCode('BsBreakpoint.forWidth'),
            '.',
          ]),
          DocListItem([
            DocBold('Mobile first, responsive design is the goal.'),
            ' A value that you give for a breakpoint applies at that '
                'breakpoint and at every larger one, until a larger '
                'breakpoint has a value of its own. Start with the layout '
                'for the smallest screen, and adjust it for the bigger ones.',
          ]),
        ]),
        const DocHeading('Available breakpoints'),
        DocText([
          'There are six breakpoints, sometimes referred to as ',
          DocCode('grid tiers'),
          ', in the ',
          DocCode('BsBreakpoint'),
          ' enum. Their widths are Bootstrap\'s, in logical pixels, and each '
              'one was chosen to comfortably hold containers whose widths are '
              'multiples of 12.',
        ]),
        DocTable(
          headers: ['Breakpoint', 'Class infix', 'BsBreakpoint', 'Dimensions'],
          rows: [
            ['Extra small', 'None', 'BsBreakpoint.xs', '<576'],
            ['Small', 'sm', 'BsBreakpoint.sm', '≥576'],
            ['Medium', 'md', 'BsBreakpoint.md', '≥768'],
            ['Large', 'lg', 'BsBreakpoint.lg', '≥992'],
            ['Extra large', 'xl', 'BsBreakpoint.xl', '≥1200'],
            ['Extra extra large', 'xxl', 'BsBreakpoint.xxl', '≥1400'],
          ],
        ),
        DocText([
          'Each value has a ',
          DocCode('minWidth'),
          ' that is the width at which it begins, and ',
          DocCode('BsBreakpoint.values'),
          ' lists them from the smallest to the largest. They are not '
              'configurable, unlike the Sass map of Bootstrap: an enum is '
              'closed, and the library reads it everywhere. See ',
          DocLink.page('Tokens', 'Customize', 'Tokens'),
          ' for what you can change.',
        ]),
        DocText([
          'Look at the width of the window to see the one that applies to '
              'it. Resize the window of your browser, and the value changes '
              'where the table says it should.',
        ]),
        const DocExample(
          title: 'The current breakpoint',
          description:
              'BsBreakpoint.forWidth returns the largest breakpoint whose '
              'minWidth is not greater than the width.',
          code: '''
final width = MediaQuery.sizeOf(context).width;
final breakpoint = BsBreakpoint.forWidth(width);

Text('\${breakpoint.name}: \$width wide, from \${breakpoint.minWidth}')''',
          preview: _CurrentBreakpoint(),
        ),
        const DocHeading('Viewport, not container'),
        DocText([
          'Like a media query, the library looks at the whole window and '
              'not at the space its widget is given. A ',
          DocCode('BsContainer'),
          ' in a narrow sidebar of a wide window picks the container width of '
              'the window. To lay something out by the space it has, '
              'use a ',
          DocCode('LayoutBuilder'),
          ' and give the width of its constraints to ',
          DocCode('BsBreakpoint.forWidth'),
          '.',
        ]),
        const DocCodeSnippet('''
LayoutBuilder(
  builder: (context, constraints) {
    final breakpoint = BsBreakpoint.forWidth(constraints.maxWidth);
    return breakpoint.index >= BsBreakpoint.md.index
        ? const WideLayout()
        : const NarrowLayout();
  },
)'''),
        const DocHeading('Comparing breakpoints'),
        DocText([
          'Bootstrap\'s Sass mixins for media queries become comparisons in '
              'Dart, since the enum has an order and a width.',
        ]),
        const DocHeading('Min-width', sub: true),
        DocText([
          'Most of the layout is built from the minimum width: this '
              'breakpoint and the larger ones. No comparison is needed for ',
          DocCode('xs'),
          ', as it is true at every width.',
        ]),
        DocTable(
          headers: ['Bootstrap', 'opa_bootstrap_ui'],
          rows: [
            [
              '@include media-breakpoint-up(md)',
              'width >= BsBreakpoint.md.minWidth',
            ],
            [
              '@media (min-width: 768px)',
              'MediaQuery.sizeOf(context).width >= 768',
            ],
          ],
        ),
        const DocHeading('Max-width', sub: true),
        DocText([
          'Occasionally you want the other direction: the given screen size ',
          DocBold('or smaller'),
          '. Bootstrap\'s ',
          DocCode('media-breakpoint-down(md)'),
          ' is the widths below ',
          DocCode('md'),
          ', which is to say less than 768. Bootstrap subtracts .02px to '
              'keep the two ranges apart; with a strict comparison you do '
              'not have to.',
        ]),
        DocTable(
          headers: ['Bootstrap', 'opa_bootstrap_ui'],
          rows: [
            [
              '@include media-breakpoint-down(md)',
              'width < BsBreakpoint.md.minWidth',
            ],
            [
              '@include media-breakpoint-down(xxl)',
              'always true: there is no larger breakpoint',
            ],
          ],
        ),
        const DocHeading('Single breakpoint', sub: true),
        DocText([
          'To target one segment, compare the breakpoint for the width '
              'with the one you want: ',
          DocCode('media-breakpoint-only(md)'),
          ' is from 768 up to, but not including, 992.',
        ]),
        const DocCodeSnippet('''
final breakpoint = BsBreakpoint.forWidth(MediaQuery.sizeOf(context).width);

if (breakpoint == BsBreakpoint.md) {
  // 768 <= width < 992
}'''),
        const DocHeading('Between breakpoints', sub: true),
        DocText([
          'Similarly, a range spans several. The counterpart of ',
          DocCode('media-breakpoint-between(md, xl)'),
          ', from medium devices up to, and including, extra large ones, '
              'is from ',
          DocCode('md'),
          ' up to but not including ',
          DocCode('xxl'),
          ':',
        ]),
        const DocCodeSnippet('''
final width = MediaQuery.sizeOf(context).width;

if (width >= BsBreakpoint.md.minWidth && width < BsBreakpoint.xxl.minWidth) {
  // 768 <= width < 1400
}'''),
        const DocHeading('Values that depend on the breakpoint'),
        DocText([
          'Comparing is the lowest level. When a value should differ per '
              'breakpoint, use a ',
          DocCode('BsResponsiveValue'),
          ': it holds up to six values, one per breakpoint, and resolves the '
              'one that applies, cascading mobile first. A breakpoint '
              'without a value takes the nearest smaller one, and ',
          DocCode('resolve'),
          ' returns ',
          DocCode('null'),
          ' if there is none.',
        ]),
        const DocCodeSnippet('''
const columns = BsResponsiveValue<String>(
  xs: '1 column',
  md: '3 columns',
  xl: '6 columns',
);

columns.resolve(BsBreakpoint.lg); // 3 columns
columns.resolveForWidth(1500); // 6 columns'''),
        const _Cascade(),
        DocText([
          'The props of the layout and utility widgets that depend on the '
              'breakpoint take a ',
          DocCode('BsResponsive'),
          ': either a plain value, which is the same at every breakpoint, or '
              'a ',
          DocCode('BsResponsiveValue'),
          '. So ',
          DocCode('mb-3 mb-md-0'),
          ' is ',
          DocCode('mb: BsResponsiveValue(xs: BsSpacing.s3, md: BsSpacing.s0)'),
          '. Each page names the props that accept it; see ',
          DocLink.page('Utilities', 'Layout', 'Utilities'),
          '.',
        ]),
        const DocExample(
          title: 'A responsive utility',
          description:
              'Centered text on small windows, aligned to the end from md.',
          code: '''
const BsBox(
  p: BsSpacing.s3,
  border: true,
  textAlign: BsResponsiveValue(
    xs: BsTextAlign.center,
    md: BsTextAlign.end,
  ),
  child: Text('text-center text-md-end'),
)''',
          preview: BsBox(
            p: BsSpacing.s3,
            border: true,
            textAlign: BsResponsiveValue(
              xs: BsTextAlign.center,
              md: BsTextAlign.end,
            ),
            child: Text('text-center text-md-end'),
          ),
        ),
        DocText([
          'The container widths that go with each breakpoint are on the ',
          DocLink.page('Containers', 'Layout', 'Containers'),
          ' page.',
        ]),
      ],
    );
  }
}

class _CurrentBreakpoint extends StatelessWidget {
  const _CurrentBreakpoint();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final breakpoint = BsBreakpoint.forWidth(width);
    return Text(
      '${breakpoint.name}: ${width.toStringAsFixed(0)} wide, from '
      '${breakpoint.minWidth.toStringAsFixed(0)}',
    );
  }
}

class _Cascade extends StatelessWidget {
  const _Cascade();

  @override
  Widget build(BuildContext context) {
    final current = BsBreakpoint.forWidth(MediaQuery.sizeOf(context).width);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DocTable(
        headers: const ['Breakpoint', 'Resolves to', ''],
        rows: [
          for (final breakpoint in BsBreakpoint.values)
            [
              breakpoint.name,
              _columns.resolve(breakpoint)!,
              breakpoint == current ? 'your window' : '',
            ],
        ],
      ),
    );
  }
}
