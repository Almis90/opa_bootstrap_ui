import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  // BsCollapse's own doc comment requires a bounded (not necessarily tight)
  // width from its parent for the vertical axis — pumpWidget's root imposes
  // *tight* constraints, under which AnimatedSize skips animating (and
  // never fires onEnd) entirely, so every case here wraps in a Column.
  Widget wrap(Widget collapse) => BsApp(home: Column(children: [collapse]));

  testWidgets('isExpanded still drives visibility directly, unchanged from before', (tester) async {
    var expanded = false;
    late StateSetter setState;

    await tester.pumpWidget(
      wrap(
        StatefulBuilder(
          builder: (context, setter) {
            setState = setter;
            return BsCollapse(isExpanded: expanded, child: const Text('Collapsible content'));
          },
        ),
      ),
    );

    expect(find.text('Collapsible content'), findsNothing);

    setState(() => expanded = true);
    await tester.pumpAndSettle();
    expect(tester.getSize(find.text('Collapsible content')).height, greaterThan(0));

    setState(() => expanded = false);
    await tester.pumpAndSettle();
    expect(find.text('Collapsible content'), findsNothing);
  });

  testWidgets('BsCollapseController.expand/collapse/toggle drive visibility without isExpanded', (tester) async {
    final controller = BsCollapseController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(wrap(BsCollapse(controller: controller, child: const Text('Collapsible content'))));

    expect(find.text('Collapsible content'), findsNothing);

    controller.expand();
    await tester.pumpAndSettle();
    expect(tester.getSize(find.text('Collapsible content')).height, greaterThan(0));

    controller.toggle();
    await tester.pumpAndSettle();
    expect(find.text('Collapsible content'), findsNothing);

    controller.toggle();
    await tester.pumpAndSettle();
    expect(tester.getSize(find.text('Collapsible content')).height, greaterThan(0));

    controller.collapse();
    await tester.pumpAndSettle();
    expect(find.text('Collapsible content'), findsNothing);
  });

  testWidgets('An explicit controller wins over isExpanded', (tester) async {
    final controller = BsCollapseController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      wrap(
        BsCollapse(
          isExpanded: true, // ignored: controller is given
          controller: controller,
          child: const Text('Collapsible content'),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Collapsible content'), findsNothing);

    controller.expand();
    await tester.pumpAndSettle();
    expect(tester.getSize(find.text('Collapsible content')).height, greaterThan(0));
  });

  testWidgets('onShow/onHide fire immediately, onShown/onHidden fire once the size animation settles', (tester) async {
    final controller = BsCollapseController();
    addTearDown(controller.dispose);
    final events = <String>[];

    await tester.pumpWidget(
      wrap(
        BsCollapse(
          controller: controller,
          onShow: () => events.add('show'),
          onShown: () => events.add('shown'),
          onHide: () => events.add('hide'),
          onHidden: () => events.add('hidden'),
          child: const Text('Collapsible content'),
        ),
      ),
    );

    controller.expand();
    expect(events, ['show']);
    await tester.pumpAndSettle();
    expect(events, ['show', 'shown']);

    controller.collapse();
    expect(events, ['show', 'shown', 'hide']);
    await tester.pumpAndSettle();
    expect(events, ['show', 'shown', 'hide', 'hidden']);
  });

  testWidgets('A content-only size change while expanded does not spuriously re-fire onShown', (tester) async {
    final controller = BsCollapseController();
    addTearDown(controller.dispose);
    final events = <String>[];
    var tall = false;
    late StateSetter setState;

    await tester.pumpWidget(
      wrap(
        StatefulBuilder(
          builder: (context, setter) {
            setState = setter;
            return BsCollapse(
              controller: controller,
              onShown: () => events.add('shown'),
              child: SizedBox(height: tall ? 200 : 100, child: const Text('Collapsible content')),
            );
          },
        ),
      ),
    );

    // A real expand transition, so there's a pending transition for
    // onShown to correctly fire against.
    controller.expand();
    await tester.pumpAndSettle();
    expect(events, ['shown']);

    // Changes the child's intrinsic height while already expanded — this
    // still animates via AnimatedSize (and fires its onEnd), but it's not
    // an expand/collapse transition, so onShown must not fire again.
    setState(() => tall = true);
    await tester.pumpAndSettle();
    expect(events, ['shown']);
  });
}
