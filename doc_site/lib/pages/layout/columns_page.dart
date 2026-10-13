import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_content.dart';
import '../../src/doc_example.dart';
import '../../src/doc_grid.dart';
import '../../src/doc_page.dart';

/// "Columns": alignment, wrapping, breaks, ordering and offsets of the
/// columns of a `BsRow`, and `BsBox(col:)` outside of one.
class ColumnsPage extends StatelessWidget {
  const ColumnsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      leadGap: 0,
      title: 'Columns',
      lead:
          'Learn how to modify columns with a handful of options for '
          'alignment, ordering and offsetting, thanks to the flexbox grid '
          'system. Plus, see how to give any widget the width of a column.',
      children: [
        DocText([
          DocBold('Heads up!'),
          ' Be sure to read the ',
          DocLink.page('Grid system', 'Layout', 'Grid'),
          ' page first, before diving into how to modify and customize your '
              'grid columns.',
        ]),
        const DocHeading('How they work'),
        DocList([
          DocListItem([
            DocBold('Columns build on the grid\'s flexbox architecture.'),
            ' Flexbox means you have options for changing individual '
                'columns, with the props of ',
            DocCode('BsFlexItem'),
            ', and for modifying groups of columns at the row level, with '
                'the props of ',
            DocCode('BsRow'),
            ' (see ',
            DocLink.page('Row columns', 'Layout', 'Grid'),
            '). You choose how columns grow, shrink or otherwise change.',
          ]),
          DocListItem([
            DocBold('When building grid layouts, all content goes in columns.'),
            ' The hierarchy goes from ',
            DocCode('BsContainer'),
            ' to ',
            DocCode('BsRow'),
            ' to a column, which is a ',
            DocCode('BsFlexItem'),
            ', to your content. A ',
            DocCode('BsFlexItem'),
            ' has to be a direct child of the row, so do not wrap it in '
                'another widget.',
          ]),
          DocListItem([
            DocBold('There is a value for every width and every tier.'),
            ' With six breakpoints and twelve widths of ',
            DocCode('BsCol'),
            ', a column can have any of the layouts of Bootstrap\'s '
                'predefined classes, and a ',
            DocCode('BsResponsiveValue'),
            ' says which one at each tier.',
          ]),
        ]),
        const DocHeading('Alignment'),
        DocText([
          'Use the flexbox alignment props to vertically and horizontally '
              'align columns.',
        ]),
        const DocHeading('Vertical alignment', sub: true),
        DocText([
          'Change the vertical alignment with ',
          DocCode('alignItems'),
          ' on the row, which takes a ',
          DocCode('BsAlign'),
          ': ',
          DocCode('start'),
          ', ',
          DocCode('center'),
          ', ',
          DocCode('end'),
          ' or ',
          DocCode('stretch'),
          ', the default. It places the columns within the height of their '
              'line, which is the height of the tallest column in it, so the '
              'examples below have one column that is taller than the rest. '
              'Like any prop of the grid, it can take a ',
          DocCode('BsResponsiveValue'),
          '.',
        ]),
        DocExample(
          code: '''
BsContainer(
  child: BsRow(
    alignItems: BsAlign.start,
    children: [
      BsFlexItem(
        col: BsCol.equal,
        child: SizedBox(height: 100, child: Text('Tall column')),
      ),
      BsFlexItem(col: BsCol.equal, child: Text('Column')),
      BsFlexItem(col: BsCol.equal, child: Text('Column')),
    ],
  ),
)''',
          preview: _alignItems(BsAlign.start),
        ),
        DocExample(
          code: '''
BsRow(
  alignItems: BsAlign.center,
  children: [
    BsFlexItem(
      col: BsCol.equal,
      child: SizedBox(height: 100, child: Text('Tall column')),
    ),
    BsFlexItem(col: BsCol.equal, child: Text('Column')),
    BsFlexItem(col: BsCol.equal, child: Text('Column')),
  ],
)''',
          preview: _alignItems(BsAlign.center),
        ),
        DocExample(
          code: '''
BsRow(
  alignItems: BsAlign.end,
  children: [
    BsFlexItem(
      col: BsCol.equal,
      child: SizedBox(height: 100, child: Text('Tall column')),
    ),
    BsFlexItem(col: BsCol.equal, child: Text('Column')),
    BsFlexItem(col: BsCol.equal, child: Text('Column')),
  ],
)''',
          preview: _alignItems(BsAlign.end),
        ),
        DocText([
          'Or change the alignment of each column individually with ',
          DocCode('alignSelf'),
          ' on the ',
          DocCode('BsFlexItem'),
          ', which is also responsive.',
        ]),
        DocExample(
          code: '''
BsRow(
  children: [
    BsFlexItem(
      col: BsCol.equal,
      child: SizedBox(height: 100, child: Text('Tall column')),
    ),
    BsFlexItem(
      col: BsCol.equal,
      alignSelf: BsAlign.start,
      child: Text('Start'),
    ),
    BsFlexItem(
      col: BsCol.equal,
      alignSelf: BsAlign.center,
      child: Text('Center'),
    ),
    BsFlexItem(
      col: BsCol.equal,
      alignSelf: BsAlign.end,
      child: Text('End'),
    ),
  ],
)''',
          preview: BsRow(
            children: [
              docCol('Tall column', col: BsCol.equal, height: 100),
              docCol('Start', col: BsCol.equal, alignSelf: BsAlign.start),
              docCol('Center', col: BsCol.equal, alignSelf: BsAlign.center),
              docCol('End', col: BsCol.equal, alignSelf: BsAlign.end),
            ],
          ),
        ),
        DocText([
          'A row is as high as its tallest column, so a column that is short '
              'has no room to move on its own. To make room, as the 75 pixel '
              'height that Bootstrap\'s examples give their rows does, put a ',
          DocCode('SizedBox'),
          ' with a ',
          DocCode('height'),
          ' around the content of one of the columns, as the examples do.',
        ]),
        const DocHeading('Horizontal alignment', sub: true),
        DocText([
          'Change the horizontal alignment with ',
          DocCode('justifyContent'),
          ' on the row, which takes a ',
          DocCode('BsJustify'),
          ': ',
          DocCode('start'),
          ', ',
          DocCode('center'),
          ', ',
          DocCode('end'),
          ', ',
          DocCode('around'),
          ', ',
          DocCode('between'),
          ' or ',
          DocCode('evenly'),
          '. The columns below take up a third of the row each, so that '
              'there is space to distribute.',
        ]),
        for (final justify in BsJustify.values)
          DocExample(
            code:
                '''
BsRow(
  justifyContent: BsJustify.${justify.name},
  children: [
    BsFlexItem(col: BsCol(4), child: Text('One of two columns')),
    BsFlexItem(col: BsCol(4), child: Text('One of two columns')),
  ],
)''',
            preview: BsRow(
              justifyContent: justify,
              children: [
                docCol('One of two columns', col: const BsCol(4)),
                docCol('One of two columns', col: const BsCol(4)),
              ],
            ),
          ),
        const DocHeading('Column wrapping', sub: true),
        DocText([
          'If more than 12 columns are placed within a single row, each '
              'group of extra columns will, as one unit, wrap onto a new '
              'line.',
        ]),
        DocExample(
          code: '''
BsRow(
  children: [
    BsFlexItem(col: BsCol(9), child: Text('col-9')),
    BsFlexItem(
      col: BsCol(4),
      child: Text('col-4 — since 9 + 4 = 13 > 12, this 4-column-wide '
          'column gets wrapped onto a new line as one contiguous unit.'),
    ),
    BsFlexItem(
      col: BsCol(6),
      child: Text('col-6 — subsequent columns continue along the new line.'),
    ),
  ],
)''',
          preview: BsRow(
            children: [
              docCol('col-9', col: const BsCol(9)),
              docCol(
                'col-4 — since 9 + 4 = 13 > 12, this 4-column-wide column '
                'gets wrapped onto a new line as one contiguous unit.',
                col: const BsCol(4),
              ),
              docCol(
                'col-6 — subsequent columns continue along the new line.',
                col: const BsCol(6),
              ),
            ],
          ),
        ),
        const DocHeading('Column breaks', sub: true),
        DocText([
          'Breaking columns to a new line takes a small hack in flexbox: an '
              'element with a width of 100% wherever you want the columns to '
              'wrap. Normally this is accomplished with multiple rows, but '
              'not every implementation can account for this. A ',
          DocCode('BsFlexItem'),
          ' with no ',
          DocCode('col'),
          ' is as wide as the row, so an empty one without padding is the '
              'break.',
        ]),
        DocExample(
          code: '''
BsRow(
  children: [
    BsFlexItem(col: BsCol(6), child: Text('col-6')),
    BsFlexItem(col: BsCol(6), child: Text('col-6')),

    // Force next columns to break to new line
    BsFlexItem(p: BsSpacing.s0, child: SizedBox.shrink()),

    BsFlexItem(col: BsCol(6), child: Text('col-6')),
    BsFlexItem(col: BsCol(6), child: Text('col-6')),
  ],
)''',
          preview: BsRow(
            children: [
              docCol('col-6', col: const BsCol(6)),
              docCol('col-6', col: const BsCol(6)),
              const BsFlexItem(p: BsSpacing.s0, child: SizedBox.shrink()),
              docCol('col-6', col: const BsCol(6)),
              docCol('col-6', col: const BsCol(6)),
            ],
          ),
        ),
        DocText([
          'There are no responsive display utilities to hide the break at '
              'some of the breakpoints, as Bootstrap does with ',
          DocCode('d-none d-md-block'),
          '. Build the break only where you want it, by reading the '
              'breakpoint, as the ',
          DocLink.page('Breakpoints', 'Layout', 'Breakpoints'),
          ' page shows. Here the break is there from ',
          DocCode('md'),
          ' up, and the columns stay in a line below it. The window of this '
              'page is the one that is compared.',
        ]),
        DocExample(
          code: '''
@override
Widget build(BuildContext context) {
  final breakpoint = BsBreakpoint.forWidth(MediaQuery.sizeOf(context).width);
  final md = breakpoint.index >= BsBreakpoint.md.index;

  return BsRow(
    children: [
      BsFlexItem(col: BsCol(6), child: Text('col-6')),
      BsFlexItem(col: BsCol(6), child: Text('col-6')),

      // Force next columns to break to new line at md and up
      if (md) BsFlexItem(p: BsSpacing.s0, child: SizedBox.shrink()),

      BsFlexItem(col: BsCol(6), child: Text('col-6')),
      BsFlexItem(col: BsCol(6), child: Text('col-6')),
    ],
  );
}''',
          preview: const _BreakAtMd(),
        ),
        const DocHeading('Reordering'),
        const DocHeading('Order', sub: true),
        DocText([
          'There are no ',
          DocCode('order-*'),
          ' classes: the order of the children of a row is the order in '
              'which they are laid out, which is the order you would give '
              'them in the DOM anyway. Where Bootstrap would keep the markup '
              'and change the ',
          DocCode('order'),
          ', here you change the list, so ',
          DocCode('order-first'),
          ' is a column moved to the front and ',
          DocCode('order-last'),
          ' one moved to the back.',
        ]),
        DocExample(
          code: '''
BsRow(
  children: [
    BsFlexItem(col: BsCol.equal, child: Text('Third')),
    BsFlexItem(col: BsCol.equal, child: Text('Second')),
    BsFlexItem(col: BsCol.equal, child: Text('First')),
  ],
)''',
          preview: BsRow(
            children: [
              docCol('Third', col: BsCol.equal),
              docCol('Second', col: BsCol.equal),
              docCol('First', col: BsCol.equal),
            ],
          ),
        ),
        DocText([
          'The order can depend on the breakpoint, as ',
          DocCode('order-1 order-md-2'),
          ' does. The list is Dart, so read the breakpoint and build it in '
              'the order you want. Below ',
          DocCode('md'),
          ' the example puts "Third" ahead of the others.',
        ]),
        DocExample(
          code: '''
@override
Widget build(BuildContext context) {
  final breakpoint = BsBreakpoint.forWidth(MediaQuery.sizeOf(context).width);
  final small = breakpoint.index < BsBreakpoint.md.index;

  const first = BsFlexItem(col: BsCol.equal, child: Text('First'));
  const second = BsFlexItem(col: BsCol.equal, child: Text('Second'));
  const third = BsFlexItem(col: BsCol.equal, child: Text('Third'));

  return BsRow(
    children: small ? [third, first, second] : [first, second, third],
  );
}''',
          preview: const _ReorderBelowMd(),
        ),
        DocText([
          'To reverse the whole row there is ',
          DocCode('direction'),
          ': ',
          DocCode('BsFlexDirection.rowReverse'),
          ' lays the columns of each line out from the end, and ',
          DocCode('columnReverse'),
          ' stacks them from the bottom. The wrapping lines themselves keep '
              'their order.',
        ]),
        DocExample(
          code: '''
BsRow(
  direction: BsFlexDirection.rowReverse,
  children: [
    BsFlexItem(col: BsCol(4), child: Text('First')),
    BsFlexItem(col: BsCol(4), child: Text('Second')),
  ],
)''',
          preview: BsRow(
            direction: BsFlexDirection.rowReverse,
            children: [
              docCol('First', col: const BsCol(4)),
              docCol('Second', col: const BsCol(4)),
            ],
          ),
        ),
        const DocHeading('Offsetting columns', sub: true),
        DocText([
          'You can offset grid columns in two ways: the ',
          DocCode('offset'),
          ' of a ',
          DocCode('BsFlexItem'),
          ' and the margin props. An offset is sized to match columns, '
              'while margins are more useful for quick layouts where the '
              'width of the offset is variable.',
        ]),
        const DocHeading('Offsets', sub: true),
        DocText([
          'Move columns to the end with an ',
          DocCode('offset'),
          ': it increases the start margin of a column by that many '
              'columns. For example, ',
          DocCode('offset: BsResponsiveValue(md: BsCol(4))'),
          ' moves a ',
          DocCode('col: BsResponsiveValue(md: BsCol(4))'),
          ' over four columns. Like a ',
          DocCode('col'),
          ', it is responsive, and its value reaches up from the '
              'breakpoint that holds it.',
        ]),
        DocExample(
          code: '''
BsRow(
  children: [
    BsFlexItem(
      col: BsResponsiveValue(md: BsCol(4)),
      child: Text('md-4'),
    ),
    BsFlexItem(
      col: BsResponsiveValue(md: BsCol(4)),
      offset: BsResponsiveValue(md: BsCol(4)),
      child: Text('md-4'),
    ),
  ],
)''',
          preview: BsRow(
            children: [
              docCol('md-4', col: const BsResponsiveValue(md: BsCol(4))),
              docCol(
                'md-4',
                col: const BsResponsiveValue(md: BsCol(4)),
                offset: const BsResponsiveValue(md: BsCol(4)),
              ),
            ],
          ),
        ),
        DocExample(
          code: '''
BsRow(
  children: [
    BsFlexItem(
      col: BsResponsiveValue(md: BsCol(3)),
      offset: BsResponsiveValue(md: BsCol(3)),
      child: Text('md-3'),
    ),
    BsFlexItem(
      col: BsResponsiveValue(md: BsCol(3)),
      offset: BsResponsiveValue(md: BsCol(3)),
      child: Text('md-3'),
    ),
  ],
)''',
          preview: BsRow(
            children: [
              docCol(
                'md-3',
                col: const BsResponsiveValue(md: BsCol(3)),
                offset: const BsResponsiveValue(md: BsCol(3)),
              ),
              docCol(
                'md-3',
                col: const BsResponsiveValue(md: BsCol(3)),
                offset: const BsResponsiveValue(md: BsCol(3)),
              ),
            ],
          ),
        ),
        DocExample(
          code: '''
BsRow(
  children: [
    BsFlexItem(
      col: BsResponsiveValue(md: BsCol(6)),
      offset: BsResponsiveValue(md: BsCol(3)),
      child: Text('md-6'),
    ),
  ],
)''',
          preview: BsRow(
            children: [
              docCol(
                'md-6',
                col: const BsResponsiveValue(md: BsCol(6)),
                offset: const BsResponsiveValue(md: BsCol(3)),
              ),
            ],
          ),
        ),
        DocText([
          DocBold('An offset cannot be reset.'),
          ' Bootstrap has ',
          DocCode('offset-0'),
          ' for a layout like ',
          DocCode('offset-md-3 offset-lg-0'),
          ', but a ',
          DocCode('BsCol'),
          ' is from 1 to 12, so there is no value that means "none" for a '
              'larger breakpoint. Give the offset only to the breakpoints '
              'that need it, and when a larger one should have none, build '
              'the column without an offset there, with the breakpoint read '
              'as in the examples above.',
        ]),
        const DocHeading('Margin utilities', sub: true),
        DocText([
          'With flexbox, you can use margins such as ',
          DocCode('me: BsSpacing.auto'),
          ' to force sibling columns away from one another. ',
          DocCode('ms'),
          ' and ',
          DocCode('me'),
          ' are the start and end margins, so they follow the direction of '
              'the text.',
        ]),
        DocExample(
          code: '''
BsRow(
  children: [
    BsFlexItem(
      col: BsResponsiveValue(md: BsCol(4)),
      child: Text('md-4'),
    ),
    BsFlexItem(
      col: BsResponsiveValue(md: BsCol(4)),
      ms: BsSpacing.auto,
      child: Text('md-4 ms-auto'),
    ),
  ],
)''',
          preview: BsRow(
            children: [
              docCol('md-4', col: const BsResponsiveValue(md: BsCol(4))),
              docCol(
                'md-4 ms-auto',
                col: const BsResponsiveValue(md: BsCol(4)),
                ms: BsSpacing.auto,
              ),
            ],
          ),
        ),
        DocExample(
          code: '''
BsRow(
  children: [
    BsFlexItem(
      col: BsResponsiveValue(md: BsCol(3)),
      ms: BsResponsiveValue(md: BsSpacing.auto),
      child: Text('md-3 ms-md-auto'),
    ),
    BsFlexItem(
      col: BsResponsiveValue(md: BsCol(3)),
      ms: BsResponsiveValue(md: BsSpacing.auto),
      child: Text('md-3 ms-md-auto'),
    ),
  ],
)''',
          preview: BsRow(
            children: [
              docCol(
                'md-3 ms-md-auto',
                col: const BsResponsiveValue(md: BsCol(3)),
                ms: const BsResponsiveValue(md: BsSpacing.auto),
              ),
              docCol(
                'md-3 ms-md-auto',
                col: const BsResponsiveValue(md: BsCol(3)),
                ms: const BsResponsiveValue(md: BsSpacing.auto),
              ),
            ],
          ),
        ),
        DocExample(
          code: '''
BsRow(
  children: [
    BsFlexItem(
      col: BsCol.auto,
      me: BsSpacing.auto,
      child: Text('col-auto me-auto'),
    ),
    BsFlexItem(col: BsCol.auto, child: Text('col-auto')),
  ],
)''',
          preview: BsRow(
            children: [
              docCol('col-auto me-auto', col: BsCol.auto, me: BsSpacing.auto),
              docCol('col-auto', col: BsCol.auto),
            ],
          ),
        ),
        const DocHeading('Standalone column widths'),
        DocText([
          'A column width is not only for the children of a row. ',
          DocCode('BsBox'),
          ' takes the same ',
          DocCode('col'),
          ' and gives the box that share of the width of its parent, as the ',
          DocCode('.col-*'),
          ' classes do when they are used outside of a row. The gutters are '
              'left out then, because only a column of a row has them. Use '
              'it with ',
          DocCode('crossAxisAlignment: CrossAxisAlignment.start'),
          ' in a ',
          DocCode('Column'),
          ': the default centers the box.',
        ]),
        DocExample(
          code: '''
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    BsBox(
      col: BsCol(3),
      p: BsSpacing.s3,
      mb: BsSpacing.s2,
      child: Text('.col-3: width of 25%'),
    ),
    BsBox(
      col: BsResponsiveValue(sm: BsCol(9)),
      p: BsSpacing.s3,
      child: Text('.col-sm-9: width of 75% above the sm breakpoint'),
    ),
  ],
)''',
          preview: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _standalone('.col-3: width of 25%', const BsCol(3)),
              const SizedBox(height: 8),
              _standalone(
                '.col-sm-9: width of 75% above the sm breakpoint',
                const BsResponsiveValue(sm: BsCol(9)),
              ),
            ],
          ),
        ),
        DocText([
          'There is no float to take a column out of the flow, so Bootstrap\'s '
              'responsive floated image, with text that wraps around it and a ',
          DocCode('.clearfix'),
          ' to hold the float, has no counterpart. The way to put text next '
              'to an image is a row of two columns, which stack on a small '
              'window.',
        ]),
      ],
    );
  }
}

