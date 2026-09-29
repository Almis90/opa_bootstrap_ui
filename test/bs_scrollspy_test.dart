import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  // Three fixed-height sections stacked in a bounded-height scrollable, so
  // scrolling past each one's top moves the active index forward.
  Widget buildHarness({
    required ScrollController scrollController,
    required List<GlobalKey> sectionKeys,
    required List<double> heights,
  }) {
    return BsApp(
      home: SizedBox(
        height: 300,
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              for (var i = 0; i < heights.length; i++)
                SizedBox(key: sectionKeys[i], height: heights[i], child: Text('Section $i')),
            ],
          ),
        ),
      ),
    );
  }

  testWidgets('activeIndex tracks scroll position across section boundaries', (tester) async {
    final scrollController = ScrollController();
    addTearDown(scrollController.dispose);
    final sectionKeys = List.generate(3, (_) => GlobalKey());

    await tester.pumpWidget(
      buildHarness(scrollController: scrollController, sectionKeys: sectionKeys, heights: [200, 200, 200]),
    );
    await tester.pumpAndSettle();

    final scrollspy = BsScrollspyController(scrollController: scrollController, sectionKeys: sectionKeys);
    addTearDown(scrollspy.dispose);
    await tester.pumpAndSettle();
    expect(scrollspy.activeIndex, 0);

    scrollController.jumpTo(200);
    await tester.pump();
    expect(scrollspy.activeIndex, 1);

    scrollController.jumpTo(400);
    await tester.pump();
    expect(scrollspy.activeIndex, 2);
  });

  testWidgets('onActivate fires only when activeIndex actually changes', (tester) async {
    final scrollController = ScrollController();
    addTearDown(scrollController.dispose);
    final sectionKeys = List.generate(3, (_) => GlobalKey());

    await tester.pumpWidget(
      buildHarness(scrollController: scrollController, sectionKeys: sectionKeys, heights: [200, 200, 200]),
    );
    await tester.pumpAndSettle();

    final activated = <int>[];
    final scrollspy = BsScrollspyController(
      scrollController: scrollController,
      sectionKeys: sectionKeys,
      onActivate: activated.add,
    );
    addTearDown(scrollspy.dispose);
    await tester.pumpAndSettle();

    scrollController.jumpTo(50); // still within section 0 — no activation
    await tester.pump();
    scrollController.jumpTo(200); // enters section 1
    await tester.pump();
    scrollController.jumpTo(250); // still within section 1 — no activation
    await tester.pump();
    scrollController.jumpTo(400); // enters section 2
    await tester.pump();

    expect(activated, [1, 2]);
  });

  testWidgets('refresh() recomputes the active index on demand, without waiting for a scroll event', (tester) async {
    final scrollController = ScrollController();
    addTearDown(scrollController.dispose);
    final sectionKeys = List.generate(3, (_) => GlobalKey());

    await tester.pumpWidget(
      buildHarness(scrollController: scrollController, sectionKeys: sectionKeys, heights: [200, 200, 200]),
    );
    await tester.pumpAndSettle();

    final activated = <int>[];
    final scrollspy = BsScrollspyController(
      scrollController: scrollController,
      sectionKeys: sectionKeys,
      onActivate: activated.add,
    );
    addTearDown(scrollspy.dispose);
    await tester.pumpAndSettle();

    scrollController.jumpTo(400);
    await tester.pump();
    expect(scrollspy.activeIndex, 2);
    expect(activated, [2]);

    // Calling refresh() with nothing having actually changed must recompute
    // the same answer and not spuriously re-fire onActivate for an index
    // that never changed.
    scrollspy.refresh();
    expect(scrollspy.activeIndex, 2);
    expect(activated, [2]);
  });
}
