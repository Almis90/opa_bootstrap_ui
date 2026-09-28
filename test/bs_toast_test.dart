import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  testWidgets('showBsToast returns a controller that dismisses the toast early', (tester) async {
    await tester.pumpWidget(
      BsApp(
        home: Builder(
          builder: (context) => BsButton(onPressed: () {}, child: const Text('Anchor')),
        ),
      ),
    );

    late BsToastController controller;
    final context = tester.element(find.text('Anchor'));
    controller = showBsToast(
      context,
      duration: const Duration(seconds: 5),
      builder: (context, dismiss) => BsToast(body: const Text('Toast message')),
    );
    await tester.pump();

    expect(find.text('Toast message'), findsOneWidget);
    expect(controller.isShown, isTrue);

    controller.hide();
    expect(controller.isShown, isFalse);
    await tester.pumpAndSettle();
    expect(find.text('Toast message'), findsNothing);
  });

  testWidgets('The close button (via dismiss callback) still works and stays in sync with the controller', (
    tester,
  ) async {
    await tester.pumpWidget(
      BsApp(
        home: Builder(
          builder: (context) => BsButton(onPressed: () {}, child: const Text('Anchor')),
        ),
      ),
    );

    final context = tester.element(find.text('Anchor'));
    final controller = showBsToast(
      context,
      // topStart keeps the close button safely within the default test
      // viewport — bottomEnd (the default) sits close enough to the
      // bottom-right corner to land off-screen there.
      position: BsToastPosition.topStart,
      duration: const Duration(seconds: 5),
      builder: (context, dismiss) => BsToast(
        header: BsToastHeader(title: const Text('Title'), onClose: dismiss),
        body: const Text('Body'),
      ),
    );
    // pumpAndSettle, not just pump: the close button isn't meaningfully
    // hit-testable mid fade-in (SizeTransition starts collapsed at t=0).
    await tester.pumpAndSettle();

    await tester.tap(find.byType(BsCloseButton));
    expect(controller.isShown, isFalse);
    await tester.pumpAndSettle();
    expect(find.text('Body'), findsNothing);
  });

  testWidgets('Auto-dismiss after duration also syncs the controller', (tester) async {
    await tester.pumpWidget(
      BsApp(
        home: Builder(
          builder: (context) => BsButton(onPressed: () {}, child: const Text('Anchor')),
        ),
      ),
    );

    final context = tester.element(find.text('Anchor'));
    final controller = showBsToast(
      context,
      duration: const Duration(milliseconds: 200),
      builder: (context, dismiss) => BsToast(body: const Text('Toast message')),
    );
    await tester.pump();
    expect(controller.isShown, isTrue);

    await tester.pumpAndSettle(const Duration(milliseconds: 50));
    expect(controller.isShown, isFalse);
    expect(find.text('Toast message'), findsNothing);
  });

  testWidgets('onShow/onShown/onHide/onHidden fire in order for a controller.hide()', (tester) async {
    final events = <String>[];
    await tester.pumpWidget(
      BsApp(
        home: Builder(
          builder: (context) => BsButton(onPressed: () {}, child: const Text('Anchor')),
        ),
      ),
    );

    final context = tester.element(find.text('Anchor'));
    final controller = showBsToast(
      context,
      duration: const Duration(seconds: 5),
      onShow: () => events.add('show'),
      onShown: () => events.add('shown'),
      onHide: () => events.add('hide'),
      onHidden: () => events.add('hidden'),
      builder: (context, dismiss) => BsToast(body: const Text('Toast message')),
    );
    expect(events, ['show']);
    await tester.pumpAndSettle();
    expect(events, ['show', 'shown']);

    controller.hide();
    expect(events, ['show', 'shown', 'hide']);
    await tester.pumpAndSettle();
    expect(events, ['show', 'shown', 'hide', 'hidden']);
  });

  testWidgets('A caller-supplied controller works the same as the auto-created one', (tester) async {
    final controller = BsToastController();
    addTearDown(controller.dispose);
    final events = <String>[];

    await tester.pumpWidget(
      BsApp(
        home: Builder(
          builder: (context) => BsButton(onPressed: () {}, child: const Text('Anchor')),
        ),
      ),
    );

    final context = tester.element(find.text('Anchor'));
    final returned = showBsToast(
      context,
      controller: controller,
      duration: const Duration(seconds: 5),
      onHide: () => events.add('hide'),
      builder: (context, dismiss) => BsToast(body: const Text('Toast message')),
    );
    await tester.pump();

    expect(identical(returned, controller), isTrue);
    expect(find.text('Toast message'), findsOneWidget);

    controller.hide();
    expect(events, ['hide']);
    await tester.pumpAndSettle();
    expect(find.text('Toast message'), findsNothing);
  });

  testWidgets('controller.hide() called before the toast widget even mounts is not lost', (tester) async {
    final events = <String>[];

    await tester.pumpWidget(
      BsApp(
        home: Builder(
          builder: (context) => BsButton(onPressed: () {}, child: const Text('Anchor')),
        ),
      ),
    );

    final context = tester.element(find.text('Anchor'));
    final controller = showBsToast(
      context,
      duration: const Duration(seconds: 5),
      onHide: () => events.add('hide'),
      onHidden: () => events.add('hidden'),
      builder: (context, dismiss) => BsToast(body: const Text('Toast message')),
    );
    // No pump yet — the OverlayEntry hasn't built _BsToastItem, so nothing
    // is listening to the controller at this exact point.
    controller.hide();

    await tester.pumpAndSettle();
    expect(events, ['hide', 'hidden']);
    expect(find.text('Toast message'), findsNothing);
  });
}
