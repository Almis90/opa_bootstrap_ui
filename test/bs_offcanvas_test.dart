import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  Widget buildHome({required WidgetBuilder openerBuilder}) {
    return BsApp(home: Builder(builder: openerBuilder));
  }

  Widget offcanvasBuilder(BuildContext context) => BsOffcanvas(
    header: BsOffcanvasHeader(onClose: () => Navigator.of(context).pop(), child: const Text('Title')),
    body: const BsOffcanvasBody(child: Text('Offcanvas content')),
  );

  testWidgets('showBsOffcanvas fires onShow/onShown/onHide/onHidden in order via Navigator.pop', (tester) async {
    final events = <String>[];

    await tester.pumpWidget(
      buildHome(
        openerBuilder: (context) => BsButton(
          onPressed: () => showBsOffcanvas<void>(
            context: context,
            builder: offcanvasBuilder,
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
    expect(find.text('Offcanvas content'), findsOneWidget);

    final context = tester.element(find.text('Offcanvas content'));
    Navigator.of(context).pop();
    expect(events, ['show', 'shown', 'hide']);
    await tester.pumpAndSettle();
    expect(events, ['show', 'shown', 'hide', 'hidden']);
    expect(find.text('Offcanvas content'), findsNothing);
  });

  testWidgets('onHide/onHidden fire for a barrier-tap dismissal too', (tester) async {
    final events = <String>[];

    await tester.pumpWidget(
      buildHome(
        openerBuilder: (context) => BsButton(
          onPressed: () => showBsOffcanvas<void>(
            context: context,
            builder: offcanvasBuilder,
            onHide: () => events.add('hide'),
            onHidden: () => events.add('hidden'),
          ),
          child: const Text('Open'),
        ),
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(find.text('Offcanvas content'), findsOneWidget);

    // Tap the barrier, well away from the offcanvas panel itself (which
    // defaults to BsOffcanvasPlacement.start, a fixed-width panel hugging
    // the left edge).
    await tester.tapAt(const Offset(780, 300));
    expect(events, ['hide']);
    await tester.pumpAndSettle();
    expect(events, ['hide', 'hidden']);
    expect(find.text('Offcanvas content'), findsNothing);
  });

  testWidgets('BsOffcanvasController tracks isShown and show() is a no-op while already shown or disabled', (
    tester,
  ) async {
    final controller = BsOffcanvasController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      buildHome(
        openerBuilder: (context) => BsButton(
          onPressed: () => controller.show<void>(context: context, builder: offcanvasBuilder),
          child: const Text('Open'),
        ),
      ),
    );

    expect(controller.isShown, isFalse);
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(controller.isShown, isTrue);
    expect(find.text('Offcanvas content'), findsOneWidget);

    // Already shown: a second show() call must not push a second route.
    final context = tester.element(find.text('Offcanvas content'));
    expect(controller.show<void>(context: context, builder: offcanvasBuilder), isNull);

    controller.hide(context);
    await tester.pumpAndSettle();
    expect(controller.isShown, isFalse);
    expect(find.text('Offcanvas content'), findsNothing);

    controller.disable();
    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();
    expect(controller.isShown, isFalse);
    expect(find.text('Offcanvas content'), findsNothing);
  });

  testWidgets('BsOffcanvasController.toggle opens when closed and closes when open', (tester) async {
    final controller = BsOffcanvasController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      buildHome(
        openerBuilder: (context) => BsButton(
          onPressed: () => controller.toggle<void>(context: context, builder: offcanvasBuilder),
          child: const Text('Toggle'),
        ),
      ),
    );

    await tester.tap(find.text('Toggle'));
    await tester.pumpAndSettle();
    expect(find.text('Offcanvas content'), findsOneWidget);

    // The offcanvas's own barrier now covers the "Toggle" button, so call
    // toggle() directly (with a context still in the tree) rather than via
    // a tap that would actually land on the barrier instead.
    final context = tester.element(find.text('Offcanvas content'));
    controller.toggle<void>(context: context, builder: offcanvasBuilder);
    await tester.pumpAndSettle();
    expect(find.text('Offcanvas content'), findsNothing);
  });
}
