import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';
import 'package:opa_bootstrap_ui/src/bs_dropdown_placement.dart';

void main() {
  group('resolveDropdownPlacement', () {
    const viewport = Rect.fromLTWH(0, 0, 800, 600);
    const menu = Size(160, 100);
    const bottomStart = BsDropdownPlacement(BsDropdownSide.bottom);

    BsDropdownResolvedPlacement resolve(Rect target, {BsDropdownPlacement preferred = bottomStart, bool flip = true}) =>
        resolveDropdownPlacement(
          preferred: preferred,
          target: target,
          menu: menu,
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
      expect(r.placement, const BsDropdownPlacement(BsDropdownSide.top));
    });

    test('flips to end alignment when it would run off the right edge', () {
      final r = resolve(const Rect.fromLTWH(740, 100, 40, 30));
      expect(r.placement, const BsDropdownPlacement(BsDropdownSide.bottom, alignEnd: true));
      expect(r.shift, Offset.zero);
    });

    test('flips both axes in the bottom-right corner', () {
      final r = resolve(const Rect.fromLTWH(740, 560, 40, 30));
      expect(r.placement, const BsDropdownPlacement(BsDropdownSide.top, alignEnd: true));
    });

    test('prefers the alignment flip over the side flip, as Popper does', () {
      // Fits bottom-end and top-start; bottom-end comes first.
      final r = resolve(const Rect.fromLTWH(740, 100, 40, 30));
      expect(r.placement.side, BsDropdownSide.bottom);
    });

    test('slides along the toggle when neither alignment fits', () {
      // A toggle so wide that bottom-start and bottom-end both overflow.
      final r = resolve(const Rect.fromLTWH(-50, 100, 900, 30));
      expect(r.placement.side, BsDropdownSide.bottom);
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
        preferred: const BsDropdownPlacement(BsDropdownSide.right),
      );
      expect(r.placement.side, BsDropdownSide.left);
    });

    test('RTL maps logical start to the physical right edge', () {
      final p = BsDropdownPlacement.preferred(
        BsDropdownDirection.down,
        alignEnd: false,
        textDirection: TextDirection.rtl,
      );
      expect(p, const BsDropdownPlacement(BsDropdownSide.bottom, alignEnd: true));
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

    testWidgets('flip: false stays below even at the bottom edge', (tester) async {
      await pump(tester, Alignment.bottomCenter, flip: false);
      final toggle = tester.getRect(find.byKey(const Key('toggle')));
      expect(menuRect(tester).top, greaterThan(toggle.bottom));
    });

    testWidgets('is hit-testable once placed', (tester) async {
      await pump(tester, Alignment.bottomRight);
      final menu = menuRect(tester);
      expect(menu.top, lessThan(570));
      await tester.tap(find.text('One'), warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(find.text('One'), findsNothing);
    });
  });
}
