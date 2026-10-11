import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  // The focus ring is the thumb's box shadow: a halo of the page's background
  // and the .25rem ring.
  int thumbShadows(WidgetTester tester) {
    final thumbs = tester
        .widgetList<BsDecoratedContainer>(find.byType(BsDecoratedContainer))
        .where((w) => w.width == 16 && w.height == 16);
    final decoration = thumbs.single.decoration! as BoxDecoration;
    return decoration.boxShadow?.length ?? 0;
  }

  testWidgets(
    'a clicked range keeps its focus ring (:focus), and the keys move it like a native range',
    (tester) async {
      var value = 50.0;
      late StateSetter setState;
      await tester.pumpWidget(
        BsApp(
          home: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 300,
              child: StatefulBuilder(
                builder: (context, setter) {
                  setState = setter;
                  return BsFormRange(
                    value: value,
                    onChanged: (v) => setState(() => value = v),
                  );
                },
              ),
            ),
          ),
        ),
      );
      expect(thumbShadows(tester), 0);

      await tester.tap(find.byType(BsFormRange));
      await tester.pump();
      expect(thumbShadows(tester), 2, reason: 'a 1px halo and the ring');

      value = 50;
      setState(() {});
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pump();
      expect(value, 51);
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pump();
      expect(value, 50);
      await tester.sendKeyEvent(LogicalKeyboardKey.pageUp);
    await tester.pump();
      expect(value, 60);
      await tester.sendKeyEvent(LogicalKeyboardKey.end);
    await tester.pump();
      expect(value, 100);
      await tester.sendKeyEvent(LogicalKeyboardKey.home);
    await tester.pump();
      expect(value, 0);
    },
  );

  testWidgets('a disabled range ignores keys and never shows the ring', (
    tester,
  ) async {
    await tester.pumpWidget(
      const BsApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 300,
            child: BsFormRange(value: 50, onChanged: null),
          ),
        ),
      ),
    );
    await tester.tap(find.byType(BsFormRange));
    await tester.pump();
    expect(thumbShadows(tester), 0);
  });
}
