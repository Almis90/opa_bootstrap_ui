import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

class FlexPage extends StatelessWidget {
  const FlexPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Flex',
      lead:
          "BsFlex is Bootstrap's d-flex: a row laid out with CSS flexbox's own rules — wrapping, auto margins, "
          'col-* widths, justify-content and align-items. Its props carry the utility classes\' names, '
          'and anything that takes a BsResponsive (a plain value, or a BsResponsiveValue for the -md-/-lg- '
          'variants) is resolved against the window\'s breakpoint, as Bootstrap\'s media queries are.',
      examples: [
        DocExample(
          title: 'd-flex',
          description: 'Items sit side by side at their natural widths.',
          code: '''
BsFlex(
  children: [chip('One'), chip('Two'), chip('Three')],
)''',
          preview: BsFlex(alignItems: BsAlign.start, children: [_chip('One'), _chip('Two'), _chip('Three')]),
        ),
        DocExample(
          title: 'justify-content-*',
          description:
              'justifyContent places the items along the main axis: start, end, center, between, around, evenly.',
          code: '''
BsFlex(
  justifyContent: BsJustify.between,
  children: [chip('One'), chip('Two'), chip('Three')],
)''',
          preview: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final justify in BsJustify.values) ...[
                BsFlex(
                  justifyContent: justify,
                  alignItems: BsAlign.start,
                  children: [_chip('${justify.name}: One'), _chip('Two'), _chip('Three')],
                ),
                const SizedBox(height: 8),
              ],
            ],
          ),
        ),
        DocExample(
          title: 'align-items-*',
          description: 'alignItems places items across the line (stretch is the default, as in CSS).',
          code: '''
BsFlex(
  alignItems: BsAlign.center,
  children: [chip('Short'), tallChip('Tall')],
)''',
          preview: BsFlex(alignItems: BsAlign.center, children: [_chip('Short'), _chip('Tall', height: 64)]),
        ),
        DocExample(
          title: 'me-auto',
          description:
              'An auto margin on a BsFlexItem absorbs the free space on its side — here me: BsSpacing.auto pushes the '
              'last item to the end. Responsive variants take a BsResponsiveValue: me-md-auto is '
              'BsResponsiveValue(md: BsSpacing.auto).',
          code: '''
BsFlex(
  children: [
    BsFlexItem(me: BsSpacing.auto, child: chip('One')),
    chip('Two'),
  ],
)''',
          preview: BsFlex(
            alignItems: BsAlign.start,
            children: [
              BsFlexItem(me: BsSpacing.auto, child: _chip('One')),
              _chip('Two'),
            ],
          ),
        ),
        DocExample(
          title: 'flex-wrap and gap-*',
          description: 'wrap lets items break onto further lines; gap spaces both the items and the lines.',
          code: '''
BsFlex(
  wrap: true,
  gap: BsSpacing.s2,
  children: [for (var i = 1; i <= 12; i++) chip('Item \$i')],
)''',
          preview: BsFlex(
            wrap: true,
            alignItems: BsAlign.start,
            gap: BsSpacing.s2,
            children: [for (var i = 1; i <= 12; i++) _chip('Item $i')],
          ),
        ),
        DocExample(
          title: 'col-*',
          description:
              'BsCol(12) is col-12 — a whole line, so what follows wraps beneath it — and BsCol(3) is col-3 (a quarter '
              'of the width); BsCol.auto is col-auto. Used outside a .row, as Bootstrap\'s header examples do.',
          code: '''
BsFlex(
  wrap: true,
  children: [
    BsFlexItem(col: BsCol(12), child: chip('col-12')),
    BsFlexItem(col: BsCol(3), child: chip('col-3')),
    BsFlexItem(col: BsCol(9), child: chip('col-9')),
  ],
)''',
          preview: BsFlex(
            wrap: true,
            children: [
              BsFlexItem(col: const BsCol(12), child: _chip('col-12')),
              BsFlexItem(col: const BsCol(3), child: _chip('col-3')),
              BsFlexItem(col: const BsCol(9), child: _chip('col-9')),
            ],
          ),
        ),
        DocExample(
          title: 'Responsive: mb-3 mb-md-0, justify-content-lg-start',
          description: 'Resize the window: below md the items stack with a margin, from md up they share the line.',
          code: '''
BsFlex(
  wrap: true,
  justifyContent: BsResponsiveValue(xs: BsJustify.center, lg: BsJustify.start),
  children: [
    BsFlexItem(
      mb: BsResponsiveValue(xs: BsSpacing.s3, md: BsSpacing.s0),
      col: BsResponsiveValue(xs: BsCol(12), md: BsCol.auto),
      child: chip('Brand'),
    ),
    chip('Nav'),
  ],
)''',
          preview: BsFlex(
            wrap: true,
            alignItems: BsAlign.start,
            justifyContent: const BsResponsiveValue(xs: BsJustify.center, lg: BsJustify.start),
            children: [
              BsFlexItem(
                mb: const BsResponsiveValue(xs: BsSpacing.s3, md: BsSpacing.s0),
                col: const BsResponsiveValue(xs: BsCol(12), md: BsCol.auto),
                child: _chip('Brand'),
              ),
              _chip('Nav'),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _chip(String label, {double? height}) {
    return BsBox(
      bg: BsBg.bodySecondary,
      border: true,
      rounded: BsRounded.r2,
      px: BsSpacing.s3,
      py: BsSpacing.s2,
      child: SizedBox(
        height: height == null ? null : height - 18,
        child: Center(child: Text(label)),
      ),
    );
  }
}
