import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  Widget buildGroup(TextDirection textDirection) {
    return BsApp(
      home: Directionality(
        textDirection: textDirection,
        child: BsButtonGroup(
          children: [
            BsButton(onPressed: () {}, child: const Text('One')),
            BsButton(onPressed: () {}, child: const Text('Two')),
            BsButton(onPressed: () {}, child: const Text('Three')),
          ],
        ),
      ),
    );
  }

  testWidgets('LTR: renders three buttons without error, first at the physical left', (tester) async {
    await tester.pumpWidget(buildGroup(TextDirection.ltr));
    expect(tester.takeException(), isNull);

    final oneRect = tester.getRect(find.text('One'));
    final threeRect = tester.getRect(find.text('Three'));
    expect(oneRect.left, lessThan(threeRect.left));
  });

  testWidgets('RTL: renders three buttons without error, first at the physical right', (tester) async {
    await tester.pumpWidget(buildGroup(TextDirection.rtl));
    expect(tester.takeException(), isNull);

    final oneRect = tester.getRect(find.text('One'));
    final threeRect = tester.getRect(find.text('Three'));
    expect(oneRect.left, greaterThan(threeRect.left));
  });
}
