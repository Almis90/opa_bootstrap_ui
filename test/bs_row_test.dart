import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  Widget box(String key, {double h = 20}) => SizedBox(key: Key(key), height: h);

  // The row sits in a 424px-wide parent padded by 12px — a container's content
  // — so its own width (the 1.5rem gutter pulls it out by 12px on each side)
  // is the parent's 400px.
  Future<void> pump(
    WidgetTester tester,
    Widget child, {
    double width = 400,
    TextDirection direction = TextDirection.ltr,
  }) async {
    tester.view.physicalSize = Size(width, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      Directionality(
        textDirection: direction,
        child: MediaQuery(
          data: MediaQueryData(size: Size(width, 800)),
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(width: width, child: child),
          ),
        ),
      ),
    );
  }

  Rect r(WidgetTester tester, String key) =>
      tester.getRect(find.byKey(Key(key)));

  testWidgets(
    'col-6 columns share the row; the gutter is padding, the row is pulled out',
    (tester) async {
      await pump(
        tester,
        BsRow(
          children: [
            BsFlexItem(col: const BsCol(6), child: box('a')),
            BsFlexItem(col: const BsCol(6), child: box('b')),
          ],
        ),
      );
      // Row = 400 + 24 wide, from x=-12: two 212px columns, each padded by 12.
      expect(r(tester, 'a'), const Rect.fromLTWH(0, 0, 188, 20));
      expect(r(tester, 'b'), const Rect.fromLTWH(212, 0, 188, 20));
    },
  );

  testWidgets('an item without a col is the row\'s whole width (.row > *)', (
    tester,
  ) async {
    await pump(tester, BsRow(children: [box('a'), box('b')]));
    expect(r(tester, 'a').width, 400);
    // Stacked: the next line starts below.
    expect(r(tester, 'b').top, 20);
  });

  testWidgets(
    'gy gives wrapped lines a vertical gutter, without pushing the row down',
    (tester) async {
      await pump(
        tester,
        BsRow(gy: BsSpacing.s3, children: [box('a'), box('b')]),
      );
      expect(r(tester, 'a').top, 0);
      expect(r(tester, 'b').top, 20 + 16);
    },
  );

  testWidgets('g-5 widens the gutter', (tester) async {
    await pump(
      tester,
      BsRow(
        g: BsSpacing.s5,
        children: [BsFlexItem(col: const BsCol(6), child: box('a'))],
      ),
    );
    // 400 + 48 → 224 per column minus 2 × 24 of padding.
    expect(r(tester, 'a'), const Rect.fromLTWH(0, 0, 176, 20));
  });

  testWidgets('offset-* is a start margin of that many columns', (
    tester,
  ) async {
    await pump(
      tester,
      BsRow(
        children: [
          BsFlexItem(
            col: const BsCol(4),
            offset: const BsCol(1),
            child: box('a'),
          ),
        ],
      ),
    );
    // 424 / 12 ≈ 35.33 of offset, then the item's 12px padding, from x=-12.
    expect(r(tester, 'a').left, closeTo(-12 + 424 / 12 + 12, 0.01));
  });

  testWidgets('flex-row-reverse puts the first column at the end', (
    tester,
  ) async {
    await pump(
      tester,
      BsRow(
        direction: BsFlexDirection.rowReverse,
        children: [
          BsFlexItem(col: const BsCol(6), child: box('a')),
          BsFlexItem(col: const BsCol(6), child: box('b')),
        ],
      ),
    );
    expect(r(tester, 'a').left, greaterThan(r(tester, 'b').left));
    expect(r(tester, 'a').right, 400);
  });

  testWidgets('p-0 on a column takes the gutter\'s padding away', (
    tester,
  ) async {
    await pump(
      tester,
      BsRow(
        children: [
          BsFlexItem(col: const BsCol(12), p: BsSpacing.s0, child: box('a')),
        ],
      ),
    );
    expect(r(tester, 'a'), const Rect.fromLTWH(-12, 0, 424, 20));
  });

  testWidgets('a column\'s own padding replaces the gutter on its sides only', (
    tester,
  ) async {
    await pump(
      tester,
      BsRow(
        children: [
          BsFlexItem(col: const BsCol(12), pt: BsSpacing.s4, child: box('a')),
        ],
      ),
    );
    expect(r(tester, 'a'), const Rect.fromLTWH(0, 24, 400, 20));
  });

  testWidgets(
    'flex-column stacks items at the container\'s width, with the gap',
    (tester) async {
      await pump(
        tester,
        BsFlex(
          direction: BsFlexDirection.column,
          gap: BsSpacing.s2,
          children: [box('a'), box('b')],
        ),
      );
      expect(r(tester, 'a'), const Rect.fromLTWH(0, 0, 400, 20));
      expect(r(tester, 'b'), const Rect.fromLTWH(0, 28, 400, 20));
    },
  );

  testWidgets('flex-column with align-items-center centres narrow items', (
    tester,
  ) async {
    await pump(
      tester,
      BsFlex(
        direction: BsFlexDirection.column,
        alignItems: BsAlign.center,
        children: [SizedBox(key: const Key('a'), width: 100, height: 20)],
      ),
    );
    expect(r(tester, 'a').left, 150);
  });
}
