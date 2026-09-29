import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  testWidgets('builder is called with focused: true/false as focus changes', (tester) async {
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

  testWidgets('enabled: false ignores focus changes and always reports focused: false', (tester) async {
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
  });
}
