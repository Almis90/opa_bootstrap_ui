import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  // A disabled control can neither be clicked into nor tabbed to, as in a
  // browser.
  Future<void> expectUnfocusable(WidgetTester tester, Widget disabled) async {
    final probe = FocusNode();
    addTearDown(probe.dispose);
    await tester.pumpWidget(
      BsApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: 300,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                disabled,
                Focus(
                  focusNode: probe,
                  child: const SizedBox(width: 10, height: 10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    final before = FocusManager.instance.primaryFocus;

    await tester.tapAt(tester.getCenter(find.byWidget(disabled)));
    await tester.pump();
    expect(
      FocusManager.instance.primaryFocus,
      before,
      reason: 'a click into it takes no focus',
    );

    // Tab goes straight past it, to the next control.
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(probe.hasFocus, isTrue, reason: 'Tab skips it');
  }

  testWidgets('a disabled text input', (tester) async {
    await expectUnfocusable(
      tester,
      const BsFormControl(enabled: false, placeholder: 'Disabled input'),
    );
  });

  testWidgets('a disabled checkbox', (tester) async {
    await expectUnfocusable(
      tester,
      const BsFormCheck(value: false, onChanged: null, label: Text('Off')),
    );
  });

  testWidgets('a disabled range', (tester) async {
    await expectUnfocusable(
      tester,
      const BsFormRange(value: 50, onChanged: null),
    );
  });

  testWidgets('a disabled button', (tester) async {
    await expectUnfocusable(
      tester,
      const BsButton(onPressed: null, child: Text('Off')),
    );
  });
}
