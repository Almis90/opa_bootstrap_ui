import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  testWidgets(
    '.table-dark and .table-light rows are the theme colors, with their own text color',
    (tester) async {
      await tester.pumpWidget(
        BsApp(
          home: Align(
            alignment: Alignment.topLeft,
            child: BsTable(
              columns: const [Text('Head')],
              rows: [
                const BsTableRow(cells: [Text('Plain')]),
                const BsTableRow(
                  variant: BsVariant.primary,
                  cells: [Text('Primary')],
                ),
                const BsTableRow(
                  variant: BsVariant.light,
                  cells: [Text('Light')],
                ),
                const BsTableRow(
                  variant: BsVariant.dark,
                  cells: [Text('Dark')],
                ),
              ],
            ),
          ),
        ),
      );

      final rows = tester.widget<Table>(find.byType(Table)).children;
      Color rowColor(int i) => (rows[i].decoration! as dynamic).color as Color;
      Color? textColor(String text) => tester
          .widget<DefaultTextStyle>(
            find
                .ancestor(
                  of: find.text(text),
                  matching: find.byType(DefaultTextStyle),
                )
                .first,
          )
          .style
          .color;

      // rows: 0 header, 1 plain, 2 primary, 3 light, 4 dark
      expect(rowColor(2), BsVariant.primary.bgSubtle);
      expect(textColor('Primary'), BsColors.black);
      expect(rowColor(3), BsColors.gray100);
      expect(textColor('Light'), BsColors.black);
      expect(rowColor(4), BsColors.gray900);
      expect(textColor('Dark'), BsColors.white);
    },
  );
}
