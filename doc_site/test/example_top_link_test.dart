import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

import 'package:doc_site/src/example_top_link.dart';

void main() {
  testWidgets('a link to # scrolls the page smoothly to the top', (
    tester,
  ) async {
    final controller = ScrollController(initialScrollOffset: 1500);
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      BsApp(
        home: SingleChildScrollView(
          controller: controller,
          child: Column(
            children: [
              const SizedBox(height: 2000),
              Builder(
                builder: (context) => BsAnchor(
                  onTap: () => scrollExampleToTop(context),
                  child: const Text('Back to top'),
                ),
              ),
              const SizedBox(height: 200),
            ],
          ),
        ),
      ),
    );
    controller.jumpTo(controller.position.maxScrollExtent);
    await tester.pump();

    // The pointing hand over the link.
    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer(
      location: tester.getCenter(find.text('Back to top')),
    );
    await tester.pump();
    expect(
      RendererBinding.instance.mouseTracker.debugDeviceActiveCursor(1),
      SystemMouseCursors.click,
    );

    final start = controller.offset;
    await tester.tap(find.text('Back to top'));
    await tester.pump(); // (the animation starts with this frame)
    await tester.pump(const Duration(milliseconds: 100));
    expect(controller.offset, lessThan(start));
    expect(
      controller.offset,
      greaterThan(0),
      reason: 'it animates, rather than jumping',
    );

    await tester.pumpAndSettle();
    expect(controller.offset, 0);
  });
}
