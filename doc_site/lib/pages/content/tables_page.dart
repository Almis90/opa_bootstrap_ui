import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

const _columns = [Text('#'), Text('First'), Text('Last'), Text('Handle')];

const _rows = [
  BsTableRow(cells: [Text('1'), Text('Mark'), Text('Otto'), Text('@mdo')]),
  BsTableRow(cells: [Text('2'), Text('Jacob'), Text('Thornton'), Text('@fat')]),
  BsTableRow(cells: [Text('3'), Text('Larry'), Text('the Bird'), Text('@twitter')]),
];

class TablesPage extends StatelessWidget {
  const TablesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Tables',
      lead:
          'BsTable renders columns and BsTableRow entries with Flutter\'s Table widget, giving Bootstrap\'s '
          'row and cell modifiers — striped, bordered, hover, size, and dark — as simple boolean flags.',
      examples: [
        const DocExample(
          title: 'Basic',
          description: 'columns supplies an optional header row, rows a list of BsTableRow entries.',
          code: '''
BsTable(
  columns: [Text('#'), Text('First'), Text('Last'), Text('Handle')],
  rows: [
    BsTableRow(cells: [Text('1'), Text('Mark'), Text('Otto'), Text('@mdo')]),
    BsTableRow(cells: [Text('2'), Text('Jacob'), Text('Thornton'), Text('@fat')]),
    BsTableRow(cells: [Text('3'), Text('Larry'), Text('the Bird'), Text('@twitter')]),
  ],
)''',
          preview: BsTable(columns: _columns, rows: _rows),
        ),
        const DocExample(
          title: 'Striped',
          description: 'striped: true tints every other row.',
          code: "BsTable(columns: _columns, rows: _rows, striped: true)",
          preview: BsTable(columns: _columns, rows: _rows, striped: true),
        ),
        const DocExample(
          title: 'Bordered',
          description: 'bordered: true draws borders around every cell, not just between rows.',
          code: "BsTable(columns: _columns, rows: _rows, bordered: true)",
          preview: BsTable(columns: _columns, rows: _rows, bordered: true),
        ),
        const DocExample(
          title: 'Borderless',
          description: 'borderless: true removes all borders, including the horizontal rules between rows.',
          code: "BsTable(columns: _columns, rows: _rows, borderless: true)",
          preview: BsTable(columns: _columns, rows: _rows, borderless: true),
        ),
        const DocExample(
          title: 'Hover',
          description: 'hover: true tints whichever row the pointer is over. Move your pointer over the rows to see it.',
          code: "BsTable(columns: _columns, rows: _rows, hover: true)",
          preview: BsTable(columns: _columns, rows: _rows, hover: true),
        ),
        const DocExample(
          title: 'Small',
          description: 'small: true halves the cell padding for a more compact table.',
          code: "BsTable(columns: _columns, rows: _rows, small: true)",
          preview: BsTable(columns: _columns, rows: _rows, small: true),
        ),
        const DocExample(
          title: 'Dark',
          description: 'dark: true inverts the table to a dark background with light text.',
          code: "BsTable(columns: _columns, rows: _rows, dark: true)",
          preview: BsTable(columns: _columns, rows: _rows, dark: true),
        ),
        DocExample(
          title: 'Variants',
          description: 'Each BsTableRow can take a BsVariant for a tinted background, or active: true to darken it.',
          code: '''
BsTable(
  columns: _columns,
  rows: [
    BsTableRow(cells: [...], variant: BsVariant.primary),
    BsTableRow(cells: [...], variant: BsVariant.success),
    BsTableRow(cells: [...], variant: BsVariant.danger),
    BsTableRow(cells: [...], active: true),
  ],
)''',
          preview: BsTable(
            columns: _columns,
            rows: const [
              BsTableRow(
                cells: [Text('1'), Text('Mark'), Text('Otto'), Text('@mdo')],
                variant: BsVariant.primary,
              ),
              BsTableRow(
                cells: [Text('2'), Text('Jacob'), Text('Thornton'), Text('@fat')],
                variant: BsVariant.success,
              ),
              BsTableRow(
                cells: [Text('3'), Text('Larry'), Text('the Bird'), Text('@twitter')],
                variant: BsVariant.danger,
              ),
              BsTableRow(
                cells: [Text('4'), Text('Active'), Text('row'), Text('@active')],
                active: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
