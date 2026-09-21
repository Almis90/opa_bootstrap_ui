import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'demo_page.dart';

const _responsiveColumns = BsResponsiveValue<String>(xs: '1 column', sm: '2 columns', md: '3 columns', lg: '4 columns', xl: '6 columns');

class BreakpointsPage extends StatelessWidget {
  const BreakpointsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Breakpoints',
      children: [
        DemoSection(
          title: 'Current breakpoint (resize the window)',
          child: LayoutBuilder(
            builder: (context, constraints) {
              final breakpoint = BsBreakpoint.forWidth(constraints.maxWidth);
              return Text(
                'Available width: ${constraints.maxWidth.toStringAsFixed(0)}px  →  '
                '${breakpoint.name} (applies at ≥${breakpoint.minWidth.toStringAsFixed(0)}px)',
              );
            },
          ),
        ),
        DemoSection(
          title: 'BsResponsiveValue resolution',
          child: LayoutBuilder(
            builder: (context, constraints) {
              final resolved = _responsiveColumns.resolveForWidth(constraints.maxWidth);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'BsResponsiveValue(xs: "1 column", sm: "2 columns", md: "3 columns", '
                    'lg: "4 columns", xl: "6 columns")',
                  ),
                  const SizedBox(height: 8),
                  Text('Resolved at the current width: $resolved'),
                ],
              );
            },
          ),
        ),
        DemoSection(title: 'BsBreakpoint values', child: _BreakpointTable()),
        DemoSection(title: 'BsGrid tokens', child: _GridTokenTable()),
      ],
    );
  }
}

class _BreakpointTable extends StatelessWidget {
  const _BreakpointTable();

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {0: FlexColumnWidth(1), 1: FlexColumnWidth(1.4), 2: FlexColumnWidth(1.6)},
      border: TableBorder.all(color: BsBorders.color),
      children: [
        _headerRow(const ['Breakpoint', 'Min width', 'Container max-width']),
        for (final breakpoint in BsBreakpoint.values)
          _row([
            breakpoint.name,
            '${breakpoint.minWidth.toStringAsFixed(0)}px',
            BsGrid.containerMaxWidthFor(breakpoint) == null
                ? 'none (fluid)'
                : '${BsGrid.containerMaxWidthFor(breakpoint)!.toStringAsFixed(0)}px',
          ]),
      ],
    );
  }

  TableRow _headerRow(List<String> cells) {
    return TableRow(
      decoration: const BoxDecoration(color: BsColors.gray100),
      children: [for (final cell in cells) _cell(cell, bold: true)],
    );
  }

  TableRow _row(List<String> cells) {
    return TableRow(children: [for (final cell in cells) _cell(cell)]);
  }

  Widget _cell(String text, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text(text, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
    );
  }
}

class _GridTokenTable extends StatelessWidget {
  const _GridTokenTable();

  @override
  Widget build(BuildContext context) {
    final rows = <(String, String)>[
      ('BsGrid.columns', '${BsGrid.columns}'),
      ('BsGrid.gutterWidth', '${BsGrid.gutterWidth}px'),
      ('BsGrid.rowColumns', '${BsGrid.rowColumns}'),
      ('BsGrid.containerPaddingX', '${BsGrid.containerPaddingX}px'),
    ];

    return Table(
      columnWidths: const {0: FlexColumnWidth(1.4), 1: FlexColumnWidth(1)},
      border: TableBorder.all(color: BsBorders.color),
      children: [
        for (final (token, value) in rows)
          TableRow(
            children: [
              Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), child: Text(token)),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), child: Text(value)),
            ],
          ),
      ],
    );
  }
}
