import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

class UtilitiesPage extends StatelessWidget {
  const UtilitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Utilities',
      lead:
          "BsBox is an element with Bootstrap's utility classes on it. Its props are the classes' own names — "
          'm/p with x, y, t, e, b, s for spacing (BsSpacing.s0 to s5, or auto), border-*, bg-*, text-bg-*, '
          'text-*, fs-*, rounded-*, text-start/center/end and w-* — so a class list reads straight across.',
      examples: [
        DocExample(
          title: 'Spacing: m-*, p-*',
          description:
              'Where props overlap the most specific wins, as in the CSS: pt over py over p. Spacing, fs, '
              'textAlign and w take a BsResponsive, so mb-3 mb-md-0 is '
              'mb: BsResponsiveValue(xs: BsSpacing.s3, md: BsSpacing.s0).',
          code: '''
BsBox(
  p: BsSpacing.s1,
  pt: BsSpacing.s4,
  mb: BsSpacing.s3,
  bg: BsBg.bodySecondary,
  child: Text('p-1 pt-4 mb-3'),
)''',
          preview: const BsBox(
            p: BsSpacing.s1,
            pt: BsSpacing.s4,
            mb: BsSpacing.s3,
            bg: BsBg.bodySecondary,
            child: Text('p-1 pt-4 mb-3'),
          ),
        ),
        DocExample(
          title: 'Borders: border, border-bottom, rounded-*',
          description:
              'A border adds to the box\'s size, as in CSS, and rounded takes BsRounded.r0…r5, circle or pill.',
          code: '''
BsBox(
  p: BsSpacing.s3,
  border: true,
  rounded: BsRounded.r3,
  child: Text('border rounded-3'),
)''',
          preview: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              BsBox(
                p: BsSpacing.s3,
                mb: BsSpacing.s3,
                border: true,
                rounded: BsRounded.r3,
                child: Text('border rounded-3'),
              ),
              BsBox(p: BsSpacing.s3, borderBottom: true, child: Text('border-bottom')),
            ],
          ),
        ),
        DocExample(
          title: 'Colors: bg-*, text-bg-*, text-*',
          description:
              'textBg gives a variant background with a contrasting text color; bg and textColor set each alone.',
          code: '''
BsBox(p: BsSpacing.s3, textBg: BsVariant.dark, child: Text('text-bg-dark'))
BsBox(p: BsSpacing.s3, bg: BsBg.bodyTertiary, textColor: BsTextColor.secondary, child: Text('bg-body-tertiary text-secondary'))''',
          preview: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              BsBox(p: BsSpacing.s3, mb: BsSpacing.s2, textBg: BsVariant.dark, child: Text('text-bg-dark')),
              BsBox(
                p: BsSpacing.s3,
                bg: BsBg.bodyTertiary,
                textColor: BsTextColor.secondary,
                child: Text('bg-body-tertiary text-secondary'),
              ),
            ],
          ),
        ),
        DocExample(
          title: 'Font size: fs-1 to fs-6',
          description:
              'The larger sizes scale with the window below the xl breakpoint (calc(1.275rem + .3vw) for fs-4) and '
              'are fixed from xl up.',
          code: "BsBox(fs: BsFs.fs4, child: Text('fs-4'))",
          preview: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [for (final fs in BsFs.values) BsBox(fs: fs, child: Text('fs-${fs.className}'))],
          ),
        ),
        DocExample(
          title: 'Alignment and width: text-end, w-50',
          code: '''
BsBox(textAlign: BsTextAlign.end, child: Text('text-end'))
BsBox(w: BsWidth.w50, bg: BsBg.bodySecondary, child: Text('w-50'))''',
          preview: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              BsBox(textAlign: BsTextAlign.end, mb: BsSpacing.s2, child: Text('text-end')),
              BsBox(w: BsWidth.w50, bg: BsBg.bodySecondary, p: BsSpacing.s2, child: Text('w-50')),
            ],
          ),
        ),
      ],
    );
  }
}
