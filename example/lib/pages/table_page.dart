import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'demo_page.dart';

const _columns = [Text('#'), Text('First'), Text('Last'), Text('Handle')];

const _rows = [
  BsTableRow(cells: [Text('1'), Text('Mark'), Text('Otto'), Text('@mdo')]),
  BsTableRow(cells: [Text('2'), Text('Jacob'), Text('Thornton'), Text('@fat')]),
  BsTableRow(
    cells: [Text('3'), Text('Larry'), Text('the Bird'), Text('@twitter')],
  ),
];

class TablePage extends StatelessWidget {
  const TablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Tables',
      children: [
        const DemoSection(
          title: 'Basic',
          child: BsTable(columns: _columns, rows: _rows),
        ),
        const DemoSection(
          title: 'Striped',
          child: BsTable(columns: _columns, rows: _rows, striped: true),
        ),
        const DemoSection(
          title: 'Bordered',
          child: BsTable(columns: _columns, rows: _rows, bordered: true),
        ),
        const DemoSection(
          title: 'Borderless',
          child: BsTable(columns: _columns, rows: _rows, borderless: true),
        ),
        const DemoSection(
          title: 'Hover (move the pointer over a row)',
          child: BsTable(columns: _columns, rows: _rows, hover: true),
        ),
        const DemoSection(
          title: 'Small',
          child: BsTable(columns: _columns, rows: _rows, small: true),
        ),
        const DemoSection(
          title: 'Dark',
          child: BsTable(columns: _columns, rows: _rows, dark: true),
        ),
        DemoSection(
          title: 'Variants',
          child: BsTable(
            columns: _columns,
            rows: [
              const BsTableRow(
                cells: [Text('1'), Text('Mark'), Text('Otto'), Text('@mdo')],
                variant: BsVariant.primary,
              ),
              const BsTableRow(
                cells: [
                  Text('2'),
                  Text('Jacob'),
                  Text('Thornton'),
                  Text('@fat'),
                ],
                variant: BsVariant.success,
              ),
              const BsTableRow(
                cells: [
                  Text('3'),
                  Text('Larry'),
                  Text('the Bird'),
                  Text('@twitter'),
                ],
                variant: BsVariant.danger,
              ),
              const BsTableRow(
                cells: [
                  Text('4'),
                  Text('Active'),
                  Text('row'),
                  Text('@active'),
                ],
                active: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
