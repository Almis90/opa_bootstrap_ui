import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  // The default test viewport (800x600) is narrower than BsBreakpoint.lg
  // (992), so BsNavbar's default expandBreakpoint already renders the
  // collapsed/hamburger layout without needing to resize anything.
  Widget buildNavbar({
    BsCollapseController? collapseController,
    VoidCallback? onShow,
    VoidCallback? onShown,
    VoidCallback? onHide,
    VoidCallback? onHidden,
  }) {
    return BsApp(
      home: BsNavbar(
        brand: const Text('Brand'),
        collapseController: collapseController,
        onShow: onShow,
        onShown: onShown,
        onHide: onHide,
        onHidden: onHidden,
        items: const [BsNavbarItem(child: Text('Home'))],
      ),
    );
  }

  // The toggler is the only GestureDetector wrapping a CustomPaint in this
  // tree — find.byType(GestureDetector).first would instead hit the
  // brand's (which renders first and has a null onTap in these tests).
  Future<void> tapToggler(WidgetTester tester) =>
      tester.tap(find.ancestor(of: find.byType(CustomPaint), matching: find.byType(GestureDetector)).first);

  testWidgets('Tapping the hamburger toggler still opens and closes the mobile menu', (tester) async {
    await tester.pumpWidget(buildNavbar());
    expect(find.text('Home'), findsNothing);

    await tapToggler(tester);
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);

    await tapToggler(tester);
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsNothing);
  });

  testWidgets('BsCollapseController.expand/collapse/toggle drive the mobile menu without the toggler', (tester) async {
    final controller = BsCollapseController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(buildNavbar(collapseController: controller));

    expect(find.text('Home'), findsNothing);

    controller.expand();
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);

    controller.collapse();
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsNothing);

    controller.toggle();
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsOneWidget);
  });

  testWidgets('The toggler and an explicit collapseController drive the same state', (tester) async {
    final controller = BsCollapseController();
    addTearDown(controller.dispose);
    await tester.pumpWidget(buildNavbar(collapseController: controller));

    await tapToggler(tester);
    await tester.pumpAndSettle();
    expect(controller.isExpanded, isTrue);
    expect(find.text('Home'), findsOneWidget);

    controller.collapse();
    await tester.pumpAndSettle();
    expect(find.text('Home'), findsNothing);
  });

  testWidgets('onShow/onShown/onHide/onHidden fire for the mobile menu', (tester) async {
    final events = <String>[];
    await tester.pumpWidget(
      buildNavbar(
        onShow: () => events.add('show'),
        onShown: () => events.add('shown'),
        onHide: () => events.add('hide'),
        onHidden: () => events.add('hidden'),
      ),
    );

    await tapToggler(tester);
    expect(events, ['show']);
    await tester.pumpAndSettle();
    expect(events, ['show', 'shown']);

    await tapToggler(tester);
    expect(events, ['show', 'shown', 'hide']);
    await tester.pumpAndSettle();
    expect(events, ['show', 'shown', 'hide', 'hidden']);
  });
}
