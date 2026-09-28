import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  Future<void> pumpAndHover(WidgetTester tester, BsTooltipPlacement placement, String label) async {
    await tester.pumpWidget(
      BsApp(
        home: Center(
          child: BsTooltip(
            placement: placement,
            message: Text('Tooltip on ${label.toLowerCase()}'),
            child: BsButton(onPressed: () {}, child: Text(label)),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);
    await tester.pump();
    await gesture.moveTo(tester.getCenter(find.text(label)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
  }

  // Reproduces a layout bug identical in spirit to BsCloseButton's: the
  // Overlay hands OverlayPortal's overlay child *tight* constraints
  // matching the full screen, so a CompositedTransformFollower placed
  // directly in it (with no Stack in between to loosen those constraints,
  // the way BsDropdown/BsPopover's own overlay builders do) had its child
  // stretched to fill the whole screen. `followerAnchor: bottomCenter`/
  // `centerRight` (used by `top`/`start`) read that stretched size via
  // Alignment.alongSize, throwing the bubble hundreds of pixels off in the
  // wrong direction; `topCenter`/`centerLeft` (`bottom`/`end`) always read
  // 0 for their sensitive axis, so they rendered correctly by accident.
  for (final placement in BsTooltipPlacement.values) {
    testWidgets('BsTooltip with placement $placement renders adjacent to its target', (tester) async {
      final label = switch (placement) {
        BsTooltipPlacement.top => 'Top',
        BsTooltipPlacement.bottom => 'Bottom',
        BsTooltipPlacement.start => 'Start',
        BsTooltipPlacement.end => 'End',
      };
      await pumpAndHover(tester, placement, label);

      final targetRect = tester.getRect(find.text(label));
      final messageRect = tester.getRect(find.text('Tooltip on ${label.toLowerCase()}'));

      // However placement is wired up, the bubble must land within a
      // small margin of the target's own bounding box, never hundreds of
      // pixels away (the symptom of the stretched-follower bug) nor
      // exactly overlapping the target itself.
      const maxGap = 60.0;
      switch (placement) {
        case BsTooltipPlacement.top:
          expect(messageRect.bottom, lessThanOrEqualTo(targetRect.top));
          expect(targetRect.top - messageRect.bottom, lessThan(maxGap));
        case BsTooltipPlacement.bottom:
          expect(messageRect.top, greaterThanOrEqualTo(targetRect.bottom));
          expect(messageRect.top - targetRect.bottom, lessThan(maxGap));
        case BsTooltipPlacement.start:
          expect(messageRect.right, lessThanOrEqualTo(targetRect.left));
          expect(targetRect.left - messageRect.right, lessThan(maxGap));
        case BsTooltipPlacement.end:
          expect(messageRect.left, greaterThanOrEqualTo(targetRect.right));
          expect(messageRect.left - targetRect.right, lessThan(maxGap));
      }
    });
  }

  testWidgets('BsTooltipController disables hover and hides an already-shown tooltip', (tester) async {
    final controller = BsTooltipController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      BsApp(
        home: Center(
          child: BsTooltip(
            controller: controller,
            message: const Text('Tooltip message'),
            child: BsButton(onPressed: () {}, child: const Text('Btn')),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
    await gesture.addPointer(location: Offset.zero);
    addTearDown(gesture.removePointer);
    await tester.pump();
    await gesture.moveTo(tester.getCenter(find.text('Btn')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('Tooltip message'), findsOneWidget);

    controller.disable();
    await tester.pumpAndSettle();
    expect(find.text('Tooltip message'), findsNothing);

    // Disabled: hovering again must not bring it back.
    await gesture.moveTo(Offset.zero);
    await tester.pump();
    await gesture.moveTo(tester.getCenter(find.text('Btn')));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Tooltip message'), findsNothing);

    controller.enable();
    await gesture.moveTo(Offset.zero);
    await tester.pump();
    await gesture.moveTo(tester.getCenter(find.text('Btn')));
    await tester.pump(const Duration(milliseconds: 200));
    expect(find.text('Tooltip message'), findsOneWidget);
  });

  testWidgets('BsTooltipController show/hide/toggle work without any hover', (tester) async {
    final controller = BsTooltipController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      BsApp(
        home: Center(
          child: BsTooltip(
            controller: controller,
            message: const Text('Tooltip message'),
            child: BsButton(onPressed: () {}, child: const Text('Btn')),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Tooltip message'), findsNothing);

    controller.show();
    await tester.pumpAndSettle();
    expect(find.text('Tooltip message'), findsOneWidget);
    expect(controller.isShown, isTrue);

    controller.hide();
    await tester.pumpAndSettle();
    expect(find.text('Tooltip message'), findsNothing);
    expect(controller.isShown, isFalse);

    controller.toggle();
    await tester.pumpAndSettle();
    expect(find.text('Tooltip message'), findsOneWidget);

    controller.toggle();
    await tester.pumpAndSettle();
    expect(find.text('Tooltip message'), findsNothing);

    // show() is a no-op while disabled.
    controller.disable();
    controller.show();
    await tester.pumpAndSettle();
    expect(find.text('Tooltip message'), findsNothing);
  });

  testWidgets('BsTooltipController.setContent updates an already-shown tooltip', (tester) async {
    final controller = BsTooltipController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      BsApp(
        home: Center(
          child: BsTooltip(
            controller: controller,
            message: const Text('Original'),
            child: BsButton(onPressed: () {}, child: const Text('Btn')),
          ),
        ),
      ),
    );

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

  testWidgets('BsTooltipController.setContent makes an originally-empty tooltip interactive', (tester) async {
    final controller = BsTooltipController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      BsApp(
        home: Center(
          child: BsTooltip(
            controller: controller,
            message: const Text(''),
            child: BsButton(onPressed: () {}, child: const Text('Btn')),
          ),
        ),
      ),
    );

    controller.show();
    await tester.pumpAndSettle();
    expect(find.text('Filled in'), findsNothing);

    controller.setContent(const Text('Filled in'));
    controller.show();
    await tester.pumpAndSettle();
    expect(find.text('Filled in'), findsOneWidget);
  });
}
