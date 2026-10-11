import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  testWidgets(
    "a select's menu is at least as wide as the control, as a <select>'s list is",
    (tester) async {
      await tester.pumpWidget(
        BsApp(
          home: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 400,
              child: BsFormSelect<String>(
                value: 'a',
                onChanged: (_) {},
                items: const [
                  BsFormSelectItem(value: 'a', label: Text('A')),
                  BsFormSelectItem(value: 'b', label: Text('B')),
                ],
              ),
            ),
          ),
        ),
      );

      final control = tester.getSize(find.byType(BsFormSelect<String>)).width;
      expect(control, 400);

      await tester.tap(find.byType(BsFormSelect<String>));
      await tester.pumpAndSettle();

      // An option's row spans the menu's width (less its 1px borders).
      final row = find
          .ancestor(of: find.text('B'), matching: find.byType(DecoratedBox))
          .first;
      expect(tester.getSize(row).width, closeTo(control, 2));
    },
  );
}
