import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  Widget box(String key, double w, double h) =>
      SizedBox(key: Key(key), width: w, height: h);

  Future<void> pump(
    WidgetTester tester,
    Widget flex, {
    double width = 400,
    TextDirection direction = TextDirection.ltr,
  }) async {
    tester.view.physicalSize = Size(width, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      Directionality(
        textDirection: direction,
        child: MediaQuery(
          data: MediaQueryData(size: Size(width, 600)),
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(width: width, child: flex),
          ),
        ),
      ),
    );
  }

  Rect r(WidgetTester tester, String key) =>
      tester.getRect(find.byKey(Key(key)));

  testWidgets('lays items out left to right at their natural widths', (
    tester,
  ) async {
    await pump(
      tester,
      BsFlex(
        alignItems: BsAlign.start,
        children: [box('a', 50, 20), box('b', 70, 30)],
      ),
    );
    expect(r(tester, 'a'), const Rect.fromLTWH(0, 0, 50, 20));
    expect(r(tester, 'b').left, 50);
  });

  testWidgets(
    'me-auto absorbs the free space, pushing what follows to the end',
    (tester) async {
      await pump(
        tester,
        BsFlex(
          children: [
            BsFlexItem(me: BsSpacing.auto, child: box('a', 50, 20)),
            box('b', 70, 20),
          ],
        ),
      );
      expect(r(tester, 'a').left, 0);
      expect(r(tester, 'b').right, 400);
    },
  );

  testWidgets('responsive margins follow the viewport breakpoint', (
    tester,
  ) async {
    Widget flex() => BsFlex(
      children: [
        BsFlexItem(
          me: const BsResponsiveValue(md: BsSpacing.auto),
          child: box('a', 50, 20),
        ),
        box('b', 70, 20),
      ],
    );
    await pump(tester, flex(), width: 700); // below md: no auto margin
    expect(r(tester, 'b').left, 50);
    await pump(tester, flex(), width: 800); // md and up
    expect(r(tester, 'b').right, 800);
  });

  testWidgets('justify-content center / end / between', (tester) async {
    Future<Rect> run(BsJustify j, String key) async {
      await pump(
        tester,
        BsFlex(
          justifyContent: j,
          children: [box('a', 100, 20), box('b', 100, 20)],
        ),
      );
      return r(tester, key);
    }

    expect((await run(BsJustify.center, 'a')).left, 100);
    expect((await run(BsJustify.end, 'b')).right, 400);
    expect((await run(BsJustify.between, 'b')).right, 400);
    expect((await run(BsJustify.between, 'a')).left, 0);
  });

  testWidgets('wrap breaks lines, and gap separates items and lines', (
    tester,
  ) async {
    await pump(
      tester,
      BsFlex(
        wrap: true,
        gap: BsSpacing.s3,
        children: [box('a', 150, 20), box('b', 150, 30), box('c', 150, 10)],
      ),
    );
    expect(r(tester, 'b').left, 166); // 150 + gap 16
    expect(r(tester, 'c').top, 46); // first line is 30 tall + gap 16
    expect(r(tester, 'c').left, 0);
  });

  testWidgets('col-12 takes a whole line and the next item wraps beneath it', (
    tester,
  ) async {
    await pump(
      tester,
      BsFlex(
        wrap: true,
        children: [
          box('a', 50, 20),
          BsFlexItem(col: const BsCol(12), child: box('b', 10, 20)),
          box('c', 50, 20),
        ],
      ),
    );
    expect(r(tester, 'b').width, 400);
    expect(r(tester, 'b').top, 20);
    expect(r(tester, 'c').top, 40);
  });

  testWidgets('col-3 is a quarter of the width', (tester) async {
    await pump(
      tester,
      BsFlex(
        children: [BsFlexItem(col: const BsCol(3), child: box('a', 10, 20))],
      ),
    );
    expect(r(tester, 'a').width, 100);
  });

  testWidgets('align-items center vs stretch', (tester) async {
    await pump(
      tester,
      BsFlex(
        alignItems: BsAlign.center,
        children: [box('a', 50, 20), box('b', 50, 60)],
      ),
    );
    expect(r(tester, 'a').top, 20);
    await pump(
      tester,
      BsFlex(
        children: [
          const SizedBox(key: Key('a'), width: 50),
          box('b', 50, 60),
        ],
      ),
    );
    expect(r(tester, 'a').height, 60); // stretch is the default
  });

  testWidgets('margins add around an item and its line grows with them', (
    tester,
  ) async {
    await pump(
      tester,
      BsFlex(
        children: [
          BsFlexItem(
            mb: BsSpacing.s3,
            mt: BsSpacing.s1,
            child: box('a', 50, 20),
          ),
        ],
      ),
    );
    expect(r(tester, 'a').top, 4);
    expect(tester.getSize(find.byType(BsFlex)).height, 4 + 20 + 16);
  });

  testWidgets('a nowrap row shrinks items instead of overflowing', (
    tester,
  ) async {
    await pump(
      tester,
      BsFlex(children: [box('a', 300, 20), box('b', 300, 20)]),
    );
    expect(tester.takeException(), isNull);
    expect(r(tester, 'a').width + r(tester, 'b').width, closeTo(400, 0.5));
  });

  testWidgets('RTL mirrors the row and swaps ms/me', (tester) async {
    await pump(
      tester,
      BsFlex(
        children: [
          BsFlexItem(me: BsSpacing.auto, child: box('a', 50, 20)),
          box('b', 70, 20),
        ],
      ),
      direction: TextDirection.rtl,
    );
    expect(r(tester, 'a').right, 400); // starts at the right
    expect(r(tester, 'b').left, 0); // me-auto pushed it to the far (left) end
  });

  testWidgets(
    'a BsFlex nested in a BsFlex (even inside a link) is as wide as its content, not its container',
    (tester) async {
      await pump(
        tester,
        BsFlex(
          children: [
            BsFlexItem(
              me: BsSpacing.auto,
              child: BsAnchor(
                child: BsFlex(
                  key: const Key('inner'),
                  alignItems: BsAlign.center,
                  children: [box('a', 60, 20)],
                ),
              ),
            ),
            box('b', 70, 20),
          ],
        ),
      );
      expect(tester.getSize(find.byKey(const Key('inner'))).width, 60);
      expect(
        r(tester, 'b').right,
        400,
      ); // the auto margin still pushes b to the end
    },
  );

  testWidgets(
    'a container stretched taller than its line centres align-items: center in it',
    (tester) async {
      await pump(
        tester,
        BsFlex(
          children: [
            // The nested flex is stretched to the outer line's height (60).
            BsFlex(alignItems: BsAlign.center, children: [box('a', 50, 20)]),
            box('b', 50, 60),
          ],
        ),
      );
      expect(r(tester, 'a').top, 20);
    },
  );

  testWidgets('d-inline-flex is as wide as its content; d-flex fills', (
    tester,
  ) async {
    await pump(
      tester,
      Align(
        alignment: Alignment.topLeft,
        child: BsFlex(
          inline: true,
          children: [box('a', 50, 20), box('b', 70, 20)],
        ),
      ),
    );
    expect(tester.getSize(find.byType(BsFlex)).width, 120);
    await pump(
      tester,
      Align(
        alignment: Alignment.topLeft,
        child: BsFlex(children: [box('a', 50, 20), box('b', 70, 20)]),
      ),
    );
    expect(tester.getSize(find.byType(BsFlex)).width, 400);
  });
}
