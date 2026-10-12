import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';
import 'package:opa_bootstrap_ui/src/bs_placement.dart';

void main() {
  group('resolvePlacement (centred, as popovers and tooltips use it)', () {
    const viewport = Rect.fromLTWH(0, 0, 800, 600);
    const bubble = Size(120, 60);
    const top = BsPlacement(BsPlacementSide.top);

    BsResolvedPlacement resolve(
      Rect target, {
      BsPlacement preferred = top,
      bool flip = true,
    }) => resolvePlacement(
      preferred: preferred,
      target: target,
      content: bubble,
      viewport: viewport,
      spacer: 0,
      flip: flip,
    );

    test('keeps the preferred side when it fits', () {
      final r = resolve(const Rect.fromLTWH(340, 300, 120, 40));
      expect(r.placement, top);
      expect(r.shift, Offset.zero);
    });

    test(
      'flips to the bottom when there is no room above, with no alignment variations to try',
      () {
        final r = resolve(const Rect.fromLTWH(340, 20, 120, 40));
        expect(r.placement, const BsPlacement(BsPlacementSide.bottom));
      },
    );

    test(
      'stays put and slides sideways at the left edge, rather than flipping',
      () {
        final r = resolve(const Rect.fromLTWH(0, 300, 40, 40));
        expect(r.placement, top);
        // Centred on a 40-wide target at x=0, the 120-wide bubble would start at -40.
        expect(r.shift, const Offset(40, 0));
      },
    );

    test('flips start to end when there is no room to the left', () {
      final r = resolve(
        const Rect.fromLTWH(60, 300, 40, 40),
        preferred: const BsPlacement(BsPlacementSide.left),
      );
      expect(r.placement, const BsPlacement(BsPlacementSide.right));
    });

    test('flip: false never changes side', () {
      final r = resolve(const Rect.fromLTWH(340, 20, 120, 40), flip: false);
      expect(r.placement, top);
    });
  });

  group('arrowShift', () {
    test('moves against the bubble shift', () {
      expect(
        arrowShift(shift: 40, contentExtent: 120, arrowExtent: 12, padding: 6),
        -40,
      );
    });

    test('stops short of the bubble corners', () {
      // (120 - 12) / 2 - 6 = 48
      expect(
        arrowShift(shift: 80, contentExtent: 120, arrowExtent: 12, padding: 6),
        -48,
      );
      expect(
        arrowShift(shift: -80, contentExtent: 120, arrowExtent: 12, padding: 6),
        48,
      );
    });

    test('does nothing for a bubble too small to slide along', () {
      expect(
        arrowShift(shift: 10, contentExtent: 20, arrowExtent: 12, padding: 6),
        0,
      );
    });
  });

  group('widgets', () {
    Future<void> setSize(WidgetTester tester) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
    }

    Widget app(Widget child) =>
        BsApp(debugShowCheckedModeBanner: false, home: child);

    testWidgets('BsPopover flips below its trigger at the top edge', (
      tester,
    ) async {
      await setSize(tester);
      final controller = BsPopoverController();
      await tester.pumpWidget(
        app(
          Align(
            alignment: Alignment.topCenter,
            child: BsPopover(
              placement: BsPopoverPlacement.top,
              controller: controller,
              content: const Text('Body'),
              triggerBuilder: (context, toggle, isOpen) =>
                  const SizedBox(key: Key('trigger'), width: 80, height: 30),
            ),
          ),
        ),
      );
      controller.show();
      await tester.pumpAndSettle();
      final trigger = tester.getRect(find.byKey(const Key('trigger')));
      expect(
        tester.getRect(find.text('Body')).top,
        greaterThan(trigger.bottom),
      );
    });

    testWidgets(
      'BsPopover with flip: false stays above even if that is off screen',
      (tester) async {
        await setSize(tester);
        final controller = BsPopoverController();
        await tester.pumpWidget(
          app(
            Align(
              alignment: Alignment.topCenter,
              child: BsPopover(
                placement: BsPopoverPlacement.top,
                flip: false,
                controller: controller,
                content: const Text('Body'),
                triggerBuilder: (context, toggle, isOpen) =>
                    const SizedBox(key: Key('trigger'), width: 80, height: 30),
              ),
            ),
          ),
        );
        controller.show();
        await tester.pumpAndSettle();
        final trigger = tester.getRect(find.byKey(const Key('trigger')));
        expect(tester.getRect(find.text('Body')).bottom, lessThan(trigger.top));
      },
    );

    testWidgets('BsPopover slides to stay on screen at the left edge', (
      tester,
    ) async {
      await setSize(tester);
      final controller = BsPopoverController();
      await tester.pumpWidget(
        app(
          Align(
            alignment: Alignment.centerLeft,
            child: BsPopover(
              placement: BsPopoverPlacement.top,
              controller: controller,
              content: const SizedBox(width: 200, child: Text('Body')),
              triggerBuilder: (context, toggle, isOpen) =>
                  const SizedBox(key: Key('trigger'), width: 20, height: 30),
            ),
          ),
        ),
      );
      controller.show();
      await tester.pumpAndSettle();
      expect(tester.getRect(find.text('Body')).left, greaterThanOrEqualTo(0));
      // Still above the trigger: sliding, not flipping.
      final trigger = tester.getRect(find.byKey(const Key('trigger')));
      expect(tester.getRect(find.text('Body')).bottom, lessThan(trigger.top));
    });

    testWidgets(
      'a real tap inside a popover reaches its content and leaves it open',
      (tester) async {
        await setSize(tester);
        final controller = BsPopoverController();
        var pressed = 0;
        await tester.pumpWidget(
          app(
            Align(
              alignment: Alignment.bottomRight,
              child: BsPopover(
                placement: BsPopoverPlacement.top,
                controller: controller,
                content: BsButton(
                  onPressed: () => pressed++,
                  child: const Text('Inside'),
                ),
                triggerBuilder: (context, toggle, isOpen) =>
                    const SizedBox(width: 80, height: 30),
              ),
            ),
          ),
        );
        controller.show();
        await tester.pumpAndSettle();

        await tester.tap(find.text('Inside'));
        await tester.pumpAndSettle();

        expect(pressed, 1);
        expect(controller.isShown, isTrue);
      },
    );

    testWidgets('BsTooltip flips below its target at the top edge', (
      tester,
    ) async {
      await setSize(tester);
      final controller = BsTooltipController();
      await tester.pumpWidget(
        app(
          Align(
            alignment: Alignment.topCenter,
            child: BsTooltip(
              controller: controller,
              message: const Text('Tip'),
              child: const SizedBox(key: Key('target'), width: 80, height: 30),
            ),
          ),
        ),
      );
      controller.show();
      await tester.pumpAndSettle();
      final target = tester.getRect(find.byKey(const Key('target')));
      expect(tester.getRect(find.text('Tip')).top, greaterThan(target.bottom));
    });

    testWidgets(
      'BsTooltip start placement flips to the right at the left edge',
      (tester) async {
        await setSize(tester);
        final controller = BsTooltipController();
        await tester.pumpWidget(
          app(
            Align(
              alignment: Alignment.centerLeft,
              child: BsTooltip(
                placement: BsTooltipPlacement.start,
                controller: controller,
                message: const Text('Tip'),
                child: const SizedBox(
                  key: Key('target'),
                  width: 30,
                  height: 30,
                ),
              ),
            ),
          ),
        );
        controller.show();
        await tester.pumpAndSettle();
        final target = tester.getRect(find.byKey(const Key('target')));
        expect(
          tester.getRect(find.text('Tip')).left,
          greaterThan(target.right),
        );
      },
    );

    testWidgets('BsTooltip stays where asked when it fits', (tester) async {
      await setSize(tester);
      final controller = BsTooltipController();
      await tester.pumpWidget(
        app(
          Center(
            child: BsTooltip(
              controller: controller,
              message: const Text('Tip'),
              child: const SizedBox(key: Key('target'), width: 80, height: 30),
            ),
          ),
        ),
      );
      controller.show();
      await tester.pumpAndSettle();
      final target = tester.getRect(find.byKey(const Key('target')));
      expect(tester.getRect(find.text('Tip')).bottom, lessThan(target.top));
    });
  });
}
