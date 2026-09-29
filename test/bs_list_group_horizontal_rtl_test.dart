import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  Widget buildGroup(TextDirection textDirection) {
    return BsApp(
      home: Directionality(
        textDirection: textDirection,
        child: SizedBox(
          width: 400,
          child: BsListGroup(
            orientation: BsListGroupOrientation.horizontal,
            items: const [
              BsListGroupItem(child: Text('One')),
              BsListGroupItem(child: Text('Two')),
              BsListGroupItem(child: Text('Three')),
            ],
          ),
        ),
      ),
    );
  }

  // A middle item (squared off on every corner — a style: none side plus a
  // geometrically-zero borderRadius) is exactly the combination that
  // crashed inside BorderDirectional.paint() before the null-borderRadius
  // workaround; three or more horizontal items is the minimum repro.
  testWidgets('LTR: three horizontal items render without error, in list order', (tester) async {
    await tester.pumpWidget(buildGroup(TextDirection.ltr));
    expect(tester.takeException(), isNull);

    final oneRect = tester.getRect(find.text('One'));
    final threeRect = tester.getRect(find.text('Three'));
    expect(oneRect.left, lessThan(threeRect.left));
  });

  testWidgets('RTL: three horizontal items render without error, first at the physical right', (tester) async {
    await tester.pumpWidget(buildGroup(TextDirection.rtl));
    expect(tester.takeException(), isNull);

    final oneRect = tester.getRect(find.text('One'));
    final threeRect = tester.getRect(find.text('Three'));
    expect(oneRect.left, greaterThan(threeRect.left));
  });
}