Widget _alignItems(BsAlign align) {
  return BsRow(
    alignItems: align,
    children: [
      docCol('Tall column', col: BsCol.equal, height: 100),
      docCol('Column', col: BsCol.equal),
      docCol('Column', col: BsCol.equal),
    ],
  );
}

Widget _standalone(String label, BsResponsive<BsCol> col) {
  return BsBox(
    col: col,
    p: BsSpacing.s3,
    child: DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0x26702CF9),
        border: Border.all(color: const Color(0x4D702CF9)),
      ),
      child: Padding(padding: const EdgeInsets.all(12), child: Text(label)),
    ),
  );
}

class _BreakAtMd extends StatelessWidget {
  const _BreakAtMd();

  @override
  Widget build(BuildContext context) {
    final breakpoint = BsBreakpoint.forWidth(MediaQuery.sizeOf(context).width);
    final md = breakpoint.index >= BsBreakpoint.md.index;

    return BsRow(
      children: [
        docCol('col-6', col: const BsCol(6)),
        docCol('col-6', col: const BsCol(6)),
        if (md) const BsFlexItem(p: BsSpacing.s0, child: SizedBox.shrink()),
        docCol('col-6', col: const BsCol(6)),
        docCol('col-6', col: const BsCol(6)),
      ],
    );
  }
}

class _ReorderBelowMd extends StatelessWidget {
  const _ReorderBelowMd();

  @override
  Widget build(BuildContext context) {
    final breakpoint = BsBreakpoint.forWidth(MediaQuery.sizeOf(context).width);
    final small = breakpoint.index < BsBreakpoint.md.index;

    final first = docCol('First', col: BsCol.equal);
    final second = docCol('Second', col: BsCol.equal);
    final third = docCol('Third', col: BsCol.equal);
    return BsRow(
      children: small ? [third, first, second] : [first, second, third],
    );
  }
}
