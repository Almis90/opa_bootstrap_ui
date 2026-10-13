import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_content.dart';
import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

/// "Utilities for layout": what replaces the display, flex, spacing and
/// visibility utilities, and where each one is documented.
class UtilitiesPage extends StatelessWidget {
  const UtilitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      leadGap: 0,
      title: 'Utilities for layout',
      lead:
          'For faster mobile-friendly and responsive development, the '
          'library has props for showing, hiding, aligning and spacing '
          'content, that read like the utility classes of Bootstrap.',
      children: [
        const DocHeading('Changing display'),
        DocText([
          'Bootstrap has display utilities for responsively toggling common '
              'values of the ',
          DocCode('display'),
          ' property, such as ',
          DocCode('d-none d-md-block'),
          ', to show or hide content across specific viewports. There are no '
              'such classes here, and no ',
          DocCode('display'),
          ' to set: a widget either takes part in the layout or it does '
              'not. To show or hide something at a breakpoint, build it or '
              'leave it out, by reading the breakpoint (see ',
          DocLink.page('Breakpoints', 'Layout', 'Breakpoints'),
          ').',
        ]),
        DocExample(
          code: '''
@override
Widget build(BuildContext context) {
  final breakpoint = BsBreakpoint.forWidth(MediaQuery.sizeOf(context).width);
  final md = breakpoint.index >= BsBreakpoint.md.index;

  return Column(
    children: [
      // d-md-none
      if (!md) BsAlert(variant: BsVariant.info, child: Text('Below md')),
      // d-none d-md-block
      if (md) BsAlert(variant: BsVariant.success, child: Text('md and up')),
    ],
  );
}''',
          preview: const _DisplayFromMd(),
        ),
        const DocHeading('Flexbox options'),
        DocText([
          'Bootstrap is built with flexbox, but not every element has had '
              'its ',
          DocCode('display'),
          ' changed to ',
          DocCode('flex'),
          ', and you add ',
          DocCode('.d-flex'),
          ' when you need the flexbox utilities. In Flutter the layout '
              'widgets are what lay content out, so there is nothing to '
              'switch on. ',
          DocCode('BsFlex'),
          ' is the flexbox container, ',
          DocCode('d-flex'),
          ' and ',
          DocCode('d-inline-flex'),
          ' with ',
          DocCode('inline: true'),
          ', and it takes the sizing, alignment, spacing and direction props '
              'of the ',
          DocLink.page('flex utilities', 'Utilities', 'Flex'),
          '. The grid builds on it: ',
          DocCode('BsRow'),
          ' is a wrapping ',
          DocCode('BsFlex'),
          '.',
        ]),
        const DocHeading('Margin and padding'),
        DocText([
          'Use the margin and padding props of ',
          DocCode('BsBox'),
          ' to control how elements and components are spaced and sized. '
              'There is a six-level scale, ',
          DocCode('BsSpacing.s0'),
          ' to ',
          DocCode('BsSpacing.s5'),
          ', based on a base spacing of 16 logical pixels (see ',
          DocLink.page('Spacing', 'Utilities', 'Spacing'),
          '). Choose a value for all viewports, such as ',
          DocCode('me: BsSpacing.s3'),
          ' for ',
          DocCode('.me-3'),
          ', or a responsive one to target specific viewports, such as ',
          DocCode('me: BsResponsiveValue(md: BsSpacing.s3)'),
          ' for ',
          DocCode('.me-md-3'),
          ': the end margin from the ',
          DocCode('md'),
          ' breakpoint up. The end is the right in a left-to-right layout and '
              'the left in a right-to-left one.',
        ]),
        DocExample(
          code: '''
BsBox(
  p: BsSpacing.s1,
  pt: BsSpacing.s4,
  mb: BsResponsiveValue(xs: BsSpacing.s3, md: BsSpacing.s0),
  bg: BsBg.bodySecondary,
  child: Text('p-1 pt-4 mb-3 mb-md-0'),
)''',
          preview: const BsBox(
            p: BsSpacing.s1,
            pt: BsSpacing.s4,
            mb: BsResponsiveValue(xs: BsSpacing.s3, md: BsSpacing.s0),
            bg: BsBg.bodySecondary,
            child: Text('p-1 pt-4 mb-3 mb-md-0'),
          ),
        ),
        DocText([
          'Where the props overlap, the most specific wins, as it does in '
              'the CSS: ',
          DocCode('pt'),
          ' over ',
          DocCode('py'),
          ' over ',
          DocCode('p'),
          '.',
        ]),
        const DocHeading('Toggle visibility'),
        DocText([
          'When leaving a widget out is not what you want, because the '
              'layout should keep its place, the counterpart of ',
          DocCode('.invisible'),
          ' is a Flutter ',
          DocCode('Visibility'),
          ' that maintains the size, state and animations. An invisible '
              'widget still affects the layout of the page, but is hidden '
              'from visitors, and, as long as you leave ',
          DocCode('maintainInteractivity'),
          ' and ',
          DocCode('maintainSemantics'),
          ' off, it cannot be tapped and screen readers skip it. Do not use ',
          DocCode('Visibility.maintain'),
          ' for this: it keeps both on.',
        ]),
        DocExample(
          code: '''
BsFlex(
  gap: BsSpacing.s2,
  children: [
    BsBox(p: BsSpacing.s3, bg: BsBg.bodySecondary, child: Text('Visible')),
    Visibility(
      visible: false,
      maintainState: true,
      maintainAnimation: true,
      maintainSize: true,
      child: BsBox(
        p: BsSpacing.s3,
        bg: BsBg.bodySecondary,
        child: Text('Invisible'),
      ),
    ),
    BsBox(p: BsSpacing.s3, bg: BsBg.bodySecondary, child: Text('Visible')),
  ],
)''',
          preview: const BsFlex(
            gap: BsSpacing.s2,
            children: [
              BsBox(
                p: BsSpacing.s3,
                bg: BsBg.bodySecondary,
                child: Text('Visible'),
              ),
              Visibility(
                visible: false,
                maintainState: true,
                maintainAnimation: true,
                maintainSize: true,
                child: BsBox(
                  p: BsSpacing.s3,
                  bg: BsBg.bodySecondary,
                  child: Text('Invisible'),
                ),
              ),
              BsBox(
                p: BsSpacing.s3,
                bg: BsBg.bodySecondary,
                child: Text('Visible'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DisplayFromMd extends StatelessWidget {
  const _DisplayFromMd();

  @override
  Widget build(BuildContext context) {
    final breakpoint = BsBreakpoint.forWidth(MediaQuery.sizeOf(context).width);
    final md = breakpoint.index >= BsBreakpoint.md.index;

    return Column(
      children: [
        if (!md)
          const BsAlert(variant: BsVariant.info, child: Text('Below md')),
        if (md)
          const BsAlert(variant: BsVariant.success, child: Text('md and up')),
      ],
    );
  }
}
