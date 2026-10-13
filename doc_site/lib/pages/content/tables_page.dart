import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_content.dart';
import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

const _bold = TextStyle(fontWeight: FontWeight.bold);

const _columns = [Text('#'), Text('First'), Text('Last'), Text('Handle')];

const _rows = [
  BsTableRow(
    cells: [
      Text('1', style: _bold),
      Text('Mark'),
      Text('Otto'),
      Text('@mdo'),
    ],
  ),
  BsTableRow(
    cells: [
      Text('2', style: _bold),
      Text('Jacob'),
      Text('Thornton'),
      Text('@fat'),
    ],
  ),
  BsTableRow(
    cells: [
      Text('3', style: _bold),
      Text('Larry'),
      Text('the Bird'),
      Text('@twitter'),
    ],
  ),
];

String _number(double value) =>
    value == value.roundToDouble() ? value.toInt().toString() : '$value';

/// "Tables": `BsTable` and `BsTableRow`, their variants, accents, borders,
/// sizes, anatomy and responsive behavior, and `BsTableStyle`.
class TablesPage extends StatelessWidget {
  const TablesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      leadGap: 0,
      title: 'Tables',
      lead:
          'Documentation and examples for styling tables with Bootstrap: '
          'BsTable, and the rows, accents, borders and variants it takes.',
      children: [
        const DocHeading('Overview'),
        DocText([
          'Bootstrap\'s tables are opt-in, since the ',
          DocCode('<table>'),
          ' element is also used by third-party widgets such as calendars. '
              'In Flutter a table is only what you build, so there is nothing '
              'to opt out of: ',
          DocCode('BsTable'),
          ' is the Bootstrap table. It is laid out by Flutter\'s ',
          DocCode('Table'),
          ', with ',
          DocCode('columns'),
          ' for the head, whose cells are bold, and ',
          DocCode('rows'),
          ' for the body, each a ',
          DocCode('BsTableRow'),
          ' with a ',
          DocCode('cells'),
          ' list that has a widget for every column.',
        ]),
        DocExample(
          code: '''
const columns = [Text('#'), Text('First'), Text('Last'), Text('Handle')];

const bold = TextStyle(fontWeight: FontWeight.bold);

const rows = [
  BsTableRow(
    cells: [Text('1', style: bold), Text('Mark'), Text('Otto'), Text('@mdo')],
  ),
  BsTableRow(
    cells: [Text('2', style: bold), Text('Jacob'), Text('Thornton'), Text('@fat')],
  ),
  BsTableRow(
    cells: [Text('3', style: bold), Text('Larry'), Text('the Bird'), Text('@twitter')],
  ),
];

BsTable(columns: columns, rows: rows)''',
          preview: const BsTable(columns: _columns, rows: _rows),
        ),
        DocText([
          'The examples below use these ',
          DocCode('columns'),
          ' and ',
          DocCode('rows'),
          ' again. A cell can be any widget, not only a ',
          DocCode('Text'),
          '. There is no row header (a cell with ',
          DocCode('scope="row"'),
          '): make the first cell of a row bold, as above, if you want one. '
              'Leave out ',
          DocCode('columns'),
          ' for a table without a head.',
        ]),
        DocText([
          'A table is as wide as the space it is given when that is fixed, '
              'as in a grid column, a card body or a ',
          DocCode('Column'),
          ' that stretches its children, which is what ',
          DocCode('width: 100%'),
          ' does in the CSS. Where it is not, in a plain ',
          DocCode('Column'),
          ' for one, the table is as wide as its content. The columns take '
              'the width of their widest cell; give the ones that need a '
              'width of their own to ',
          DocCode('columnWidths'),
          ', keyed by the index of the column.',
        ]),
        DocExample(
          code: '''
BsTable(
  columnWidths: {0: FixedColumnWidth(120)},
  columns: columns,
  rows: rows,
)''',
          preview: const BsTable(
            columnWidths: {0: FixedColumnWidth(120)},
            columns: _columns,
            rows: _rows,
          ),
        ),
        const DocHeading('Variants'),
        DocText([
          'Use the ',
          DocCode('variant'),
          ' of a row to color it, with one of the eight contextual colors of ',
          DocCode('BsVariant'),
          '. Bootstrap colors a whole table or a single cell as well; here '
              'the row is the unit, so set the variant on every row of a '
              'table you want colored.',
        ]),
        DocText([
          DocBold('Heads up!'),
          ' Bootstrap warns that its table variants do not adapt to the color '
              'mode. Neither do these: a colored row keeps its light tint and '
              'its black text in dark mode (the ',
          DocCode('dark'),
          ' variant its dark gray and white text), and the rules under it '
              'are its text color mixed 20% into its background.',
        ]),
        DocExample(
          code: '''
BsTable(
  columns: [Text('Variant'), Text('Heading'), Text('Heading')],
  rows: [
    BsTableRow(cells: [Text('Default', style: bold), Text('Cell'), Text('Cell')]),
    for (final variant in BsVariant.values)
      BsTableRow(
        variant: variant,
        cells: [Text(variant.name, style: bold), Text('Cell'), Text('Cell')],
      ),
  ],
)''',
          preview: BsTable(
            columns: const [Text('Variant'), Text('Heading'), Text('Heading')],
            rows: [
              const BsTableRow(
                cells: [
                  Text('Default', style: _bold),
                  Text('Cell'),
                  Text('Cell'),
                ],
              ),
              for (final variant in BsVariant.values)
                BsTableRow(
                  variant: variant,
                  cells: [
                    Text(variant.name, style: _bold),
                    const Text('Cell'),
                    const Text('Cell'),
                  ],
                ),
            ],
          ),
        ),
        DocText([
          DocBold('Accessibility tip.'),
          ' Using color to add meaning only provides a visual indication, '
              'which will not be conveyed to users of assistive technologies '
              'like screen readers. Make sure the meaning is obvious from the '
              'content itself, the visible text with enough color contrast, or '
              'give the cell a label of its own with a ',
          DocCode('Semantics'),
          ' widget (see ',
          DocLink.page('Accessibility', 'Getting started', 'Accessibility'),
          ').',
        ]),
        const DocHeading('Accented tables'),
        const DocHeading('Striped rows', sub: true),
        DocText([
          'Use ',
          DocCode('striped: true'),
          ' to add zebra-striping to the rows of the body. The first row of '
              'the body is the first that is striped, as in Bootstrap.',
        ]),
        DocExample(
          code: 'BsTable(striped: true, columns: columns, rows: rows)',
          preview: const BsTable(striped: true, columns: _columns, rows: _rows),
        ),
        DocText([
          'There is no striping of the columns, ',
          DocCode('.table-striped-columns'),
          '.',
        ]),
        DocText(['These work on a dark table, too:']),
        DocExample(
          code: 'BsTable(dark: true, striped: true, columns: columns, rows: rows)',
          preview: const BsTable(
            dark: true,
            striped: true,
            columns: _columns,
            rows: _rows,
          ),
        ),
        const DocHeading('Hoverable rows', sub: true),
        DocText([
          'Use ',
          DocCode('hover: true'),
          ' to give the rows of the body a hover state, which follows the '
              'pointer. Move it over the rows to see it.',
        ]),
        DocExample(
          code: 'BsTable(hover: true, columns: columns, rows: rows)',
          preview: const BsTable(hover: true, columns: _columns, rows: _rows),
        ),
        DocExample(
          code:
              'BsTable(dark: true, hover: true, columns: columns, rows: rows)',
          preview: const BsTable(
            dark: true,
            hover: true,
            columns: _columns,
            rows: _rows,
          ),
        ),
        DocText([
          'The hoverable rows can also be combined with the striped rows:',
        ]),
        DocExample(
          code: 'BsTable(striped: true, hover: true, columns: columns, rows: rows)',
          preview: const BsTable(
            striped: true,
            hover: true,
            columns: _columns,
            rows: _rows,
          ),
        ),
        const DocHeading('Active rows', sub: true),
        DocText([
          'Highlight a row with ',
          DocCode('active: true'),
          ' on the ',
          DocCode('BsTableRow'),
          '. A cell cannot be active on its own.',
        ]),
        DocExample(
          code: '''
BsTable(
  columns: columns,
  rows: [
    BsTableRow(active: true, cells: [Text('1', style: bold), Text('Mark'), Text('Otto'), Text('@mdo')]),
    BsTableRow(cells: [Text('2', style: bold), Text('Jacob'), Text('Thornton'), Text('@fat')]),
    BsTableRow(cells: [Text('3', style: bold), Text('Larry'), Text('the Bird'), Text('@twitter')]),
  ],
)''',
          preview: BsTable(
            columns: _columns,
            rows: [
              BsTableRow(active: true, cells: _rows[0].cells),
              _rows[1],
              _rows[2],
            ],
          ),
        ),
        DocExample(
          code: '''
BsTable(
  dark: true,
  columns: columns,
  rows: [
    BsTableRow(active: true, cells: [...]),
    ...
  ],
)''',
          preview: BsTable(
            dark: true,
            columns: _columns,
            rows: [
              BsTableRow(active: true, cells: _rows[0].cells),
              _rows[1],
              _rows[2],
            ],
          ),
        ),
        const DocHeading('How are the accents made?'),
        DocText([
          'The stripes, the hover state and the active rows are tints: the '
              'text color of the row laid over its background, at ',
          DocCode(_number(BsTableStyle.defaultStripedBackgroundOpacity)),
          ' for a stripe, ',
          DocCode(_number(BsTableStyle.defaultHoverBackgroundOpacity)),
          ' for the hover and ',
          DocCode(_number(BsTableStyle.defaultActiveBackgroundOpacity)),
          ' for an active row (see ',
          DocCode('BsTableStyle'),
          ' below). When they meet, a stripe is laid first, then the hover, '
              'then the active tint. The text color of a colored row is its '
              'own, black on the light tints and white on the ',
          DocCode('dark'),
          ' variant, and so is the color of its tints; the text of a dark '
              'table is white and tints with white, so the accents show on '
              'every color.',
        ]),
        const DocHeading('Table borders'),
        const DocHeading('Bordered tables', sub: true),
        DocText([
          'Use ',
          DocCode('bordered: true'),
          ' for borders on all sides of the table and its cells.',
        ]),
        DocExample(
          code: 'BsTable(bordered: true, columns: columns, rows: rows)',
          preview: const BsTable(
            bordered: true,
            columns: _columns,
            rows: _rows,
          ),
        ),
        DocText([
          'There is no border color utility for a table. Change the color of '
              'its rules with the ',
          DocCode('borderColor'),
          ' of a ',
          DocCode('BsTableStyle'),
          ':',
        ]),
        DocExample(
          code: '''
BsTable(
  bordered: true,
  style: BsTableStyle(borderColor: BsColors.blue),
  columns: columns,
  rows: rows,
)''',
          preview: const BsTable(
            bordered: true,
            style: BsTableStyle(borderColor: BsColors.blue),
            columns: _columns,
            rows: _rows,
          ),
        ),
        const DocHeading('Tables without borders', sub: true),
        DocText([
          'Use ',
          DocCode('borderless: true'),
          ' for a table without borders.',
        ]),
        DocExample(
          code: 'BsTable(borderless: true, columns: columns, rows: rows)',
          preview: const BsTable(
            borderless: true,
            columns: _columns,
            rows: _rows,
          ),
        ),
        DocExample(
          code: 'BsTable(dark: true, borderless: true, columns: columns, rows: rows)',
          preview: const BsTable(
            dark: true,
            borderless: true,
            columns: _columns,
            rows: _rows,
          ),
        ),
        const DocHeading('Small tables'),
        DocText([
          'Use ',
          DocCode('small: true'),
          ' to make a table more compact by cutting all the cell padding in '
              'half, from ',
          DocCode(
            '${_number(BsTableStyle.defaultCellPadding.left)} to '
            '${_number(BsTableStyle.defaultCellPaddingSm.left)}',
          ),
          ' logical pixels.',
        ]),
        DocExample(
          code: 'BsTable(small: true, columns: columns, rows: rows)',
          preview: const BsTable(small: true, columns: _columns, rows: _rows),
        ),
        DocExample(
          code:
              'BsTable(dark: true, small: true, columns: columns, rows: rows)',
          preview: const BsTable(
            dark: true,
            small: true,
            columns: _columns,
            rows: _rows,
          ),
        ),
        const DocHeading('Table group dividers'),
        DocText([
          'Bootstrap adds a thicker, darker border between the groups of a '
              'table, the ',
          DocCode('<thead>'),
          ', ',
          DocCode('<tbody>'),
          ' and ',
          DocCode('<tfoot>'),
          ', with ',
          DocCode('.table-group-divider'),
          '. A table here has no such groups, so say where one starts: '
              'a row with ',
          DocCode('groupStart: true'),
          ' gets a rule of 2 logical pixels in the text color above it. It is '
              'not drawn in a ',
          DocCode('bordered'),
          ' or ',
          DocCode('borderless'),
          ' table.',
        ]),
        DocExample(
          code: '''
BsTable(
  columns: columns,
  rows: [
    BsTableRow(groupStart: true, cells: [Text('1', style: bold), Text('Mark'), Text('Otto'), Text('@mdo')]),
    BsTableRow(cells: [Text('2', style: bold), Text('Jacob'), Text('Thornton'), Text('@fat')]),
    BsTableRow(cells: [Text('3', style: bold), Text('Larry'), Text('the Bird'), Text('@twitter')]),
  ],
)''',
          preview: BsTable(
            columns: _columns,
            rows: [
              BsTableRow(groupStart: true, cells: _rows[0].cells),
              _rows[1],
              _rows[2],
            ],
          ),
        ),
        const DocHeading('Vertical alignment'),
        DocText([
          'The cells of the head are always aligned to the bottom, and the '
              'cells of the body to the top, which is where Bootstrap puts '
              'them. There are no ',
          DocCode('.align-*'),
          ' classes to change this for a table, a row or a cell.',
        ]),
        DocExample(
          code: '''
BsTable(
  columns: [Text('Heading'), Text('Heading'), Text('A heading\\nof two lines')],
  rows: [
    BsTableRow(cells: [Text('Cell'), Text('Cell'), Text('A cell\\nof\\nthree lines')]),
  ],
)''',
          preview: const BsTable(
            columns: [
              Text('Heading'),
              Text('Heading'),
              Text('A heading\nof two lines'),
            ],
            rows: [
              BsTableRow(
                cells: [
                  Text('Cell'),
                  Text('Cell'),
                  Text('A cell\nof\nthree lines'),
                ],
              ),
            ],
          ),
        ),
        const DocHeading('Nesting'),
        DocText([
          'Put a ',
          DocCode('BsTable'),
          ' in a cell to nest it. Borders, accents and variants of the table '
              'around it are not inherited by the one inside, which has only '
              'what you give it.',
        ]),
        DocExample(
          code: '''
BsTable(
  striped: true,
  bordered: true,
  columns: columns,
  rows: [
    BsTableRow(cells: [Text('1', style: bold), Text('Mark'), Text('Otto'), Text('@mdo')]),
    BsTableRow(
      cells: [
        Text('2', style: bold),
        Text('Jacob'),
        Text('Thornton'),
        BsTable(
          columns: [Text('Heading'), Text('Heading')],
          rows: [
            BsTableRow(cells: [Text('Cell'), Text('Cell')]),
            BsTableRow(cells: [Text('Cell'), Text('Cell')]),
          ],
        ),
      ],
    ),
    BsTableRow(cells: [Text('3', style: bold), Text('Larry'), Text('the Bird'), Text('@twitter')]),
  ],
)''',
          preview: BsTable(
            striped: true,
            bordered: true,
            columns: _columns,
            rows: [
              _rows[0],
              const BsTableRow(
                cells: [
                  Text('2', style: _bold),
                  Text('Jacob'),
                  Text('Thornton'),
                  BsTable(
                    columns: [Text('Heading'), Text('Heading')],
                    rows: [
                      BsTableRow(cells: [Text('Cell'), Text('Cell')]),
                      BsTableRow(cells: [Text('Cell'), Text('Cell')]),
                    ],
                  ),
                ],
              ),
              _rows[2],
            ],
          ),
        ),
        const DocHeading('Anatomy'),
        const DocHeading('Table head', sub: true),
        DocText([
          'The cells of ',
          DocCode('columns'),
          ' are the head. Bootstrap can make the head of a table light or '
              'dark gray with ',
          DocCode('.table-light'),
          ' or ',
          DocCode('.table-dark'),
          '; here the head takes the look of the table around it, and only '
              'the whole table can be ',
          DocCode('dark'),
          ', as shown above.',
        ]),
        const DocHeading('Table foot', sub: true),
        DocText([
          'A table has no foot of its own either: add the rows of one to ',
          DocCode('rows'),
          ', and start the group with ',
          DocCode('groupStart'),
          ' if you want it set apart.',
        ]),
        DocExample(
          code: '''
BsTable(
  columns: columns,
  rows: [
    ...rows,
    BsTableRow(
      groupStart: true,
      cells: [Text('Footer'), Text('Footer'), Text('Footer'), Text('Footer')],
    ),
  ],
)''',
          preview: const BsTable(
            columns: _columns,
            rows: [
              ..._rows,
              BsTableRow(
                groupStart: true,
                cells: [
                  Text('Footer'),
                  Text('Footer'),
                  Text('Footer'),
                  Text('Footer'),
                ],
              ),
            ],
          ),
        ),
        const DocHeading('Captions', sub: true),
        DocText([
          'A caption is a heading for a table: a widget under the table, in ',
          DocCode('caption'),
          ', in the muted color. It helps people find the table and decide '
              'if they want to read it. There is no ',
          DocCode('.caption-top'),
          ' to put it above; place a ',
          DocCode('Text'),
          ' over the table for that.',
        ]),
        DocExample(
          code: '''
BsTable(
  small: true,
  caption: Text('List of users'),
  columns: columns,
  rows: rows,
)''',
          preview: const BsTable(
            small: true,
            caption: Text('List of users'),
            columns: _columns,
            rows: _rows,
          ),
        ),
        const DocHeading('Responsive tables'),
        DocText([
          'Responsive tables allow tables to be scrolled horizontally with '
              'ease. There is no class for it. Wrap the table in a ',
          DocCode('SingleChildScrollView'),
          ' with ',
          DocCode('scrollDirection: Axis.horizontal'),
          ', which lets the table be as wide as its content, and a ',
          DocCode('ConstrainedBox'),
          ' with the width of the space as its ',
          DocCode('minWidth'),
          ', so that a table narrower than the space still fills it, as '
              'Bootstrap\'s does.',
        ]),
        const DocHeading('Always responsive', sub: true),
        DocText([
          'Across every breakpoint, scroll a table that is wider than the space:',
        ]),
        DocExample(
          code: '''
LayoutBuilder(
  builder: (context, constraints) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: ConstrainedBox(
      constraints: BoxConstraints(minWidth: constraints.maxWidth),
      child: BsTable(
        columns: [for (var i = 0; i < 12; i++) Text('Heading')],
        rows: [
          for (var row = 0; row < 3; row++)
            BsTableRow(cells: [for (var i = 0; i < 12; i++) Text('Cell')]),
        ],
      ),
    ),
  ),
)''',
          preview: const _ResponsiveTable(scrolls: true, columns: 12),
        ),
        const DocHeading('Breakpoint specific', sub: true),
        DocText([
          'For ',
          DocCode('.table-responsive-md'),
          ' and the others, scroll only below a breakpoint, and let the table '
              'be as it is from there up. Read the breakpoint (see ',
          DocLink.page('Breakpoints', 'Layout', 'Breakpoints'),
          '): a table scrolls while ',
          DocCode('breakpoint.index < BsBreakpoint.md.index'),
          ', and the same goes for ',
          DocCode('sm'),
          ', ',
          DocCode('lg'),
          ', ',
          DocCode('xl'),
          ' and ',
          DocCode('xxl'),
          '.',
        ]),
        DocExample(
          code: '''
@override
Widget build(BuildContext context) {
  final breakpoint = BsBreakpoint.forWidth(MediaQuery.sizeOf(context).width);
  final table = BsTable(...);

  if (breakpoint.index >= BsBreakpoint.md.index) return table;

  return LayoutBuilder(
    builder: (context, constraints) => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: ConstrainedBox(
        constraints: BoxConstraints(minWidth: constraints.maxWidth),
        child: table,
      ),
    ),
  );
}''',
          preview: const _ResponsiveTable(scrolls: false, columns: 8),
        ),
        const DocHeading('Customizing'),
        DocText([
          'The look of a table is the fields of a ',
          DocCode('BsTableStyle'),
          ', given as the ',
          DocCode('style'),
          ' of a table and layered over the defaults, which are the dark ones '
              'in dark mode. All fields are optional.',
        ]),
        DocExample(
          code: '''
BsTable(
  striped: true,
  style: BsTableStyle(
    cellPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    stripedBackgroundOpacity: 0.1,
  ),
  columns: columns,
  rows: rows,
)''',
          preview: const BsTable(
            striped: true,
            style: BsTableStyle(
              cellPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              stripedBackgroundOpacity: 0.1,
            ),
            columns: _columns,
            rows: _rows,
          ),
        ),
        DocTable(
          headers: ['Bootstrap (Sass)', 'BsTableStyle', 'Default'],
          rows: [
            [
              r'$table-cell-padding-y, $table-cell-padding-x',
              'cellPadding',
              '${_number(BsTableStyle.defaultCellPadding.left)} on every side',
            ],
            [
              r'$table-cell-padding-y-sm, $table-cell-padding-x-sm',
              'cellPaddingSm',
              '${_number(BsTableStyle.defaultCellPaddingSm.left)} on every '
                  'side',
            ],
            [
              r'$table-color',
              'color',
              'The emphasis color: black, white in dark mode',
            ],
            [
              r'$table-bg',
              'background',
              'The body background: white, the dark one in dark mode',
            ],
            [r'$table-accent-bg', 'accentBackground', 'Transparent'],
            [r'$table-striped-color', 'stripedColor', 'The color of the table'],
            [
              r'$table-striped-bg-factor',
              'stripedBackgroundOpacity',
              _number(BsTableStyle.defaultStripedBackgroundOpacity),
            ],
            [r'$table-active-color', 'activeColor', 'The color of the table'],
            [
              r'$table-active-bg-factor',
              'activeBackgroundOpacity',
              _number(BsTableStyle.defaultActiveBackgroundOpacity),
            ],
            [r'$table-hover-color', 'hoverColor', 'The color of the table'],
            [
              r'$table-hover-bg-factor',
              'hoverBackgroundOpacity',
              _number(BsTableStyle.defaultHoverBackgroundOpacity),
            ],
            [
              r'$table-border-width',
              'borderWidth',
              _number(BsTableStyle.defaultBorderWidth),
            ],
            [
              r'$table-border-color',
              'borderColor',
              'Gray 300, gray 700 in dark mode',
            ],
            [
              r'$table-caption-color',
              'captionColor',
              'The secondary color of the body',
            ],
          ],
        ),
        DocText([
          'The other variables are not options. A cell is aligned to the top '
              'and a head cell to the bottom, a head cell is bold, the divider '
              'between groups is in the text color, the rules of a dark table '
              'and of a colored row are the text color mixed 20% into the '
              'background, and a colored row has the subtle color of its '
              'variant (see ',
          DocLink.page('Colors', 'Customize', 'Color'),
          ').',
        ]),
      ],
    );
  }
}

class _ResponsiveTable extends StatelessWidget {
  const _ResponsiveTable({required this.scrolls, required this.columns});

  /// Scrolls at any width, or only below `md`.
  final bool scrolls;

  final int columns;

  @override
  Widget build(BuildContext context) {
    final breakpoint = BsBreakpoint.forWidth(MediaQuery.sizeOf(context).width);
    final table = BsTable(
      columns: [for (var i = 0; i < columns; i++) const Text('Heading')],
      rows: [
        for (var row = 0; row < 3; row++)
          BsTableRow(
            cells: [for (var i = 0; i < columns; i++) const Text('Cell')],
          ),
      ],
    );

    if (!scrolls && breakpoint.index >= BsBreakpoint.md.index) return table;

    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(minWidth: constraints.maxWidth),
          child: table,
        ),
      ),
    );
  }
}
