import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  Widget host(Widget child) => Directionality(
    textDirection: TextDirection.ltr,
    child: MediaQuery(
      data: const MediaQueryData(size: Size(400, 400)),
      child: Align(
        alignment: Alignment.topLeft,
        child: SizedBox(width: 400, child: child),
      ),
    ),
  );

  testWidgets('is 1em of its font size, and a flex line does not stretch it', (
    tester,
  ) async {
    await tester.pumpWidget(
      host(
        BsFlex(
          children: [
            BsFormCheckInput(value: false, onChanged: (_) {}, fontSize: 22),
            const SizedBox(width: 10, height: 60),
          ],
        ),
      ),
    );
    final glyph = find.descendant(
      of: find.byType(BsFormCheckInput),
      matching: find.byType(BsDecoratedBox),
    );
    expect(tester.getSize(glyph.first), const Size(22, 22));
  });

  testWidgets(
    'reports a tap as the opposite value; disabled without onChanged',
    (tester) async {
      bool? changed;
      await tester.pumpWidget(
        host(BsFormCheckInput(value: false, onChanged: (v) => changed = v)),
      );
      await tester.tap(find.byType(BsFormCheckInput));
      expect(changed, isTrue);

      changed = null;
      await tester.pumpWidget(
        host(const BsFormCheckInput(value: false, onChanged: null)),
      );
      await tester.tap(find.byType(BsFormCheckInput));
      expect(changed, isNull);
      expect(tester.widget<Opacity>(find.byType(Opacity)).opacity, 0.5);
    },
  );
}
