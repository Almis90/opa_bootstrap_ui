import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  // The ring is the glyph's box shadow.
  Finder ring() => find.byWidgetPredicate((w) {
    final decoration = w is BsDecoratedContainer
        ? w.decoration
        : (w is BsAnimatedContainer ? w.decoration : null);
    return decoration is BoxDecoration && decoration.boxShadow != null;
  });

  for (final type in [
    BsFormCheckType.checkbox,
    BsFormCheckType.radio,
    BsFormCheckType.switchToggle,
  ]) {
    testWidgets(
      '$type: a click focuses it (ring and light-blue border, like :focus); Space toggles it',
      (tester) async {
        var value = false;
        late StateSetter setState;
        await tester.pumpWidget(
          BsApp(
            home: Align(
              alignment: Alignment.topLeft,
              child: StatefulBuilder(
                builder: (context, setter) {
                  setState = setter;
                  return BsFormCheck(
                    type: type,
                    value: value,
                    onChanged: (v) => setState(() => value = v),
                    label: const Text('Check me'),
                  );
                },
              ),
            ),
          ),
        );
        expect(ring(), findsNothing);

        await tester.tap(find.text('Check me'));
        await tester.pump();
        expect(value, isTrue);
        expect(
          ring(),
          findsOneWidget,
          reason: 'a clicked control keeps its focus ring',
        );

        await tester.sendKeyEvent(LogicalKeyboardKey.space);
        await tester.pump();
        expect(value, isFalse);
      },
    );
  }

  testWidgets('a disabled checkbox never shows the ring', (tester) async {
    await tester.pumpWidget(
      const BsApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: BsFormCheck(value: false, onChanged: null, label: Text('Off')),
        ),
      ),
    );
    await tester.tap(find.text('Off'));
    await tester.pump();
    expect(ring(), findsNothing);
  });
}
