import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  testWidgets(
    'cells sit at the top of a row and head cells at the bottom, as in Bootstrap',
    (tester) async {
      await tester.pumpWidget(
        const BsApp(
          home: Align(
            alignment: Alignment.topLeft,
            child: BsTable(
              columns: [
                Text('Short head'),
                SizedBox(width: 40, height: 60, child: Text('Tall head')),
              ],
              rows: [
                BsTableRow(
                  cells: [
                    Text('Short'),
                    SizedBox(width: 40, height: 60, child: Text('Tall')),
                  ],
                ),
              ],
            ),
          ),
        ),
      );

      final tall = tester.getRect(find.text('Tall'));
      final short = tester.getRect(find.text('Short'));
      expect(short.top, tall.top);

      final tallHead = tester.getRect(find.text('Tall head'));
      final shortHead = tester.getRect(find.text('Short head'));
      expect(shortHead.bottom, closeTo(tallHead.bottom, 20));
      expect(shortHead.top, greaterThan(tallHead.top + 20));
    },
  );
}
