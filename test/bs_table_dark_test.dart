import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  testWidgets(
    'a dark table lightens its stripes and mixes its rules from white, as in Bootstrap',
    (tester) async {
      await tester.pumpWidget(
        const BsApp(
          home: Align(
            alignment: Alignment.topLeft,
            child: BsTable(
              dark: true,
              striped: true,
              rows: [
                BsTableRow(cells: [Text('a')]),
                BsTableRow(cells: [Text('b')]),
              ],
            ),
          ),
        ),
      );

      final table = tester.widget<Table>(find.byType(Table));
      double red(int i) =>
          ((table.children[i].decoration! as dynamic).color as Color).r;
      expect(red(0), greaterThan(red(1)));
      final rule = table.border!.bottom.color;
      expect(rule.r * 255, closeTo(0x4D, 1));
      expect(rule.g * 255, closeTo(0x51, 1));
      expect(rule.b * 255, closeTo(0x54, 1));
    },
  );

  testWidgets('striped variant rows get a black tint in dark mode too', (
    tester,
  ) async {
    await tester.pumpWidget(
      const BsApp(
        brightness: Brightness.dark,
        home: Align(
          alignment: Alignment.topLeft,
          child: BsTable(
            striped: true,
            rows: [
              BsTableRow(variant: BsVariant.success, cells: [Text('a')]),
              BsTableRow(variant: BsVariant.success, cells: [Text('b')]),
            ],
          ),
        ),
      ),
    );

    final table = tester.widget<Table>(find.byType(Table));
    double red(int i) =>
        ((table.children[i].decoration! as dynamic).color as Color).r;
    expect(red(0), lessThan(red(1)));
  });
}
