import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_content.dart';
import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

const _fill = Color(0x26702CF9);
const _line = Color(0x4D702CF9);

/// A column whose content is tinted, so that the gutter around it is the
/// empty space, as in Bootstrap's gutter examples.
Widget _column(String label, {BsResponsive<BsCol>? col, double padding = 16}) {
  return BsFlexItem(
    col: col,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: _fill,
        border: Border.all(color: _line),
      ),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Text(label, textAlign: TextAlign.center),
      ),
    ),
  );
}

/// "Gutters": the `g`, `gx` and `gy` of a `BsRow`.
class GuttersPage extends StatelessWidget {
  const GuttersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      leadGap: 0,
      title: 'Gutters',
      lead:
          'Gutters are the padding between your columns, used to '
          'responsively space and align content in the grid system.',
      children: [
        const DocHeading('How they work'),
        DocList([
          DocListItem([
            DocBold(
              'Gutters are the gaps between column content, created by '
              'horizontal padding.',
            ),
            ' Every ',
            DocCode('BsFlexItem'),
            ' in a ',
            DocCode('BsRow'),
            ' is padded by half the gutter on each side, and the row is '
                'pulled out by the same half on its start and end, so that '
                'the content of the first and last columns lines up with the '
                'content around the row. The same goes for the vertical '
                'gutter, which spaces the lines when the columns wrap.',
          ]),
          DocListItem([
            DocBold('Gutters start at 24 logical pixels wide.'),
            ' That is ',
            DocCode('BsSpacing.s4'),
            ', for the horizontal gutter, which allows the grid to match '
                'the scale of the padding and margin of ',
            DocCode('BsBox'),
            '. The vertical gutter starts at none.',
          ]),
          DocListItem([
            DocBold('Gutters can be responsively adjusted.'),
            ' Use ',
            DocCode('g'),
            ', ',
            DocCode('gx'),
            ' and ',
            DocCode('gy'),
            ' of the row with a ',
            DocCode('BsResponsiveValue'),
            ' to modify the horizontal gutters, the vertical gutters or '
                'both, at the breakpoints you choose.',
          ]),
        ]),
        DocText([
          'In the previews below, the tinted boxes are the content of the '
              'columns, so that the gutters are the space between them. This '
              'is not the tint of the ',
          DocLink.page('Grid system', 'Layout', 'Grid'),
          ' page, which shows the gutters inside the columns.',
        ]),
        const DocHeading('Horizontal gutters'),
        DocText([
          DocCode('gx'),
          ' controls the horizontal gutter width. The row reaches half a '
              'gutter past its parent, on each side, as in Bootstrap. The '
              'padding of 12 pixels of a container takes the default gutter '
              'of 24 exactly, but a wider gutter makes the row reach past '
              'the container itself, and into whatever is around it. The '
              'container may need more padding to match, with ',
          DocCode('px'),
          '. For example, in the following example the padding is increased '
              'to ',
          DocCode('BsSpacing.s4'),
          ':',
        ]),
        DocExample(
          code: '''
BsContainer(
  px: BsSpacing.s4,
  child: BsRow(
    gx: BsSpacing.s5,
    children: [
      BsFlexItem(
        col: BsCol.equal,
        child: BsBox(p: BsSpacing.s3, child: Text('Custom column padding')),
      ),
      BsFlexItem(
        col: BsCol.equal,
        child: BsBox(p: BsSpacing.s3, child: Text('Custom column padding')),
      ),
    ],
  ),
)''',
          preview: BsContainer(
            px: BsSpacing.s4,
            child: BsRow(
              gx: BsSpacing.s5,
              children: [
                _column('Custom column padding', col: BsCol.equal),
                _column('Custom column padding', col: BsCol.equal),
              ],
            ),
          ),
        ),
        DocText([
          'An alternative solution is to clip the row with a wrapper, ',
          DocCode('BsBox(overflowHidden: true)'),
          ', so that the part of it that is past the edge is not painted. '
              'Only the empty gutter is cut: the content of the columns is '
              'inside the box.',
        ]),
        DocExample(
          code: '''
BsContainer(
  child: BsBox(
    overflowHidden: true,
    child: BsRow(
      gx: BsSpacing.s5,
      children: [
        BsFlexItem(
          col: BsCol.equal,
          child: BsBox(p: BsSpacing.s3, child: Text('Custom column padding')),
        ),
        BsFlexItem(
          col: BsCol.equal,
          child: BsBox(p: BsSpacing.s3, child: Text('Custom column padding')),
        ),
      ],
    ),
  ),
)''',
          preview: BsContainer(
            child: BsBox(
              overflowHidden: true,
              child: BsRow(
                gx: BsSpacing.s5,
                children: [
                  _column('Custom column padding', col: BsCol.equal),
                  _column('Custom column padding', col: BsCol.equal),
                ],
              ),
            ),
          ),
        ),
        const DocHeading('Vertical gutters'),
        DocText([
          DocCode('gy'),
          ' controls the vertical gutter width within a row, when columns '
              'wrap to new lines. It is the space between the lines: the first '
              'one is not pushed down by it, since the row takes the same '
              'amount off its top.',
        ]),
        DocExample(
          code: '''
BsContainer(
  child: BsRow(
    gy: BsSpacing.s5,
    children: [
      BsFlexItem(col: BsCol(6), child: Text('Custom column padding')),
      BsFlexItem(col: BsCol(6), child: Text('Custom column padding')),
      BsFlexItem(col: BsCol(6), child: Text('Custom column padding')),
      BsFlexItem(col: BsCol(6), child: Text('Custom column padding')),
    ],
  ),
)''',
          preview: BsContainer(
            child: BsRow(
              gy: BsSpacing.s5,
              children: [
                _column('Custom column padding', col: const BsCol(6)),
                _column('Custom column padding', col: const BsCol(6)),
                _column('Custom column padding', col: const BsCol(6)),
                _column('Custom column padding', col: const BsCol(6)),
              ],
            ),
          ),
        ),
        const DocHeading('Horizontal & vertical gutters'),
        DocText([
          DocCode('g'),
          ' controls both the horizontal and the vertical grid gutters. ',
          DocCode('gx'),
          ' and ',
          DocCode('gy'),
          ' win over it, for the axis that they set. In the example below '
              'the gutter is smaller than the padding of the container, so '
              'it needs no wrapper.',
        ]),
        DocExample(
          code: '''
BsContainer(
  child: BsRow(
    g: BsSpacing.s2,
    children: [
      BsFlexItem(col: BsCol(6), child: Text('Custom column padding')),
      BsFlexItem(col: BsCol(6), child: Text('Custom column padding')),
      BsFlexItem(col: BsCol(6), child: Text('Custom column padding')),
      BsFlexItem(col: BsCol(6), child: Text('Custom column padding')),
    ],
  ),
)''',
          preview: BsContainer(
            child: BsRow(
              g: BsSpacing.s2,
              children: [
                _column('Custom column padding', col: const BsCol(6)),
                _column('Custom column padding', col: const BsCol(6)),
                _column('Custom column padding', col: const BsCol(6)),
                _column('Custom column padding', col: const BsCol(6)),
              ],
            ),
          ),
        ),
        const DocHeading('Row columns gutters'),
        DocText([
          'Gutters go along with ',
          DocLink.page('row columns', 'Layout', 'Grid'),
          ' too. In the following example, the row has responsive row '
              'columns and responsive gutters: two columns to a line and a '
              'gutter of 8 pixels, and five columns and 16 pixels from ',
          DocCode('lg'),
          '.',
        ]),
        DocExample(
          code: '''
BsContainer(
  child: BsRow(
    rowCols: BsResponsiveValue(xs: 2, lg: 5),
    g: BsResponsiveValue(xs: BsSpacing.s2, lg: BsSpacing.s3),
    children: [
      for (var i = 0; i < 10; i++)
        BsFlexItem(child: Text('Row column')),
    ],
  ),
)''',
          preview: BsContainer(
            child: BsRow(
              rowCols: const BsResponsiveValue(xs: 2, lg: 5),
              g: const BsResponsiveValue(xs: BsSpacing.s2, lg: BsSpacing.s3),
              children: [for (var i = 0; i < 10; i++) _column('Row column')],
            ),
          ),
        ),
        const DocHeading('No gutters'),
        DocText([
          'The gutters between columns can be removed with ',
          DocCode('g: BsSpacing.s0'),
          '. It takes the negative margin off the row and the horizontal '
              'padding off all of its children. You can use it along with '
              'all the other props of the grid: column widths, responsive '
              'tiers, order and more.',
        ]),
        DocText([
          DocBold('Need an edge-to-edge design?'),
          ' Drop the parent ',
          DocCode('BsContainer'),
          ' and set ',
          DocCode('g: BsSpacing.s0'),
          ' on the row, so that it does not extend past the window. Bootstrap '
              'also needs ',
          DocCode('.mx-0'),
          ' on the row for this. Here the zero gutter takes the negative '
              'margin off already.',
        ]),
        DocExample(
          code: '''
BsRow(
  g: BsSpacing.s0,
  children: [
    BsFlexItem(
      col: BsResponsiveValue(sm: BsCol(6), md: BsCol(8)),
      child: Text('.col-sm-6 .col-md-8'),
    ),
    BsFlexItem(
      col: BsResponsiveValue(xs: BsCol(6), md: BsCol(4)),
      child: Text('.col-6 .col-md-4'),
    ),
  ],
)''',
          preview: BsRow(
            g: BsSpacing.s0,
            children: [
              _column(
                '.col-sm-6 .col-md-8',
                col: const BsResponsiveValue(sm: BsCol(6), md: BsCol(8)),
                padding: 12,
              ),
              _column(
                '.col-6 .col-md-4',
                col: const BsResponsiveValue(xs: BsCol(6), md: BsCol(4)),
                padding: 12,
              ),
            ],
          ),
        ),
        DocText([
          'A single column can lose its padding on its own: ',
          DocCode('p: BsSpacing.s0'),
          ' on the ',
          DocCode('BsFlexItem'),
          ' takes the gutter off that column only, and ',
          DocCode('px'),
          ' puts a different one on it.',
        ]),
        const DocHeading('Change the gutters'),
        DocText([
          'Bootstrap builds the gutter classes from a ',
          DocCode(r'$gutters'),
          ' Sass map, which is inherited from the spacers. The values of ',
          DocCode('g'),
          ', ',
          DocCode('gx'),
          ' and ',
          DocCode('gy'),
          ' are the ',
          DocCode('BsSpacing'),
          ' steps, which are the same:',
        ]),
        DocTable(
          headers: ['Step', 'Class suffix', 'Size'],
          rows: [
            for (final step in BsSpacing.values)
              if (step != BsSpacing.auto)
                [
                  'BsSpacing.${step.name}',
                  step.className,
                  '${step.size.toStringAsFixed(0)}px',
                ],
          ],
        ),
        DocText([
          'The scale is an enum, so there is no way to add a step to it or '
              'to change one, and ',
          DocCode(r'$grid-gutter-width'),
          ' is the 24 pixels of ',
          DocCode('BsSpacing.s4'),
          ', which is where a row starts. For a gutter that is not on the '
              'scale, use the Flutter ',
          DocCode('Wrap'),
          ', whose ',
          DocCode('spacing'),
          ' and ',
          DocCode('runSpacing'),
          ' take any number of pixels. See ',
          DocLink.page('Customize', 'Customize', 'Options'),
          ' for what can be changed and what cannot.',
        ]),
      ],
    );
  }
}
