import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  Future<void> pump(WidgetTester tester, {required double dpr}) async {
    tester.view.physicalSize = Size(200 * dpr, 200 * dpr);
    tester.view.devicePixelRatio = dpr;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(left: 10.4, top: 10.4),
            child: SizedBox(
              width: 50.2,
              height: 20.3,
              child: BsDecoratedBox(
                decoration: BoxDecoration(color: Color(0xFF000000)),
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('paints its edges on whole device pixels (1x)', (tester) async {
    await pump(tester, dpr: 1);
    // On screen: 10.4 → 10, 10.4 + 50.2 = 60.6 → 61; 10.4 → 10,
    // 10.4 + 20.3 = 30.7 → 31 (the rectangle is relative to the box).
    expect(
      find.byType(BsDecoratedBox),
      paints
        ..rect(rect: Rect.fromLTRB(10 - 10.4, 10 - 10.4, 61 - 10.4, 31 - 10.4)),
    );
  });

  testWidgets('and on device pixels, not CSS pixels, at 2x', (tester) async {
    await pump(tester, dpr: 2);
    // On screen, in device pixels: 20.8 → 21 (10.5), 121.2 → 121 (60.5);
    // 20.8 → 21 (10.5), 61.4 → 61 (30.5).
    expect(
      find.byType(BsDecoratedBox),
      paints..rect(
        rect: Rect.fromLTRB(10.5 - 10.4, 10.5 - 10.4, 60.5 - 10.4, 30.5 - 10.4),
      ),
    );
  });

  testWidgets('does not change the box layout', (tester) async {
    await pump(tester, dpr: 1);
    final rect = tester.getRect(find.byType(BsDecoratedBox));
    expect(rect.left, closeTo(10.4, 1e-9));
    expect(rect.width, closeTo(50.2, 1e-9));
    expect(rect.height, closeTo(20.3, 1e-9));
  });
}
