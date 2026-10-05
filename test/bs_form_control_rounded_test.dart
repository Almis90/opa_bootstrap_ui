import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  BorderRadius radiusOf(WidgetTester tester) {
    final box = tester.widget<BsDecoratedBox>(
      find
          .descendant(
            of: find.byType(BsFormControl),
            matching: find.byType(BsDecoratedBox),
          )
          .first,
    );
    return (box.decoration as BoxDecoration).borderRadius! as BorderRadius;
  }

  // `.rounded-bottom-0` on the email input of the sign-in form's stacked pair.
  testWidgets('BsFormControl roundedTop/roundedBottom square one side only', (
    tester,
  ) async {
    await tester.pumpWidget(
      const BsApp(home: BsFormControl(roundedBottom: BsRounded.r0)),
    );
    final radius = radiusOf(tester);
    expect(radius.topLeft, const Radius.circular(6));
    expect(radius.topRight, const Radius.circular(6));
    expect(radius.bottomLeft, Radius.zero);
    expect(radius.bottomRight, Radius.zero);
  });

  testWidgets('BsFormFloating passes the corner overrides through', (
    tester,
  ) async {
    await tester.pumpWidget(
      const BsApp(
        home: BsFormFloating(label: Text('Password'), roundedTop: BsRounded.r0),
      ),
    );
    final radius = radiusOf(tester);
    expect(radius.topLeft, Radius.zero);
    expect(radius.bottomLeft, const Radius.circular(6));
  });
}
