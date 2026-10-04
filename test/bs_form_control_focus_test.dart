import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  // Flutter web closes the text-input connection when the browser window loses
  // focus, which unfocuses the field *before* AppLifecycleState.inactive; these
  // tests replay that order.
  Future<(FocusNode, TextEditingController)> pumpFocused(WidgetTester tester) async {
    final node = FocusNode();
    final controller = TextEditingController(text: 'hello world')
      ..selection = const TextSelection.collapsed(offset: 5);
    addTearDown(node.dispose);
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      BsApp(
        debugShowCheckedModeBanner: false,
        home: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(width: 200, child: BsFormControl(focusNode: node, controller: controller)),
        ),
      ),
    );
    node.requestFocus();
    await tester.pump();
    expect(node.hasFocus, isTrue);
    return (node, controller);
  }

  testWidgets('regains focus, caret where it was, after the window loses and regains focus', (tester) async {
    final (node, controller) = await pumpFocused(tester);

    node.unfocus(); // engine closes the connection...
    await tester.pump();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive); // ...then the window blur arrives
    await tester.pump();
    expect(node.hasFocus, isFalse);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump(const Duration(milliseconds: 10));
    await tester.pump();

    expect(node.hasFocus, isTrue);
    expect(controller.selection, const TextSelection.collapsed(offset: 5));
  });

  testWidgets('also when the lifecycle change comes first', (tester) async {
    final (node, _) = await pumpFocused(tester);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    node.unfocus();
    await tester.pump();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump(const Duration(milliseconds: 10));
    await tester.pump();

    expect(node.hasFocus, isTrue);
  });

  testWidgets('does not steal focus back when the user had already moved on', (tester) async {
    final (node, _) = await pumpFocused(tester);

    node.unfocus();
    await tester.pump(const Duration(seconds: 1)); // well before any window blur
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump(const Duration(milliseconds: 10));
    await tester.pump();

    expect(node.hasFocus, isFalse);
  });

  testWidgets('does not refocus a field that was not focused', (tester) async {
    final node = FocusNode();
    addTearDown(node.dispose);
    await tester.pumpWidget(
      BsApp(debugShowCheckedModeBanner: false, home: Center(child: SizedBox(width: 200, child: BsFormControl(focusNode: node)))),
    );
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.inactive);
    await tester.pump();
    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump(const Duration(milliseconds: 10));
    await tester.pump();
    expect(node.hasFocus, isFalse);
  });
}
