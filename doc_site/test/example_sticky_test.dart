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
}
