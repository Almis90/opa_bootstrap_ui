import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:doc_site/src/example_sticky.dart';

void main() {
  const stickyKey = Key('sticky');

  Widget page(ScrollController controller) => Directionality(
    textDirection: TextDirection.ltr,
    child: SingleChildScrollView(
      controller: controller,
      child: Column(
        children: [
          const SizedBox(height: 100),
          // A 1000px row: the sticky 200px box may travel 800px.
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(width: 100, height: 1000),
                Expanded(
                  child: ExampleSticky(
                    top: 32,
                    child: SizedBox(key: stickyKey, height: 200),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 1500),
        ],
      ),
    ),
  );

  testWidgets(
    'holds its child at `top` while the page scrolls, then lets it go',
    (tester) async {
      tester.view.physicalSize = const Size(400, 600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final controller = ScrollController();
      await tester.pumpWidget(page(controller));

      double top() => tester.getTopLeft(find.byKey(stickyKey)).dy;

      // In its place, 100px down.
      expect(top(), 100);

      // Scrolled 300px: it would be at -200, and is held at 32.
      controller.jumpTo(300);
      await tester.pump();
      expect(top(), 32);

      // The row ends 1100px down: scrolled 1000px the box (200 tall) can be at
      // most at 1100 - 200 - 1000 = -100, so it has left the top.
      controller.jumpTo(1000);
      await tester.pump();
      expect(top(), -100);
    },
  );

  testWidgets(
    'within: the containing block is another box, and the sticky part leaves with it',
    (tester) async {
      tester.view.physicalSize = const Size(400, 600);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final controller = ScrollController();
      addTearDown(controller.dispose);
      final block = GlobalKey();

      // A 1000px block with a 100px sticky label at the top of it (in a column
      // that is only as tall as the label), then 1500px more page.
      await tester.pumpWidget(
        Directionality(
          textDirection: TextDirection.ltr,
          child: SingleChildScrollView(
            controller: controller,
            child: Column(
              children: [
                const SizedBox(height: 100),
                Row(
                  key: block,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ExampleSticky(
                      top: 128,
                      within: block,
                      child: const SizedBox(
                        key: stickyKey,
                        width: 80,
                        height: 100,
                      ),
                    ),
                    const SizedBox(width: 100, height: 1000),
                  ],
                ),
                const SizedBox(height: 1500),
              ],
            ),
          ),
        ),
      );
      double top() => tester.getTopLeft(find.byKey(stickyKey)).dy;

      // It starts 100px down, above its `top`, so (as in CSS) it is held at 128.
      expect(top(), 128);
      // Scrolled 500px it would be at -400: held at `top`.
      controller.jumpTo(500);
      await tester.pump();
      expect(top(), 128);
      // The block ends 1100px down: scrolled 1000px the label (100 tall) may be at
      // most at 1100 - 100 - 1000 = 0 — pushed up out of the held position.
      controller.jumpTo(1000);
      await tester.pump();
      expect(top(), 0);
    },
  );
}
