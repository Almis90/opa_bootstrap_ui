import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  Future<void> pump(
    WidgetTester tester,
    Widget box, {
    double width = 400,
  }) async {
    tester.view.physicalSize = Size(width, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      BsApp(
        debugShowCheckedModeBanner: false,
        home: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(width: width, child: box),
        ),
      ),
    );
  }

  const content = SizedBox(key: Key('c'), width: 50, height: 20);
  Rect rect(WidgetTester tester) => tester.getRect(find.byKey(const Key('c')));

  testWidgets('padding and margin utilities use the spacing scale', (
    tester,
  ) async {
    await pump(
      tester,
      const BsBox(p: BsSpacing.s3, mt: BsSpacing.s2, child: content),
    );
    expect(rect(tester).topLeft, const Offset(16, 8 + 16));
  });

  testWidgets('the most specific spacing prop wins: pt over py over p', (
    tester,
  ) async {
    await pump(
      tester,
      const BsBox(
        p: BsSpacing.s1,
        py: BsSpacing.s2,
        pt: BsSpacing.s3,
        child: content,
      ),
    );
    expect(rect(tester).top, 16); // pt
    expect(
      tester.getSize(find.byType(BsBox)).height,
      16 + 20 + 8,
    ); // pb falls back to py
    expect(rect(tester).left, 4); // px falls back to p
  });

  testWidgets('a border adds to the box rather than painting over it', (
    tester,
  ) async {
    await pump(
      tester,
      const BsBox(py: BsSpacing.s3, borderBottom: true, child: content),
    );
    expect(tester.getSize(find.byType(BsBox)).height, 16 + 20 + 16 + 1);
  });

  testWidgets('responsive spacing follows the viewport breakpoint', (
    tester,
  ) async {
    const box = BsBox(
      mb: BsResponsiveValue(xs: BsSpacing.s3, md: BsSpacing.s0),
      child: content,
    );
    await pump(tester, box, width: 700);
    expect(tester.getSize(find.byType(BsBox)).height, 20 + 16);
    await pump(tester, box, width: 800);
    expect(tester.getSize(find.byType(BsBox)).height, 20);
  });

  testWidgets('mx-auto centres, ms-auto aligns to the end', (tester) async {
    await pump(tester, const BsBox(mx: BsSpacing.auto, child: content));
    expect(rect(tester).left, 175);
    await pump(tester, const BsBox(ms: BsSpacing.auto, child: content));
    expect(rect(tester).right, 400);
  });

  testWidgets('text-bg-dark: the variant background with contrasting text', (
    tester,
  ) async {
    await pump(
      tester,
      const BsBox(
        textBg: BsVariant.dark,
        child: Text('x', key: Key('t')),
      ),
    );
    final box = tester.widget<BsDecoratedContainer>(
      find
          .descendant(
            of: find.byType(BsBox),
            matching: find.byType(BsDecoratedContainer),
          )
          .first,
    );
    expect((box.decoration! as BoxDecoration).color, BsVariant.dark.color);
    expect(
      DefaultTextStyle.of(
        tester.element(find.byKey(const Key('t'))),
      ).style.color,
      BsColors.white,
    );
  });

  testWidgets('fs-4 is calc(1.275rem + .3vw) below xl and 1.5rem from xl', (
    tester,
  ) async {
    expect(BsFs.fs4.sizeFor(1000), closeTo(20.4 + 3, 0.001));
    expect(BsFs.fs4.sizeFor(1200), 24);
    expect(BsFs.fs6.sizeFor(300), 16);
    await pump(
      tester,
      const BsBox(
        fs: BsFs.fs4,
        child: Text('x', key: Key('t')),
      ),
      width: 1300,
    );
    expect(
      DefaultTextStyle.of(
        tester.element(find.byKey(const Key('t'))),
      ).style.fontSize,
      24,
    );
  });

  testWidgets('text-end puts inline content at the inline end', (tester) async {
    await pump(tester, const BsBox(textAlign: BsTextAlign.end, child: content));
    expect(rect(tester).right, 400);
  });

  testWidgets('bg-body-tertiary, border and rounded-3 together', (
    tester,
  ) async {
    await pump(
      tester,
      const BsBox(
        bg: BsBg.bodyTertiary,
        border: true,
        rounded: BsRounded.r3,
        child: SizedBox(height: 10),
      ),
    );
    final box = tester.widget<BsDecoratedContainer>(
      find
          .descendant(
            of: find.byType(BsBox),
            matching: find.byType(BsDecoratedContainer),
          )
          .first,
    );
    final decoration = box.decoration! as BoxDecoration;
    expect(decoration.borderRadius, BorderRadius.circular(8));
    expect(tester.takeException(), isNull);
    expect(
      tester.getSize(find.byType(BsBox)).height,
      10 + 2,
    ); // the 1px border adds on both sides
  });

  testWidgets(
    'text-end box in a flex line is as wide as its content (so justify-content centres it)',
    (tester) async {
      await pump(
        tester,
        BsFlex(
          justifyContent: BsJustify.center,
          alignItems: BsAlign.start,
          children: const [
            BsBox(
              textAlign: BsTextAlign.end,
              child: SizedBox(key: Key('c'), width: 50, height: 20),
            ),
          ],
        ),
      );
      expect(
        rect(tester).left,
        175,
      ); // centred on the 400px line, not pushed to the end
    },
  );

  testWidgets('w-50 is half the parent', (tester) async {
    await pump(
      tester,
      const BsBox(
        w: BsWidth.w50,
        child: SizedBox(key: Key('c'), height: 10),
      ),
    );
    expect(tester.getSize(find.byKey(const Key('c'))).width, 200);
  });

  testWidgets('fs-4 text is as tall as a CSS line (fractional line-height)', (
    tester,
  ) async {
    await pump(
      tester,
      const BsBox(
        fs: BsFs.fs4,
        child: Text('Title', key: Key('c')),
      ),
      width: 390,
    );
    // calc(1.275rem + .3vw) = 21.57px; × 1.5 = 32.355px, floored to 1/64px
    // by the browser's layout.
    expect(tester.getSize(find.byType(BsBox)).height, closeTo(32.34375, 0.001));
  });

  testWidgets('col-6 outside a row is half the parent', (tester) async {
    await pump(
      tester,
      const BsBox(
        col: BsCol(6),
        child: SizedBox(key: Key('c'), height: 10),
      ),
    );
    expect(tester.getSize(find.byKey(const Key('c'))).width, 200);
  });

  testWidgets('fw-bold and lh-1 style the text inside', (tester) async {
    await pump(
      tester,
      const BsBox(
        fw: BsFw.bold,
        lh: BsLh.lh1,
        child: Text('x', key: Key('c')),
      ),
    );
    final style = DefaultTextStyle.of(
      tester.element(find.byKey(const Key('c'))),
    );
    expect(style.style.fontWeight, FontWeight.w700);
    expect(style.style.height, 1);
  });

  testWidgets('overflow-hidden clips; d-inline-block shrinks to its content', (
    tester,
  ) async {
    await pump(
      tester,
      const BsBox(
        inlineBlock: true,
        overflowHidden: true,
        child: SizedBox(key: Key('c'), width: 50, height: 20),
      ),
    );
    expect(find.byType(ClipRRect), findsOneWidget);
    expect(tester.getSize(find.byKey(const Key('c'))).width, 50);
    // (the box itself is 50px wide inside the 400px line it is placed in)
    expect(tester.getSize(find.byType(ClipRRect)).width, 50);
  });

  testWidgets('display headings are fluid below xl and fixed from it', (
    tester,
  ) async {
    Future<double> sizeAt(double width) async {
      await pump(
        tester,
        const BsDisplayHeading(
          BsDisplayLevel.d5,
          child: Text('x', key: Key('c')),
        ),
        width: width,
      );
      return DefaultTextStyle.of(
        tester.element(find.byKey(const Key('c'))),
      ).style.fontSize!;
    }

    // calc(1.425rem + 2.1vw) at 400px; 3rem from 1200px.
    expect(await sizeAt(400), closeTo(1.425 * 16 + 400 * 0.021, 0.001));
    expect(await sizeAt(1200), 48);
  });
}
