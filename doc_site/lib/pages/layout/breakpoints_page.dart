import 'package:flutter/widgets.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import '../../src/doc_example.dart';
import '../../src/doc_page.dart';

const _responsiveColumns = BsResponsiveValue<String>(xs: '1 column', sm: '2 columns', md: '3 columns', lg: '4 columns', xl: '6 columns');

class BreakpointsPage extends StatelessWidget {
  const BreakpointsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DocPage(
      title: 'Breakpoints',
      lead:
          'BsBreakpoint mirrors Bootstrap\'s six breakpoints, and BsResponsiveValue resolves a '
          'value that differs per breakpoint against the current width — the building blocks '
          'behind BsContainer and BsGrid.',
      examples: [
        DocExample(
          title: 'Current breakpoint',
          description: 'BsBreakpoint.forWidth resolves the active breakpoint for a given width. Resize the window to see it change.',
          code: '''
LayoutBuilder(
  builder: (context, constraints) {
    final breakpoint = BsBreakpoint.forWidth(constraints.maxWidth);
    return Text('\${breakpoint.name} (applies at >= \${breakpoint.minWidth}px)');
  },
)''',
          preview: LayoutBuilder(
            builder: (context, constraints) {
              final breakpoint = BsBreakpoint.forWidth(constraints.maxWidth);
              return Text(
                'Available width: ${constraints.maxWidth.toStringAsFixed(0)}px  →  '
                '${breakpoint.name} (applies at ≥${breakpoint.minWidth.toStringAsFixed(0)}px)',
              );
            },
          ),
        ),
        DocExample(
          title: 'BsResponsiveValue resolution',
          description: 'Give each breakpoint its own value and read back whichever one applies at the current width.',
          code: '''
const columns = BsResponsiveValue<String>(
  xs: '1 column', sm: '2 columns', md: '3 columns', lg: '4 columns', xl: '6 columns',
);

columns.resolveForWidth(constraints.maxWidth)''',
          preview: LayoutBuilder(
            builder: (context, constraints) {
              final resolved = _responsiveColumns.resolveForWidth(constraints.maxWidth);
              return Text('Resolved at the current width: $resolved');
            },
          ),
        ),
        DocExample(title: 'Breakpoint reference', preview: const _BreakpointTable(), code: 'for (final breakpoint in BsBreakpoint.values) ...'),
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
            BsGrid.containerMaxWidthFor(breakpoint) == null ? 'none (fluid)' : '${BsGrid.containerMaxWidthFor(breakpoint)!.toStringAsFixed(0)}px',
          ]),
      ],
    );
  }

  TableRow _headerRow(List<String> cells) {
    return TableRow(decoration: const BoxDecoration(color: BsColors.gray100), children: [for (final cell in cells) _cell(cell, bold: true)]);
  }

  TableRow _row(List<String> cells) => TableRow(children: [for (final cell in cells) _cell(cell)]);

  Widget _cell(String text, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Text(text, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
    );
  }
}
