import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  testWidgets('a validated BsFormControl shows the feedback icon', (
    tester,
  ) async {
    await tester.pumpWidget(
      const BsApp(home: Center(child: BsFormControl(valid: false))),
    );
    expect(find.byType(BsValidationIcon), findsOneWidget);
    expect(
      tester.widget<BsValidationIcon>(find.byType(BsValidationIcon)).valid,
      isFalse,
    );
  });

  testWidgets('an unvalidated BsFormControl shows none', (tester) async {
    await tester.pumpWidget(const BsApp(home: Center(child: BsFormControl())));
    expect(find.byType(BsValidationIcon), findsNothing);
  });

  testWidgets('BsFormSelect valid shows the icon too', (tester) async {
    await tester.pumpWidget(
      BsApp(
        home: Center(
          child: SizedBox(
            width: 300,
            child: BsFormSelect<int>(
              valid: true,
              value: null,
              items: const [BsFormSelectItem(value: 1, label: Text('One'))],
              onChanged: (_) {},
              placeholder: const Text('Choose...'),
            ),
          ),
        ),
      ),
    );
    expect(find.byType(BsValidationIcon), findsOneWidget);
  });

  testWidgets('BsFormCheck valid colors its label', (tester) async {
    await tester.pumpWidget(
      BsApp(
        home: Center(
          child: BsFormCheck(
            valid: true,
            value: false,
            onChanged: (_) {},
            label: const Text('Remember'),
          ),
        ),
      ),
    );
    final style = DefaultTextStyle.of(tester.element(find.text('Remember')));
    expect(style.style.color, BsVariant.success.color);
  });
}
