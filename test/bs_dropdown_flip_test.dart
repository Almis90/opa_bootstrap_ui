import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';
import 'package:opa_bootstrap_ui/src/bs_placement.dart';

void main() {
  group('resolvePlacement', () {
    const viewport = Rect.fromLTWH(0, 0, 800, 600);
    const menu = Size(160, 100);
    const bottomStart = BsPlacement(BsPlacementSide.bottom, BsPlacementAlign.start);

    BsResolvedPlacement resolve(Rect target, {BsPlacement preferred = bottomStart, bool flip = true}) =>
        resolvePlacement(
          preferred: preferred,
          target: target,
          content: menu,
          viewport: viewport,
          spacer: 2,
          flip: flip,
        );

    test('keeps the preferred placement when it fits', () {
      final r = resolve(const Rect.fromLTWH(100, 100, 40, 30));
      expect(r.placement, bottomStart);
      expect(r.shift, Offset.zero);
    });

    test('flips to the top when there is no room below', () {
      final r = resolve(const Rect.fromLTWH(100, 560, 40, 30));
      expect(r.placement, const BsPlacement(BsPlacementSide.top, BsPlacementAlign.start));
    });

    test('flips to end alignment when it would run off the right edge', () {
      final r = resolve(const Rect.fromLTWH(740, 100, 40, 30));
      expect(r.placement, const BsPlacement(BsPlacementSide.bottom, BsPlacementAlign.end));
      expect(r.shift, Offset.zero);
    });

    test('flips both axes in the bottom-right corner', () {
      final r = resolve(const Rect.fromLTWH(740, 560, 40, 30));
      expect(r.placement, const BsPlacement(BsPlacementSide.top, BsPlacementAlign.end));
    });

    test('prefers the alignment flip over the side flip, as Popper does', () {
      // Fits bottom-end and top-start; bottom-end comes first.
      final r = resolve(const Rect.fromLTWH(740, 100, 40, 30));
      expect(r.placement.side, BsPlacementSide.bottom);
    });

    test('slides along the toggle when neither alignment fits', () {
      // A toggle so wide that bottom-start and bottom-end both overflow.
      final r = resolve(const Rect.fromLTWH(-50, 100, 900, 30));
      expect(r.placement.side, BsPlacementSide.bottom);
      final rect = r.placement.rect(const Rect.fromLTWH(-50, 100, 900, 30), menu, 2).shift(r.shift);
      expect(rect.left, greaterThanOrEqualTo(0));
      expect(rect.right, lessThanOrEqualTo(800));
    });

    test('flip: false still slides but never changes side or alignment', () {
      final r = resolve(const Rect.fromLTWH(740, 560, 40, 30), flip: false);
      expect(r.placement, bottomStart);
      expect(r.shift.dx, 800 - (740 + 160));
    });

    test('dropend flips to the left side near the right edge', () {
      final r = resolve(
        const Rect.fromLTWH(700, 100, 40, 30),
        preferred: const BsPlacement(BsPlacementSide.right, BsPlacementAlign.start),
      );
      expect(r.placement.side, BsPlacementSide.left);
    });
  });

  group('BsDropdown', () {
    Future<void> pump(WidgetTester tester, Alignment alignment, {bool flip = true, bool alignEnd = false}) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        BsApp(
          debugShowCheckedModeBanner: false,
          home: Align(
            alignment: alignment,
            child: BsDropdown(
              flip: flip,
              alignEnd: alignEnd,
              toggleBuilder: (context, toggle, isOpen) => GestureDetector(
                key: const Key('toggle'),
                onTap: toggle,
                behavior: HitTestBehavior.opaque,
                child: const SizedBox(width: 40, height: 30),
              ),
              items: const [BsDropdownItem(child: Text('One')), BsDropdownItem(child: Text('Two'))],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('toggle')));
      await tester.pumpAndSettle();
    }

    Rect menuRect(WidgetTester tester) => tester.getRect(find.byType(DecoratedBox).last);

    testWidgets('opens below, left-aligned, when there is room', (tester) async {
      await pump(tester, Alignment.center);
      final toggle = tester.getRect(find.byKey(const Key('toggle')));
      final menu = menuRect(tester);
      expect(menu.top, greaterThan(toggle.bottom));
      expect(menu.left, closeTo(toggle.left, 1));
    });

    testWidgets('opens above when the toggle is at the bottom edge', (tester) async {
      await pump(tester, Alignment.bottomCenter);
      final toggle = tester.getRect(find.byKey(const Key('toggle')));
      final menu = menuRect(tester);
      expect(menu.bottom, lessThan(toggle.top));
      expect(menu.left, closeTo(toggle.left, 1));
    });

    testWidgets('right-aligns itself when the toggle is at the right edge', (tester) async {
      await pump(tester, Alignment.centerRight);
      final toggle = tester.getRect(find.byKey(const Key('toggle')));
      final menu = menuRect(tester);
      expect(menu.right, closeTo(toggle.right, 1));
      expect(menu.top, greaterThan(toggle.bottom));
    });

    testWidgets('in RTL, logical start means the physical right edge', (tester) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        BsApp(
          debugShowCheckedModeBanner: false,
          builder: (context, child) => Directionality(textDirection: TextDirection.rtl, child: child!),
          home: Center(
            child: BsDropdown(
              toggleBuilder: (context, toggle, isOpen) => GestureDetector(
                key: const Key('toggle'),
                behavior: HitTestBehavior.opaque,
                onTap: toggle,
                child: const SizedBox(width: 40, height: 30),
              ),
              items: const [BsDropdownItem(child: Text('One'))],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('toggle')));
      await tester.pumpAndSettle();
      final toggle = tester.getRect(find.byKey(const Key('toggle')));
      expect(menuRect(tester).right, closeTo(toggle.right, 1));
    });

    testWidgets('flip: false stays below even at the bottom edge', (tester) async {
      await pump(tester, Alignment.bottomCenter, flip: false);
      final toggle = tester.getRect(find.byKey(const Key('toggle')));
      expect(menuRect(tester).top, greaterThan(toggle.bottom));
    });

    testWidgets('a real tap on a menu item reaches it, then closes the menu', (tester) async {
      tester.view.physicalSize = const Size(800, 600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      var taps = 0;
      await tester.pumpWidget(
        BsApp(
          debugShowCheckedModeBanner: false,
          home: Align(
            alignment: Alignment.bottomRight,
            child: BsDropdown(
              toggleBuilder: (context, toggle, isOpen) => GestureDetector(
                key: const Key('toggle'),
                behavior: HitTestBehavior.opaque,
                onTap: toggle,
                child: const SizedBox(width: 40, height: 30),
              ),
              items: [BsDropdownItem(child: const Text('One'), onTap: () => taps++)],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('toggle')));
      await tester.pumpAndSettle();
      expect(find.text('One'), findsOneWidget);

      // warnIfMissed stays on: the item must really be under the pointer.
      await tester.tap(find.text('One'));
      await tester.pumpAndSettle();

      expect(taps, 1);
      expect(find.text('One'), findsNothing);
    });

    testWidgets('a real tap outside still closes the menu', (tester) async {
      await pump(tester, Alignment.center);
      expect(find.text('One'), findsOneWidget);
      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();
      expect(find.text('One'), findsNothing);
    });
  });
}
