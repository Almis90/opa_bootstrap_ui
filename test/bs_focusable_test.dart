import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  testWidgets('builder is called with focused: true/false as focus changes', (
    tester,
  ) async {
    final focusNode = FocusNode();
    final otherFocusNode = FocusNode();
    addTearDown(focusNode.dispose);
    addTearDown(otherFocusNode.dispose);
    final states = <bool>[];

    await tester.pumpWidget(
      BsApp(
        home: Column(
          children: [
            BsFocusableBuilder(
              focusNode: focusNode,
              builder: (context, focused) {
                states.add(focused);
                return const SizedBox();
              },
            ),
            Focus(focusNode: otherFocusNode, child: const SizedBox()),
          ],
        ),
      ),
    );
    expect(states.last, isFalse);

    focusNode.requestFocus();
    await tester.pumpAndSettle();
    expect(states.last, isTrue);

    // Moving focus elsewhere, rather than unfocus()-ing outright, is the
    // realistic way a node loses focus (e.g. tabbing to the next control).
    otherFocusNode.requestFocus();
    await tester.pumpAndSettle();
    expect(states.last, isFalse);
  });

  testWidgets(
    'enabled: false ignores focus changes and always reports focused: false',
    (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      final states = <bool>[];

      await tester.pumpWidget(
        BsApp(
          home: BsFocusableBuilder(
            focusNode: focusNode,
            enabled: false,
            builder: (context, focused) {
              states.add(focused);
              return const SizedBox();
            },
          ),
        ),
      );

      focusNode.requestFocus();
      await tester.pumpAndSettle();

      expect(states, everyElement(isFalse));
    },
  );

  testWidgets(
    'focusVisibleOnly: a click focuses without the ring, a key press shows it',
    (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      var focused = false;

      await tester.pumpWidget(
        BsApp(
          home: Center(
            child: BsFocusableBuilder(
              focusNode: focusNode,
              focusVisibleOnly: true,
              builder: (context, value) {
                focused = value;
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: focusNode.requestFocus,
                  child: const SizedBox(
                    key: Key('target'),
                    width: 50,
                    height: 50,
                  ),
                );
              },
            ),
          ),
        ),
      );

      // Tab onto it: a keyboard user gets the ring.
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      focusNode.requestFocus();
      await tester.pump();
      expect(focused, isTrue);

      // Click: still focused, but no ring ...
      focusNode.unfocus();
      await tester.tap(find.byKey(const Key('target')));
      await tester.pump();
      expect(focusNode.hasFocus, isTrue);
      expect(focused, isFalse);

      // ... until a key is pressed (the original's Escape on a clicked toggler).
      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pump();
      expect(focused, isTrue);
    },
  );
}
