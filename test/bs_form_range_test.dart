import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  // BsApp wraps WidgetsApp's Localizations, which installs its own
  // Directionality resolved from the locale — an outer Directionality
  // ancestor wouldn't reach BsFormRange at all, so the override has to sit
  // inside `home`, past where Localizations already set one up.
  Widget buildRange({required TextDirection textDirection, required ValueChanged<double> onChanged}) {
    return BsApp(
      home: Directionality(
        textDirection: textDirection,
        child: SizedBox(width: 300, child: BsFormRange(value: 50, min: 0, max: 100, onChanged: onChanged)),
      ),
    );
  }

  testWidgets('LTR: tapping near the left edge reports a low value, near the right a high value', (tester) async {
    final values = <double>[];
    await tester.pumpWidget(buildRange(textDirection: TextDirection.ltr, onChanged: values.add));

    final rangeRect = tester.getRect(find.byType(BsFormRange));
    await tester.tapAt(Offset(rangeRect.left + 5, rangeRect.center.dy));
    await tester.tapAt(Offset(rangeRect.right - 5, rangeRect.center.dy));

    expect(values.length, 2);
    expect(values[0], lessThan(20));
    expect(values[1], greaterThan(80));
  });

  testWidgets('RTL: tapping near the left edge reports a high value, near the right a low value', (tester) async {
    final values = <double>[];
    await tester.pumpWidget(buildRange(textDirection: TextDirection.rtl, onChanged: values.add));

    final rangeRect = tester.getRect(find.byType(BsFormRange));
    await tester.tapAt(Offset(rangeRect.left + 5, rangeRect.center.dy));
    await tester.tapAt(Offset(rangeRect.right - 5, rangeRect.center.dy));

    expect(values.length, 2);
    expect(values[0], greaterThan(80));
    expect(values[1], lessThan(20));
  });

  testWidgets('RTL: the thumb renders on the physical left for a low value (its start side)', (tester) async {
    await tester.pumpWidget(
      BsApp(
        home: Directionality(
          textDirection: TextDirection.rtl,
          child: SizedBox(width: 300, child: BsFormRange(value: 0, min: 0, max: 100, onChanged: (_) {})),
        ),
      ),
    );

    final rangeRect = tester.getRect(find.byType(BsFormRange));
    final thumbRect = tester.getRect(find.byType(PositionedDirectional));
    // value: 0 sits at the start edge, which in RTL is the physical right.
    expect(thumbRect.center.dx, greaterThan(rangeRect.center.dx));
  });
}
