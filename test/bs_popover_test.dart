import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  Widget buildPopover({
    BsPopoverController? controller,
    BsPopoverPlacement placement = BsPopoverPlacement.top,
    Widget content = const Text('Popover content'),
    ValueChanged<bool>? onOpenChanged,
    VoidCallback? onShow,
    VoidCallback? onShown,
    VoidCallback? onHide,
    VoidCallback? onHidden,
  }) {
    return BsApp(
      home: Center(
        child: BsPopover(
          controller: controller,
          placement: placement,
          content: content,
          onOpenChanged: onOpenChanged,
          onShow: onShow,
          onShown: onShown,
          onHide: onHide,
          onHidden: onHidden,
          triggerBuilder: (context, toggle, isOpen) => BsButton(onPressed: toggle, child: const Text('Trigger')),
        ),
      ),
    );
  }

  testWidgets('Tapping the trigger opens and closes the popover', (tester) async {
    await tester.pumpWidget(buildPopover());
    expect(find.text('Popover content'), findsNothing);

    await tester.tap(find.text('Trigger'));
    await tester.pumpAndSettle();
    expect(find.text('Popover content'), findsOneWidget);

    // The full-screen dismiss barrier sits on top while open, so this tap
    // actually lands on it rather than the trigger underneath — closing
    // the popover the same way an outside tap would.
    await tester.tap(find.text('Trigger'), warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(find.text('Popover content'), findsNothing);
  });

  testWidgets('Tapping outside the popover closes it', (tester) async {
    await tester.pumpWidget(buildPopover());
    await tester.tap(find.text('Trigger'));
    await tester.pumpAndSettle();
    expect(find.text('Popover content'), findsOneWidget);

    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
    expect(find.text('Popover content'), findsNothing);
  });

  testWidgets('BsPopoverController disables the trigger and closes an already-open popover', (tester) async {
    final controller = BsPopoverController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(buildPopover(controller: controller));

    await tester.tap(find.text('Trigger'));
    await tester.pumpAndSettle();
    expect(find.text('Popover content'), findsOneWidget);

    controller.disable();
    await tester.pumpAndSettle();
    expect(find.text('Popover content'), findsNothing);

    // Disabled: tapping the trigger again must not reopen it.
    await tester.tap(find.text('Trigger'));
    await tester.pumpAndSettle();
    expect(find.text('Popover content'), findsNothing);

    controller.enable();
    await tester.tap(find.text('Trigger'));
    await tester.pumpAndSettle();
    expect(find.text('Popover content'), findsOneWidget);
  });

  testWidgets('BsPopoverController show/hide/toggle work without any tap', (tester) async {
    final controller = BsPopoverController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(buildPopover(controller: controller));
    expect(find.text('Popover content'), findsNothing);

    controller.show();
    await tester.pumpAndSettle();
    expect(find.text('Popover content'), findsOneWidget);
    expect(controller.isShown, isTrue);

    controller.hide();
    await tester.pumpAndSettle();
    expect(find.text('Popover content'), findsNothing);

    controller.toggle();
    await tester.pumpAndSettle();
    expect(find.text('Popover content'), findsOneWidget);

    controller.toggle();
    await tester.pumpAndSettle();
    expect(find.text('Popover content'), findsNothing);

    // show() is a no-op while disabled.
    controller.disable();
    controller.show();
    await tester.pumpAndSettle();
    expect(find.text('Popover content'), findsNothing);
  });

  testWidgets('BsPopoverController.setContent updates an already-open popover', (tester) async {
    final controller = BsPopoverController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(buildPopover(controller: controller, content: const Text('Original')));

    controller.show();
    await tester.pumpAndSettle();
    expect(find.text('Original'), findsOneWidget);

    controller.setContent(const Text('Updated'));
    await tester.pump();
    expect(find.text('Original'), findsNothing);
    expect(find.text('Updated'), findsOneWidget);

    controller.setContent(null);
    await tester.pump();
    expect(find.text('Original'), findsOneWidget);
  });

  testWidgets('BsPopoverController.setPlacement moves an already-open popover', (tester) async {
    final controller = BsPopoverController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(buildPopover(controller: controller));

    controller.show();
    await tester.pumpAndSettle();
    final targetRect = tester.getRect(find.text('Trigger'));
    var contentRect = tester.getRect(find.text('Popover content'));
    // Default placement is top: the bubble sits above the target.
    expect(contentRect.bottom, lessThanOrEqualTo(targetRect.top));

    controller.setPlacement(BsPopoverPlacement.bottom);
    await tester.pumpAndSettle();
    contentRect = tester.getRect(find.text('Popover content'));
    expect(contentRect.top, greaterThanOrEqualTo(targetRect.bottom));
  });

  testWidgets('BsPopover fires onShow/onShown/onHide/onHidden and onOpenChanged in order', (tester) async {
    final controller = BsPopoverController();
    addTearDown(controller.dispose);
    final events = <String>[];

    await tester.pumpWidget(
      buildPopover(
        controller: controller,
        onShow: () => events.add('show'),
        onShown: () => events.add('shown'),
        onHide: () => events.add('hide'),
        onHidden: () => events.add('hidden'),
        onOpenChanged: (open) => events.add('openChanged:$open'),
      ),
    );

    controller.show();
    await tester.pumpAndSettle();
    expect(events, ['show', 'shown', 'openChanged:true']);

    controller.hide();
    await tester.pumpAndSettle();
    expect(events, ['show', 'shown', 'openChanged:true', 'hide', 'hidden', 'openChanged:false']);
  });

  testWidgets('setContent/setPlacement while open do not re-fire onShow/onShown', (tester) async {
    final controller = BsPopoverController();
    addTearDown(controller.dispose);
    final events = <String>[];

    await tester.pumpWidget(
      buildPopover(controller: controller, onShow: () => events.add('show'), onShown: () => events.add('shown')),
    );

    controller.show();
    await tester.pumpAndSettle();
    expect(events, ['show', 'shown']);

    controller.setContent(const Text('Updated'));
    controller.setPlacement(BsPopoverPlacement.bottom);
    await tester.pumpAndSettle();
    expect(events, ['show', 'shown']);
  });
}
