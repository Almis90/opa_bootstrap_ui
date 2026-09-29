import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:opa_bootstrap_ui/opa_bootstrap_ui.dart';

void main() {
  const children = [Text('Pane 0'), Text('Pane 1'), Text('Pane 2')];

  testWidgets('activeIndex still drives which pane is shown directly, unchanged from before', (tester) async {
    var index = 0;
    late StateSetter setState;

    await tester.pumpWidget(
      BsApp(
        home: StatefulBuilder(
          builder: (context, setter) {
            setState = setter;
            return BsTabView(activeIndex: index, children: children);
          },
        ),
      ),
    );

    expect(find.text('Pane 0'), findsOneWidget);
    expect(find.text('Pane 1'), findsNothing);

    setState(() => index = 1);
    await tester.pumpAndSettle();
    expect(find.text('Pane 0'), findsNothing);
    expect(find.text('Pane 1'), findsOneWidget);
  });

  testWidgets('BsTabController.show drives the active pane without activeIndex', (tester) async {
    final controller = BsTabController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(BsApp(home: BsTabView(controller: controller, children: children)));

    expect(find.text('Pane 0'), findsOneWidget);

    controller.show(2);
    await tester.pumpAndSettle();
    expect(find.text('Pane 0'), findsNothing);
    expect(find.text('Pane 2'), findsOneWidget);
  });

  testWidgets('onShow/onHide fire immediately with the incoming/outgoing indices; onShown/onHidden after the fade', (
    tester,
  ) async {
    final controller = BsTabController();
    addTearDown(controller.dispose);
    final events = <String>[];

    await tester.pumpWidget(
      BsApp(
        home: BsTabView(
          controller: controller,
          onShow: (i) => events.add('show:$i'),
          onShown: (i) => events.add('shown:$i'),
          onHide: (i) => events.add('hide:$i'),
          onHidden: (i) => events.add('hidden:$i'),
          children: children,
        ),
      ),
    );

    controller.show(1);
    expect(events, ['hide:0', 'show:1']);
    await tester.pumpAndSettle();
    expect(events, ['hide:0', 'show:1', 'hidden:0', 'shown:1']);
  });

  testWidgets('A rapid second switch before the fade ends does not fire a stale onShown/onHidden for the first', (
    tester,
  ) async {
    final controller = BsTabController();
    addTearDown(controller.dispose);
    final events = <String>[];

    await tester.pumpWidget(
      BsApp(
        home: BsTabView(
          controller: controller,
          duration: const Duration(milliseconds: 100),
          onShown: (i) => events.add('shown:$i'),
          onHidden: (i) => events.add('hidden:$i'),
          children: children,
        ),
      ),
    );

    controller.show(1);
    await tester.pump(const Duration(milliseconds: 50));
    controller.show(2);
    await tester.pumpAndSettle();

    // Only the final transition (1 -> 2) should report completion — the
    // superseded 0 -> 1 transition never actually finished, so 'hidden:0'/
    // 'shown:1' must never appear.
    expect(events, ['hidden:1', 'shown:2']);
  });
}
