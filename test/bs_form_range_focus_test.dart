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

  testWidgets(
    'values land on multiples of step, like a native range (the thumb moves in jumps)',
    (tester) async {
      final values = <double>[];
      await tester.pumpWidget(
        BsApp(
          home: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 300,
              child: BsFormRange(
                value: 0,
                min: 0,
                max: 5,
                step: 0.5,
                onChanged: values.add,
              ),
            ),
          ),
        ),
      );
      final left = tester.getTopLeft(find.byType(BsFormRange));
      // Usable track: 300 less the 16px thumb, offset by half of it.
      Future<void> tapAtFraction(double t) async {
        await tester.tapAt(left + Offset(8 + t * 284, 12));
        await tester.pump();
      }

      await tapAtFraction(0.46); // 2.3 of 5
      await tapAtFraction(0.42); // 2.1
      await tapAtFraction(1); // the end
      expect(values, [2.5, 2.0, 5.0]);
    },
  );

  testWidgets('step 3 on 0-10: the last reachable value is 9, not 10', (
    tester,
  ) async {
    final values = <double>[];
    await tester.pumpWidget(
      BsApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 300,
            child: BsFormRange(
              value: 0,
              min: 0,
              max: 10,
              step: 3,
              onChanged: values.add,
            ),
          ),
        ),
      ),
    );
    await tester.tapAt(
      tester.getTopRight(find.byType(BsFormRange)) + const Offset(-1, 12),
    );
    await tester.pump();
    expect(values, [9.0]);
  });
}
