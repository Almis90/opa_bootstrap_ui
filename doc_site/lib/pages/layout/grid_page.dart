import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_content.dart';
import '../../src/doc_example.dart';
import '../../src/doc_grid.dart';
import '../../src/doc_page.dart';

/// "Grid system": `BsContainer`, `BsRow` and the `col` of a `BsFlexItem`.
class GridPage extends StatelessWidget {
  const GridPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      leadGap: 0,
      title: 'Grid system',
      lead:
          'Use the mobile-first grid to build layouts of all shapes and '
          'sizes with a twelve column system, six responsive tiers and a '
          'handful of widgets.',
      children: [
        const DocHeading('Example'),
        DocText([
          'The grid system uses a series of containers, rows and columns to '
              'lay out and align content. It is responsive, and it has the '
              'rules of flexbox: ',
          DocCode('BsRow'),
          ' is a wrapping ',
          DocCode('BsFlex'),
          ', and a column is a child of it with a ',
          DocCode('col'),
          '. Below is an example, and an in-depth explanation of how the '
              'grid comes together.',
        ]),
        DocText([
          'In the previews, each column is tinted to show where it is, '
              'gutter included, as Bootstrap\'s docs do. In the code the '
              'column holds a ',
          DocCode('Text'),
          ' and nothing else.',
        ]),
        DocExample(
          code: '''
BsContainer(
  child: BsRow(
    children: [
      BsFlexItem(col: BsCol.equal, child: Text('Column')),
      BsFlexItem(col: BsCol.equal, child: Text('Column')),
      BsFlexItem(col: BsCol.equal, child: Text('Column')),
    ],
  ),
)''',
          preview: BsContainer(
            child: BsRow(
              children: [
                docCol('Column', col: BsCol.equal),
                docCol('Column', col: BsCol.equal),
                docCol('Column', col: BsCol.equal),
              ],
            ),
          ),
        ),
        DocText([
          'The example creates three equal-width columns on every window '
              'size, using the widths of the grid. Those columns are '
              'centered in the page by the parent ',
          DocCode('BsContainer'),
          '.',
        ]),
        const DocHeading('How it works'),
        DocText(['Breaking it down, here is how the grid comes together:']),
        DocList([
          DocListItem([
            DocBold('The grid supports six responsive breakpoints.'),
            ' They are the ones of ',
            DocCode('BsBreakpoint'),
            ' (see ',
            DocLink.page('Breakpoints', 'Layout', 'Breakpoints'),
            ') and they are compared with the width of the window. A width '
                'that you give for a breakpoint applies to it and to all '
                'those above it: ',
            DocCode('BsResponsiveValue(md: BsCol(4))'),
            ' is ',
            DocCode('.col-md-4'),
            ', for ',
            DocCode('md'),
            ', ',
            DocCode('lg'),
            ', ',
            DocCode('xl'),
            ' and ',
            DocCode('xxl'),
            '.',
          ]),
          DocListItem([
            DocBold('Containers center and horizontally pad your content.'),
            ' Use ',
            DocCode('BsContainer'),
            ' for a responsive pixel width, ',
            DocCode('BsContainer.fluid'),
            ' for the full width of the window, or ',
            DocCode('BsContainer.responsiveFrom'),
            ' for a combination of fluid and pixel widths. See ',
            DocLink.page('Containers', 'Layout', 'Containers'),
            '.',
          ]),
          DocListItem([
            DocBold('Rows are wrappers for columns.'),
            ' Each column has horizontal padding, called a gutter, for the '
                'space between them. The row cancels that padding with a '
                'negative margin of half the gutter on each side, so that '
                'the content of the columns lines up with the content '
                'around the row. A row also takes ',
            DocCode('rowCols'),
            ' to size all of its columns at once, and the ',
            DocCode('g'),
            ', ',
            DocCode('gx'),
            ' and ',
            DocCode('gy'),
            ' gutters (see ',
            DocLink.page('Gutters', 'Layout', 'Gutters'),
            ').',
          ]),
          DocListItem([
            DocBold('Columns are incredibly flexible.'),
            ' There are 12 template columns in a row, so that you can '
                'combine elements that span any number of them. ',
            DocCode('BsCol(4)'),
            ' spans four. The widths are percentages, so the relative '
                'sizes stay the same.',
          ]),
          DocListItem([
            DocBold('Gutters are responsive too.'),
            ' They have the sizes of the spacing, ',
            DocCode('BsSpacing'),
            ': ',
            DocCode('gx'),
            ' is the horizontal gutter, ',
            DocCode('gy'),
            ' the vertical one and ',
            DocCode('g'),
            ' both, and ',
            DocCode('BsSpacing.s0'),
            ' removes them.',
          ]),
          DocListItem([
            DocBold('There are no Sass variables and mixins.'),
            ' If the ready-made widgets are not what you want, build your '
                'own layout from the same ',
            DocCode('BsFlex'),
            ' and ',
            DocCode('BsFlexItem'),
            ' (see ',
            DocLink.page('Utilities', 'Layout', 'Utilities'),
            ').',
          ]),
        ]),
        DocText([
          'A column is not a widget of its own. A ',
          DocCode('BsFlexItem'),
          ' wraps any child of the row and gives it a ',
          DocCode('BsCol'),
          ': the number of columns it spans, ',
          DocCode('BsCol.equal'),
          ' (',
          DocCode('.col'),
          ') or ',
          DocCode('BsCol.auto'),
          ' (',
          DocCode('.col-auto'),
          '). A child of a row without one is the '
              'whole width of the row, so it stacks, as ',
          DocCode('.row > *'),
          ' does in Bootstrap.',
        ]),
        const DocHeading('Grid options'),
        DocText([
          'The grid adapts across all six breakpoints. This is how it '
              'changes across them:',
        ]),
        const _GridOptionsTable(),
        DocList([
          DocListItem([
            DocBold('Number of columns:'),
            ' 12, at every breakpoint.',
          ]),
          DocListItem([
            DocBold('Gutter width:'),
            ' 24, which is 12 on the left and on the right of a column.',
          ]),
          DocListItem([
            DocBold('Custom gutters:'),
            ' yes, see ',
            DocLink.page('Gutters', 'Layout', 'Gutters'),
            '.',
          ]),
          DocListItem([DocBold('Nestable:'), ' yes, see Nesting below.']),
          DocListItem([
            DocBold('Column ordering:'),
            ' a row can be reversed, per breakpoint, with its ',
            DocCode('direction'),
            ' (see ',
            DocLink.page('Columns', 'Layout', 'Columns'),
            ').',
          ]),
        ]),
        const DocHeading('Auto-layout columns'),
        DocText([
          'Give the columns a width by breakpoint for easy sizing, without a '
              'number for each of them.',
        ]),
        const DocHeading('Equal-width', sub: true),
        DocText([
          'Here are two grids that apply to every window size, from ',
          DocCode('xs'),
          ' to ',
          DocCode('xxl'),
          '. Use ',
          DocCode('BsCol.equal'),
          ' on any number of columns and every one of them has the same '
              'width.',
        ]),
        DocExample(
          code: '''
BsContainer(
  child: Column(
    children: [
      BsRow(
        children: [
          BsFlexItem(col: BsCol.equal, child: Text('1 of 2')),
          BsFlexItem(col: BsCol.equal, child: Text('2 of 2')),
        ],
      ),
      BsRow(
        children: [
          BsFlexItem(col: BsCol.equal, child: Text('1 of 3')),
          BsFlexItem(col: BsCol.equal, child: Text('2 of 3')),
          BsFlexItem(col: BsCol.equal, child: Text('3 of 3')),
        ],
      ),
    ],
  ),
)''',
          preview: BsContainer(
            child: Column(
              children: [
                BsRow(
                  children: [
                    docCol('1 of 2', col: BsCol.equal),
                    docCol('2 of 2', col: BsCol.equal),
                  ],
                ),
                BsRow(
                  children: [
                    docCol('1 of 3', col: BsCol.equal),
                    docCol('2 of 3', col: BsCol.equal),
                    docCol('3 of 3', col: BsCol.equal),
                  ],
                ),
              ],
            ),
          ),
        ),
        const DocHeading('Setting one column width', sub: true),
        DocText([
          'You can set the width of one column, and the others resize '
              'around it: the equal columns share the space that is left, '
              'whatever the width of the one in the middle.',
        ]),
        DocExample(
          code: '''
BsContainer(
  child: Column(
    children: [
      BsRow(
        children: [
          BsFlexItem(col: BsCol.equal, child: Text('1 of 3')),
          BsFlexItem(col: BsCol(6), child: Text('2 of 3 (wider)')),
          BsFlexItem(col: BsCol.equal, child: Text('3 of 3')),
        ],
      ),
      BsRow(
        children: [
          BsFlexItem(col: BsCol.equal, child: Text('1 of 3')),
          BsFlexItem(col: BsCol(5), child: Text('2 of 3 (wider)')),
          BsFlexItem(col: BsCol.equal, child: Text('3 of 3')),
        ],
      ),
    ],
  ),
)''',
          preview: BsContainer(
            child: Column(
              children: [
                BsRow(
                  children: [
                    docCol('1 of 3', col: BsCol.equal),
                    docCol('2 of 3 (wider)', col: const BsCol(6)),
                    docCol('3 of 3', col: BsCol.equal),
                  ],
                ),
                BsRow(
                  children: [
                    docCol('1 of 3', col: BsCol.equal),
                    docCol('2 of 3 (wider)', col: const BsCol(5)),
                    docCol('3 of 3', col: BsCol.equal),
                  ],
                ),
              ],
            ),
          ),
        ),
        const DocHeading('Variable width content', sub: true),
        DocText([
          'Use ',
          DocCode('BsCol.auto'),
          ' to size a column by the natural width of its content. In a '
              'responsive value it works at a breakpoint of your choice: '
              'the column below is the whole row until ',
          DocCode('md'),
          ' and as wide as its content from there.',
        ]),
        DocExample(
          code: '''
BsContainer(
  child: Column(
    children: [
      BsRow(
        justifyContent: BsResponsiveValue(md: BsJustify.center),
        children: [
          BsFlexItem(
            col: BsResponsiveValue(xs: BsCol.equal, lg: BsCol(2)),
            child: Text('1 of 3'),
          ),
          BsFlexItem(
            col: BsResponsiveValue(md: BsCol.auto),
            child: Text('Variable width content'),
          ),
          BsFlexItem(
            col: BsResponsiveValue(xs: BsCol.equal, lg: BsCol(2)),
            child: Text('3 of 3'),
          ),
        ],
      ),
      BsRow(
        children: [
          BsFlexItem(col: BsCol.equal, child: Text('1 of 3')),
          BsFlexItem(
            col: BsResponsiveValue(md: BsCol.auto),
            child: Text('Variable width content'),
          ),
          BsFlexItem(
            col: BsResponsiveValue(xs: BsCol.equal, lg: BsCol(2)),
            child: Text('3 of 3'),
          ),
        ],
      ),
    ],
  ),
)''',
          preview: BsContainer(
            child: Column(
              children: [
                BsRow(
                  justifyContent: const BsResponsiveValue(md: BsJustify.center),
                  children: [
                    docCol(
                      '1 of 3',
                      col: const BsResponsiveValue(
                        xs: BsCol.equal,
                        lg: BsCol(2),
                      ),
                    ),
                    docCol(
                      'Variable width content',
                      col: const BsResponsiveValue(md: BsCol.auto),
                    ),
                    docCol(
                      '3 of 3',
                      col: const BsResponsiveValue(
                        xs: BsCol.equal,
                        lg: BsCol(2),
                      ),
                    ),
                  ],
                ),
                BsRow(
                  children: [
                    docCol('1 of 3', col: BsCol.equal),
                    docCol(
                      'Variable width content',
                      col: const BsResponsiveValue(md: BsCol.auto),
                    ),
                    docCol(
                      '3 of 3',
                      col: const BsResponsiveValue(
                        xs: BsCol.equal,
                        lg: BsCol(2),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const DocHeading('Responsive columns'),
        DocText([
          'The grid has six tiers, so that you can size your columns on '
              'extra small, small, medium, large, extra large or extra extra '
              'large windows however you see fit.',
        ]),
        const DocHeading('All breakpoints', sub: true),
        DocText([
          'For a grid that is the same from the smallest to the largest '
              'window, give the columns a plain ',
          DocCode('BsCol'),
          ': ',
          DocCode('BsCol.equal'),
          ' (',
          DocCode('.col'),
          ') or a number (',
          DocCode('.col-*'),
          '). Use a number when you need a column of a particular size, and '
              'stick to equal columns otherwise.',
        ]),
        DocExample(
          code: '''
BsContainer(
  child: Column(
    children: [
      BsRow(
        children: [
          BsFlexItem(col: BsCol.equal, child: Text('col')),
          BsFlexItem(col: BsCol.equal, child: Text('col')),
          BsFlexItem(col: BsCol.equal, child: Text('col')),
          BsFlexItem(col: BsCol.equal, child: Text('col')),
        ],
      ),
      BsRow(
        children: [
          BsFlexItem(col: BsCol(8), child: Text('col-8')),
          BsFlexItem(col: BsCol(4), child: Text('col-4')),
        ],
      ),
    ],
  ),
)''',
          preview: BsContainer(
            child: Column(
              children: [
                BsRow(
                  children: [
                    for (var i = 0; i < 4; i++) docCol('col', col: BsCol.equal),
                  ],
                ),
                BsRow(
                  children: [
                    docCol('col-8', col: const BsCol(8)),
                    docCol('col-4', col: const BsCol(4)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const DocHeading('Stacked to horizontal', sub: true),
        DocText([
          'A column with a width from a breakpoint up starts out stacked, '
              'as a whole row, and becomes horizontal at that breakpoint. '
              'Give the width only to the breakpoint and nothing to ',
          DocCode('xs'),
          ': ',
          DocCode('.col-sm-8'),
          ' is ',
          DocCode('BsResponsiveValue(sm: BsCol(8))'),
          '. Make the window narrower than 576 to stack them.',
        ]),
        DocExample(
          code: '''
BsContainer(
  child: Column(
    children: [
      BsRow(
        children: [
          BsFlexItem(
            col: BsResponsiveValue(sm: BsCol(8)),
            child: Text('col-sm-8'),
          ),
          BsFlexItem(
            col: BsResponsiveValue(sm: BsCol(4)),
            child: Text('col-sm-4'),
          ),
        ],
      ),
      BsRow(
        children: [
          BsFlexItem(
            col: BsResponsiveValue(sm: BsCol.equal),
            child: Text('col-sm'),
          ),
          BsFlexItem(
            col: BsResponsiveValue(sm: BsCol.equal),
            child: Text('col-sm'),
          ),
          BsFlexItem(
            col: BsResponsiveValue(sm: BsCol.equal),
            child: Text('col-sm'),
          ),
        ],
      ),
    ],
  ),
)''',
          preview: BsContainer(
            child: Column(
              children: [
                BsRow(
                  children: [
                    docCol(
                      'col-sm-8',
                      col: const BsResponsiveValue(sm: BsCol(8)),
                    ),
                    docCol(
                      'col-sm-4',
                      col: const BsResponsiveValue(sm: BsCol(4)),
                    ),
                  ],
                ),
                BsRow(
                  children: [
                    for (var i = 0; i < 3; i++)
                      docCol(
                        'col-sm',
                        col: const BsResponsiveValue(sm: BsCol.equal),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const DocHeading('Mix and match', sub: true),
        DocText([
          'Do you not want your columns to simply stack in some of the '
              'tiers? Combine the widths of as many breakpoints as you need. '
              'The example shows how they work together.',
        ]),
        DocExample(
          code: '''
BsContainer(
  child: Column(
    children: [
      // Stack the columns on mobile by making one full-width and the
      // other half-width
      BsRow(
        children: [
          BsFlexItem(
            col: BsResponsiveValue(md: BsCol(8)),
            child: Text('.col-md-8'),
          ),
          BsFlexItem(
            col: BsResponsiveValue(xs: BsCol(6), md: BsCol(4)),
            child: Text('.col-6 .col-md-4'),
          ),
        ],
      ),
      // Columns start at 50% wide on mobile and bump up to 33.3% wide
      // on desktop
      BsRow(
        children: [
          for (var i = 0; i < 3; i++)
            BsFlexItem(
              col: BsResponsiveValue(xs: BsCol(6), md: BsCol(4)),
              child: Text('.col-6 .col-md-4'),
            ),
        ],
      ),
      // Columns are always 50% wide, on mobile and desktop
      BsRow(
        children: [
          BsFlexItem(col: BsCol(6), child: Text('.col-6')),
          BsFlexItem(col: BsCol(6), child: Text('.col-6')),
        ],
      ),
    ],
  ),
)''',
          preview: BsContainer(
            child: Column(
              children: [
                BsRow(
                  children: [
                    docCol(
                      '.col-md-8',
                      col: const BsResponsiveValue(md: BsCol(8)),
                    ),
                    docCol(
                      '.col-6 .col-md-4',
                      col: const BsResponsiveValue(xs: BsCol(6), md: BsCol(4)),
                    ),
                  ],
                ),
                BsRow(
                  children: [
                    for (var i = 0; i < 3; i++)
                      docCol(
                        '.col-6 .col-md-4',
                        col: const BsResponsiveValue(
                          xs: BsCol(6),
                          md: BsCol(4),
                        ),
                      ),
                  ],
                ),
                BsRow(
                  children: [
                    docCol('.col-6', col: const BsCol(6)),
                    docCol('.col-6', col: const BsCol(6)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const DocHeading('Row columns', sub: true),
        DocText([
          'Set the number of columns that best renders your content and '
              'layout with the ',
          DocCode('rowCols'),
          ' of the row, which can be responsive. Where a ',
          DocCode('col'),
          ' sizes a single column (',
          DocCode('.col-md-4'),
          '), ',
          DocCode('rowCols'),
          ' is set on the parent row as a shortcut, for the children that '
              'have no width of their own. They do not need a ',
          DocCode('BsFlexItem'),
          ' at all.',
        ]),
        DocText([
          'Use it to quickly create basic grid layouts or to control a '
              'layout of cards. A column with a ',
          DocCode('col'),
          ' of its own keeps it.',
        ]),
        DocExample(
          code: '''
BsContainer(
  child: BsRow(
    rowCols: BsResponsiveValue(xs: 2),
    children: [
      Text('Column'),
      Text('Column'),
      Text('Column'),
      Text('Column'),
    ],
  ),
)''',
          preview: BsContainer(
            child: BsRow(
              rowCols: const BsResponsiveValue(xs: 2),
              children: [for (var i = 0; i < 4; i++) docCol('Column')],
            ),
          ),
        ),
        DocExample(
          code: '''
BsContainer(
  child: BsRow(
    rowCols: BsResponsiveValue(xs: 3),
    children: [
      Text('Column'),
      Text('Column'),
      Text('Column'),
      Text('Column'),
    ],
  ),
)''',
          preview: BsContainer(
            child: BsRow(
              rowCols: const BsResponsiveValue(xs: 3),
              children: [for (var i = 0; i < 4; i++) docCol('Column')],
            ),
          ),
        ),
        DocText([
          '.row-cols-auto, which gives the columns their natural width, is '
              'a ',
          DocCode('col'),
          ' of ',
          DocCode('BsCol.auto'),
          ' on each of them:',
        ]),
        DocExample(
          code: '''
BsContainer(
  child: BsRow(
    children: [
      BsFlexItem(col: BsCol.auto, child: Text('Column')),
      BsFlexItem(col: BsCol.auto, child: Text('Column')),
      BsFlexItem(col: BsCol.auto, child: Text('Column')),
      BsFlexItem(col: BsCol.auto, child: Text('Column')),
    ],
  ),
)''',
          preview: BsContainer(
            child: BsRow(
              children: [
                for (var i = 0; i < 4; i++) docCol('Column', col: BsCol.auto),
              ],
            ),
          ),
        ),
        DocExample(
          code: '''
BsContainer(
  child: BsRow(
    rowCols: BsResponsiveValue(xs: 4),
    children: [
      Text('Column'),
      Text('Column'),
      BsFlexItem(col: BsCol(6), child: Text('Column')),
      Text('Column'),
    ],
  ),
)''',
          preview: BsContainer(
            child: BsRow(
              rowCols: const BsResponsiveValue(xs: 4),
              children: [
                docCol('Column'),
                docCol('Column'),
                docCol('Column', col: const BsCol(6)),
                docCol('Column'),
              ],
            ),
          ),
        ),
        DocExample(
          code: '''
BsContainer(
  child: BsRow(
    rowCols: BsResponsiveValue(xs: 1, sm: 2, md: 4),
    children: [
      Text('Column'),
      Text('Column'),
      Text('Column'),
      Text('Column'),
    ],
  ),
)''',
          preview: BsContainer(
            child: BsRow(
              rowCols: const BsResponsiveValue(xs: 1, sm: 2, md: 4),
              children: [for (var i = 0; i < 4; i++) docCol('Column')],
            ),
          ),
        ),
        const DocHeading('Nesting'),
        DocText([
          'To nest your content, put a new ',
          DocCode('BsRow'),
          ' and a set of columns inside an existing column. Nested rows '
              'should have columns that add up to 12 or fewer; it is not '
              'required to use all 12.',
        ]),
        DocExample(
          code: '''
BsContainer(
  child: BsRow(
    children: [
      BsFlexItem(
        col: BsResponsiveValue(sm: BsCol(3)),
        child: Text('Level 1: .col-sm-3'),
      ),
      BsFlexItem(
        col: BsResponsiveValue(sm: BsCol(9)),
        child: BsRow(
          children: [
            BsFlexItem(
              col: BsResponsiveValue(xs: BsCol(8), sm: BsCol(6)),
              child: Text('Level 2: .col-8 .col-sm-6'),
            ),
            BsFlexItem(
              col: BsResponsiveValue(xs: BsCol(4), sm: BsCol(6)),
              child: Text('Level 2: .col-4 .col-sm-6'),
            ),
          ],
        ),
      ),
    ],
  ),
)''',
          preview: BsContainer(
            child: BsRow(
              children: [
                docCol(
                  'Level 1: .col-sm-3',
                  col: const BsResponsiveValue(sm: BsCol(3)),
                ),
                docCol(
                  '',
                  col: const BsResponsiveValue(sm: BsCol(9)),
                  child: BsRow(
                    children: [
                      docCol(
                        'Level 2: .col-8 .col-sm-6',
                        col: const BsResponsiveValue(
                          xs: BsCol(8),
                          sm: BsCol(6),
                        ),
                      ),
                      docCol(
                        'Level 2: .col-4 .col-sm-6',
                        col: const BsResponsiveValue(
                          xs: BsCol(4),
                          sm: BsCol(6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const DocHeading('Customizing the grid'),
        DocText([
          'Bootstrap lets you change the number of columns, the gutter, the '
              'number of tiers and the container widths in Sass, and then '
              'you recompile. A Flutter package is compiled with its '
              'tokens, and these are not configurable:',
        ]),
        DocTable(
          headers: ['Bootstrap', 'opa_bootstrap_ui'],
          rows: [
            [
              r'$grid-columns: 12',
              'Twelve columns. BsGrid.columns holds the number, and '
                  'BsCol takes 1 to 12.',
            ],
            [
              r'$grid-gutter-width: 1.5rem',
              '24, in BsGrid.gutterWidth, as the default gutter of a row. '
                  'Change it for a row, or for all of them, with the g '
                  'parameters; see Gutters.',
            ],
            [
              r'$grid-row-columns: 6',
              'BsGrid.rowColumns. rowCols takes any number.',
            ],
            [r'$grid-breakpoints', 'BsBreakpoint, a fixed enum.'],
            [
              r'$container-max-widths',
              'BsGrid.containerMaxWidths, which BsContainer reads.',
            ],
          ],
        ),
        DocText([
          'Only the container tokens are read by a widget. The others '
              'document the values that the widgets use.',
        ]),
      ],
    );
  }
}

class _GridOptionsTable extends StatelessWidget {
  const _GridOptionsTable();

  @override
  Widget build(BuildContext context) {
    return DocTable(
      headers: ['', 'xs', 'sm', 'md', 'lg', 'xl', 'xxl'],
      rows: [
        ['Window width', '<576', '≥576', '≥768', '≥992', '≥1200', '≥1400'],
        [
          'Container max-width',
          'None (auto)',
          for (final breakpoint in BsBreakpoint.values.skip(1))
            BsGrid.containerMaxWidthFor(breakpoint)!.toStringAsFixed(0),
        ],
        [
          'Class prefix',
          '.col-',
          '.col-sm-',
          '.col-md-',
          '.col-lg-',
          '.col-xl-',
          '.col-xxl-',
        ],
        [
          'BsResponsiveValue',
          for (final breakpoint in BsBreakpoint.values) '${breakpoint.name}:',
        ],
      ],
    );
  }
}
