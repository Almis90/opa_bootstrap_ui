import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  Widget buildHome({required WidgetBuilder openerBuilder}) {
    return BsApp(home: Builder(builder: openerBuilder));
  }

  Widget modalBuilder(BuildContext context) => BsModalDialog(
    child: BsModal(
      header: BsModalHeader(onClose: () => Navigator.of(context).pop(), child: const Text('Title')),
      body: const BsModalBody(child: Text('Modal content')),
    ),
  );

  testWidgets('showBsModal fires onShow/onShown/onHide/onHidden in order via Navigator.pop', (tester) async {
    final events = <String>[];

    await tester.pumpWidget(
      buildHome(
        openerBuilder: (context) => BsButton(
          onPressed: () => showBsModal<void>(
            context: context,
            builder: modalBuilder,
            onShow: () => events.add('show'),
            onShown: () => events.add('shown'),
            onHide: () => events.add('hide'),
            onHidden: () => events.add('hidden'),
          ),
          child: const Text('Open'),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    expect(events, ['show']);
    await tester.pumpAndSettle();
    expect(events, ['show', 'shown']);
    expect(find.text('Modal content'), findsOneWidget);

    final context = tester.element(find.text('Modal content'));
    Navigator.of(context).pop();
    expect(events, ['show', 'shown', 'hide']);
    await tester.pumpAndSettle();
    expect(events, ['show', 'shown', 'hide', 'hidden']);
    expect(find.text('Modal content'), findsNothing);
  });

  testWidgets('onHide/onHidden fire for a barrier-tap dismissal too', (tester) async {
    final events = <String>[];

    await tester.pumpWidget(
      buildHome(
        openerBuilder: (context) => BsButton(
          onPressed: () => showBsModal<void>(
            context: context,
            builder: modalBuilder,
            onHide: () => events.add('hide'),
            onHidden: () => events.add('hidden'),
          ),
          child: const Text('Open'),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('Modal content'), findsOneWidget);

    // Tap the barrier, well outside the centered dialog box.
    await tester.tapAt(const Offset(20, 20));
    expect(events, ['hide']);
    await tester.pumpAndSettle();
    expect(events, ['hide', 'hidden']);
    expect(find.text('Modal content'), findsNothing);
  });

  testWidgets('BsModalController tracks isShown and show() is a no-op while already shown or disabled', (
    tester,
  ) async {
    final controller = BsModalController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      buildHome(
        openerBuilder: (context) => BsButton(
          onPressed: () => controller.show<void>(context: context, builder: modalBuilder),
          child: const Text('Open'),
        ),
      ),
    );

    expect(controller.isShown, isFalse);
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(controller.isShown, isTrue);
    expect(find.text('Modal content'), findsOneWidget);

    // Already shown: a second show() call must not push a second route.
    final context = tester.element(find.text('Modal content'));
    expect(controller.show<void>(context: context, builder: modalBuilder), isNull);

    controller.hide(context);
    await tester.pumpAndSettle();
    expect(controller.isShown, isFalse);
    expect(find.text('Modal content'), findsNothing);

    controller.disable();
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(controller.isShown, isFalse);
    expect(find.text('Modal content'), findsNothing);
  });

  testWidgets('BsModalController.toggle opens when closed and closes when open', (tester) async {
    final controller = BsModalController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      buildHome(
        openerBuilder: (context) => BsButton(
          onPressed: () => controller.toggle<void>(context: context, builder: modalBuilder),
          child: const Text('Toggle'),
        ),
      ),
    );

    await tester.tap(find.text('Toggle'));
    await tester.pumpAndSettle();
    expect(find.text('Modal content'), findsOneWidget);

    // The modal's own barrier now covers the "Toggle" button, so call
    // toggle() directly (with a context still in the tree) rather than via
    // a tap that would actually land on the barrier instead.
    final context = tester.element(find.text('Modal content'));
    controller.toggle<void>(context: context, builder: modalBuilder);
    await tester.pumpAndSettle();
    expect(find.text('Modal content'), findsNothing);
  });
}
